#!/bin/bash

# GitHub Branch Protection Setup Script
# This script configures branch protection rules for the main branch
# Requires GitHub CLI (gh) to be installed and authenticated

set -e

# Configuration variables
REPO_OWNER="${GITHUB_REPOSITORY_OWNER:-$(gh repo view --json owner --jq .owner.login)}"
REPO_NAME="${GITHUB_REPOSITORY_NAME:-$(gh repo view --json name --jq .name)}"
BRANCH_NAME="${BRANCH_NAME:-main}"

echo "Setting up branch protection for ${REPO_OWNER}/${REPO_NAME} on branch ${BRANCH_NAME}"

# Check if GitHub CLI is installed and authenticated
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed. Please install it first."
    echo "Visit: https://cli.github.com/"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "Error: GitHub CLI is not authenticated. Please run 'gh auth login' first."
    exit 1
fi

# Configure branch protection rules
echo "Configuring branch protection rules..."

gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "/repos/${REPO_OWNER}/${REPO_NAME}/branches/${BRANCH_NAME}/protection" \
  --input - << EOF
{
  "required_status_checks": {
    "strict": true,
    "contexts": [
      "CI / test (4.2.5)",
      "CI / test (4.3.4)"
    ]
  },
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": false,
    "require_last_push_approval": false
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "block_creations": false,
  "required_conversation_resolution": true
}
EOF

echo "✅ Branch protection rules configured successfully!"
echo ""
echo "The following protections are now active on the '${BRANCH_NAME}' branch:"
echo "  ✓ Require pull requests before merging"
echo "  ✓ Require status checks to pass before merging"
echo "  ✓ Require branches to be up to date before merging"
echo "  ✓ Required status checks: CI / test (4.2.5), CI / test (4.3.4)"
echo "  ✓ Administrator override enabled (enforce_admins: false)"
echo "  ✓ Dismiss stale reviews when new commits are pushed"
echo "  ✓ Require conversation resolution before merging"
echo "  ✓ Prevent force pushes and branch deletion"
echo ""
echo "You can view and modify these settings at:"
echo "https://github.com/${REPO_OWNER}/${REPO_NAME}/settings/branches"