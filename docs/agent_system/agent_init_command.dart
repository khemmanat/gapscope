import 'dart:io';

import 'ai_prompt_processor.dart';
import 'document_reader_agent.dart';

class AgentInitCommand {
  static Future<void> initialize() async {
    print('🚀 Initializing GapScope AI Agent System...');
    print('');

    try {
      // Initialize document reader
      print('📄 Loading documentation...');
      await DocumentReaderAgent.instance.loadDocuments();

      final docSummary = DocumentReaderAgent.instance.getDocumentSummary();
      print('   ✓ Loaded ${docSummary['totalDocuments']} documents');

      final typeCount = docSummary['documentsByType'] as Map<String, int>;
      for (final entry in typeCount.entries) {
        print('   ✓ ${entry.key} files: ${entry.value}');
      }

      print('   ✓ Total size: ${_formatBytes(docSummary['totalSize'] as int)}');
      print('');

      // Initialize AI prompt processor
      print('🤖 Initializing AI prompt processor...');
      await AIPromptProcessor.instance.initialize();
      print('   ✓ AI prompt processor ready');
      print('');

      // Display system status
      print('✨ AI Agent System Status:');
      print('   • Document cache: Active');
      print('   • Context processing: Ready');
      print('   • Architecture awareness: Enabled');
      print('   • Project guidance: Available');
      print('');

      _showAgentCapabilities();
      _showQuickCommands();

    } catch (e) {
      print('❌ Error initializing AI agent system: $e');
      exit(1);
    }
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  static void _showAgentCapabilities() {
    print('🔧 Agent Capabilities:');
    print('   • Architecture blueprint access');
    print('   • Document search and retrieval');
    print('   • Context-aware prompt processing');
    print('   • Project-specific guidance');
    print('   • Development phase tracking');
    print('');
  }

  static void _showQuickCommands() {
    print('📋 Available Agent Commands:');
    print('   • ask "your question"     - Get AI assistance with context');
    print('   • search "keyword"        - Search documentation');
    print('   • architecture            - Show architecture blueprint');
    print('   • guidance "component"    - Get architectural guidance');
    print('   • phases                  - Show development phases');
    print('   • techstack               - Show recommended tech stack');
    print('   • api                     - Show API examples');
    print('   • status                  - Show agent system status');
    print('');
  }

  static void showStatus() {
    print('📊 AI Agent System Status:');
    print('');

    final docSummary = DocumentReaderAgent.instance.getDocumentSummary();
    print('Documents: ${docSummary['totalDocuments']}');
    print('Cache Size: ${_formatBytes(docSummary['totalSize'] as int)}');
    print('');

    final typeCount = docSummary['documentsByType'] as Map<String, int>;
    print('Document Types:');
    for (final entry in typeCount.entries) {
      print('  ${entry.key}: ${entry.value}');
    }
    print('');

    print('System Status: Operational');
    print('Context Processing: Active');
    print('Architecture Awareness: Enabled');
    print('');
  }

  static Future<void> processUserQuery(String query) async {
    print('🤔 Processing query: "$query"');
    print('');

    try {
      final enhancedPrompt = AIPromptProcessor.instance.processPrompt(query);

      print('📝 Enhanced prompt generated:');
      print('   Length: ${enhancedPrompt.length} characters');
      print('   Context lines: ${enhancedPrompt.split(r"\n").length}');
      print('');

      print('🔍 Relevant context found:');

      // Check for architecture mentions
      if (query.toLowerCase().contains('architecture') ||
          query.toLowerCase().contains('structure')) {
        print('   • Architecture blueprint');
      }

      // Check for component mentions
      if (query.toLowerCase().contains('component') ||
          query.toLowerCase().contains('widget')) {
        print('   • Component system');
      }

      // Check for API mentions
      if (query.toLowerCase().contains('api') ||
          query.toLowerCase().contains('interface')) {
        print('   • API design and examples');
      }

      print('');
      print('✅ Query processed successfully');
      print('   Enhanced prompt ready for AI processing');
      print('');

    } catch (e) {
      print('❌ Error processing query: $e');
    }
  }

  static void searchDocumentation(String keyword) {
    print('🔍 Searching for: "$keyword"');
    print('');

    final results = DocumentReaderAgent.instance.getDocumentsByKeyword(keyword);

    if (results.isEmpty) {
      print('No results found for: $keyword');
    } else {
      print('Found ${results.length} document(s):');
      print('');

      for (final doc in results) {
        print('📄 ${doc['path']}');
        print('   Size: ${doc['size']} bytes');
        print('   Modified: ${doc['lastModified']}');
        print('   Preview: ${_getPreview(doc['content'] as String, 100)}');
        print('');
      }
    }
  }

  static String _getPreview(String content, int maxLength) {
    if (content.length <= maxLength) return content;
    return '${content.substring(0, maxLength)}...';
  }

  static void showArchitecture() {
    print('🏗️  Architecture Blueprint:');
    print('');
    final blueprint = DocumentReaderAgent.instance.getArchitectureBlueprint();
    if (blueprint.isEmpty) {
      print('No architecture blueprint found');
    } else {
      print(blueprint);
    }
  }

  static void showGuidance(String component) {
    print('🎯 Architectural Guidance for: $component');
    print('');
    final guidance = AIPromptProcessor.instance.getArchitecturalGuidance(component);
    print(guidance);
  }

  static void showPhases() {
    print('📅 Development Phases:');
    print('');
    final phases = AIPromptProcessor.instance.getPhaseInformation();
    if (phases.isEmpty) {
      print('No phase information found');
    } else {
      for (final phase in phases) {
        print('• $phase');
      }
    }
    print('');
  }

  static void showTechStack() {
    print('🛠️  Recommended Tech Stack:');
    print('');
    final techStack = AIPromptProcessor.instance.getTechStack();
    if (techStack.isEmpty) {
      print('No tech stack information found');
    } else {
      print(techStack);
    }
  }

  static void showApiExamples() {
    print('📚 API Examples:');
    print('');
    final apiExamples = AIPromptProcessor.instance.getApiExamples();
    if (apiExamples.isEmpty) {
      print('No API examples found');
    } else {
      print(apiExamples);
    }
  }
}