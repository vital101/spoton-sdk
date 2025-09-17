package test;

import utest.Runner;
import utest.ui.Report;
import utest.TestResult;
import haxe.Timer;

/**
 * Utility class for test suite management and discovery.
 * Provides automatic test registration, execution flow, and reporting capabilities.
 */
class TestRunner {
    
    private var runner:Runner;
    private var startTime:Float;
    private var config:TestConfig;
    private var testResults:TestResults;
    
    /**
     * Creates a new TestRunner instance with the specified configuration.
     * @param config Test configuration settings
     */
    public function new(?config:TestConfig) {
        this.config = config != null ? config : getDefaultConfig();
        this.runner = new Runner();
        this.testResults = createEmptyResults();
        
        // Configure test reporting
        Report.create(runner);
        
        // Set up test result handlers
        setupResultHandlers();
    }
    
    /**
     * Registers a test class with the runner.
     * @param testClass The test class to register
     */
    public function addTest(testClass:Class<Dynamic>):Void {
        runner.addCase(testClass);
    }
    
    /**
     * Registers multiple test classes with the runner.
     * @param testClasses Array of test classes to register
     */
    public function addTests(testClasses:Array<Class<Dynamic>>):Void {
        for (testClass in testClasses) {
            addTest(testClass);
        }
    }
    
    /**
     * Automatically discovers and registers all test classes in the test package.
     * This method uses reflection to find classes that follow the test naming convention.
     */
    public function discoverTests():Void {
        // Note: In a real implementation, this would use macro-based discovery
        // For now, we'll provide a manual registration method that can be called from TestMain
        if (config.logLevel != "silent") {
            trace("Test discovery: Manual registration required until macro implementation");
        }
    }
    
    /**
     * Runs all registered tests and returns the results.
     * @return TestResults containing execution summary
     */
    public function run():TestResults {
        if (config.logLevel != "silent") {
            trace("Starting test execution...");
        }
        startTime = Timer.stamp();
        
        // Run the tests
        runner.run();
        
        // Return results
        return testResults;
    }
    
    /**
     * Gets the current test configuration.
     * @return Current TestConfig
     */
    public function getConfig():TestConfig {
        return config;
    }
    
    /**
     * Updates the test configuration.
     * @param newConfig New configuration to apply
     */
    public function setConfig(newConfig:TestConfig):Void {
        this.config = newConfig;
    }
    
    /**
     * Gets performance metrics for the test run.
     * @return TestMetrics containing timing and performance data
     */
    public function getMetrics():TestMetrics {
        var endTime = Timer.stamp();
        var duration = endTime - startTime;
        
        return {
            totalDuration: duration,
            testCount: runner.length,
            startTime: startTime,
            endTime: endTime
        };
    }
    
    /**
     * Generates a summary report of test execution.
     * @return String containing formatted test summary
     */
    public function generateSummary():String {
        var metrics = getMetrics();
        
        var summary = new StringBuf();
        summary.add("=== Test Execution Summary ===\n");
        summary.add('Total Tests: ${metrics.testCount}\n');
        summary.add('Duration: ${Math.round(metrics.totalDuration * 1000)}ms\n');
        summary.add('Passed: ${testResults.passed}\n');
        summary.add('Failed: ${testResults.failed}\n');
        summary.add('Errors: ${testResults.errors}\n');
        
        if (metrics.testCount > 0) {
            summary.add('Success Rate: ${Math.round((testResults.passed / metrics.testCount) * 100)}%\n');
        }
        
        if (testResults.failed > 0 || testResults.errors > 0) {
            summary.add("\n=== Failures and Errors ===\n");
            for (failure in testResults.failures) {
                summary.add('FAIL: ${failure.method} - ${failure.message}\n');
            }
            for (error in testResults.errorDetails) {
                summary.add('ERROR: ${error.method} - ${error.message}\n');
            }
        }
        
        return summary.toString();
    }
    
    /**
     * Sets up result handlers for test execution monitoring.
     */
    private function setupResultHandlers():Void {
        runner.onProgress.add(function(o) {
            // Simple result tracking without pattern matching
            var resultStr = Std.string(o.result);
            
            if (resultStr.indexOf("Success") >= 0) {
                testResults.passed++;
                if (config.logLevel == "verbose") {
                    trace('✓ PASS: Test completed successfully');
                }
            } else if (resultStr.indexOf("Failure") >= 0) {
                testResults.failed++;
                testResults.failures.push({
                    method: "test_method",
                    message: "Test failed",
                    expected: "",
                    actual: ""
                });
                if (config.logLevel == "verbose") {
                    trace('✗ FAIL: Test failed');
                }
            } else if (resultStr.indexOf("Error") >= 0) {
                testResults.errors++;
                testResults.errorDetails.push({
                    method: "test_method",
                    message: "Test error",
                    stack: ""
                });
                if (config.logLevel == "verbose") {
                    trace('ERROR: Test error');
                }
            } else if (resultStr.indexOf("Ignore") >= 0) {
                testResults.ignored++;
                if (config.logLevel == "verbose") {
                    trace('- SKIP: Test ignored');
                }
            } else if (resultStr.indexOf("Timeout") >= 0) {
                testResults.errors++;
                testResults.errorDetails.push({
                    method: "test_method",
                    message: "Test timeout",
                    stack: ""
                });
                if (config.logLevel == "verbose") {
                    trace('TIMEOUT: Test timed out');
                }
            }
        });
        
        runner.onComplete.add(function(result) {
            if (config.logLevel != "silent") {
                var summary = generateSummary();
                trace(summary);
            }
            
            // Exit with appropriate code based on test results
            var exitCode = (testResults.failed == 0 && testResults.errors == 0) ? 0 : 1;
            #if sys
            Sys.exit(exitCode);
            #end
        });
    }
    
    /**
     * Creates empty test results structure.
     * @return Empty TestResults object
     */
    private function createEmptyResults():TestResults {
        return {
            passed: 0,
            failed: 0,
            errors: 0,
            ignored: 0,
            failures: [],
            errorDetails: []
        };
    }
    
    /**
     * Gets the default test configuration.
     * @return Default TestConfig
     */
    private function getDefaultConfig():TestConfig {
        return {
            enableMocks: true,
            logLevel: "normal",
            timeoutMs: 5000,
            retryAttempts: 0,
            baseUrl: "https://api.spoton.com"
        };
    }
}

/**
 * Test configuration structure
 */
typedef TestConfig = {
    enableMocks: Bool,
    logLevel: String, // "silent", "normal", "verbose"
    timeoutMs: Int,
    retryAttempts: Int,
    baseUrl: String
}

/**
 * Test execution results structure
 */
typedef TestResults = {
    passed: Int,
    failed: Int,
    errors: Int,
    ignored: Int,
    failures: Array<TestFailure>,
    errorDetails: Array<TestError>
}

/**
 * Test failure information
 */
typedef TestFailure = {
    method: String,
    message: String,
    expected: String,
    actual: String
}

/**
 * Test error information
 */
typedef TestError = {
    method: String,
    message: String,
    stack: String
}

/**
 * Test performance metrics
 */
typedef TestMetrics = {
    totalDuration: Float,
    testCount: Int,
    startTime: Float,
    endTime: Float
}