#!/usr/bin/env bash
# Quick Test Script for Nix Develop Setup

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧪 Testing Nix Develop Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Test 1: Check direnv is installed
echo "1️⃣  Checking direnv installation..."
if command -v direnv &> /dev/null; then
    echo "   ✅ direnv is installed"
else
    echo "   ❌ direnv not found - run 'nrs' first"
    exit 1
fi

# Test 2: Create test project
echo ""
echo "2️⃣  Creating test C++ project..."
TEST_DIR="$HOME/test-nix-dev"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cp "$HOME/dotfiles/dev-templates/cpp/flake.nix" "$TEST_DIR/"
echo "   ✅ Test project created at $TEST_DIR"

# Test 3: Create simple C++ file
echo ""
echo "3️⃣  Creating test program..."
cat > "$TEST_DIR/hello.cpp" << 'EOF'
#include <iostream>

int main() {
    std::cout << "Hello from Nix Development Shell! 🎉" << std::endl;
    return 0;
}
EOF
echo "   ✅ hello.cpp created"

# Test 4: Instructions
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎯 Next Steps:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Run these commands:"
echo ""
echo "  cd $TEST_DIR"
echo "  echo 'use flake' > .envrc"
echo "  direnv allow"
echo ""
echo "Then compile and run:"
echo ""
echo "  g++ hello.cpp -o hello"
echo "  ./hello"
echo ""
echo "Try leaving and re-entering the directory to see"
echo "automatic environment activation!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
