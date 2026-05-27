# GapScope AI Agent System

## Overview

The GapScope AI Agent System is an intelligent document processing and context-aware assistant designed specifically for the GapScope Studio project. It reads all documentation in the `docs/` directory and provides AI-powered assistance with full architectural context.

## Features

- **Document Caching**: Automatically loads and caches all project documentation
- **Context-Aware Processing**: Enhances user prompts with relevant architectural context
- **Architecture Intelligence**: Understands the GapScope architecture blueprint deeply
- **Search Capabilities**: Search across all documentation for specific keywords
- **Development Guidance**: Provides architectural guidance for specific components
- **Phase Tracking**: Access development phases and milestones
- **API Examples**: Quick access to API usage examples

## Installation & Setup

### Location

The agent system is located in:
```
docs/agent_system/
```

### Files

- `document_reader_agent.dart` - Core document processing engine
- `ai_prompt_processor.dart` - Context-aware prompt enhancement
- `agent_init_command.dart` - Command interface and initialization
- `agent_cli.dart` - CLI entry point

## Usage

### Basic Commands

Run from the `docs/agent_system/` directory:

```bash
# Initialize the agent system
dart agent_cli.dart init

# Show system status
dart agent_cli.dart status

# Search documentation
dart agent_cli.dart search "inspector"

# Show full architecture blueprint
dart agent_cli.dart architecture

# Get architectural guidance for a component
dart agent_cli.dart guidance "GapScopeInspector"

# Show development phases
dart agent_cli.dart phases

# Show recommended tech stack
dart agent_cli.dart techstack

# Show API examples
dart agent_cli.dart api
```

### AI-Powered Query Processing

```bash
# Ask questions with full architectural context
dart agent_cli.dart ask "How should I structure the inspector system?"

# Get component guidance
dart agent_cli.dart ask "What are the key architectural considerations for the overlay system?"

# Architecture-specific questions
dart agent_cli.dart ask "What are the performance requirements for GapScope Studio?"
```

## System Architecture

### Document Flow

```
docs/ Directory
    ↓
DocumentReaderAgent
    ↓
Document Cache (Memory)
    ↓
AIPromptProcessor
    ↓
Enhanced Context Output
```

### Key Components

#### 1. DocumentReaderAgent

- Scans `docs/` directory recursively
- Loads supported file types (.md, .txt, .json)
- Caches content in memory
- Provides search and retrieval

#### 2. AIPromptProcessor

- Processes user queries
- Extracts relevant context
- Enhances prompts with architectural information
- Provides component-specific guidance

#### 3. AgentInitCommand

- Initializes the system
- Provides CLI interface
- Manages document loading
- Handles user queries

## Integration with GapScope Development

### Before Any Development Session

```bash
cd docs/agent_system
dart agent_cli.dart init
```

This ensures:
- Latest documentation is loaded
- Architecture blueprint is cached
- AI context is ready for complex queries

### During Development

Use the agent to:
- Verify architectural decisions
- Get component guidance
- Understand development phases
- Access API examples
- Search technical specifications

### Example Development Workflow

```bash
# 1. Initialize agent system
dart agent_cli.dart init

# 2. Ask about the component you're building
dart agent_cli.dart ask "What are the key architectural considerations for building the GapScopeInspector?"

# 3. Get specific guidance
dart agent_cli.dart guidance "GapScopeInspector"

# 4. Check API examples
dart agent_cli.dart api

# 5. Verify against architecture
dart agent_cli.dart architecture
```

## Document Support

### Supported File Types

- `.md` - Markdown files
- `.txt` - Plain text files
- `.json` - JSON configuration files

### Directory Structure

```
docs/
├── agent_system/          # Agent system files
│   ├── document_reader_agent.dart
│   ├── ai_prompt_processor.dart
│   ├── agent_init_command.dart
│   ├── agent_cli.dart
│   └── README.md
└── guidelines/           # Project documentation
    └── gapscope_studio_master_architecture_blueprint.md
```

## Performance Considerations

- **Caching**: All documents are cached in memory after first load
- **Incremental Updates**: Use `dart agent_cli.dart init` to reload documents
- **Memory Usage**: Typical document sets use < 50MB RAM
- **Search Speed**: Instant search across cached documents

## AI Agent Capabilities

### Architecture Awareness

- Understands complete GapScope architecture
- Tracks component relationships
- Knows development phases
- Aware of technical constraints

### Context Enhancement

When you ask a question, the agent:
1. Loads relevant architecture sections
2. Finds related documentation
3. Extracts component-specific guidance
4. Provides API examples
5. Considers development phase requirements

### Development Guidance

Provides guidance for:
- Component architecture
- API design
- Performance requirements
- File organization
- State management
- Testing strategy

## Troubleshooting

### Common Issues

**Issue**: "Docs directory not found"
- **Solution**: Ensure you're running from the correct directory

**Issue**: "No documents loaded"
- **Solution**: Check that docs/ directory contains supported files

**Issue**: "Architecture blueprint not found"
- **Solution**: Verify `gapscope_studio_master_architecture_blueprint.md` exists

## Future Enhancements

Planned features:
- Real-time document watching
- Integration with code analysis
- Historical query tracking
- Component dependency mapping
- Automated architecture compliance checking

## License

Part of the GapScope Studio project.