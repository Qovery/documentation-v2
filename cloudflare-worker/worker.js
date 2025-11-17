export default {
  async fetch(request, env, ctx) {
    try {
      const urlObject = new URL(request.url);

      // If the request is to a Vercel verification path, allow it to pass through
      if (urlObject.pathname.startsWith('/.well-known/')) {
        return await fetch(request);
      }

      // Serve the qovery-iam-aws.json file directly
      if (urlObject.pathname === '/docs/files/qovery-iam-aws.json') {
        const iamPolicy = {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Effect": "Allow",
              "Action": [
                "iam:*",
                "s3:ListAllMyBuckets",
                "cloudwatch:*",
                "autoscaling:*",
                "application-autoscaling:*",
                "elasticloadbalancing:*",
                "organizations:DescribeAccount",
                "organizations:DescribeOrganization",
                "organizations:DescribeOrganizationalUnit",
                "organizations:DescribePolicy",
                "organizations:ListChildren",
                "organizations:ListParents",
                "organizations:ListPoliciesForTarget",
                "organizations:ListRoots",
                "organizations:ListPolicies",
                "organizations:ListTargetsForPolicy",
                "dynamodb:*",
                "ecr:*",
                "ec2:*",
                "elasticache:*",
                "cloudtrail:LookupEvents",
                "dynamodb:*",
                "tag:GetResources",
                "rds:*",
                "ecs:*",
                "eks:*",
                "logs:*",
                "events:DescribeRule",
                "events:DeleteRule",
                "events:ListRuleNamesByTarget",
                "events:ListTargetsByRule",
                "events:PutRule",
                "events:PutTargets",
                "es:AddTags",
                "es:RemoveTags",
                "es:ListTags",
                "es:DeleteElasticsearchDomain",
                "es:DescribeElasticsearchDomain",
                "es:CreateElasticsearchDomain",
                "events:RemoveTargets",
                "kms:*",
                "events:TagResource",
                "events:ListTagsForResource"
              ],
              "Resource": "*"
            },
            {
              "Action": [
                "s3:*",
                "sqs:*"
              ],
              "Effect": "Allow",
              "Resource": [
                "arn:aws:s3:::qovery*",
                "arn:aws:s3:::qovery*/*",
                "arn:aws:sqs:*:*:qovery*",
                "arn:aws:sqs:*:*:qovery*/*"
              ]
            }
          ]
        };

        return new Response(JSON.stringify(iamPolicy, null, 2), {
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
          }
        });
      }

      // If the request is to /docs or /docs/, redirect to /docs/introduction
      if (urlObject.pathname === '/docs' || urlObject.pathname === '/docs/') {
        return Response.redirect(urlObject.origin + '/docs/getting-started/introduction', 301);
      }

      // If the request is to the docs subdirectory
      if (urlObject.pathname.startsWith('/docs/')) {
        // Proxy to Mintlify
        const DOCS_URL = "qovery.mintlify.dev";
        const CUSTOM_URL = "www.qovery.com";

        let url = new URL(request.url);
        url.hostname = DOCS_URL;

        let proxyRequest = new Request(url, request);

        proxyRequest.headers.set("Host", DOCS_URL);
        proxyRequest.headers.set("X-Forwarded-Host", CUSTOM_URL);
        proxyRequest.headers.set("X-Forwarded-Proto", "https");
        // If deploying to Vercel, preserve client IP
        proxyRequest.headers.set("CF-Connecting-IP", request.headers.get("CF-Connecting-IP"));

        return await fetch(proxyRequest);
      }

      // Route everything else to main Webflow site
      const MAIN_SITE_URL = "qovery.webflow.io";
      let mainSiteUrl = new URL(request.url);
      mainSiteUrl.hostname = MAIN_SITE_URL;
      return await fetch(mainSiteUrl, {
        method: request.method,
        headers: request.headers,
        body: request.body
      });

      // If no action found, serve the regular request
      return await fetch(request);
    } catch (error) {
      // If error occurs, serve the regular request
      return await fetch(request);
    }
  }
};
