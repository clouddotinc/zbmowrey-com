<template>
  <div class="row py-3 mb-2">
    <div class="col-md-12 order-2">
      <div class="overflow-hidden">
        <h2 class="text-color-dark font-weight-bold text-12 mb-2 pt-0 mt-0"
            data-appear-animation="maskUp" data-appear-animation-delay="300">How It All Comes Together</h2>
      </div>
      <div class="overflow-hidden mb-3">
        <p class="font-weight-bold text-primary text-uppercase mb-0"
           data-appear-animation="maskUp" data-appear-animation-delay="500">Github Actions + Terraform + Serverless + AWS</p>
      </div>
      <p class="lead">
        All of my sites use a common workflow and set of tools for Version Control and Deployment. This is how they
        integrate:
      </p>
      <p class="text-center" id="version-control">
        <img src="img/devops-workflow.png" alt="DevOps Workflow Diagram">
      </p>
      <div class="overflow-hidden">
        <h4 class="text-color-dark font-weight-bold mb-2 pt-0 mt-0">Version Control</h4>
      </div>
      <p>
        I use this
        <a href="https://github.com/zbmowrey/version-control">version-control repository</a> to manage the
        creation and configuration of all of my repositories, including the version-control repository itself (I did
        have to create it and then import it). The only things not explicitly version controlled are
        secrets/credentials. For those, there is unfortunately no good solution except to trust that Github and/or
        Terraform will treat my secrets with utmost care.
      </p>
      <p class="pb-3">
        If I were an enterprise, I'd subscribe to Terraform Cloud Enterprise and self-host TCE and Gitlab, using Vault
        for secrets management. Sadly, I do not have an enterprise budget. Moving forward, my plan is to implement some
        form of credential rotation and use the Github, Terraform, and Serverless APIs to update the AWS credentials
        frequently.
      </p>
      <div class="overflow-hidden" id="deployment-site">
        <h4 class="text-color-dark font-weight-bold mb-2 pt-0 mt-0">Deployment: Site Code</h4>
      </div>
      <p class="pb-3">
        Site code changes are monitored on the develop, staging, and main branches. Github Actions will trigger a build
        of the application (yarn build for production), then sync to s3 in two regions (one for failover). The last step
        of a deployment is invalidation of the relevant CloudFront distribution. Here's an example of my
        <a href="https://github.com/zbmowrey/zbmowrey-com/tree/develop/.github/workflows/site.yml" target="_blank">
          Site Deployment Github Action
        </a>.
      </p>
      <div class="overflow-hidden" id="deployment-lambda">
        <h4 class="text-color-dark font-weight-bold mb-2 pt-0 mt-0">Deployment: Lambda</h4>
      </div>
      <p>
        I make use of Serverless Framework for quick configuration and deployment of Lambda functions. I would use a VCS
        integration, but Serverless.com wants $20/mo for the ability to integrate at the Organization level (I use Github
        Organizations to limit the blast radius of potential issues). Because of this high monthly cost for my extremely
        low change volume, I've elected to keep the Serverless handling within Github Actions. This serves admirably.
      </p>
      <p class="pb-3">
        If you review my <a href="https://github.com/zbmowrey/zbmowrey-com/blob/develop/.github/workflows/serverless-mail-handler.yml" target="_blank">Serverless Deployment Github Action</a>, you'll notice I install a tagging module - that allows me to ensure that all resources are tagged appropriately.
        This is key to being able to allocate costs to the application or team responsible.
      </p>
      <div class="overflow-hidden" id="deployment-infra">
        <h4 class="text-color-dark font-weight-bold mb-2 pt-0 mt-0">Deployment: Infrastructure</h4>
      </div>
      <p class="pb-3">
        I use Terraform to define my Infrastructure-as-Code and I use Terraform Cloud to deploy infrastructure changes
        from key branches of my repositories: develop, staging, and main. Terraform Cloud is configured and managed by
        the <a href="https://github.com/zbmowrey/terraform-cloud" target="_blank">terraform-cloud</a> repository. This
        keeps all of my organizations, workspaces, settings, and variables under version control.
      </p>
          <div class="overflow-hidden" id="cloud-governance">
        <h4 class="text-color-dark font-weight-bold mb-2 pt-0 mt-0">Cloud Governance</h4>
      </div>
      <p class="pb-3">
        If you're not using multiple AWS accounts, today is the best day to start. They're free and they give you
        a world of opportunity to partition services. I use this <a href="https://github.com/zbmowrey/cloud-admin">
        Cloud Governance Github Repository</a> to maintain a root account, organization, organizational units,
        application environment accounts, service control policies, and centralized billing/reporting.
      </p>
      <div class="overflow-hidden" id="cloud-accounts">
        <h4 class="text-color-dark font-weight-bold mb-2 pt-0 mt-0">Cloud Account Partitioning</h4>
      </div>
      <p>
        I partition my environments by using separate AWS accounts for each. For example, pushing to develop on <a href="https://github.com/zbmowrey/zbmowrey-com" target="_blank">This Site's Repository</a> will
        trigger a deployment to my Development AWS account, while pushing to staging will trigger a deployment to the
        Staging account.
      </p>
      <p>
        This practice enforces strict separation of environments, limits the blast radius of any oversights, and the
        independence of each environment means I can safely auto-park Development resources without causing an outage
        in production.
      </p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'DevOps',
  props: {}
}
</script>

<style lang="scss" scoped></style>