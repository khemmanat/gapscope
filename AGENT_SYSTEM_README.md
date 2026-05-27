# GapScope Studio - AI Agent System

## 🎯 Quick Start for AI Agents

**For AI Agents**: Start here! This system provides intelligent context and guidance for GapScope Studio development.

### 🚀 Instant Initialization

```bash
# Option 1: Automated initialization (Recommended)
./agent_init.sh

# Option 2: Manual initialization
cd docs/agent_system
dart agent_cli.dart init
```

### 📋 Essential Reading Order

1. **AGENTS.md** - AI Agent protocol and initialization instructions
2. **docs/guidelines/gapscope_studio_master_architecture_blueprint.md** - Complete architecture
3. **docs/agent_system/README.md** - Agent system documentation

---

## 🤖 What is the AI Agent System?

The GapScope AI Agent System is an intelligent document processing and context-aware assistant that:

- **Reads and caches** all project documentation
- **Understands** the complete GapScope architecture
- **Provides** context-aware guidance for development
- **Ensures** adherence to architectural constraints
- **Accelerates** development with intelligent search

---

## 🏗️ Architecture Context

### Project Overview

**GapScope Studio** is a Flutter component workbench and runtime QA inspector that combines:

- Widgetbook-style component catalog
- Runtime layout inspection
- Overlay/dialog/bottomsheet inspection
- Flex and whitespace visualization
- Accessibility inspection
- Story preview system
- QA reporting tools

### Current Development Phase

**Phase 1**: Basic Studio + Story Preview

Features:
- Sidebar navigation
- Story rendering
- Theme addon
- Device addon
- Inspector toggle

---

## 🔧 AI Agent Capabilities

### 1. Context-Aware Processing

The agent enhances your prompts with relevant architectural context:

```bash
dart agent_cli.dart ask "How should I structure the inspector system?"
```

The agent automatically:
- Loads relevant architecture sections
- Finds related documentation
- Extracts component-specific guidance
- Provides API examples

### 2. Architectural Guidance

Get specific guidance for any component:

```bash
dart agent_cli.dart guidance "GapScopeInspector"
```

### 3. Documentation Search

Search across all project documentation:

```bash
dart agent_cli.dart search "overlay system"
```

### 4. Development Phase Tracking

Check current phase requirements:

```bash
dart agent_cli.dart phases
```

---

## 📁 System Structure

```
gapscope/
├── AGENTS.md                          # AI Agent protocol (START HERE!)
├── agent_init.sh                      # Automated initialization script
├── AGENT_SYSTEM_README.md            # This file
│
├── docs/
│   ├── agent_system/                 # AI Agent implementation
│   │   ├── agent_cli.dart           # CLI entry point
│   │   ├── document_reader_agent.dart
│   │   ├── ai_prompt_processor.dart
│   │   ├── agent_init_command.dart
│   │   └── README.md                # Agent system docs
│   │
│   └── guidelines/                   # Project documentation
│       └── gapscope_studio_master_architecture_blueprint.md
```

---

## 🎯 Common AI Agent Workflows

### Creating New Components

```bash
# 1. Initialize agent system
./agent_init.sh

# 2. Get architectural guidance
cd docs/agent_system
dart agent_cli.dart guidance "GapScopeComponent"

# 3. Review API examples
dart agent_cli.dart api

# 4. Search for similar patterns
dart agent_cli.dart search "component"
```

### Building Inspector Features

```bash
# 1. Initialize and get context
./agent_init.sh

# 2. Get inspector-specific guidance
cd docs/agent_system
dart agent_cli.dart guidance "GapScopeInspector"

# 3. Check performance requirements
dart agent_cli.dart search "performance"

# 4. Review overlay constraints
dart agent_cli.dart search "overlay"
```

### Architecture Verification

```bash
# 1. Load architecture context
./agent_init.sh

# 2. Review full architecture
cd docs/agent_system
dart agent_cli.dart architecture

# 3. Check specific constraints
dart agent_cli.dart search "performance rules"
dart agent_cli.dart search "package structure"
```

---

## ⚙️ Configuration & Constraints

### Critical Architectural Rules

**File Size**: 100-250 lines per file
**State Management**: ValueNotifier/ChangeNotifier preferred
**Rendering**: CustomPainter for performance
**Dependencies**: No heavy external dependencies
**Package Boundaries**: Package must not depend on apps

### Package Structure

```
gapscope/
├── packages/gapscope/              # Main reusable package
├── apps/gapscope_studio_app/      # Development app
└── docs/                          # Documentation only
```

**Important**: The studio app depends on the package, not vice versa.

---

## 🔍 Quick Reference Commands

### Initialization

```bash
# Automated (recommended)
./agent_init.sh

# Manual
cd docs/agent_system
dart agent_cli.dart init
```

### Information Retrieval

```bash
cd docs/agent_system

# System status
dart agent_cli.dart status

# Architecture blueprint
dart agent_cli.dart architecture

# Development phases
dart agent_cli.dart phases

# Tech stack
dart agent_cli.dart techstack

# API examples
dart agent_cli.dart api
```

### Search & Guidance

```bash
cd docs/agent_system

# Search documentation
dart agent_cli.dart search "keyword"

# Get component guidance
dart agent_cli.dart guidance "ComponentName"

# Ask with context
dart agent_cli.dart ask "your question"
```

---

## 📊 Project Status Tracking

### Current Status

- **Architecture**: ✅ Defined and documented
- **AI Agent System**: ✅ Operational
- **Documentation**: ✅ Comprehensive
- **Development**: Phase 1 (Basic Studio + Story Preview)

### Next Phases

- **Phase 2**: Runtime spacing inspection
- **Phase 3**: Overlay support
- **Phase 4**: Advanced QA features
- **Phase 5**: Export + ecosystem

---

## 🚨 Troubleshooting

### Common Issues

**Issue**: `AGENTS.md not found`
- **Solution**: Ensure you're in the GapScope root directory

**Issue**: `Dart command not found`
- **Solution**: Install Dart SDK and add to PATH

**Issue**: `No documents loaded`
- **Solution**: Check docs/ directory contains supported files (.md, .txt, .json)

**Issue**: `Architecture blueprint not found`
- **Solution**: Verify `gapscope_studio_master_architecture_blueprint.md` exists

---

## 🎓 Best Practices for AI Agents

### Before Any Task

1. ✅ Read AGENTS.md
2. ✅ Run initialization script
3. ✅ Load architecture context
4. ✅ Check current development phase
5. ✅ Verify constraints

### During Development

1. ✅ Consult architecture for decisions
2. ✅ Use agent commands for guidance
3. ✅ Follow established conventions
4. ✅ Maintain package boundaries
5. ✅ Adhere to file size limits

### After Implementation

1. ✅ Verify against architecture
2. ✅ Check performance requirements
3. ✅ Validate package structure
4. ✅ Ensure documentation completeness

---

## 🔗 Additional Resources

### Documentation

- **AGENTS.md** - AI Agent protocol and rules
- **docs/agent_system/README.md** - Agent system documentation
- **docs/guidelines/gapscope_studio_master_architecture_blueprint.md** - Complete architecture

### Tools

- **agent_init.sh** - Automated initialization
- **agent_cli.dart** - Command-line interface

### External Resources

- Flutter Documentation: https://flutter.dev/docs
- Dart Documentation: https://dart.dev/guides
- Melos Workspace: https://melos.infinitered.com/

---

## 🎯 Success Criteria

AI agents using this system should be able to:

- ✅ Understand the complete GapScope architecture
- ✅ Provide context-aware guidance
- ✅ Follow architectural constraints
- ✅ Make informed decisions about implementation
- ✅ Maintain consistency with established patterns
- ✅ Accelerate development while maintaining quality

---

## 🚀 Ready to Build!

The AI Agent System is now ready to assist with GapScope Studio development.

**Start here**: `./agent_init.sh`

Then explore the capabilities and let the agent guide your development with full architectural context.

---

*Last Updated: 2025-05-27*
*GapScope Studio - Architecture-aware AI Agent System*