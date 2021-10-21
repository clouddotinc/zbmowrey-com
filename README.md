# zbmowrey-com

This is the code behind [my website](https://zbmowrey.com). It's a Vue 2 SPA hosted as HTML,
CSS, and Javascript on s3 behind CloudFront; this keeps my hosting costs near zero. Feel free
to poke around in .github/workflows, where I showcase Github Actions for automated deployment
and Terraform to build out infrastructure. 

If you see something I could improve, please point it out. I'm always happy to learn something new!

## Project setup
```
Install the app dependencies: 

    yarn install

Add repository secrets:

    If you are using a development environment with the 'develop' branch name:

    AWS_KEY_DEVELOP
    AWS_SECRET_DEVELOP
    CF_DISTRIBUTION_DEVELOP

    If you are using a staging environment with the 'staging' branch name:

    AWS_KEY_STAGING
    AWS_SECRET_STAGING
    CF_DISTRIBUTION_STAGING

    For your main/production environment. Branch name 'main': 
    AWS_KEY_MAIN
    AWS_SECRET_MAIN
    CF_DISTRIBUTION_MAIN

    Your token for tf cloud. Be sure your workspace is using LOCAL deployment (settings > general).
    TERRAFORM_CLOUD_TOKEN

```

### Compiles and hot-reloads for development
```
yarn serve
```

### Compiles and minifies for production
```
yarn build
```

### Lints and fixes files
```
yarn lint
```

### Deployment

Pushes to main, develop (optional), or staging (optional) will automatically
trigger Github Actions (see the Actions tab in your repository) which will 
build the application and deploy to s3. 

You MUST customize the following files: 
    .github/workflows/terraform/env/*.tfvars
    .github/workflows/terraform/terraform.tfvars

### Examples

This project also contains working examples of VPC Creation and Python Lambda deployment.
See the vpc.tf file and the lambda-web-mail.tf for examples (commented out for now). 

### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).
