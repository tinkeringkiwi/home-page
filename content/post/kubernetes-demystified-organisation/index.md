+++
date = '2026-01-25T15:44:43+13:00'
draft = true
category = 'Kubernetes'
tags = ['Kubernetes', 'tutorial']
title = 'Kubernetes Demystified - Organisation'
summary = "A brief dive into organising your resources in Kubernetes"
+++

# Kubernetes Demystified Part 2 - Organisation

In [part 1 of the Kubernetes Demystified series](../kubernetes-demystified/), I covered quite a lot, getting straight into getting your hands dirty creating and running apps. I wanted to start off this way, to show that Kubernetes doesn't have to be intimidating if you're used to Docker and running containers. 

In this follow up, I'd like to take a step back, a little more chill, and talk about the features Kubernetes provides for you to organise your resources. 

## Namespaces
In Kubernetes, all resources are assigned to a Namespace. In [part 1](../kubernetes-demystified/), we didn't interact with namespaces at all, so everything was done in the `default` namespace. 

You can create Namespaces imperatively on the command line:
```bash
kubectl create namespace super-app
```

Or declaratively using Kube YAML:
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: super-app
```

If you put the Namespace declaration at the top of your application's YAML, it will be created first, and you can put all your resources into it. 

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: super-app
---
apiVersion: apps/v1
kind: Deployment
metadata:
    name: my-app
    namespace: super-app
spec:
    replicas: 3
    [...]
```

When using Kubectl or other command line tools designed to interact with Kubernetes, the Namespace can be specified using the `-n` or `--namespace` flag.

```bash
kubectl -n super-app get pods 
kubectl -n super-app describe deployment my-app
```

I like to put the `-n` flag at the start, to make it more ergonomic to change my next command.

You can also list all Namespaces just like any other resource:
```bash
kubectl get namespaces
```

{{<alert "fire" >}}
**Pro tip!**
Install the handy [kubectx](https://github.com/ahmetb/kubectx/) tool, then run `kubens super-app` to set the default Namespace. Handy when you start running a few apps.
{{</alert>}}

Finally, there are a handful of resources that are *not* namespace-scoped in a Kubernetes cluster. These are called cluster scoped resources. The most common type of these you'll be interacting with are Persistent Volumes, though the PersistentVolumeClaims that bind them to your applications *are* namespaced. 

If you specify a namespace while interacting with these resources, no error will be thrown, so don't worry too much.
```bash
kubectl get persistentvolumes # Get the cluster-scoped resource
kubectl -n foobar get persistentvolumes # Output is identical if foobar exists 
```

## Labels 
Both Labels and Annotations are arbitrary key-value pairs you can set on any Kubernetes resource, but they serve slightly different purposes.

Labels should uniquely identify the resource. For example, you might use these labels:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-app-pod
  labels:
    app: my-app
    environment: production
```
You can then use these labels to select resources. For example, you might want to get all the Pods for your app:
```bash
kubectl -n super-app get pods -l app=my-app
```

Or follow the logs for *all the replicas of your app*:

```bash
kubectl -n super-app logs -f -l app=my-app
```


## Annotations
Annotations look and feel similar to Labels, but they should be used for things that don't identify your app. 

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-app-pod
  annotations:
    kubernetes.io/description: "Primary frontend for my-app"
    team.example.com/owner: "frontend-team"
```

Annotations are often used by controllers and Kubernetes addons (to be covered in part 4) to hold configuration. 

## Ingress - Tying it All Together
To tie all of these concepts together, I'm going to introduce one more resource we didn't cover in part 1. The Ingress resource.

An Ingress allows you to send external traffic to one or more of the Services running in your cluster. Let's look at a full example: 
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-frontend-ingress
  namespace: production 
  labels:
    app.kubernetes.io/name: web-frontend
    app.kubernetes.io/environment: production
  annotations:
    # Forces all HTTP traffic to redirect to HTTPS
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    # Basic rate limiting for the root path
    nginx.ingress.kubernetes.io/limit-rps: "10"
spec:
  ingressClassName: nginx
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-frontend-service
            port:
              number: 80
```

Here we create an Ingress object in the `production` namespace, with some of the [Kubernetes recommended labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/) set. This Ingress configuration sends all traffic for `app.example.com` to the service `web-frontend-service`. 

### Homework

Set up a Kubernetes Ingress object for the Nginx production setup we configured in [Part 1](../kubernetes-demystified/#putting-it-all-together). The example above gives you most of the YAML needed.

Most Kubernetes environments come with a Kubernetes Ingress Controller (more about controllers in a future instalment). If not Nginx, it might be Traefik or Envoy. You can find out by running `kubectl get ingressclass`, and searching the right configuration for yours. 

## One Last Tip
You're going to be running `kubectl` a lot. I like to set up an alias in my shell so I can just use `k`.
```bash
alias k=kubectl
```
You can also add this line to your `.bashrc` (or whatever the equivalent for your shell is), to make the alias permanent. You'll also want to make sure that Kubectl's autocomplete is loaded in there too. Here's my `.zshrc` for Mac and some Linuxes:
```zsh
# Load the completion system (prevents error)
autoload -Uz compinit
compinit

source <(kubectl completion zsh)

# alias Kubectl and set up completion
alias k=kubectl
compdef _kubectl k
```

Also, many resources in Kubernetes have "shorthand" names you can use. With the alias above set up, the following are all equivalents:
```bash
kubectl get namespaces
k get ns 

kubectl get persistentvolumeclaims
k get pvc

kubectl describe service wordpress
k describe svc wordpress
```

## Conclusion
I've shown you some tips and tricks today for how to get Kubernetes to work more ergonomically for you, and how to be tidy and organise your resources so other admins will know what's going on. 

In the next part, I'm going to cover configuring your app and using secrets, then in part 4 I will cover controllers and addons, which we touched on briefly here today.