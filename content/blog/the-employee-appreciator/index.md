+++
date = '2025-11-06T11:09:02+13:00'
draft = false
title = 'The Employee Appreciator'
summary = "The Employee Appreciator is a mid-2000s inspired web app to generate a award for corporate's appreciation of its employees."
category = "Blog"
+++
On a beautiful spring morning a couple of months ago, I popped into my local branch of a certain red and yellow fast food chain, where they had a large "Employee of the Month" *shrine* prominently displayed for customers to see. I was so taken by the obvious passion and enthusiasm imbued in the graphic design of this employee appreciation altar, that I knew I had to craft my own respectful tribute. 

On November 1st I was at the [Watchful](https://watchful.co.nz/) Halloween Hackathon, where I finally got my chance and a team to build the Employee Appreciator.

**Behold, the Employee Appreciation Award:**
![An Employee Appreciation Award. There is the title "Employee Appreciation Award", an image of me as a confused employee on the left, with words like "Productivity" and "Attitude" floating around the right, with a Microsoft Paint gold star awkwardly positioned at the bottom-right.](featured.jpg)
## You, too, can [Become Appreciated Here](https://appreciator.myhackathon.app)

## The Tech

The Appreciator was a fairly simple app to make with some LLM assistance. I built the backend which does the actual image generation, while my team mate built a frontend to make it self-service for corporate employees. Initially we went with a yellow and red garish fast food themed frontend, but we decided it would be more on-brand to make the tool look like an ancient .NET application that hadn't been updated in 20 years and nobody knows how to fix.

The backend uses the Python image library Pillow to overlay text and images onto a base image. The frontend is running React and Next.JS. Nothing is saved because there's no way I'm storing a bunch of random images from the public (yikes). 

For deployment, I got Claude to write up a Dockerfile and a Kubernetes manifest, and deployed it to my usual tinkerprod at Rackspace Spot.

## Thanks Watchful!
I want to thank the team at [Watchful](https://watchful.co.nz/) for putting on the Halloween Hackathon, especially [Walter](https://walt.online/). Events like this always take more organising than you might expect, and there haven't been as many in recent years, so it's great to see them coming back. With the rise of LLM-based tools, they no longer have to be full-weekend events, as building prototypes is what LLMs tend to be best at. 