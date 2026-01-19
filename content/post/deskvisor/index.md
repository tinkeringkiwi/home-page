+++
date = '2026-01-17T19:38:44+13:00'
draft = true
title = 'Deskvisor'
category = 'Deskvisor'
summary = 'Overview and introduction to Deskvisor'
+++

# Deskvisor

I've embarked once again on a project that I've had a few cracks at over the years. It's an ambitious project technically and outside of my usual wheelhouse, but some recent advances in the Linux ecosystem as a whole mean it's now tantalisingly close. 

## What is Deskvisor?
We're all familiar with the benefits of virtualisation in a server environment. We can create, move, save, and treat our VMs as cattle rather than pets. We can enforce backup procedures at the VM level so we don't have to do it on a case-by-case basis.

Yet somehow, as far as I can tell, there's been no effort to bring these benefits to the desktop. Zero. Zilch. Nada. 

Yes, we can create VMs on our desktop, play around with them, test, etc. But somehow, in 2025, your desktop OS is still, and always has been, some pet that you have to treat just right.

### The Vision
My vision is a light weight, immutable Linux OS. You download the ISO for this OS, burn it to a USB like any Linux distro, pop it in, reboot and install. This OS install should be super quick with minimal options. 

On first boot, it says okay, what OS do you want to install? Let's say I click on Bazzite. Deskvisor goes and downloads a Bazzite ISO.

This is where the magic happens. 

Deskvisor creates a VM which is assigned nearly all of the system's resources, mounts the ISO file it downloaded, then reboots. 

When Deskvisor restarts, it appears like it no longer exists. It boots hopefully very quickly, then the screen is taken over by Bazzite. 

Bazzite boots, you install it like normal, everything is normal. You reboot, shut down, and Deskvisor just ticks along in the background, unseen, unnoticed. 

Then, say, in three months, you install a bad update, `curl | sudo bash` something you shouldn't have, whatever. You've probably forgotten all about that Deskvisor thing by now.

You reboot your machine, hold down some key, and boom, you're back in Deskvisor. 

Deskvisor configured your desktop VM with automatic snapshots. You simply roll it back to your last reboot, yesterday, an hour ago, whatever.

Deskvisor reboots. Bazzite appears. Life continues. 

## Some Details
I think Deskvisor should stay out of your way as much as possible. When you install, it sets up a VM with these settings:

- All CPU cores
- All RAM apart from 512MB (maybe 1GB on beefy machines)
- The GPU and sound card passed through.
- Every time you connect a USB device, it's immediately automatically connected to the guest. Flash drives could be scanned for viruses, then connected. 
- Automatic, atomic updates (installed when you reboot in due course, like atomic OSes)

It then stays in the background. It should be something you can install on your family's PC. They should never know nor hear of this "Deskvisor" thing. If something breaks, you go beep boop, doop, roll back, and it's fixed. They marvel at your genius. 

I envision there being a desktop app you can install. Probably electron (more on that later). This desktop app lets you configure the hypervisor and your machine. I see it needing these things:

- A way to set up more VMs (for those testing and development boxes), though there's nothing stopping you using hyper-v or even Virtualbox on the desktop.
- Install another OS and dual boot. It should be able to provide a super slick way to download another ISO (say, Windows this time, for that one game), and reboot your machine with that VM as the desktop OS. Swapping back should be as simple as opening the desktop application, clicking Bazzite and clicking "Reboot now". 
- A way to configure networking. For devices with WiFi, the hypervisor will probably have to connect to the network, then provide NAT access to the desktop. Otherwise the hypervisor can't download updates. 
- Backups! It should be super easy to have your desktop's snapshots uploaded to the cloud, your NAS, someone else's computer. 

## Enterprise
Deskvisor fits very naturally into multiple enterprise environments. If Deskvisor can connect to a central management server, you immediately have a super easy way to deploy "golden images" to environments like schools and hospitals where everything is highly centralised and users move frequently between workstations. You could enforce in your image that when users log out, the desktop restarts and Deskvisor blows the entire desktop immediately back to the golden image state.

Windows updates don't interrupt your users' workflow. They are delivered silently on the next reboot. 

In smaller environments like employees with personal laptops, the centralised management would let you enforce backup policies to the central server. When a user takes their laptop for a swim for the third time, you can give them a laptop that looks and behaves exactly like that one did this morning. In *minutes*. 

If a user forgets their laptop, they can log into their Deskvisor Cloud account, click on the last snapshot of the VM, and boot it up on a virtual cloud instance. Or image another laptop, and upload the snapshot back at the end of the day. 

## The Plan