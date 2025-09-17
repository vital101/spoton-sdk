#!/bin/bash

# GitHub Actions Workflow Validation Script
# This script validates the CI workflow syntax and configuration

set -e

echo "🔍 GitHub Actions Workflow Validation"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    case $status in
        "success")
            echo -e "${GREEN}✓${NC} $message"
            ;;
        "warning")
            echo -e "${YELLOW}⚠${NC} $message"
            ;;
        "error")
            echo -e "${RED}✗${NC} $message"
            ;;
        "info")
            echo -e "ℹ $message"
            ;;
    esac
}

# Check if workflow file exists
WORKFLOW_FILE=".github/workflows/ci.yml"
if [ ! -f "$WORKFLOW_FILE" ]; then
    print_status "error" "Workflow file not found: $WORKFLOW_FILE"
    exit 1
fi

print_status "success" "Found workflow file: $WORKFLOW_FILE"

# Validate YAML syntax
echo ""
echo "📋 Validating YAML Syntax"
echo "-------------------------"

if command -v yq >/dev/null 2>&1; then
    if yq eval '.' "$WORKFLOW_FILE" >/dev/null 2>&1; then
        print_status "success" "YAML syntax is valid"
    else
        print_status "error" "YAML syntax validation failed"
        yq eval '.' "$WORKFLOW_FILE" 2>&1 || true
        exit 1
    fi
elif command -v python3 >/dev/null 2>&1; then
    if python3 -c "import yaml; yaml.safe_load(open('$WORKFLOW_FILE'))" 2>/dev/null; then
        print_status "success" "YAML syntax is valid (using Python)"
    else
        print_status "error" "YAML syntax validation failed"
        python3 -c "import yaml; yaml.safe_load(open('$WORKFLOW_FILE'))" 2>&1 || true
        exit 1
    fi
else
    print_status "warning" "No YAML validator found (yq or python3), skipping syntax check"
fi

# Validate GitHub Actions schema
echo ""
echo "🔧 Validating GitHub Actions Schema"
echo "-----------------------------------"

# Check required top-level keys
required_keys=("name" "on" "jobs")
for key in "${required_keys[@]}"; do
    if grep -q "^$key:" "$WORKFLOW_FILE"; then
        print_status "success" "Required key '$key' found"
    else
        print_status "error" "Required key '$key' missing"
        exit 1
    fi
done

# Check job structure
if grep -q "^jobs:" "$WORKFLOW_FILE"; then
    # Extract job names
    job_names=$(grep -A 1000 "^jobs:" "$WORKFLOW_FILE" | grep -E "^  [a-zA-Z_][a-zA-Z0-9_-]*:" | sed 's/://g' | sed 's/^  //')
    
    if [ -n "$job_names" ]; then
        print_status "success" "Found jobs: $(echo $job_names | tr '\n' ' ')"
        
        # Validate each job has required keys
        while IFS= read -r job; do
            if [ -n "$job" ]; then
                if grep -A 50 "^  $job:" "$WORKFLOW_FILE" | grep -q "runs-on:"; then
                    print_status "success" "Job '$job' has runs-on specified"
                else
                    print_status "error" "Job '$job' missing runs-on"
                    exit 1
                fi
                
                if grep -A 50 "^  $job:" "$WORKFLOW_FILE" | grep -q "steps:"; then
                    print_status "success" "Job '$job' has steps defined"
                else
                    print_status "error" "Job '$job' missing steps"
                    exit 1
                fi
            fi
        done <<< "$job_names"
    else
        print_status "error" "No jobs found in workflow"
        exit 1
    fi
fi

# Validate action versions
echo ""
echo "🏷️  Validating Action Versions"
echo "------------------------------"

# Check for pinned action versions
action_lines=$(grep -n "uses:" "$WORKFLOW_FILE" | grep -v "#")
if [ -n "$action_lines" ]; then
    while IFS= read -r line; do
        line_num=$(echo "$line" | cut -d: -f1)
        action=$(echo "$line" | cut -d: -f2- | sed 's/.*uses: *//' | sed 's/^[[:space:]]*//')
        
        if [[ "$action" == *"@"* ]]; then
            version=$(echo "$action" | cut -d@ -f2)
            action_name=$(echo "$action" | cut -d@ -f1)
            
            # Check if version looks like a commit SHA (40 characters, hex)
            if [[ ${#version} -eq 40 && "$version" =~ ^[a-f0-9]+$ ]]; then
                print_status "success" "Action '$action_name' pinned to commit SHA (line $line_num)"
            elif [[ "$version" =~ ^v[0-9]+(\.[0-9]+)*$ ]]; then
                print_status "warning" "Action '$action_name' uses tag version '$version' (line $line_num) - consider pinning to commit SHA"
            else
                print_status "warning" "Action '$action_name' version '$version' format unclear (line $line_num)"
            fi
        else
            print_status "error" "Action '$action' not pinned to version (line $line_num)"
            exit 1
        fi
    done <<< "$action_lines"
else
    print_status "info" "No actions found in workflow"
fi

# Validate environment variables and secrets
echo ""
echo "🔐 Validating Environment and Secrets"
echo "-------------------------------------"

# Check for hardcoded secrets (basic check)
if grep -i -E "(password|token|key|secret)" "$WORKFLOW_FILE" | grep -v -E "(secrets\.|env\.|matrix\.)" | grep -q ":"; then
    print_status "warning" "Potential hardcoded secrets found - please review:"
    grep -n -i -E "(password|token|key|secret)" "$WORKFLOW_FILE" | grep -v -E "(secrets\.|env\.|matrix\.)" || true
else
    print_status "success" "No obvious hardcoded secrets detected"
fi

# Check for proper secret usage
if grep -q "secrets\." "$WORKFLOW_FILE"; then
    print_status "success" "Secrets are properly referenced using secrets. context"
fi

# Validate matrix strategy
echo ""
echo "📊 Validating Matrix Strategy"
echo "-----------------------------"

if grep -A 10 "strategy:" "$WORKFLOW_FILE" | grep -q "matrix:"; then
    print_status "success" "Matrix strategy found"
    
    # Check for fail-fast setting
    if grep -A 10 "strategy:" "$WORKFLOW_FILE" | grep -q "fail-fast:"; then
        fail_fast_value=$(grep -A 10 "strategy:" "$WORKFLOW_FILE" | grep "fail-fast:" | sed 's/.*fail-fast: *//')
        print_status "info" "Matrix fail-fast setting: $fail_fast_value"
    else
        print_status "warning" "Matrix fail-fast not explicitly set (defaults to true)"
    fi
    
    # Check matrix variables
    matrix_vars=$(grep -A 20 "matrix:" "$WORKFLOW_FILE" | grep -E "^[[:space:]]*[a-zA-Z_-]+:" | sed 's/://g' | sed 's/^[[:space:]]*//')
    if [ -n "$matrix_vars" ]; then
        print_status "success" "Matrix variables: $(echo $matrix_vars | tr '\n' ' ')"
    fi
else
    print_status "info" "No matrix strategy found"
fi

# Validate caching configuration
echo ""
echo "💾 Validating Caching Configuration"
echo "-----------------------------------"

if grep -q "actions/cache@" "$WORKFLOW_FILE"; then
    print_status "success" "Caching action found"
    
    # Check cache key configuration
    if grep -A 5 "actions/cache@" "$WORKFLOW_FILE" | grep -q "key:"; then
        print_status "success" "Cache key configured"
    else
        print_status "error" "Cache action missing key configuration"
        exit 1
    fi
    
    # Check cache path configuration
    if grep -A 5 "actions/cache@" "$WORKFLOW_FILE" | grep -q "path:"; then
        print_status "success" "Cache path configured"
    else
        print_status "error" "Cache action missing path configuration"
        exit 1
    fi
    
    # Check for restore-keys
    if grep -A 10 "actions/cache@" "$WORKFLOW_FILE" | grep -q "restore-keys:"; then
        print_status "success" "Cache restore-keys configured for fallback"
    else
        print_status "warning" "Cache restore-keys not configured - consider adding for better cache hits"
    fi
else
    print_status "info" "No caching configuration found"
fi

# Validate artifact upload/download
echo ""
echo "📦 Validating Artifact Configuration"
echo "------------------------------------"

upload_count=$(grep -c "actions/upload-artifact@" "$WORKFLOW_FILE" || echo "0")
download_count=$(grep -c "actions/download-artifact@" "$WORKFLOW_FILE" || echo "0")

print_status "info" "Upload artifact actions: $upload_count"
print_status "info" "Download artifact actions: $download_count"

if [ "$upload_count" -gt 0 ]; then
    # Check artifact retention
    if grep -A 5 "actions/upload-artifact@" "$WORKFLOW_FILE" | grep -q "retention-days:"; then
        print_status "success" "Artifact retention configured"
    else
        print_status "warning" "Artifact retention not configured - will use default (90 days)"
    fi
fi

# Final validation summary
echo ""
echo "📋 Validation Summary"
echo "======================"

print_status "success" "Workflow validation completed successfully!"
print_status "info" "Workflow file: $WORKFLOW_FILE"
print_status "info" "Validation timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)"

echo ""
echo "💡 Recommendations:"
echo "- Consider pinning actions to commit SHAs for better security"
echo "- Review any warnings above and address as needed"
echo "- Test workflow changes in a feature branch before merging"
echo "- Use 'act' tool for local testing before pushing changes"

exit 0