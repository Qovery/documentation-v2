# Qovery Documentation - Agent Session Notes

This file documents the work completed by AI agents on the Qovery documentation using Mintlify.

## Current Session Overview

**Date**: 2025-10-13 (Continued Session)
**Purpose**: Complete Qovery documentation with Configuration overview, API Gateway guides, and kubectl access

## Latest Work Completed (Current Session)

### 12. Configuration Overview Page (2025-10-13)
- **Created**: configuration/overview.mdx (628 lines, 17KB)
- **Content**: Comprehensive overview for Configuration tab
- **Structure**: Introduction to all configuration sections with visual hierarchy
- **Key Sections**:
  - Mermaid hierarchy diagram (Organization → Projects → Environments → Services)
  - Configuration Sections (5 cards: Organization, Resources, Services, Deployment, Settings)
  - Organization Configuration (8 accordions with detailed explanations)
  - Resources Configuration (3 tabs: Projects, Environments, Clusters)
  - Services Configuration (6 cards for all service types)
  - Deployment Configuration (9 steps covering full deployment process)
  - Settings (2 cards: Environment Variables, Advanced Settings)
  - Configuration Best Practices (8 cards)
  - Configuration Methods (4 tabs: Console, CLI, API, Terraform)
  - Common Workflows (4 accordions with step-by-step guides)
  - Next Steps (4 cards linking to quickstart, org setup, CLI, API)
- **Components Used**: CardGroup, AccordionGroup, Tabs, Steps, Mermaid diagram
- **Brand Colors**: Mermaid diagram uses Qovery purple palette (#642DFF, #7C3FFF, #965FFF, #B080FF)
- **Navigation**: Added as first item in Configuration tab under "Overview" group
- **Purpose**: Provides comprehensive introduction to all configuration capabilities

### 11. EKS kubectl Access Guide (2025-10-11)
- **Created**: integrations/kubernetes/eks/kubectl-access.mdx (605 lines, 16KB)
- **Content**: Comprehensive guide for connecting to EKS clusters with kubectl
- **Structure**: Two-method approach with Qovery CLI recommended first
- **Key Sections**:
  - Overview with two methods clearly explained
  - Prerequisites with tabs for each method
  - Method 1: Qovery CLI (Recommended)
    - Option A: Get Kubeconfig File (5 steps)
    - Option B: Open Debug Pod (3 steps)
  - Method 2: AWS CLI (Traditional)
    - IAM permissions setup
    - AWS CLI configuration
    - Manual kubeconfig setup
  - Working with Applications (namespace, pods, logs, shell)
  - Common Operations (port-forward, describe, resource usage, events)
  - Troubleshooting (4 accordion sections)
  - Security Best Practices (Do's and Don'ts cards)
  - Comparison table: Qovery CLI vs AWS CLI
  - Next Steps (4 cards linking to related docs)
- **Components Used**: Tabs, Steps, Accordion, AccordionGroup, CardGroup, Warning, Info, Tip
- **CLI Commands Featured**:
  - `qovery cluster kubeconfig --cluster-id <id>` - Downloads kubeconfig
  - `qovery cluster debug-pod -o <org-id> -c <cluster-id>` - Opens debug pod
- **Updated**: cli/commands/cluster.mdx with new kubeconfig and debug-pod commands
- **Navigation**: Added to docs.json under Integrations > Kubernetes > AWS EKS group

## Previous Work Completed

### 1. Introduction Page Updates
- **Product Logos**: Updated introduction.mdx to use actual Qovery product SVG logos instead of generic icons
- **Architecture Diagram**: Integrated qovery-architecture.svg showing 5 products on Kubernetes
- Created "How Qovery Works" section with architecture visualization
- Updated card icons to use `/logos/provision.svg`, `/logos/deploy.svg`, etc.

### 2. How It Works Page Simplification
- **Complete Rewrite**: Reduced from 416 lines to 156 lines
- **Focus**: Emphasized "Kubernetes as super orchestrator" concept
- **Content Removed**: Excessive technical details about deployment workflows, networking, scaling
- **Content Added**: Architecture SVG, product logo cards, universal orchestration capabilities
- Maintained key concepts while improving readability

### 3. Documentation Cleanup
- **Removed "What is Qovery?" page**: Content merged into introduction
- **Removed .qovery.yml references**: Removed from 6 files (non-existent file format)

### 4. Guides Tab Restructure
- **New Structure**: Basics, Use Cases, Others
- **Use Cases Created** (4 comprehensive guides):
  - Production Environment Management
  - Cloud Migration and Scaling
  - Ephemeral Environment
  - Multi Kubernetes Clusters Management

### 5. VPC Peering Guide
- **Created**: guides/others/aws-vpc-peering.mdx (357 lines)
- **Content**: Imported from qovery.com/docs, adapted to Mintlify format
- **Sections**: Prerequisites, step-by-step setup, route tables, security groups, testing

### 6. CLI Commands Documentation
- **Structure Change**: Broke single CLI page into 20 individual command pages
- **Navigation**: Matches API Reference style with individual pages per command
- **Commands Documented**:
  - auth (with --headless option)
  - context, project, environment
  - application, database, container
  - cronjob, lifecycle, helm
  - service, env, log, shell
  - port-forward, status, cluster
  - console, demo, token

### 7. Terraform Provider Documentation
- **Registry Links**: Added prominent links to registry.terraform.io
- **Integration Examples**: Created pages for AWS RDS, AWS S3, Cloudflare Worker, Google BigQuery, Others

### 8. Copilot Tab (Complete Documentation)

#### Created 10 Comprehensive Pages:

**Overview Section**:
- `copilot/overview.mdx` - Main Copilot introduction with agentic AI explanation
  - Added Mermaid architecture diagram showing 7-step workflow
  - Shows knowledge sources: Documentation + Data Warehouse
  - Updated access methods to Web Console and MCP Server only
  - Color-coded with Qovery brand colors
- `copilot/what-is-agentic-ai.mdx` - Deep dive into agentic AI technology

**Getting Started**:
- `copilot/getting-started.mdx` - How to use Copilot effectively
- `copilot/mcp-server.mdx` - MCP Server setup for Claude Desktop

**Capabilities** (with support matrices):
- `copilot/capabilities/infrastructure-management.mdx` - 10 capabilities documented
- `copilot/capabilities/deployment-automation.mdx` - 11 capabilities documented
- `copilot/capabilities/optimization.mdx` - 9 capabilities documented
- `copilot/capabilities/troubleshooting.mdx` - 12 capabilities documented

Each capability page includes:
- Support level matrix (✅ Full Support, 🚧 Partial Support, ⏳ Coming Soon)
- Example prompts
- Last validation date (2025-01-15 placeholder)

**Examples**:
- `copilot/examples/common-tasks.mdx` - Everyday operations
- `copilot/examples/advanced-workflows.mdx` - Complex automation including time-based scheduling

#### Copilot Key Features Documented:
- **Early Access**: Requires contact to support@qovery.com
- **Agentic Nature**: Plans, executes, reasons, learns (not just a chatbot)
- **Model**: Powered by Claude Sonnet 4.5 (with future model selection)
- **Access Methods**: Web Console (integrated chat) and MCP Server (Claude Desktop)
- **Knowledge Sources**:
  - Full Qovery documentation access
  - Data Warehouse with historical infrastructure data
- **Time-Based Automation**:
  - One-time scheduled tasks
  - Recurring schedules (daily, weekly)
  - Maintenance windows
  - Cost optimization schedules
  - Ephemeral environment lifecycle
  - Conditional time-based rules

#### Advanced Workflows Examples Added:
- "Every weekday at 6 PM, stop all dev environments"
- "Deploy hotfix tomorrow at 2 AM"
- "Run database backups every night at 2 AM"
- "Scale down non-production services on weekends"
- "During business hours, ensure 5 replicas. Outside hours, scale to 2"
- "Delete feature environments older than 2 weeks every Monday"

### 9. Brand Identity & Styling

#### Custom CSS (custom.css):
- Card icon sizing: 64x64px (balanced size)
- Fixed icon overlap issues with proper spacing
- Maintained aspect ratio with object-fit
- Proper flex layout for cards

**Logos**: Using actual product SVGs from `/logos/` directory:
- provision.svg / provision-white.svg
- deploy.svg / deploy-white.svg
- observe.svg / observe-white.svg
- optimize.svg / optimize-white.svg
- secure.svg / secure-white.svg

### 10. Theme Configuration
- **Primary Color**: #642DFF (Qovery Purple)
- **Light Background**: #D8CBFF
- **Dark Background**: #151B2B
- **Typography**: Roboto Flex for headings/body, Roboto Mono for code
- **Navigation**: Added Console, Roadmap, Website links to topbar

## Git Commits (Current Session)

Total commits in current session: **30**

1. Use actual product logos in introduction cards
2. Remove "What is Qovery?" page
3. Simplify "How It Works" page with architecture focus
4. Restructure Guides tab (Basics, Use Cases, Others)
5. Add Terraform integration examples (5 pages)
6. Remove .qovery.yml references across documentation
7. Add navigation links (Console, Roadmap, Website)
8. Update theme colors (light/dark backgrounds)
9. Integrate architecture SVG diagram
10. Replace Others section with VPC Peering guide
11. Break CLI commands into individual pages (20 pages)
12. Add Terraform Registry links
13. Create comprehensive Copilot tab (10 pages)
14. Move Copilot tab after Integrations
15. Redirect Interface MCP Server page to Copilot
16. Fix parsing error in MCP Server page
17. Revert custom branding styles
18. Add early access notices to Copilot docs
19. Add capability support matrices (4 capability pages)
20. Add time-based scheduling to advanced workflows
21. Update Copilot to Claude Sonnet 4.5
22. Fix product logo icon sizes (custom.css)
23. Increase icon size to 96px
24. Fix icon overlap with 64px and spacing
25. Add --headless option to qovery auth
26. Add Mermaid diagram and update access methods
27. Add knowledge sources to Copilot architecture
28. Add Configuration tab overview page
29. Rename CLAUDE.md to AGENT.md

## Documentation Statistics

### Pages Created This Session: ~35+ pages
- Configuration overview: 1 page
- API Gateway guides: 2 pages (NGINX, Caddy)
- kubectl access guide: 1 page
- Copilot documentation: 10 pages
- CLI commands: 20 individual pages
- VPC Peering guide: 1 page
- Use cases: 4 pages (previous session continued)

### Total Lines of Documentation: ~13,000+ lines
- Configuration overview: ~630 lines
- API Gateway guides: ~2,500 lines (NGINX + Caddy)
- kubectl access: ~605 lines
- Copilot section: ~3,500 lines
- CLI commands: ~2,000 lines
- Guides: ~2,700 lines
- Other updates: ~1,800 lines

## Key Technical Features

### Mermaid Diagram Architecture
The Copilot overview includes a comprehensive Mermaid flowchart showing:
1. User request → Natural language processing
2. Knowledge sources (Documentation + Data Warehouse)
3. Planning engine → Task sequencing
4. Qovery API tools execution
5. Infrastructure management via Kubernetes
6. State validation with retry logic
7. Conversation memory for context
8. Response generation

### Capability Support Matrices
All capability pages include tables with:
- Capability name and category
- Example prompt
- Support level (Full/Partial/Coming Soon)
- Last validation date

### Time-Based Scheduling
Documented 8 categories of time-based automation:
1. Scheduled one-time tasks
2. Recurring scheduled tasks
3. Time-based cost optimization
4. Maintenance windows
5. Conditional time-based actions
6. Ephemeral environment lifecycle
7. Progressive deployments
8. Disaster recovery automation

## Files Modified/Created (Current Session)

### New Files:
- configuration/overview.mdx
- integrations/kubernetes/eks/kubectl-access.mdx
- integrations/api-gateway-nginx.mdx
- integrations/api-gateway-caddy.mdx
- copilot/overview.mdx
- copilot/what-is-agentic-ai.mdx
- copilot/getting-started.mdx
- copilot/mcp-server.mdx
- copilot/capabilities/infrastructure-management.mdx
- copilot/capabilities/deployment-automation.mdx
- copilot/capabilities/optimization.mdx
- copilot/capabilities/troubleshooting.mdx
- copilot/examples/common-tasks.mdx
- copilot/examples/advanced-workflows.mdx
- cli/commands/auth.mdx
- cli/commands/context.mdx
- cli/commands/project.mdx
- cli/commands/environment.mdx
- cli/commands/application.mdx
- cli/commands/database.mdx
- cli/commands/container.mdx
- cli/commands/cronjob.mdx
- cli/commands/lifecycle.mdx
- cli/commands/helm.mdx
- cli/commands/service.mdx
- cli/commands/env.mdx
- cli/commands/log.mdx
- cli/commands/shell.mdx
- cli/commands/port-forward.mdx
- cli/commands/status.mdx
- cli/commands/cluster.mdx
- cli/commands/console.mdx
- cli/commands/demo.mdx
- cli/commands/token.mdx
- guides/others/aws-vpc-peering.mdx
- images/qovery-architecture.svg
- custom.css

### Modified Files:
- docs.json (navigation updates, CSS reference, Configuration overview, API Gateway group, kubectl access)
- introduction.mdx (product logos, architecture)
- how-it-works.mdx (complete rewrite)
- using-qovery/interface/mcp-server.mdx (redirect to Copilot)
- terraform/overview.mdx (registry links)
- cli/commands/cluster.mdx (added kubeconfig and debug-pod commands)
- AGENT.md (this file, renamed from CLAUDE.md)

## Repository Status

- **Path**: `/Users/evoxmusic/IdeaProjects/qovery/documentation-v2`
- **Branch**: main
- **Status**: All changes committed
- **Total Commits**: 30 commits (current session)
- **Last Commit**: Add Configuration tab overview page (28c5084)

## Key Messages & Themes

1. **Kubernetes as Universal Orchestrator**: Consistently emphasized throughout all documentation
2. **Agentic AI**: Not just a chatbot - plans, executes, reasons, learns autonomously
3. **Early Access**: Copilot available by contacting support@qovery.com
4. **Time-Based Intelligence**: Comprehensive scheduling and automation capabilities
5. **Knowledge-Enhanced**: Access to documentation and historical data warehouse
6. **Multi-Cloud**: AWS, GCP, Azure, Scaleway support
7. **DevOps Automation Platform**: Consistent terminology (not "Internal Developer Platform")

## Technical Decisions

1. **Mintlify Components**: Extensive use of Card, CardGroup, Tabs, Steps, Accordion
2. **Mermaid Diagrams**: Used for architecture visualization with brand colors
3. **Support Matrices**: Structured tables for capability tracking
4. **Brand Colors**: Purple palette (#642DFF primary) with extended variations
5. **Custom CSS**: Minimal, focused on icon sizing and spacing
6. **Individual CLI Pages**: Better navigation and SEO (matches API Reference pattern)
7. **No Emojis**: Professional tone throughout documentation

## Notes for Future Reference

- Copilot validation dates set to 2025-01-15 (placeholder for Qovery team to update)
- All Copilot features marked as Beta
- MCP Server setup requires Node.js 18+ or Python 3.10+
- Web Console has integrated Copilot chat (no setup required)
- Time-based automation includes conditional rules based on time of day
- Knowledge sources enable historical trend analysis and data-driven decisions

## Session Continuation

This session is a continuation of previous work on the Qovery documentation. Previous session completed basic structure, security/compliance, integrations, and guides. Current session focused on:
- Branding and visual identity
- Complete Copilot documentation with advanced features
- CLI command reference
- Architecture diagrams and visualizations
- Time-based automation capabilities
