---
sidebar_position: 1
---


# GitHub OIDC & AWS

# ClickOps: AWS Console


<div style={{textAlign: 'center', paddingTop: '3em', paddingBottom: '3em'}}>
  <iframe width="75%" height="400" src="https://www.youtube.com/embed/k2Tv-EJl7V4?start=1174" title="E6 - GitHub Actions: Learn OpenID Connect (OIDC) and deploy securely to AWS || Full Tutorial" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>


# DevOps: Terraform

While this method requires additional know-how (Terraform), it does provide a repeatable solution that can be automated
and integrated into a CI/CD pipeline.

## What

Connect GitHub to AWS without having to store long-lived access credentials.

## Why

The old way of doing things was to store your access key and secret in a GitHub Secret and then use those to authenticate 
to AWS. This is a bad idea for a few reasons:

- The key and secret require occasional rotation.
- There is a possibility of accidentally leaking the key and secret.

Connecting GitHub OIDC to AWS allows you to authenticate to AWS without having to store long-lived credentials. AWS will
allow role assumption based on the GitHub repository and action that is being run.

## How

We're going to rely on a Terraform configuration which will create the OIDC provider and the IAM role that will be assumed.

### The Idea

[unfunco/terraform-aws-oidc-github](https://github.com/unfunco/terraform-aws-oidc-github) is a well-developed example
and an easy module to use. 

    locals {
      github_repos = [
        "my-org/my-repo", # allow any branch on the repo to assume the role.
        "my-org/my-other-repo", # allow only a specific branch.
      ]
      oidc_module_role = "my-oidc-role-name"
      attach_admin_policy = true # false if you want to attach a custom policy.
    }

    module "github-oidc-dev" {
      source              = "registry.terraform.io/unfunco/oidc-github/aws"
      version             = "1.1.0"
      github_repositories = [ for repo in local.github_repos: "${repo}:ref:refs/heads/develop" ]
      iam_role_name       = local.oidc_module_role
      attach_admin_policy = local.oidc_module_admin
    }

### The Details

To begin, we're going to pin the module to a specific version. This is important because the module is still in active 
development and the API may change.

If you have a well-defined deployment role that you want to use, you can set `attach_admin_policy` to `false` and then
attach the policy to the role that is created by the module using `iam_role_policy_arns`, which is a list of policy
ARNs which will be attached to the OIDC role. 

If you don't have a well-defined deployment role, you can set `attach_admin_policy` to `true` and the module will attach
the AWS managed AdministratorAccess policy to the role.

See the github_repositories property of the module? We're allow-listing the locals.github_repos items, but we're
specifying that GitHub can only assume the deployment role if we're merging to the develop branch. 

### The Execution

Add the above to your existing Terraform configuration for the account you'll be using. Pull the module by running
`terraform init` and then run `terraform plan` to see what will be created. If you're happy with the plan, run it.

After the OIDC Provider is in place, you can create a test github action which will attempt to authenticate and assume
the deployment role.

#### Prerequisites

Create a GitHub Secret in this repo called AWS_MAIN_ACCOUNT which contains the account number of the
account where the OIDC provider was created. (If you're using a branch other than main, you'll need to change the
name of the secret to match: AWS_MAIN_ACCOUNT, AWS_DEV_ACCOUNT, etc.).

Create the following script as .github/workflows/oidc-test.yml:

    on:
        workflow_dispatch:
        push:
            branches:
                - main
    permissions:
        id-token: write
        contents: read
    jobs:
        oidc_validate:
            timeout-minutes: 30
            runs-on: ubuntu-latest
            permissions:
            id-token: write
            contents: read
            outputs:
            branch: ${{steps.branch.outputs.lowercase}}
            session: ${{ env.AWS_SESSION_TOKEN }}
            defaults:
            run:
            shell: bash
            working-directory: ./
            steps:
                - name: Checkout Repo
                  uses: actions/checkout@v2.3.4
                - name: Branch Name From Push
                  id: branch-merge
                  if: github.event_name == 'push'
                  run: echo "branch=${GITHUB_REF#refs/*/}" >> $GITHUB_ENV
                - name: Branch Name Case Transformation
                  id: branch
                  uses: ASzc/change-string-case-action@v1
                  with:
                    string: ${{ env.branch }}
                - name: Set Keys
                  id: keys
                  run: |
                    echo "::set-output name=ROLE_SESSION_NAME::GitHubDeployment${{steps.branch.outputs.capitalized}}"
                    echo "::set-output name=AWS_ACCOUNT_ID::${{secrets[format('AWS_{0}_ACCOUNT',steps.branch.outputs.uppercase)]}}"
                - name: Configure AWS Credentials
                  uses: aws-actions/configure-aws-credentials@v1.6.0
                  with:
                    role-to-assume: arn:aws:iam::${{steps.keys.outputs.AWS_ACCOUNT_ID}}:role/GitHubDeploymentRole
                    role-session-name: ${{steps.keys.outputs.ROLE_SESSION_NAME}}
                    aws-region: us-east-2

You can now push a change to the main branch or trigger a workflow run manually. The workflow will attempt to assume the
deployment role. If the action reports success, GitHub was able to authenticate successfully. If there is an error, you
should have enough detail to troubleshoot. 