.PHONY: help build test lint format clean all docs

# Default target
help:
	@echo "Logger Swift Package - Available targets:"
	@echo ""
	@echo "  make build          Build the package"
	@echo "  make test           Run all tests"
	@echo "  make test-verbose   Run tests with verbose output"
	@echo "  make lint           Run SwiftLint checks"
	@echo "  make format         Auto-format code with SwiftFormat"
	@echo "  make clean          Remove build artifacts"
	@echo "  make coverage       Generate code coverage report"
	@echo "  make all            Run test, lint, and coverage checks"
	@echo "  make help           Show this help message"
	@echo ""

# Build the package
build:
	@echo "📦 Building Logger package..."
	swift build

# Run all tests
test:
	@echo "🧪 Running tests..."
	swift test

# Run tests with verbose output
test-verbose:
	@echo "🧪 Running tests (verbose)..."
	swift test -v

# Run SwiftLint for code style checks
lint:
	@echo "🔍 Running SwiftLint..."
	@command -v swiftlint >/dev/null 2>&1 || { echo "❌ SwiftLint not installed. Install with: brew install swiftlint"; exit 1; }
	swiftlint lint --strict

# Auto-format code with SwiftFormat
format:
	@echo "✨ Formatting code..."
	@command -v swiftformat >/dev/null 2>&1 || { echo "❌ SwiftFormat not installed. Install with: brew install swiftformat"; exit 1; }
	swiftformat .

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	swift package clean
	rm -rf .build

# Generate code coverage report
coverage:
	@echo "📊 Generating code coverage report..."
	swift test --enable-code-coverage
	@mkdir -p coverage
	@xcrun llvm-cov export \
		.build/debug/LoggerPackageTests.xctest/Contents/MacOS/LoggerPackageTests \
		-instr-profile .build/debug/codecov/default.profdata \
		-format="lcov" > coverage/lcov.info
	@echo "✅ Coverage report generated: coverage/lcov.info"

# Run all checks (test, lint, coverage)
all: test lint coverage
	@echo ""
	@echo "✅ All checks passed!"
	@echo ""

# Deprecated: kept for backward compatibility
check: all
	@true
