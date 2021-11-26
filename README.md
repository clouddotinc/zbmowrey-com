# zbmowrey-com

This is the code behind [my website](https://zbmowrey.com). 

If you see something I could improve, please point it out. I'm always happy to learn something new!

## The App

This app is an HTML & Javascript static website:
* Hosting: s3 (multi-region)
* CDN: CloudFront (with failover)
* Form Handling: API Gateway & Lambda 

## Deployment Pipeline

NOTE: The following are targets for v1.0. At the moment, Code Deployment and Infrastructure Deployment are complete.
Lambda Deployment is a work in progress. 

Pushes to develop, staging, or main branches will trigger the following (if needed): 
* Infrastructure Deployment: Terraform Cloud
  * Condition: changes detected in the terraform/ folder.
 
 
* Lambda Deployment: Serverless Framework
  * Condition: changes detected in the serverless/ folder.


* Code Deployment: Github Actions
  * Condition: changes detected outside serverless/ and terraform/ folders.

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