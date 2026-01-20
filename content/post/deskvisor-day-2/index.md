+++
date = '2026-01-17T19:38:44+13:00'
title = 'Deskvisor Day 2'
category = 'Deskvisor'
summary = 'Summary of day 2 working on Deskvisor - my OS designed for desktop virtualisation'
+++

# Deskvisor - Day 2

This was my second full day working on [Deskvisor](../deskvisor/). I'm going to be writing a summary each day this week of what I've worked on.

## So Far
Over the weekend I was playing around with the Archiso tool, trying to make a meme OS called Michaelsoft Binbows. I started playing with immutable OSes, which are very similar to building Docker containers, so something I'm very familiar with. 
I've set up a physical machine for testing with a dedicated GPU for a guest, and integrated GPU for the host. I've got the repo set up, deciding to go with a Universal Blue based immutable OS. Also, fuck Bluebuild. 

## Shower Thoughts
As Gemini pointed out, there aren't super a lot of benefits to doing virtualisation on the desktop for Joe Public that's used to nursing the same Windows install that came with the machine along for its entire life. Mostly just around backup and restore. 

However, there's a whole community based around running desktop virtual machines, you can find examples with Mutahar of SomeOrdinaryGamers. Most of the community is built around running custom setups with Virtual Machine Manager. I think the initial target should be these users. 

The goal should be to create a standardised way of doing this, with scripts and a GUI to getting it set up, and hopefully bring this setup to more high-end Linux users. 

I think my ultimate end goal will be to put two GPUs into my desktop and run two Linux gaming VMs. 

## 1 - Cleanup
I've been working on a few different projects lately, like a [speed camera] and looking at the [Genius SP-Q06S], so my desk area has morphed into an electronics workstation with the associated mess. This project is also messy, with two monitors, my daily laptop I'm typing this on, three keyboards two mice and the giant Apple Trackpad thing needing to fit on one desk. 

## 2 - Build Disk Image
I first built a disk image in QCOW format, using the "nearly vanilla Fedora XFCE". I then booted the VM I've tailored to be my development environment from this.  

## 3 - Docker Registry
When I build my custom images, they come out as Docker / OCI images. As discussed yesterday, I can super easily switch to these within an existing immutable installation. Building an entire new QCOW images takes tens of minutes while these are all downloaded, and all the files are packed into the QCOW file. 

The solution is set up a Docker registry container. Super simple:
```bash
podman run -d -p 5000:5000 --restart=always --name registry registry:2
```

The guest can already access the host, as all its network connectivity is by NATing through the host. 

I set up this function in the `.bashrc` of the guest so I can quickly switch whenever I bake a new image:
```bash
rebase () {
    sudo rpm-ostree rebase ostree-unverified-registry:192.168.122.1:5000/deskvisor:latest
    systemctl reboot
}
```

So I can just type `rebase` on the test VM, and it will start rebasing to the image I built last. 

## 4 - Customising
I've started bringing the customisations from `aurora-dx`, my reference repo, into my custom image. I've got Incus etc installed, but I'm having some trouble figuring out how to use the Universal Blue custom installs. This means Incus is installed and running on my custom ISO, but the user's permissions can't be set up for access. For some reason the code to install ublue customisations is failing. This is where I'll pick up tomorrow.

## The End
This is where I leave off today. I didn't manage to get too much done with cleaning up and reorganising, but my development environment is all well set up and decently smooth. 

Here's my list from here:
- Figure out the ublue customisations issue
- Instal the Incus-UI into the image 
- Experiment with double-passthrough: pass my test VM's GPU through to an Incus instance

I think from there it comes down to how to make this automated, how to make it easy to install different desktop OSes on your Incus instance, and whether Incus is the right fit for this use case or we have to go to Libvirt. 