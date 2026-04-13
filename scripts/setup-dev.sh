#!/bin/bash
# Development environment setup script for Logger package

set -e

echo "🚀 Setting up Logger development environment..."
echo ""

# Check Swift installation
echo "✓ Checking Swift toolchain..."
if ! command -v swift &> /dev/null; then
    echo "❌ Swift not found. Install from: https://swift.org/download/"
    exit 1
fi
swift_version=$(swift --version | grep -oE '[0-9]+\.[0-9]+' | head -1)
echo "  Swift $swift_version installed"

# Check Xcode (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "✓ Checking Xcode..."
    if ! command -v xcode-select &> /dev/null; then
        echo "❌ Xcode Command Line Tools not found."
        echo "   Run: xcode-select --install"
        exit 1
    fi
fi

# Install SwiftLint
echo "✓ Checking SwiftLint..."
if ! command -v swiftlint &> /dev/null; then
    echo "  Installing SwiftLint..."
    if command -v brew &> /dev/null; then
        brew install swiftlint
    else
        echo "⚠️  Homebrew not found. Install SwiftLint manually:"
        echo "   https://github.com/realm/SwiftLint"
    fi
else
    swiftlint_version=$(swiftlint version)
    echo "  SwiftLint $swiftlint_version installed"
fi

# Install SwiftFormat (optional, for make format)
echo "✓ Checking SwiftFormat..."
if ! command -v swiftformat &> /dev/null; then
    echo "  Installing SwiftFormat..."
    if command -v brew &> /dev/null; then
        brew install swiftformat
    else
        echo "⚠️  Homebrew not found. Install SwiftFormat manually:"
        echo "   https://github.com/nicklockwood/SwiftFormat"
    fi
else
    swiftformat_version=$(swiftformat --version)
    echo "  SwiftFormat $swiftformat_version installed"
fi

# Verify git hooks are executable
echo "✓ Setting up git hooks..."
if [ -f ".git/hooks/pre-commit" ]; then
    chmod +x .git/hooks/pre-commit
    echo "  Pre-commit hook enabled"
else
    echo "  ⚠️  No pre-commit hook found"
fi

# Build package
echo "✓ Building package..."
swift build

# Run initial tests
echo "✓ Running tests..."
swift test 2>&1 | tail -5

echo ""
echo "✅ Setup complete!"
echo ""
echo "Quick start commands:"
echo "  make test          - Run all tests"
echo "  make lint          - Check code style"
echo "  make format        - Auto-format code"
echo "  make all           - Run all checks"
echo ""
echo "Happy coding! 🎉"
