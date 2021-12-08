# zbmowrey-com

This is the code behind [my website](https://zbmowrey.com). If you see something I could improve, please point it out. I'm always happy to learn something new!

## The App

The app is a static HTML website hosted in S3 and served by CloudFront. A multi-region design improves the SLA of my site from 99.9% (~9 hours/year downtime) to 99.99% (~52 minutes/year downtime). 

Form handling, when necessary, will be performed using AWS Lambda & API Gateway, which both have generous permanently-free tiers.

This architecture gives me a hosting cost so close to zero it might as well be. Including route53 zone costs, a single domain web app with develop, staging, and production environments will cost me well under $2.00 USD unless it gets wildly popular for some reason. 

## Deployment Pipeline

### Guard Rails

All deployments are constrained to the develop, staging, or main environments, with branches named accordingly.

### Terraform Cloud

Terraform Cloud is our backend state & lock provider. Deployments are executed locally within the Github Actions container. 
This avoids secret spread, where creds get stored in many external provider accounts. 

### Serverless Framework

Serverless Framework is the lambda development & deployment solution of choice. Deployments here are also
run locally to the Github Actions container, rather than executed from the Serverless Dashboard. 

### Github Actions

Github Actions is triggered by changes in the src/, public/, serverless/, or terraform/ folders:
* Changes in the src/ or public/ folders will trigger a process which builds, syncs to s3, and invalidates the CDN distribution.
* Changes in sub-folders of serverless/ will trigger a Serverless Framework deployment.
  * Each must be defined in .github/workflows/
  * See .github/workflows/serverless-mail-handler.yml for an example.
* Changes in terraform/ will trigger evaluation:
  * A pull request will trigger a plan, followed by a PR comment of the plan output. 
  * A push will trigger a plan/apply cycle. 
 
### Notes on Timing

As we rely on parallel deployment of site, lambda, and infrastructure changes, users should consider the implications of combining multiple changes
into a single push. For example, a change which relies on both site and lambda updates might see the site updated before the lambda deployment completes. This
would result in a window where increased error rates are encountered. The same is true if any code change relies on an infrastructure (terraform) update.

For the moment, I'm keeping site, lambda, and infrastructure packaged in a single repo to minimize my maintenance window and the amount of manual work I need to do when coordinating a release (creating 3 separate PRs, merging, and monitoring vs creating a single PR and monitoring). This may need to change if/when the complexity of the application grows. 

## Project setup
```
Install the app dependencies: 

    yarn install

Add repository secrets:

    If you are using a development environment with the 'develop' branch name:

    AWS_KEY_DEVELOP
    AWS_SECRET_DEVELOP
    CF_DISTRIBUTION_DEVELOP (initially empty. Add the distribution ID after initial creation)

    If you are using a staging environment with the 'staging' branch name:

    AWS_KEY_STAGING
    AWS_SECRET_STAGING
    CF_DISTRIBUTION_STAGING (initially empty. Add the distribution ID after initial creation)

    For your main/production environment. Branch name 'main': 
    AWS_KEY_MAIN
    AWS_SECRET_MAIN
    CF_DISTRIBUTION_MAIN (initially empty. Add the distribution ID after initial creation)

```

### Compiles and hot-reloads for development
```
yarn serve
```

### Compiles and minifies for production
```
yarn build
```

### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).
