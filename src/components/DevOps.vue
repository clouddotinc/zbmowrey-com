<template>
  <div class="row py-3 mb-2">
    <div class="col-md-12 order-2">
      <div class="overflow-hidden">
        <h2 class="text-color-dark font-weight-bold text-12 mb-2 pt-0 mt-0"
            data-appear-animation="maskUp" data-appear-animation-delay="300">How It All Comes Together</h2>
      </div>
      <div class="overflow-hidden mb-3">
        <p class="font-weight-bold text-primary text-uppercase mb-0"
           data-appear-animation="maskUp" data-appear-animation-delay="500">Github Actions + Terraform + Serverless +
          AWS</p>
      </div>
      <p class="lead">
        All of my sites use a common workflow and set of tools for Version Control and Deployment. This is how they
        integrate:
      </p>
      <p class="text-center pb-5" id="version-control">
        <img src="img/devops-workflow.png" alt="DevOps Workflow Diagram">
      </p>
      <div class="overflow-hidden">
        <h4 class="text-color-dark font-weight-bold mb-2 pb-3 pt-0 mt-0">Version Control</h4>
      </div>
      <div class="overflow-hidden">
        <h5 class="text-color-dark font-weight-bold mb-2 pt-0 mt-0">Overview</h5>
      </div>
      <p>
        I use this <a href="https://github.com/zbmowrey/version-control">version-control repository</a> to manage the
        creation and configuration of all of my repositories and organizations, including the version-control
        repository itself (Admittedly, I did have to create it and then import it). The only things not explicitly
        version controlled are secrets/credentials. For those, there is unfortunately no good solution except to trust
        that Github and/or Terraform will treat my secrets with utmost care.
      </p>
            <div class="overflow-hidden">
        <h5 class="text-color-dark font-weight-bold mb-2 pt-0 mt-0">Proper handling of secrets</h5>
      </div>
      <p>
        If I were an enterprise, I'd subscribe to Terraform Cloud Enterprise and self-host TCE and Gitlab, using Vault
        for secrets management. Sadly, I do not have an enterprise budget. Moving forward, my plan is to implement some
        form of credential rotation and use the Github, Terraform, and Serverless APIs to update the AWS credentials
        frequently.
      </p>
            <div class="overflow-hidden">
        <h5 class="text-color-dark font-weight-bold mb-2 pt-0 mt-0">Partition Code by Cost Center</h5>
      </div>
      <p class="pb-5" id="deployment-site">
        For each CostCenter in my cloud infrastructure, I create a new Github Organization so that code is completely
        partitioned by client/project. This imposes additional complexity when configuring VCS integrations, but has the
        benefit of limiting any potential breach to just one Organization.
      </p>
      <div class="overflow-hidden">
        <h4 class="text-color-dark font-weight-bold mb-2 pb-3 pt-0 mt-0">Deployment: Site Code</h4>
      </div>
      <p class="pb-5" id="deployment-lambda">
        Site code changes are monitored on the develop, staging, and main branches. Github Actions will trigger a build
        of the application (yarn build for production), then sync to s3 in two regions (one for failover). The last step
        of a deployment is invalidation of the relevant CloudFront distribution. Here's an example of my
        <a href="https://github.com/zbmowrey/zbmowrey-com/tree/develop/.github/workflows/site.yml" target="_blank">
          Site Deployment Github Action
        </a>.
      </p>
      <div class="overflow-hidden">
        <h4 class="text-color-dark font-weight-bold mb-2 pb-3 pt-0 mt-0">Deployment: Lambda</h4>
      </div>
      <p class="pb-5" id="deployment-infra">
        I use <a href="https://www.serverless.com/" target="_blank">Serverless Framework</a> for quick configuration
        and deployment of <a href="https://aws.amazon.com/lambda/" target="_blank">Lambda functions</a>. I would use a
        VCS integration, but Serverless.com wants $20/mo for the ability to integrate at the Organization level (see
        "Version Control" above). Because of this high monthly cost for my extremely low change volume, I've elected to
        keep the Serverless handling within Github Actions. This serves admirably.
      </p>
      <div class="overflow-hidden">
        <h4 class="text-color-dark font-weight-bold mb-2 pb-3 pt-0 mt-0">Deployment: Infrastructure</h4>
      </div>
      <div class="overflow-hidden">
        <h5 class="text-color-dark font-weight-bold mb-2 pt-0 mt-0">Overview</h5>
      </div>
      <p>
        I use Terraform to define my Infrastructure-as-Code and I use <a href="https://www.terraform.io/cloud" target="_blank">
        Terraform Cloud</a> to deploy infrastructure changes from key branches of my repositories: develop, staging, and
        main. Terraform Cloud is configured and managed by my <a href="https://github.com/zbmowrey/terraform-cloud"
                                                                 target="_blank">terraform-cloud</a>
        repository. This keeps all of my organizations, workspaces, settings, and variables under version control.
      </p>
      <div class="overflow-hidden">
        <h5 class="text-color-dark font-weight-bold mb-2 pt-0 mt-0">Why use a monorepo design?</h5>
      </div>
      <p>
        The monorepo design I've selected for my applications is a good choice for small projects without a lot of moving
        parts. I've chosen to optimize for developer comfort (ie, automate the toil) by rolling the various deployments
        into a single workflow.
      </p>
      <div class="overflow-hidden">
        <h5 class="text-color-dark font-weight-bold mb-2 pt-0 mt-0">Limitations & Cautions</h5>
      </div>
      <p class="pb-5" id="cloud-governance">
        I recognize that there are some potential issues with this practice if the apps in question gain complexity
        and/or my maintenance windows shrink: namely, I may need to cherry-pick commits to control change timing or
        implement versioned endpoints to ensure continuity of service.
      </p>
      <div class="overflow-hidden">
        <h4 class="text-color-dark font-weight-bold mb-2 pb-3 pt-0 mt-0">Cloud Governance</h4>
      </div>
      <p>
        I use this <a href="https://github.com/zbmowrey/cloud-admin">Cloud Governance Github Repository</a> to maintain
        a root account, organization, organizational units, application environment accounts, service control policies,
        and centralized billing/reporting. Environment separation is strictly enforced: each app environment (develop,
        staging, main) is deployed into its own account and no cross-account access is configured. This limits the blast
        radius of any mis-steps and gives me peace of mind, knowing that I can safely auto-park resources in Development
        and Staging environments without affecting Production.
      </p>
      <p>
        Required tags on all resources are CostCenter, Environment, Owner, and Source. Source provides a link directly
        to the Github folder for a given stack, allowing a developer or engineer to quickly navigate to the code which
        creates a given resource. For an example, see the <a href="https://github.com/zbmowrey/zbmowrey-com/tree/develop/terraform">
        zbmowrey.com Terraform Source</a>.
      </p>
      <p>

        This tagging strategy allows me to generate granular billing details to see where my costs are allocated and to
        detect anomalies quickly. Tag enforcement is delivered using a combination of Terraform
        <a href="https://www.hashicorp.com/blog/default-tags-in-the-terraform-aws-provider" target="_blank">provider-level
          tags</a> and the <a href="https://www.serverless.com/plugins/serverless-plugin-resource-tagging" target="_blank">
        serverless-plugin-resource-tagging</a> addon for Serverless Framework.
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