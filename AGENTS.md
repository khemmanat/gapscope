# AGENTS.md - AI Agent Initialization Protocol

## 🤖 AI Agent Instructions

**IMPORTANT**: Before processing ANY user prompt, AI agents MUST follow this initialization protocol to ensure proper context and understanding of the GapScope Studio architecture.

---

## 🚀 Initialization Sequence

### Step 1: Read Architecture Blueprint

**CRITICAL**: Start by reading the master architecture blueprint:

```
docs/guidelines/gapscope_studio_master_architecture_blueprint.md
```

This file contains:
- Complete architectural vision and goals
- Technical stack requirements
- Repository structure
- Detailed system architecture
- Performance rules and constraints
- API design patterns
- Development phases
- Package structure requirements

### Step 2: Initialize Document Reader Agent

After reading the architecture blueprint, initialize the document reader system:

```bash
cd docs/agent_system
dart agent_cli.dart init
```

This will:
- Load all project documentation into memory
- Cache architectural context
- Enable intelligent search capabilities
- Prepare context-aware prompt processing

### Step 3: Context Verification

Verify the agent has proper context by checking:

```bash
# Verify documents are loaded
dart agent_cli.dart status

# Test architecture access
dart agent_cli.dart architecture | head -20

# Test search capabilities
dart agent_cli.dart search "inspector"
```

---

## 📋 Mandatory Context Requirements

### Before ANY Development Task

AI agents MUST have context of:

1. **Architecture Blueprint** - Complete understanding of GapScope vision
2. **Technical Constraints** - Performance rules, file size conventions
3. **Package Structure** - How packages and apps relate
4. **Development Phase** - Current MVP phase requirements
5. **API Patterns** - Public API design conventions

### Context Checklist

- [ ] Architecture blueprint read and understood
- [ ] Document reader agent initialized
- [ ] Search functionality tested
- [ ] Current development phase identified
- [ ] Technical constraints acknowledged
- [ ] API patterns reviewed

---

## 🎯 Agent Decision Framework

### When User Asks For Features

1. **Check Architecture First**: Consult blueprint for architectural guidance
2. **Verify Current Phase**: Ensure feature fits current MVP phase
3. **Follow Conventions**: Use established patterns from architecture
4. **Search Documentation**: Look for existing similar implementations
5. **Get Specific Guidance**: Use `dart agent_cli.dart guidance "ComponentName"`

### When User Requests Structural Changes

1. **Consult Package Structure Rules**: Verify against blueprint requirements
2. **Check Dependency Flow**: Ensure packages don't depend on apps
3. **Follow File Conventions**: Maintain 100-250 lines per file
4. **Respect Boundaries**: Keep packages publishable and independent

### When User Provides Implementation Tasks

1. **Initialize Agent System**: Run `dart agent_cli.dart init`
2. **Get Architectural Guidance**: Ask for specific component guidance
3. **Review API Examples**: Check `dart agent_cli.dart api`
4. **Follow Performance Rules**: Adhere to optimization guidelines
5. **Maintain Conventions**: Use established naming and structure patterns

---

## 🔧 Agent Commands Reference

### Always Available Commands

```bash
# Initialize agent context (run first!)
dart agent_cli.dart init

# Get architectural guidance
dart agent_cli.dart guidance "ComponentName"

# Search for relevant documentation
dart agent_cli.dart search "keyword"

# View architecture blueprint
dart agent_cli.dart architecture

# Check current phase requirements
dart agent_cli.dart phases

# View API examples
dart agent_cli.dart api

# Check tech stack requirements
dart agent_cli.dart techstack
```

---

## 📊 Current Project Status

### Project: GapScope Studio

**Type**: Flutter Component Workbench + Runtime QA Inspector

**Architecture**: Modular package system with Melos workspace

**Current Phase**: Phase 1 - Basic Studio + Story Preview

**Key Constraints**:
- Files: 100-250 lines each
- State: ValueNotifier/ChangeNotifier
- Rendering: CustomPainter preferred
- Performance: Minimal rebuilds, overlay-safe

**Package Structure**:
```
gapscope/
├── packages/gapscope/     # Main reusable package
├── apps/gapscope_studio_app/  # Development app
└── docs/                   # Documentation
```

---

## ⚠️ Critical Rules for AI Agents

### MUST DO

1. **Always** read architecture blueprint before suggesting code
2. **Always** initialize document reader for complex tasks
3. **Always** check current development phase
4. **Always** follow file size conventions (100-250 lines)
5. **Always** maintain package boundaries (no app→package dependencies)
6. **Always** use established naming conventions
7. **Always** consider performance requirements

### MUST NOT DO

1. **Never** skip architecture blueprint reading
2. **Never** suggest files larger than 250 lines
3. **Never** create circular dependencies
4. **Never** hard-code package dependencies (like Riverpod)
5. **Never** ignore performance constraints
6. **Never** create God files with multiple responsibilities
7. **Never** skip initialization sequence

---

## 🎯 Agent Prompt Enhancement

### How This File Helps AI Agents

This AGENTS.md file serves as:

1. **Initialization Trigger**: Tells agents to load context first
2. **Context Source**: Provides project status and constraints
3. **Decision Framework**: Guides how to approach different request types
4. **Rule Reference**: Critical must-do/must-not-do rules
5. **Command Reference**: Available agent commands

### Example Agent Workflow

```
User: "Create the inspector system"

Agent Process:
1. Read AGENTS.md → Find initialization sequence
2. Read architecture blueprint → Understand inspector requirements
3. Initialize document reader → Load all context
4. Get specific guidance → dart agent_cli.dart guidance "GapScopeInspector"
5. Check current phase → Verify inspector fits Phase 2
6. Review constraints → Performance, overlay-safe, CustomPainter
7. Search existing code → Look for similar patterns
8. Follow conventions → File structure, naming, API design
9. Implement according to blueprint → Maintain architectural vision
```

---

## 🔍 Quick Reference for Common Tasks

### Creating New Components
```bash
dart agent_cli.dart guidance "GapScopeComponent"
dart agent_cli.dart api
```

### Building Inspector Features
```bash
dart agent_cli.dart guidance "GapScopeInspector"
dart agent_cli.dart search "performance"
```

### Adding UI Elements
```bash
dart agent_cli.dart guidance "UI System"
dart agent_cli.dart search "rendering"
```

### Package Structure Questions
```bash
dart agent_cli.dart architecture
dart agent_cli.dart search "package structure"
```

---

## 📝 Agent Self-Check

Before responding to any user request, AI agents should verify:

- [ ] Have I read the architecture blueprint?
- [ ] Have I initialized the document reader?
- [ ] Do I understand the current development phase?
- [ ] Am I following the established conventions?
- [ ] Are my suggestions within architectural constraints?
- [ ] Have I checked for existing implementations?
- [ ] Am I maintaining package boundaries?

---

## 🚀 Ready to Assist

Once an AI agent has:

1. ✅ Read this AGENTS.md file
2. ✅ Read the architecture blueprint
3. ✅ Initialized the document reader system
4. ✅ Verified context loading

Then it is ready to provide intelligent, context-aware assistance for GapScope Studio development.

---

**Note**: This file should be updated as the project evolves to maintain accurate agent guidance.