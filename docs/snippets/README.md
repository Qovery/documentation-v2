# Documentation Snippets

This directory contains reusable content snippets that should be kept consistent across the documentation.

## Available Snippets

### `install-qovery-cli.mdx`

**Source:** [GitHub Template](https://github.com/Qovery/documentation/blob/main/scripts/generate/templates/_partials/_qovery_install_cli.md.erb)

Contains the complete Qovery CLI installation instructions for all platforms (Linux, MacOS, Windows, Docker) with nested tabs for different installation methods.

**Used in:**
- `/installation/kubernetes.mdx` - Step 1: Install Qovery CLI (BYOK setup)
- `/quickstart/docker-desktop.mdx` - Step 1: Install Qovery CLI
- Should be used anywhere CLI installation instructions are needed

**Update Instructions:**
When updating CLI installation instructions:
1. Update the snippet file: `/snippets/install-qovery-cli.mdx`
2. Copy the updated content to all locations listed above
3. Keep in sync with the [original template](https://github.com/Qovery/documentation/blob/main/scripts/generate/templates/_partials/_qovery_install_cli.md.erb)

**Structure:**
- **Linux**: 3 nested tabs (*nix, Arch Linux, Manual)
- **MacOS**: 3 nested tabs (Homebrew, Script, Manual)
- **Windows**: 2 nested tabs (Scoop, Manual)
- **Docker**: No nested tabs

---

### `aws-credentials-sts.mdx`

**Source:** [AWS Documentation Hub](https://hub.qovery.com/docs/getting-started/install-qovery/aws/cluster-managed-by-qovery/create-credentials/)

Contains the AWS STS Assume Role credentials setup instructions with CloudFormation stack creation and IAM role configuration.

**Used in:**
- `/installation/aws.mdx` - Step 3: Connect AWS Account → STS Assume Role tab
- `/configuration/organization/cloud-credentials.mdx` - AWS section → STS Assume Role tab

**Update Instructions:**
When updating AWS STS credentials instructions:
1. Update the snippet file: `/snippets/aws-credentials-sts.mdx`
2. Copy the updated content to all locations listed above
3. Keep screenshots in sync: `/images/aws-credentials/stack-output.png` and `/images/install-qovery/aws/create-credentials.jpg`

**Screenshots included:**
- CloudFormation stack output with Role ARN
- Qovery Console credentials entry form

---

### `aws-credentials-static.mdx`

**Source:** [AWS Documentation Hub](https://hub.qovery.com/docs/getting-started/install-qovery/aws/cluster-managed-by-qovery/create-credentials/)

Contains the AWS Static Credentials (Access Keys) setup instructions with IAM user creation and access key generation.

**Used in:**
- `/installation/aws.mdx` - Step 3: Connect AWS Account → Static Credentials tab
- `/configuration/organization/cloud-credentials.mdx` - AWS section → Static Credentials tab

**Update Instructions:**
When updating AWS static credentials instructions:
1. Update the snippet file: `/snippets/aws-credentials-static.mdx`
2. Copy the updated content to all locations listed above
3. Keep screenshots in sync (8 total):
   - `/images/aws-credentials/create-user-1.png`
   - `/images/aws-credentials/create-user-2.png`
   - `/images/aws-credentials/create-user-3.png`
   - `/images/aws-credentials/aws-create-credentials-1.png`
   - `/images/aws-credentials/aws-create-credentials-2.png`
   - `/images/aws-credentials/aws-create-credentials-3.png`
   - `/images/aws-credentials/aws-create-credentials-4.png`

**Screenshots included:**
- IAM user creation steps (3 screenshots)
- Access key generation steps (4 screenshots)
- Qovery Console credentials entry form

---

### `gcp-credentials.mdx`

**Source:** [GCP Documentation Hub](https://hub.qovery.com/docs/getting-started/install-qovery/gcp/cluster-managed-by-qovery/create-credentials/)

Contains the GCP credentials setup instructions using service account and JSON key file generation through Cloud Shell.

**Used in:**
- `/installation/gcp.mdx` - Step 1: Create GCP Credentials
- `/configuration/organization/cloud-credentials.mdx` - Google Cloud Platform section

**Update Instructions:**
When updating GCP credentials instructions:
1. Update the snippet file: `/snippets/gcp-credentials.mdx`
2. Copy the updated content to all locations listed above
3. Keep screenshots in sync (5 total):
   - `/images/gcp-credentials/gcp_project.png`
   - `/images/gcp-credentials/cloud-shell.png`
   - `/images/gcp-credentials/gcp_shell_1.png`
   - `/images/gcp-credentials/gcp_shell_5.png`
   - `/images/gcp-credentials/gcp_shell_6.png`

**Screenshots included:**
- GCP project selection
- Cloud Shell interface
- Running credential creation script
- Downloading key.json file
- Uploading credentials to Qovery Console

---

### `scaleway-credentials.mdx`

**Source:** [Scaleway Documentation Hub](https://hub.qovery.com/docs/getting-started/install-qovery/scaleway/cluster-managed-by-qovery/create-credentials/)

Contains the Scaleway credentials setup instructions using IAM applications, API keys, and granular permission policies.

**Used in:**
- `/installation/scaleway.mdx` - Step 1: Create Scaleway Credentials
- `/configuration/organization/cloud-credentials.mdx` - Scaleway section

**Update Instructions:**
When updating Scaleway credentials instructions:
1. Update the snippet file: `/snippets/scaleway-credentials.mdx`
2. Copy the updated content to all locations listed above
3. Keep screenshots in sync (2 total):
   - `/images/scaleway-credentials/iam-menu.png`
   - `/images/scaleway-credentials/create-credentials.jpg`

**Screenshots included:**
- Scaleway IAM menu access
- Entering credentials in Qovery Console

**Key Credentials Required:**
- Access Key ID (starts with `SCW`)
- Secret Access Key (UUID format)
- Organization ID (UUID format)
- Project ID (UUID format)

---

### `azure-credentials.mdx`

**Source:** [Azure Documentation Hub](https://hub.qovery.com/docs/getting-started/install-qovery/azure/cluster-managed-by-qovery/create-credentials/)

Contains the Azure credentials setup instructions using service principals, Tenant ID, Subscription ID, and automated script execution via Azure Cloud Shell.

**Used in:**
- `/installation/azure.mdx` - Step 1: Create Azure Credentials
- `/configuration/organization/cloud-credentials.mdx` - Azure section

**Update Instructions:**
When updating Azure credentials instructions:
1. Update the snippet file: `/snippets/azure-credentials.mdx`
2. Copy the updated content to all locations listed above
3. Keep screenshots in sync (1 screenshot):
   - `/images/azure-credentials/azure_shell_1.png`

**Screenshots included:**
- Azure Cloud Shell in Bash mode

**Key Credentials Required:**
- Tenant ID (Azure AD Directory ID, GUID format)
- Subscription ID (GUID format)
- Service Principal (created automatically by script)

**Notes:**
- The script automatically creates a service principal with Contributor role
- Uses certificate-based authentication for enhanced security
- No manual service principal creation needed

## Note on Reusability

Currently, Mintlify doesn't support dynamic includes/imports for MDX snippets. Therefore:
- Content must be manually copied to each location
- This directory serves as the **single source of truth**
- Always update the snippet file first, then propagate changes to usage locations
