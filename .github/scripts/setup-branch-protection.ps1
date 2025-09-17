# GitHub Branch Protection Setup Script (PowerShell)
# This script configures branch protection rules for the main branch
# Requires GitHub CLI (gh) to be installed and authenticated

param(
    [string]$BranchName = "main",
    [string]$RepoOwner = $null,
    [string]$RepoName = $null
)

# Set error action preference
$ErrorActionPreference = "Stop"

# Get repository information if not provided
if (-not $RepoOwner) {
    try {
        $RepoOwner = (gh repo view --json owner --jq .owner.login) | Out-String
        $RepoOwner = $RepoOwner.Trim()
    }
    catch {
        Write-Error "Could not determine repository owner. Please specify -RepoOwner parameter."
        exit 1
    }
}

if (-not $RepoName) {
    try {
        $RepoName = (gh repo view --json name --jq .name) | Out-String
        $RepoName = $RepoName.Trim()
    }
    catch {
        Write-Error "Could not determine repository name. Please specify -RepoName parameter."
        exit 1
    }
}

Write-Host "Setting up branch protection for $RepoOwner/$RepoName on branch $BranchName" -ForegroundColor Green

# Check if GitHub CLI is installed and authenticated
try {
    $null = Get-Command gh -ErrorAction Stop
}
catch {
    Write-Error "GitHub CLI (gh) is not installed. Please install it first from https://cli.github.com/"
    exit 1
}

try {
    gh auth status | Out-Null
}
catch {
    Write-Error "GitHub CLI is not authenticated. Please run 'gh auth login' first."
    exit 1
}

# Configure branch protection rules
Write-Host "Configuring branch protection rules..." -ForegroundColor Yellow

$protectionConfig = @{
    required_status_checks = @{
        strict = $true
        contexts = @(
            "CI / test (4.2.5)",
            "CI / test (4.3.4)"
        )
    }
    enforce_admins = $false
    required_pull_request_reviews = @{
        required_approving_review_count = 1
        dismiss_stale_reviews = $true
        require_code_owner_reviews = $false
        require_last_push_approval = $false
    }
    restrictions = $null
    allow_force_pushes = $false
    allow_deletions = $false
    block_creations = $false
    required_conversation_resolution = $true
} | ConvertTo-Json -Depth 10

try {
    $protectionConfig | gh api `
        --method PUT `
        -H "Accept: application/vnd.github+json" `
        -H "X-GitHub-Api-Version: 2022-11-28" `
        "/repos/$RepoOwner/$RepoName/branches/$BranchName/protection" `
        --input -
    
    Write-Host "✅ Branch protection rules configured successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "The following protections are now active on the '$BranchName' branch:" -ForegroundColor Cyan
    Write-Host "  ✓ Require pull requests before merging" -ForegroundColor Green
    Write-Host "  ✓ Require status checks to pass before merging" -ForegroundColor Green
    Write-Host "  ✓ Require branches to be up to date before merging" -ForegroundColor Green
    Write-Host "  ✓ Required status checks: CI / test (4.2.5), CI / test (4.3.4)" -ForegroundColor Green
    Write-Host "  ✓ Administrator override enabled (enforce_admins: false)" -ForegroundColor Green
    Write-Host "  ✓ Dismiss stale reviews when new commits are pushed" -ForegroundColor Green
    Write-Host "  ✓ Require conversation resolution before merging" -ForegroundColor Green
    Write-Host "  ✓ Prevent force pushes and branch deletion" -ForegroundColor Green
    Write-Host ""
    Write-Host "You can view and modify these settings at:" -ForegroundColor Cyan
    Write-Host "https://github.com/$RepoOwner/$RepoName/settings/branches" -ForegroundColor Blue
}
catch {
    Write-Error "Failed to configure branch protection rules: $_"
    exit 1
}