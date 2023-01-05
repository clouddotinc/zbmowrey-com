---
sidebar_label: 'Handling Multiple Environments'
sidebar_position: 1
---

# The Problem

Because Terraform is an unopinionated tool, Engineers and Architects have an abundance of flexibility
in determining how their projects are structured. The various structures which have been established
all involve trade-offs.

## Landscape Review

While trunk-based branching strategies are gaining momentum in the software development world, my
feeling is that such a practice enforces artificial structure on Terraform projects. In this paradigm,
all feature branches are merged into main as soon and as often as may be practical. Long-lived lower
branches like develop or staging no longer exist.  

In this environment, teams often choose to replicate infrastructure for their various environments in
folders under the same project. So, for example...

    /app/terraform/main
    /app/terraform/develop
    /app/terraform/staging

... each of which would host the IAC necessary to stand up that environment's infrastructure. The problem
with this approach is that it becomes increasingly difficult to pull all of one's changes from develop and
copy them into main. It's doable, but it's a manual process and is subject to human error. It stands in
contravention to DRY (don't repeat yourself) and forces us to pay attention. 

## My Preference

I strongly prefer Git Flow branch management for Terraform projects. In this model, we maintain branches
for our long-lived environments: 

    develop
    staging
    main

And we do not break out environments by folder. We use workspaces to keep the configurations separate. The
benefit of this approach is clear: we write code one time. We can release into any environment by merging
into the appropriate branch. On validation, we can merge to main and deploy to production. At no point is
anyone copying or pasting blocks of code into another stack. 

In order to create a new environment, we need only enable deployment in our CI/CD pipeline for a new branch.
This can be made dynamic based on some portion (or a transformation) of the branch name. To see what should
be in that environment, we can review the relevant branch. 