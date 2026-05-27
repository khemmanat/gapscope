#!/bin/bash

# AI Agent Initialization Script for GapScope Studio
# This script automates the initialization sequence for AI agents

echo "🤖 GapScope Studio - AI Agent Initialization"
echo "=============================================="
echo ""

# Step 1: Check if we're in the right directory
if [ ! -f "AGENTS.md" ]; then
    echo "❌ Error: AGENTS.md not found"
    echo "   Please run this script from the GapScope root directory"
    exit 1
fi

echo "✅ Found AGENTS.md - initialization protocol loaded"
echo ""

# Step 2: Read and display key architecture information
echo "📋 Loading Architecture Context..."
echo "-----------------------------------"
echo ""

# Check if architecture blueprint exists
if [ -f "docs/guidelines/gapscope_studio_master_architecture_blueprint.md" ]; then
    echo "✅ Architecture blueprint found"
    echo "   Location: docs/guidelines/gapscope_studio_master_architecture_blueprint.md"
    echo "   Size: $(wc -c < docs/guidelines/gapscope_studio_master_architecture_blueprint.md) bytes"
    echo "   Lines: $(wc -l < docs/guidelines/gapscope_studio_master_architecture_blueprint.md) lines"
    echo ""
else
    echo "⚠️  Warning: Architecture blueprint not found"
    echo "   Expected location: docs/guidelines/gapscope_studio_master_architecture_blueprint.md"
    echo ""
fi

# Step 3: Initialize the document reader agent
echo "🚀 Initializing Document Reader Agent..."
echo "-----------------------------------------"
echo ""

if [ -d "docs/agent_system" ]; then
    cd docs/agent_system

    # Check if dart is available
    if ! command -v dart &> /dev/null; then
        echo "❌ Error: Dart command not found"
        echo "   Please ensure Dart is installed and in PATH"
        exit 1
    fi

    echo "Running: dart agent_cli.dart init"
    echo ""
    dart agent_cli.dart init

    echo ""
    echo "🔍 Verifying Agent Status..."
    echo "----------------------------"
    echo ""

    # Run status check
    dart agent_cli.dart status

    echo ""
    cd ../../
else
    echo "❌ Error: docs/agent_system directory not found"
    echo "   Please ensure the agent system is properly set up"
    exit 1
fi

# Step 4: Display project status
echo "📊 GapScope Studio Project Status"
echo "---------------------------------"
echo ""
echo "Project: GapScope Studio"
echo "Type: Flutter Component Workbench + Runtime QA Inspector"
echo "Architecture: Modular package system with Melos workspace"
echo ""

# Step 5: Display next steps
echo "✨ AI Agent Initialization Complete!"
echo "------------------------------------"
echo ""
echo "The AI agent is now ready with full architectural context."
echo ""
echo "Available Commands:"
echo "  cd docs/agent_system"
echo "  dart agent_cli.dart guidance \"ComponentName\""
echo "  dart agent_cli.dart search \"keyword\""
echo "  dart agent_cli.dart architecture"
echo "  dart agent_cli.dart api"
echo ""
echo "🎯 Ready to assist with GapScope Studio development!"
echo ""