#!/bin/bash

# GitHub Actions Performance Monitoring Script
# This script helps analyze and optimize workflow performance

set -e

echo "🔍 GitHub Actions Performance Monitor"
echo "====================================="

# Function to analyze workflow performance
analyze_performance() {
    local workflow_file="$1"
    
    echo "Analyzing workflow: $workflow_file"
    
    # Check for performance optimizations
    echo ""
    echo "📊 Performance Analysis:"
    
    # Check for concurrency controls
    if grep -q "concurrency:" "$workflow_file"; then
        echo "✅ Concurrency controls configured"
    else
        echo "⚠️  Consider adding concurrency controls to prevent resource conflicts"
    fi
    
    # Check for caching
    if grep -q "actions/cache" "$workflow_file"; then
        echo "✅ Caching is configured"
    else
        echo "⚠️  Consider adding caching to speed up builds"
    fi
    
    # Check for parallel execution
    if grep -q "max-parallel:" "$workflow_file"; then
        echo "✅ Parallel execution is configured"
    else
        echo "⚠️  Consider configuring parallel execution for matrix jobs"
    fi
    
    # Check for fail-fast
    if grep -q "fail-fast: false" "$workflow_file"; then
        echo "✅ Fail-fast is disabled (good for comprehensive testing)"
    else
        echo "ℹ️  Fail-fast is enabled (faster feedback but may miss some issues)"
    fi
    
    # Check for performance monitoring
    if grep -q "performance" "$workflow_file"; then
        echo "✅ Performance monitoring is configured"
    else
        echo "⚠️  Consider adding performance monitoring and metrics collection"
    fi
}

# Function to provide optimization recommendations
provide_recommendations() {
    echo ""
    echo "🚀 Performance Optimization Recommendations:"
    echo ""
    echo "1. **Concurrency Controls**:"
    echo "   - Use 'concurrency' to prevent multiple workflows from running simultaneously"
    echo "   - Cancel in-progress runs for feature branches to save resources"
    echo ""
    echo "2. **Caching Strategy**:"
    echo "   - Cache dependencies based on lock files or dependency manifests"
    echo "   - Use multiple restore-keys for better cache hit rates"
    echo "   - Consider caching build artifacts for incremental builds"
    echo ""
    echo "3. **Parallel Execution**:"
    echo "   - Use matrix strategies to run tests in parallel"
    echo "   - Set appropriate max-parallel limits to balance speed and resource usage"
    echo "   - Consider job dependencies to optimize the critical path"
    echo ""
    echo "4. **Resource Optimization**:"
    echo "   - Use appropriate runner types (ubuntu-latest is usually fastest)"
    echo "   - Minimize checkout depth when full history isn't needed"
    echo "   - Use conditional job execution to skip unnecessary work"
    echo ""
    echo "5. **Monitoring and Metrics**:"
    echo "   - Track job durations and identify bottlenecks"
    echo "   - Monitor cache hit rates and dependency installation times"
    echo "   - Set up alerts for performance regressions"
}

# Function to check current performance metrics
check_current_metrics() {
    echo ""
    echo "📈 Current Performance Metrics:"
    
    # Check if performance analysis artifacts exist
    if [ -d "performance-analysis" ]; then
        echo "✅ Performance analysis artifacts found"
        
        if [ -f "performance-analysis/workflow-performance.json" ]; then
            echo "📊 Workflow performance data available"
            
            # Extract key metrics if jq is available
            if command -v jq >/dev/null 2>&1; then
                TOTAL_DURATION=$(jq -r '.total_duration_seconds // "N/A"' performance-analysis/workflow-performance.json)
                echo "   Total Duration: ${TOTAL_DURATION}s"
            fi
        fi
        
        if [ -f "performance-analysis/insights.md" ]; then
            echo "💡 Performance insights available:"
            echo "   Check performance-analysis/insights.md for detailed recommendations"
        fi
    else
        echo "ℹ️  No performance analysis artifacts found"
        echo "   Run the workflow to generate performance metrics"
    fi
}

# Main execution
main() {
    local workflow_file="${1:-.github/workflows/ci.yml}"
    
    if [ ! -f "$workflow_file" ]; then
        echo "❌ Workflow file not found: $workflow_file"
        echo "Usage: $0 [workflow-file]"
        exit 1
    fi
    
    analyze_performance "$workflow_file"
    provide_recommendations
    check_current_metrics
    
    echo ""
    echo "✅ Performance analysis complete!"
    echo ""
    echo "💡 Tips:"
    echo "- Run this script regularly to monitor performance trends"
    echo "- Check the GitHub Actions usage dashboard for billing insights"
    echo "- Consider using self-hosted runners for consistent performance"
}

# Run main function with all arguments
main "$@"