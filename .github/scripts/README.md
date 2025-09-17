# GitHub Scripts

This directory contains automation scripts for managing GitHub repository settings and CI/CD workflows.

## Branch Protection Scripts

### setup-branch-protection.sh / setup-branch-protection.ps1
Automatically configures branch protection rules for the main branch according to the project requirements.

**Usage:**
```bash
# Linux/macOS
./setup-branch-protection.sh

# Windows PowerShell
.\setup-branch-protection.ps1
```

**Requirements:**
- GitHub CLI (`gh`) installed and authenticated
- Repository admin permissions

**What it configures:**
- Requires pull requests for all changes to main branch
- Requires CI status checks to pass (Haxe 4.2.5 and 4.3.4 tests)
- Requires branches to be up-to-date before merging
- Enables administrator override capabilities
- Prevents force pushes and branch deletion
- Requires conversation resolution before merging

### verify-branch-protection.sh
Verifies that branch protection rules are properly configured and reports any issues.

**Usage:**
```bash
./verify-branch-protection.sh
```

**What it checks:**
- Branch protection is enabled
- Required status checks are configured correctly
- Pull request requirements are set
- Administrator override settings
- Force push and deletion protection

## Prerequisites

Before running these scripts, ensure:

1. **GitHub CLI is installed**
   - Download from: https://cli.github.com/
   - Authenticate with: `gh auth login`

2. **Repository permissions**
   - You have admin access to the repository
   - You can modify branch protection settings

3. **CI workflow is functional**
   - The `.github/workflows/ci.yml` exists and works
   - Status checks appear as `CI / test (4.2.5)` and `CI / test (4.3.4)`

## Configuration Files

- `.github/config/branch-protection.json` - JSON configuration for GitHub API
- `.github/docs/BRANCH_PROTECTION_SETUP.md` - Detailed setup documentation

## Troubleshooting

If scripts fail to run:

1. **Permission issues (Linux/macOS):**
   ```bash
   chmod +x .github/scripts/*.sh
   ```

2. **PowerShell execution policy (Windows):**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. **GitHub CLI authentication:**
   ```bash
   gh auth login --scopes repo
   ```

For detailed troubleshooting, see `.github/docs/BRANCH_PROTECTION_SETUP.md`.