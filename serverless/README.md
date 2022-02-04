# Setup

Install [serverless](https://www.serverless.com/framework/docs/getting-started) & [serverless-plugin-resource-tagging](https://www.serverless.com/plugins/serverless-plugin-resource-tagging). 

# Configuration & Convention

## Organization & App

Do not provide org and app keys in your serverless configurations. I'm electing to avoid the
serverless dashboard wherever possible and use Serverless purely to deploy lambda. The biggest
reason for this is that enablement of the dashboard means you need to provide AWS keys and/or
role access to Serverless, and I'm trying to minimize my attack surface area by centralizing
secrets in Github (eventually it'll almost entirely be in cloud, with Github having only the
access it needs to grab secrets from there). 

## Service
The service name must be formatted as follows:

    ${opt:stage,"dev"}-$app-$service-description-kebab-case

Prefixing in this manner will ensure that every service is uniquely named within an account.
Be aware that many of our stacks are similar if not identical, and we deploy all projects of a
given stage into a common AWS account for that stage. 

### Org/App/Service Example

    org: zbmowrey
    app: zbmowrey-com
    service: zbmowrey-mail-handler 

## Stack Name
**stackName** must be declared as part of the **provider** block. The name must be formatted as the
stage name, the app name, and the lambda name, all kebab-case. 

    provider:
        ...
        stackName: ${opt:stage, "dev"}-zbmowrey-com-mail-handler

## Stack Tags
**stackTags** must be declared as part of the **provider** block, and must contain (at least) the following:

    provider:
        stackTags:
            CostCenter: zbmowrey
            Environment: ${opt:stage,'dev'}
            Source: "(github url)"

The Github URL should lead a user directly to the folder which holds the service responsible for resource creation.
Linking directly to the **develop** branch is a best practice, as staging & main branches may not yet exist for a given service.

Depending on the project's needs, you may use additional stack tags.

## Stack Description
A **resources** block must be declared in your template, and must include the **Description** field. The Description
must be as follows:

    resources:
        ...
        Description: "Managed by Serverless Framework. See tags for Source URL."