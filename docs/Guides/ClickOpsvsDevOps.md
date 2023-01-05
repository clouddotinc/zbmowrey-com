---
sidebar_label: 'ClickOps vs DevOps'
sidebar_position: 99
---

# ClickOps vs DevOps

## ClickOps

When you're in the web console, looking at resources, buttons, and dials... and you start clicking around to create
your infrastructure, you're actively participating in what we affectionately call ClickOps. Many people will say that
you're also doing it wrong, but I disagree. 

I think there's huge value in playing with the console and becoming familiar with how the CSP (Cloud Service Provider)
organizes things, thinks about problems, and presents configuration. Sometimes the console will expose you to messages
which help guide you toward a successful interaction, instead of leaving you scratching your head at the command line.

A final benefit is that you'll become familiar with the terminology and requirements alongside the creation process,
which will benefit you when you convert your ClickOps doodling into infrastructure-as-code. You did intend to circle
back and codify your infra, didn't you? 

If not, then I agree that ClickOps is "Doing It Wrong"&trade;. The only pattern that makes sense for ClickOps is to
play around in a sandbox, exploring the edges of things, and learning how they run... then taking that knowledge and
implementing it as Terraform, CloudFormation, Azure Resource Manager Templates, etc. 

Sure, you're doing it twice, but you're covering all bases and building out skills which will eventually have you
skipping the sandbox steps because you've already done it. This toolbox of practical experience is how we grow. 

## DevOps

If you ask a thousand strangers to define DevOps, 995 of them will look at you like you're speaking a foreign
language. The remaining 5 will have wildly differing opinions on the topic. 

To most of us, DevOps is a methodology or philosophy about deploying things. It creates and manages infrastructure
and delivers our applications to the machines which will run them, and in almost every case the process is automated.
The distinction between DevOps and ClickOps is that DevOps is rarely if ever accomplished in the console. Rather, we
write scripts and use APIs to achieve our aims in a programmatic fashion. 

Elaborating on "what is DevOps", while I'm aware that there is no clear "right" way to think about this, I lean toward 
the following beliefs: 

1. Use IAC (infrastructure as code) to codify your infrastructure, protecting the configurations in Version Control.
2. Build familiarity with CloudFormation, Terraform, Azure Resource Manager, etc., as appropriate to your role.
3. Automate everything that can be automated.
4. Relentlessly identify and shorten feedback loops: make things easier and faster, and people will love it. 
5. Enable self-service for engineering teams wherever possible and practical.
6. Mentor and build the next generation of cloud experts.
7. Never. Stop. Learning. Things.

## Summary

Is one better than the other? Absolutely. When it comes to DevOps, it's hard to overstate the benefits of programmatic 
access and automation. That said, ClickOps is a tool in the belt and should not be discarded. If you're in a lead 
position, ensure that your team has access to a console in a sandbox account, and encourage them to play. Rapid learning
will ensue.