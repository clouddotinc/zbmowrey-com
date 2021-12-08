# Deployment Conventions & Configuration

## In General: main, develop, and staging only.

Automated deployment using Github is restricted to the main, staging, and develop
branches. **Do not extend this list without approval:** adding a new environment means
a significant amount of work - new AWS accounts, Github branch protection, TF Cloud
workspaces, Serverless stages, etc., as well as additional costs for monitoring.  

## Local development? Go nuts.

You can, of course, do whatever you like on your local development environment and 
personal AWS account(s). 

## site.yml

This file watches the src/ and public/ folders for changes, triggers a deployment
using aws-cli (s3 sync), and finally invalidates the related CloudFront distribution
(using /* as the path to invalidate all objects). 

Prefer invalidation of /* rather than individual items, as AWS charges per line item
of invalidation, and it counts /* as a single item. 

## terraform.yml

This watches the terraform/ folder for changes and triggers a plan/apply operation
as appropriate to the trigger (pull request vs push). On a pull request, it will
perform a plan, then add a comment to the PR with the plan output. On a push, it
will apply the changes. 

## serverless-*.yml

Each serverless service will require its own deployment watcher. Prefix the file
with "serverless" and then a kebab-case version of the lambda name. This will help
us quickly find the relevant file(s) when debugging an issue. 

The 'paths' property should watch a subdirectory of serverless/ as appropriate to
your use-case. If your lambda has a dependency on another Serverless project in this
repo, you can also watch that folder if necessary. 

    on:
      push:
        paths:
          - 'serverless/mail-handler/**'
          - 'serverless/some-other-lambda/**'

