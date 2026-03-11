---
title: Troubleshooting
description: Solutions for common installation problems and answers to frequently asked questions about HVE-Core collections.
sidebar_position: 8
author: Microsoft
ms.date: 2026-03-11
keywords: [troubleshooting, FAQ, installation, collections, hve-core, hve-installer]
estimated_reading_time: 5
---

# Troubleshooting

This page covers common installation problems and answers frequently asked questions about HVE-Core extensions and collections.

## Common Installation Problems

### Extension Not Loading After Install

**Symptoms**: The extension appears in the Extensions sidebar but HVE-Core agents and prompts are not available in Copilot Chat.

**Solutions**:

1. **Reload VS Code** — Run the `Developer: Reload Window` command from the Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`).
2. **Check Copilot Chat version** — HVE-Core requires GitHub Copilot Chat. Verify it is installed and active in the Extensions sidebar.
3. **Review the Output panel** — Open the Output panel (`Ctrl+Shift+U`) and select the HVE-Core channel. Look for error messages during extension activation.
4. **Verify VS Code version** — HVE-Core requires VS Code 1.99 or later. Check your version under **Help > About**.

### Agent or Prompt Not Appearing in Copilot

**Symptoms**: Some agents or prompts are missing from the `@` mention list or `/` command list in Copilot Chat.

**Solutions**:

1. **Check the workspace** — Agents and prompts load from `.github/` directories in the open workspace. Verify that `.github/agents/` and `.github/prompts/` folders exist and contain `.agent.md` or `.prompt.md` files.
2. **Open a folder, not a file** — Copilot Chat loads workspace-scoped agents only when a folder or workspace is open. Opening a single file does not activate workspace agents.
3. **Verify collection installation** — If you used the HVE Installer, confirm that the selected collections were deployed. Run the installer agent again to verify the installed artifact list.
4. **Check `.gitignore` conflicts** — Ensure your `.gitignore` does not exclude `.github/agents/` or `.github/prompts/` directories.

### Collection Conflicts Between HVE-Core and HVE Installer

**Symptoms**: Duplicate agents appear in Copilot Chat, or agents behave unexpectedly after installing both extensions.

**Solutions**:

1. **Choose one extension** — The HVE-Core extension installs the full `hve-core-all` collection. The HVE Installer deploys individual collections selectively. Using both can produce duplicate artifacts.
2. **Uninstall the duplicate** — If you want all artifacts, keep HVE-Core and uninstall HVE Installer. If you want selective collections, keep HVE Installer and uninstall HVE-Core.
3. **Clean up residual files** — After uninstalling, delete any leftover `.github/agents/`, `.github/prompts/`, `.github/instructions/`, and `.github/skills/` directories that were deployed by the removed extension. Then reinstall with your preferred method.

### Version Compatibility Issues

**Symptoms**: Errors appear after updating VS Code or one of the HVE extensions, or agents reference features that do not exist.

**Solutions**:

1. **Update all extensions together** — When updating VS Code, also update GitHub Copilot, GitHub Copilot Chat, and the HVE extension to their latest versions.
2. **Check release notes** — Review the [CHANGELOG](https://github.com/microsoft/hve-core/blob/main/CHANGELOG.md) for breaking changes between versions.
3. **Clear and redeploy** — If artifacts are out of sync, remove the existing `.github/` HVE-Core artifacts and reinstall using your preferred method.

## Collection FAQ

### Which Extension Should I Install?

| Scenario | Recommended Extension |
|---|---|
| You want everything HVE-Core offers | [HVE-Core](https://marketplace.visualstudio.com/items?itemName=ise-hve-essentials.hve-core) (Full) |
| You want only specific domains (ADO, Design Thinking, etc.) | [HVE Installer](https://marketplace.visualstudio.com/items?itemName=ise-hve-essentials.hve-installer) (Selective) |
| You plan to contribute to HVE-Core | Clone the repository directly — see [Developer Setup](install.md#developer-setup) |

### How Do I Switch from HVE-Core to HVE Installer?

1. Uninstall the HVE-Core extension from the VS Code Extensions sidebar.
2. Delete the `.github/` HVE-Core artifacts that the extension deployed to your workspace.
3. Install the [HVE Installer](https://marketplace.visualstudio.com/items?itemName=ise-hve-essentials.hve-installer) extension.
4. Open Copilot Chat and ask any agent: *"help me customize hve-core installation"*.
5. Select the collections you need.

### Can I Use Both Extensions Simultaneously?

Using both extensions in the same workspace is not recommended. Both deploy artifacts to `.github/` directories, which can result in duplicate agents and prompts. Choose one extension based on whether you need the full collection or selective deployment. See [Collection Conflicts](#collection-conflicts-between-hve-core-and-hve-installer) above for details.

### How Do I Update to the Latest Collection Version?

* **Marketplace extensions** — VS Code handles updates automatically. When a new version is published, VS Code downloads and installs it. You can also manually check for updates in the Extensions sidebar.
* **Clone-based setups** — Pull the latest changes from the upstream repository:

  ```bash
  git pull upstream main
  ```

  Then reinstall dependencies with `npm ci` if `package.json` changed.

---

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
