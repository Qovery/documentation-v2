# Qovery Documentation - Claude Session Notes

This file documents the work completed by Claude on the Qovery documentation using Mintlify.

## Session Overview

**Date**: 2025-10-05
**Purpose**: Set up and populate Qovery documentation with comprehensive content across multiple sections

## Work Completed

### 1. Documentation Structure Setup

**Security & Compliance Section**:
- Created comprehensive Security Overview page with merged encryption and backup content
- Created nested Compliance dropdown with 5 compliance frameworks:
  - SOC 2 Type II
  - GDPR (European data protection)
  - DORA (Digital Operational Resilience Act for EU financial services)
  - HIPAA (US healthcare compliance)
  - HDS (French health data hosting)

**Interface Section**:
- Added Terraform Provider page (Infrastructure as Code)
- Added MCP Server page (Model Context Protocol integration with Qovery AI Copilot emphasis)

**Installation**:
- Replaced installation folder with single installation.mdx page
- Page redirects to appropriate integration pages based on deployment option

### 2. Guides Tab Restructure

**New Structure**:
- **Basics**: Existing getting-started guides
- **Use Cases**: 4 comprehensive new guides
  - Production Environment Management (680+ lines)
  - Cloud Migration and Scaling (710+ lines)
  - Ephemeral Environments (640+ lines)
  - Multi Kubernetes Clusters Management (720+ lines)
- **Others**: Previous advanced guides

### 3. Terraform Integration Examples

Created 5 new pages in Integrations > Terraform section:

1. **AWS RDS** (850+ lines)
   - Deployment methods (Lifecycle Job, Helm, Crossplane)
   - Production/development/read replica configurations
   - Security, monitoring, troubleshooting

2. **AWS S3** (780+ lines)
   - Bucket setup with encryption and versioning
   - Static website hosting with CloudFront
   - Data lake configurations
   - Backup strategies

3. **Cloudflare Worker** (880+ lines)
   - Edge computing deployment
   - API gateway with authentication
   - Image optimization
   - A/B testing and Durable Objects

4. **Google BigQuery** (840+ lines)
   - Dataset and table provisioning
   - Scheduled queries and data pipelines
   - BigQuery ML for machine learning
   - Security and cost optimization

5. **Any Terraform Module** (650+ lines)
   - Comprehensive overview showing Qovery's flexibility
   - Examples across compute, databases, networking, security, analytics, SaaS
   - Multi-cloud strategies
   - Best practices

**Key Message**: All pages emphasize that Qovery uses Kubernetes as a universal orchestrator to manage not just containers, but any cloud resource via Terraform.

### 4. Kubernetes Integration Structure

Expanded Kubernetes section with consistent nested structure for all platforms:
- **AWS EKS**: overview, managed, BYOK
- **Google GKE**: overview, managed, BYOK
- **Azure AKS**: overview, managed, BYOK
- **Scaleway Kapsule**: overview, managed, BYOK

Each includes quick start, configuration options, requirements, and troubleshooting.

### 5. Configuration Updates

**Removed .qovery.yml References**:
- Removed all references to `.qovery.yml` (file format doesn't exist)
- Replaced with Console UI instructions
- Updated YAML comment headers from `# .qovery.yml` to `# Qovery Configuration`
- Simplified configuration examples

**Navigation Enhancements**:
- Added topbar links: Console, Roadmap, Website
- Updated theme colors:
  - Primary: #642DFF
  - Light: #D8CBFF (updated from #B296FF)
  - Dark: #151B2B (updated from #370087)

### 6. Documentation Removed

From Documentation tab, removed these sections (to be restructured later):
- Deployment section
- Observability section
- Troubleshooting section
- Installation folder (replaced with single page)

## Key Technical Decisions

1. **Mintlify MDX Format**: All documentation uses Mintlify's MDX components
2. **Component Usage**: CardGroup, Card, Tabs, Tab, Steps, Step, AccordionGroup, Accordion, Info, Warning
3. **Git-Based Workflow**: All changes committed with descriptive messages
4. **Consistent Structure**: Platform pages follow same pattern (overview, managed, BYOK)
5. **Emphasis on Flexibility**: Documentation highlights Kubernetes as universal orchestrator for any resource

## Files Created/Modified

### New Files Created (Total: ~16,000 lines)
- security-and-compliance/overview.mdx (497 lines)
- security-and-compliance/dora.mdx (424 lines)
- security-and-compliance/hipaa.mdx (497 lines)
- security-and-compliance/hds.mdx (545 lines)
- using-qovery/interface/terraform-provider.mdx (520+ lines)
- using-qovery/interface/mcp-server.mdx (470+ lines)
- installation.mdx (335 lines)
- guides/use-cases/production-environment-management.mdx (680+ lines)
- guides/use-cases/cloud-migration-and-scaling.mdx (710+ lines)
- guides/use-cases/ephemeral-environment.mdx (640+ lines)
- guides/use-cases/multi-kubernetes-clusters-management.mdx (720+ lines)
- integrations/terraform/aws-rds.mdx (850+ lines)
- integrations/terraform/aws-s3.mdx (780+ lines)
- integrations/terraform/cloudflare-worker.mdx (880+ lines)
- integrations/terraform/google-bigquery.mdx (840+ lines)
- integrations/terraform/others.mdx (650+ lines)
- integrations/kubernetes/gke/managed.mdx
- integrations/kubernetes/gke/byok.mdx
- integrations/kubernetes/aks/managed.mdx
- integrations/kubernetes/aks/byok.mdx
- integrations/kubernetes/scaleway/managed.mdx
- integrations/kubernetes/scaleway/byok.mdx

### Modified Files
- docs.json (multiple updates for navigation structure)
- CLAUDE.md (this file)

## Git Commits

All work committed with clear, descriptive commit messages:
1. Security & Compliance restructure
2. Interface pages addition
3. Installation page creation
4. Guides tab restructure
5. Kubernetes platform expansion
6. Terraform integration examples
7. .qovery.yml reference removal
8. Navigation link additions
9. Theme color updates

## Repository Information

- **Path**: `/Users/evoxmusic/IdeaProjects/qovery/documentation-v2`
- **Branch**: main
- **Remote**: github.com:Qovery/documentation-v2
- **Status**: All changes committed and pushed

## Notes

- All documentation emphasizes Qovery as a DevOps Automation Platform (not "Internal Developer Platform")
- Consistent use of "Kubernetes as universal orchestrator" messaging
- No emojis used per guidelines
- Code examples include multiple languages (Terraform HCL, YAML, JavaScript, Python, Bash)
- Security and compliance pages include specific regional considerations
- All pages cross-link to related documentation

## Future Considerations

User mentioned need to restructure:
- Deployment section (removed for now)
- Observability section (removed for now)
- Troubleshooting section (removed for now)

These sections are marked for future restructuring per user requirements.
