+++
date = '2026-01-17T19:38:44+13:00'
title = 'Deskvisor Day 1'
category = 'Deskvisor'
summary = 'Overview and introduction to Deskvisor'
+++

# Deskvisor - Day 1

Today was my first full day working on [Deskvisor](../deskvisor/). I'm going to be trying to blog each day for the next five days, documenting my process working on this project. 

## The Groundwork
Over the weekend I was playing around with Archiso trying to make a custom OS called Michaelsoft Binbows. ArchISO turned out to be, er... *esoteric* so I had the idea to look into how Bazzite and those immutable distros are built. It then occurred to me that this would be perfect for building the Deskvisor I've been thinking about since forever, so I pivoted to that. 

## The Setup
For this project, I pulled out my old "home server" machine, it has: 

- Ryzen 5600G
- 96GB of RAM (NO LOWBALLERS I KNOW WHAT I GOT)
- Nvidia 1070Ti

Crucially, it has an integrated GPU so I can run the host from that, and pass that Nvidia GPU through to a virtual machine for testing. I will consider this machine the "golden example" and make an ISO that works here first. 

I installed Bluefin (a Universal Blue-based immutable distro with GNOME) on this machine, to act as the development environment. 

{{< alert "star" >}}
By the way - did you know you can switch immutable distros *super easily*. You basically run `ostree rebase ghcr.io/ublue-os/some-image`, it pulls the image, and you're away. Your home folder and settings remain untouched. That's insanely cool.
{{< /alert >}}

## Stage 1 - Get a VM Going
I set up a VM with GPU passthrough following [this guide](#). I spent hours going in circles trying to get this working. Sometimes I'd see a flash of the boot screen, or the GRUB screen, but the guest seemingly refused to use the GPU. This turned out to be that by default VMM / QEMU sets up the VM with BIOS rather than UEFI, for legacy support. The open-source Nouveau video driver simply doesn't support BIOS systems at all and was failing with random hex dump errors, not giving me any clues. 

## Sidequest 1 - Bluebuild
Google and Google AI mode kept telling me I should be building my immutable OS the ✨new✨ way, with ✨Bluebuild✨. Bluebuild is some kind of abstraction layer on top of the underlying tools of building an immutable OS. The underlying tools are... Dockerfiles, which should be familiar to anyone who's built for the cloud in the last 10 years. Universal Blue rightfully realised this was a dumb idea and abandoned the project, but it continues to stumble along as a separate thing.

To use Bluebuild, the easiest way is to use an image built with Bluebuild, as the tool will be installed on any such images automatically. Where should one obtain such an image? Fuck knows, I looked. *Really hard*. I could not find any other installation instructions for Bluebuild.

![MFW My Face](./ree.gif)

Want a chuckle? Here's [how BlueBuild works](https://blue-build.org/learn/how/) in their own words. Try finding any installation instructions while you're looking at their docs.

## Stage 2 - First Image
I'd previously cloned the Universal Blue (uBlue) starter template for creating a custom image. This template uses Justfiles (an alternative to a Makefile), a Containerfile (Dockerfile) and some `build.sh` scripts to create an image. It also has targets to wrap the image up into virtual machine images or ISOs. Super cool. 

I then cloned the repo for Aurora (uBlue based desktop with KDE) and started trying to experiment with their setup. It pulls directly from the Fedora images and runs a bunch of `build.sh` scripts, installing custom packages and so on. I couldn't get any of the `Justfile` templates to run on my system, they seem highly targeted to running on Github Actions only. But anyway, it's nice to have a fully-loaded example to pull what I want from. 

By default the template pulls from Bazzite as the base image, and adds `tmux`. I updated it to pull the Fedora Atomic XFCE image instead, and built an ISO. 

## The End
The image based on Fedora XFCE booted in the virtual machine, or I could rebase the host to it, but the ISO was an install-only ISO. 

That's where I pick up tomorrow. 

I'm quite happy with this for my first day of working on this. My plan from here is to set up an image which is basically "Fedora XFCE with Incus pre-configured" and start building out Deskvisor by pre-configuring Incus.

Tune in tomorrow for more on that!