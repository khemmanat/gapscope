import 'dart:io';

import 'agent_init_command.dart';
import 'document_reader_agent.dart';

void main(List<String> arguments) async {
  // For all commands, ensure documents are loaded first
  await DocumentReaderAgent.instance.loadDocuments();

  if (arguments.isEmpty) {
    await AgentInitCommand.initialize();
    return;
  }

  final command = arguments[0].toLowerCase();

  switch (command) {
    case 'init':
      await AgentInitCommand.initialize();
      break;

    case 'status':
      AgentInitCommand.showStatus();
      break;

    case 'ask':
      if (arguments.length < 2) {
        print('Usage: agent ask "your question"');
        exit(1);
      }
      final query = arguments.sublist(1).join(' ');
      await AgentInitCommand.processUserQuery(query);
      break;

    case 'search':
      if (arguments.length < 2) {
        print('Usage: agent search "keyword"');
        exit(1);
      }
      final keyword = arguments[1];
      AgentInitCommand.searchDocumentation(keyword);
      break;

    case 'architecture':
      AgentInitCommand.showArchitecture();
      break;

    case 'guidance':
      if (arguments.length < 2) {
        print('Usage: agent guidance "component"');
        exit(1);
      }
      final component = arguments[1];
      AgentInitCommand.showGuidance(component);
      break;

    case 'phases':
      AgentInitCommand.showPhases();
      break;

    case 'techstack':
      AgentInitCommand.showTechStack();
      break;

    case 'api':
      AgentInitCommand.showApiExamples();
      break;

    case 'help':
      _showHelp();
      break;

    default:
      print('Unknown command: $command');
      print('');
      _showHelp();
      exit(1);
  }
}

void _showHelp() {
  print('🤖 GapScope AI Agent System');
  print('');
  print('Usage: dart agent_cli.dart <command> [arguments]');
  print('');
  print('Available commands:');
  print('  init              Initialize the AI agent system');
  print('  status            Show system status');
  print('  ask "question"    Process a query with AI context');
  print('  search "term"     Search documentation');
  print('  architecture      Show architecture blueprint');
  print('  guidance "comp"   Get architectural guidance');
  print('  phases            Show development phases');
  print('  techstack         Show recommended tech stack');
  print('  api               Show API examples');
  print('  help              Show this help message');
  print('');
  print('Examples:');
  print('  dart agent_cli.dart init');
  print('  dart agent_cli.dart ask "How should I structure the inspector?"');
  print('  dart agent_cli.dart search "overlay"');
  print('  dart agent_cli.dart guidance "GapScopeInspector"');
  print('');
}