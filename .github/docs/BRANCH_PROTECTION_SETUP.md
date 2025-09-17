# Branch Protection Setup Guide

This guide explains how to configure branch protection rules for the SpotOn Haxe SDK repository to ensure code quality and prevent broken code from being merged into the main branch.

## Overview

Branch protection rules enforce the following requirements:
- All changes must go through pull requests
- CI tests must pass before merging
- Branches must be up-to-date before merging
- Administrators can override protection rules when necessary

## Quick Setup

### Option 1: Automated Script Setup

We provide scripts to automatically configure branch protection rules:

#### Linux/macOS (Bash)
```bash
# Make the script executable
chmod +x .github/scripts/setup-branch-protection.sh

# Run the setup script
./.github/scripts/setup-branch-protection.sh
```

#### Windows (PowerShell)
```powershell
# Run the PowerShell setup script
.\.github\scripts\setup-branch-protection.ps1
```

### Option 2: Manual Setup via GitHub Web Interface

1. Navigate to your repository on GitHub
2. Go to **Settings** → **Branches**
3. Click **Add rule** or edit existing rule for `main` branch
4. Configure the settings as described in the [Configuration Details](#configuration-details) section

### Option 3: Manual Setup via GitHub CLI

```bash
# Install and authenticate GitHub CLI if not already done
gh auth login

# Apply branch protection rules
gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "/repos/OWNER/REPO/branches/main/protection" \
  --input .github/config/branch-protection.json
```

## Prerequisites

Before setting up branch protection, ensure:

1. **GitHub CLI installed** (for automated setup)
   - Install from: https://cli.github.com/
   - Authenticate with: `gh auth login`

2. **CI workflow is working**
   - The `.github/workflows/ci.yml` file exists and is functional
   - Tests run successfully on pushes and pull requests
   - Status checks appear with names: `CI / test (4.2.5)` and `CI / test (4.3.4)`

3. **Repository permissions**
   - You have admin access to the repository
   - You can modify branch protection settings

## Configuration Details

The branch protection rules are configured with the following settings:

### Required Status Checks
- **Require status checks to pass**: ✅ Enabled
- **Require branches to be up to date**: ✅ Enabled
- **Status checks that are required**:
  - `CI / test (4.2.5)` - Tests on Haxe 4.2.5
  - `CI / test (4.3.4)` - Tests on Haxe 4.3.4

### Pull Request Requirements
- **Require pull request reviews before merging**: ✅ Enabled
- **Required approving reviews**: 1
- **Dismiss stale reviews**: ✅ Enabled
- **Require review from code owners**: ❌ Disabled
- **Require approval of the most recent push**: ❌ Disabled

### Additional Restrictions
- **Restrict pushes that create files**: ❌ Disabled
- **Allow force pushes**: ❌ Disabled
- **Allow deletions**: ❌ Disabled

### Administrative Settings
- **Do not allow bypassing the above settings**: ❌ Disabled (allows admin override)
- **Require conversation resolution before merging**: ✅ Enabled

## Verification

After setting up branch protection, verify the configuration:

1. **Check protection status**:
   ```bash
   gh api "/repos/OWNER/REPO/branches/main/protection" | jq .
   ```

2. **Test the protection**:
   - Try to push directly to main branch (should be blocked)
   - Create a pull request with failing tests (should be blocked from merging)
   - Create a pull request with passing tests (should be mergeable)

3. **Visual confirmation**:
   - Visit `https://github.com/OWNER/REPO/settings/branches`
   - Verify all settings match the configuration above

## Troubleshooting

### Common Issues

#### Status Checks Not Found
**Problem**: Error message "Required status check 'CI / test (4.2.5)' is expected but not found"

**Solution**:
1. Ensure the CI workflow has run at least once on the main branch
2. Check that the job names in `.github/workflows/ci.yml` match exactly:
   ```yaml
   jobs:
     test:
       name: test
       strategy:
         matrix:
           haxe-version: [4.2.5, 4.3.4]
   ```
3. The status check names should appear as `CI / test (4.2.5)` and `CI / test (4.3.4)`

#### Permission Denied
**Problem**: "Resource not accessible by integration" or permission errors

**Solution**:
1. Ensure you have admin access to the repository
2. Re-authenticate GitHub CLI: `gh auth login --scopes repo`
3. Check if you're in the correct repository context

#### Script Execution Issues
**Problem**: Script fails to run or permission denied

**Solution**:
1. **Linux/macOS**: Make script executable with `chmod +x .github/scripts/setup-branch-protection.sh`
2. **Windows**: Run PowerShell as Administrator if needed
3. **Windows**: Set execution policy: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

### Manual Verification Commands

```bash
# Check current branch protection status
gh api "/repos/$(gh repo view --json owner,name --jq '.owner.login + "/" + .name')/branches/main/protection"

# List all branches and their protection status
gh api "/repos/$(gh repo view --json owner,name --jq '.owner.login + "/" + .name')/branches" | jq '.[].protection'

# Check recent status checks on main branch
gh api "/repos/$(gh repo view --json owner,name --jq '.owner.login + "/" + .name')/commits/main/status"
```

## Updating Protection Rules

To modify branch protection rules:

1. **Via Script**: Edit the JSON configuration in the setup scripts and re-run
2. **Via Web Interface**: Go to repository Settings → Branches and modify the rule
3. **Via CLI**: Use the GitHub API with updated configuration

### Example: Adding New Status Check

To add a new required status check (e.g., for code coverage):

```bash
# Get current configuration
gh api "/repos/OWNER/REPO/branches/main/protection" > current-protection.json

# Edit the contexts array in required_status_checks
# Add "coverage" to the contexts list

# Apply updated configuration
gh api --method PUT "/repos/OWNER/REPO/branches/main/protection" --input current-protection.json
```

## Security Considerations

- **Administrator Override**: Enabled to allow emergency fixes, but should be used sparingly
- **Force Push Protection**: Prevents rewriting history on the main branch
- **Deletion Protection**: Prevents accidental branch deletion
- **Conversation Resolution**: Ensures all PR discussions are resolved before merging

## Best Practices

1. **Test First**: Always ensure CI is working before enabling branch protection
2. **Gradual Rollout**: Start with basic protection and add more restrictions over time
3. **Team Communication**: Inform team members about new protection rules
4. **Regular Review**: Periodically review and update protection settings
5. **Documentation**: Keep this documentation updated when making changes

## Related Documentation

- [GitHub Actions CI Setup](.github/workflows/ci.yml)
- [Contributing Guidelines](CONTRIBUTING.md)
- [GitHub Branch Protection Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches)