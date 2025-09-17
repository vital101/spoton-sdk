# CI/CD Troubleshooting Guide

This guide helps you diagnose and resolve common issues with the GitHub Actions CI/CD pipeline for the SpotOn Haxe SDK.

## Quick Diagnostics

### Check Workflow Status

1. Go to the **Actions** tab in your GitHub repository
2. Look for the latest workflow runs
3. Click on a failed run to see detailed logs
4. Check each job step for error messages

### Common Status Indicators

- ✅ **Green checkmark**: All tests passed
- ❌ **Red X**: Tests failed or build error
- 🟡 **Yellow circle**: Workflow is running
- ⚪ **Gray circle**: Workflow is queued or pending

## Common Issues and Solutions

### 1. Haxe Installation Issues

**Error**: `Haxe command not found` or `setup-haxe action failed`

**Symptoms**:
```
Run krdlab/setup-haxe@v1
Error: Unable to locate executable file: haxe
```

**Solutions**:
```yaml
# Ensure correct action version and parameters
- uses: krdlab/setup-haxe@v1
  with:
    haxe-version: ${{ matrix.haxe-version }}

# Alternative: Use specific version
- uses: krdlab/setup-haxe@v1
  with:
    haxe-version: "4.3.4"
```

**Verification**:
```bash
# Add debug step to verify installation
- name: Verify Haxe installation
  run: |
    haxe --version
    haxelib version
```

### 2. Haxelib Setup Issues

**Error**: `Can't use ~/.haxelib because it is reserved for config file`

**Symptoms**:
```
Error: Can't use /home/runner/.haxelib because it is reserved for config file
Error: Process completed with exit code 1
```

**Solutions**:
```yaml
# Use correct haxelib repository path (not ~/.haxelib)
- name: Setup haxelib environment
  run: haxelib setup ~/haxelib

# Ensure cache path matches
- name: Cache haxelib dependencies
  uses: actions/cache@v4
  with:
    path: ~/haxelib  # Not ~/.haxelib
```

**Explanation**: The `~/.haxelib` directory is reserved for haxelib configuration files, not for the library repository. Use `~/haxelib` or another path instead.

### 3. Dependency Installation Failures

**Error**: `haxelib install failed` or missing dependencies

**Symptoms**:
```
Error: Library haxe-concurrent is not installed
Error: Could not process argument --library
Library name or hxml file: : Error: Eof
```

**Solutions**:

**Check haxelib.json validity**:
```bash
# Validate JSON syntax
cat haxelib.json | python -m json.tool
```

**Fix stdin/EOF errors**:
```yaml
# Don't use haxelib install --always without arguments
# This tries to read from stdin and fails in CI
- name: Install dependencies correctly
  run: |
    haxelib install haxe-concurrent --always
    haxelib install utest --always
```

**Clear dependency cache**:
1. Go to repository **Settings** → **Actions** → **Caches**
2. Delete caches with key pattern `haxelib-*`
3. Re-run the workflow

**Manual dependency installation**:
```yaml
- name: Install dependencies with verbose output
  run: |
    haxelib setup ~/haxelib
    haxelib install haxe-concurrent --always
    haxelib install utest --always
    haxelib list
```

**Note**: Avoid using `haxelib install --always` without arguments as it tries to read from stdin and will fail in CI environments.

### 4. Test Execution Failures

**Error**: Tests fail in CI but pass locally

**Common Causes**:
- Platform differences (Windows vs Linux)
- Missing test files in repository
- Environment-specific configurations
- Race conditions in async tests

**Solutions**:

**Check test file inclusion**:
```bash
# Verify all test files are committed
git ls-files test/
```

**Add debug output**:
```yaml
- name: Run tests with debug info
  run: |
    echo "Current directory: $(pwd)"
    echo "Test files:"
    find test/ -name "*.hx" -type f
    haxe build-test.hxml -v
```

**Platform-specific fixes**:
```yaml
# Handle line ending differences
- name: Configure git line endings
  run: git config --global core.autocrlf false
```

### 5. Build Compilation Errors

**Error**: Haxe compilation fails

**Symptoms**:
```
Error: Type not found : spoton.SpotOnClient
Error: Class not found : test.TestRunner
```

**Solutions**:

**Check source paths**:
```yaml
# Verify source structure
- name: Check source structure
  run: |
    ls -la src/
    find src/ -name "*.hx" -type f | head -10
```

**Validate build files**:
```bash
# Check build configuration
cat build-test.hxml
```

**Common fixes**:
```hxml
# Ensure proper classpaths in build-test.hxml
-cp src
-cp test
-main TestRunner
-neko test.n
```

### 6. Cache-Related Issues

**Error**: Slow builds or corrupted dependencies

**Symptoms**:
- Builds take much longer than expected
- Dependency installation fails intermittently
- "Permission denied" errors on cached files

**Solutions**:

**Clear all caches**:
1. Repository **Settings** → **Actions** → **Caches**
2. Delete all cache entries
3. Re-run workflow

**Update cache configuration**:
```yaml
- name: Cache dependencies
  uses: actions/cache@v4
  with:
    path: ~/haxelib  # Correct path, not ~/.haxelib
    key: haxelib-${{ runner.os }}-${{ hashFiles('haxelib.json') }}
    restore-keys: |
      haxelib-${{ runner.os }}-
```

### 7. Branch Protection Issues

**Error**: Cannot merge PR despite passing tests

**Symptoms**:
- Tests show green checkmarks
- PR shows "Merging is blocked"
- Status checks appear to be missing

**Solutions**:

**Verify status check names**:
1. Go to **Settings** → **Branches** → **main** branch rule
2. Check required status checks match workflow job names:
   - `CI / test (4.2.5)`
   - `CI / test (4.3.4)`

**Update branch protection**:
```bash
# Use GitHub CLI to update protection rules
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["CI / test (4.2.5)","CI / test (4.3.4)"]}'
```

### 8. Workflow Permission Issues

**Error**: Workflow cannot update status or create comments

**Symptoms**:
```
Error: Resource not accessible by integration
Error: 403 Forbidden
RequestError [HttpError]: Resource not accessible by integration
```

**Solutions**:

**Check repository permissions**:
1. **Settings** → **Actions** → **General**
2. Ensure "Read and write permissions" is enabled
3. Allow GitHub Actions to create and approve pull requests

**Update workflow permissions**:
```yaml
name: CI
on: [push, pull_request]

permissions:
  contents: read
  statuses: write    # Required for commit status updates
  checks: write      # Required for check runs
  pull-requests: write

jobs:
  test:
    # ... rest of workflow
```

**Note**: The `statuses: write` permission is specifically required for updating commit statuses via the GitHub API.

## Advanced Troubleshooting

### Debug Workflow Locally

Use `act` to run GitHub Actions locally:

```bash
# Install act (requires Docker)
# macOS: brew install act
# Linux: curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Run workflow locally
act push

# Run specific job
act -j test

# Use custom runner image
act -P ubuntu-latest=nektos/act-environments-ubuntu:18.04
```

### Workflow Validation

Validate workflow syntax:

```bash
# Use GitHub CLI to validate
gh workflow view ci.yml

# Or use online validator
# https://rhysd.github.io/actionlint/
```

### Performance Analysis

Monitor workflow performance:

```yaml
- name: Workflow timing
  run: |
    echo "Job started at: $(date)"
    echo "Runner: ${{ runner.os }}"
    echo "Haxe version: ${{ matrix.haxe-version }}"
```

## Getting Additional Help

### Workflow Logs

Always check the detailed workflow logs:

1. Go to **Actions** tab
2. Click on the failed workflow run
3. Expand each step to see detailed output
4. Look for error messages and stack traces

### GitHub Actions Documentation

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Troubleshooting Workflows](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows)

### Community Resources

- [GitHub Actions Community](https://github.community/c/github-actions)
- [Haxe Community](https://community.haxe.org/)
- [Stack Overflow - GitHub Actions](https://stackoverflow.com/questions/tagged/github-actions)

### Reporting Issues

When reporting CI issues, include:

1. **Link to failed workflow run**
2. **Complete error messages** from logs
3. **Steps to reproduce** the issue locally
4. **Recent changes** that might have caused the issue
5. **Environment details** (repository settings, branch protection rules)

Create an issue at: [GitHub Issues](https://github.com/spoton/spoton-haxe-sdk/issues)

## Preventive Measures

### Best Practices

1. **Test locally** before pushing:
   ```bash
   haxe build-test.hxml
   ```

2. **Keep dependencies updated**:
   ```bash
   haxelib update
   ```

3. **Monitor workflow performance**:
   - Check build times regularly
   - Clear caches if builds become slow
   - Update action versions periodically

4. **Validate changes incrementally**:
   - Make small, focused commits
   - Test each change individually
   - Use feature branches for complex changes

### Monitoring

Set up notifications for workflow failures:

1. **Repository** → **Settings** → **Notifications**
2. Enable "Actions" notifications
3. Choose email or web notifications for failures

### Regular Maintenance

- **Monthly**: Review and update action versions
- **Quarterly**: Clear old caches and review performance
- **As needed**: Update Haxe versions in test matrix