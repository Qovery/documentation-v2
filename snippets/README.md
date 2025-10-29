# Documentation Snippets

This directory contains reusable content snippets that should be kept consistent across the documentation.

## Available Snippets

### `install-qovery-cli.mdx`

**Source:** [GitHub Template](https://github.com/Qovery/documentation/blob/main/scripts/generate/templates/_partials/_qovery_install_cli.md.erb)

Contains the complete Qovery CLI installation instructions for all platforms (Linux, MacOS, Windows, Docker) with nested tabs for different installation methods.

**Used in:**
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

## Note on Reusability

Currently, Mintlify doesn't support dynamic includes/imports for MDX snippets. Therefore:
- Content must be manually copied to each location
- This directory serves as the **single source of truth**
- Always update the snippet file first, then propagate changes to usage locations
