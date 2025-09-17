#!/bin/bash

# Branch Protection Verification Script
# This script checks if branch protection rules are properly configured

set -e

# Configuration variables
REPO_OWNER="${GITHUB_REPOSITORY_OWNER:-$(gh repo view --json owner --jq .owner.login)}"
REPO_NAME="${GITHUB_REPOSITORY_NAME:-$(gh repo view --json name --jq .name)}"
BRANCH_NAME="${BRANCH_NAME:-main}"

echo "Verifying branch protection for ${REPO_OWNER}/${REPO_NAME} on branch ${BRANCH_NAME}"

# Check if GitHub CLI is installed and authenticated
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed. Please install it first."
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "Error: GitHub CLI is not authenticated. Please run 'gh auth login' first."
    exit 1
fi

# Get current branch protection status
echo "Fetching current branch protection status..."

PROTECTION_DATA=$(gh api "/repos/${REPO_OWNER}/${REPO_NAME}/branches/${BRANCH_NAME}/protection" 2>/dev/null || echo "null")

if [ "$PROTECTION_DATA" = "null" ]; then
    echo "❌ No branch protection rules found for branch '${BRANCH_NAME}'"
    echo ""
    echo "To set up branch protection, run:"
    echo "  ./.github/scripts/setup-branch-protection.sh"
    exit 1
fi

echo "✅ Branch protection is enabled!"
echo ""

# Verify specific settings
echo "Checking protection settings..."

# Check required status checks
REQUIRED_CHECKS=$(echo "$PROTECTION_DATA" | jq -r '.required_status_checks.contexts[]?' 2>/dev/null || echo "")
if echo "$REQUIRED_CHECKS" | grep -q "CI / test (4.2.5)" && echo "$REQUIRED_CHECKS" | grep -q "CI / test (4.3.4)"; then
    echo "✅ Required status checks configured correctly"
    echo "   - CI / test (4.2.5): ✓"
    echo "   - CI / test (4.3.4): ✓"
else
    echo "❌ Required status checks not configured correctly"
    echo "   Expected: CI / test (4.2.5), CI / test (4.3.4)"
    echo "   Found: $REQUIRED_CHECKS"
fi

# Check strict mode
STRICT_MODE=$(echo "$PROTECTION_DATA" | jq -r '.required_status_checks.strict' 2>/dev/null || echo "false")
if [ "$STRICT_MODE" = "true" ]; then
    echo "✅ Strict mode enabled (branches must be up-to-date)"
else
    echo "❌ Strict mode disabled"
fi

# Check PR requirements
PR_REQUIRED=$(echo "$PROTECTION_DATA" | jq -r '.required_pull_request_reviews != null' 2>/dev/null || echo "false")
if [ "$PR_REQUIRED" = "true" ]; then
    echo "✅ Pull request reviews required"
    
    REQUIRED_REVIEWS=$(echo "$PROTECTION_DATA" | jq -r '.required_pull_request_reviews.required_approving_review_count' 2>/dev/null || echo "0")
    echo "   - Required approving reviews: $REQUIRED_REVIEWS"
    
    DISMISS_STALE=$(echo "$PROTECTION_DATA" | jq -r '.required_pull_request_reviews.dismiss_stale_reviews' 2>/dev/null || echo "false")
    if [ "$DISMISS_STALE" = "true" ]; then
        echo "   - Dismiss stale reviews: ✓"
    else
        echo "   - Dismiss stale reviews: ❌"
    fi
else
    echo "❌ Pull request reviews not required"
fi

# Check admin enforcement
ENFORCE_ADMINS=$(echo "$PROTECTION_DATA" | jq -r '.enforce_admins.enabled' 2>/dev/null || echo "false")
if [ "$ENFORCE_ADMINS" = "false" ]; then
    echo "✅ Administrator override enabled"
else
    echo "⚠️  Administrator override disabled (admins cannot bypass rules)"
fi

# Check force push and deletion protection
ALLOW_FORCE_PUSHES=$(echo "$PROTECTION_DATA" | jq -r '.allow_force_pushes.enabled' 2>/dev/null || echo "true")
ALLOW_DELETIONS=$(echo "$PROTECTION_DATA" | jq -r '.allow_deletions.enabled' 2>/dev/null || echo "true")

if [ "$ALLOW_FORCE_PUSHES" = "false" ]; then
    echo "✅ Force pushes blocked"
else
    echo "❌ Force pushes allowed"
fi

if [ "$ALLOW_DELETIONS" = "false" ]; then
    echo "✅ Branch deletion blocked"
else
    echo "❌ Branch deletion allowed"
fi

echo ""
echo "Branch protection verification complete!"
echo ""
echo "View full settings at:"
echo "https://github.com/${REPO_OWNER}/${REPO_NAME}/settings/branches"