import 'document_reader_agent.dart';

class AIPromptProcessor {

  AIPromptProcessor._internal() : _docReader = DocumentReaderAgent.instance;
  static AIPromptProcessor? _instance;
  final DocumentReaderAgent _docReader;

  static AIPromptProcessor get instance {
    _instance ??= AIPromptProcessor._internal();
    return _instance!;
  }

  Future<void> initialize() async {
    await _docReader.loadDocuments();
    print('AI Prompt Processor initialized with ${_docReader.getAllDocumentPaths().length} documents');
  }

  String processPrompt(String userPrompt) {
    final enhancedPrompt = StringBuffer();
    enhancedPrompt.writeln('You are an AI assistant for the GapScope Studio project.');
    enhancedPrompt.writeln('Below is the relevant architecture and documentation context:');
    enhancedPrompt.writeln('---');
    enhancedPrompt.writeln();

    // Add architecture blueprint context
    final blueprint = _docReader.getArchitectureBlueprint();
    if (blueprint.isNotEmpty) {
      enhancedPrompt.writeln('## Architecture Blueprint');
      enhancedPrompt.writeln(blueprint);
      enhancedPrompt.writeln('---');
      enhancedPrompt.writeln();
    }

    // Add relevant documents based on keywords
    final keywords = _extractKeywords(userPrompt);
    for (final keyword in keywords) {
      final relevantDocs = _docReader.getDocumentsByKeyword(keyword);
      for (final doc in relevantDocs) {
        enhancedPrompt.writeln('## Relevant Document: ${doc['path']}');
        enhancedPrompt.writeln(doc['content']);
        enhancedPrompt.writeln('---');
        enhancedPrompt.writeln();
      }
    }

    enhancedPrompt.writeln('## User Question:');
    enhancedPrompt.writeln(userPrompt);

    return enhancedPrompt.toString();
  }

  List<String> _extractKeywords(String prompt) {
    final keywords = <String>[];
    final lowerPrompt = prompt.toLowerCase();

    // Architecture-related keywords
    if (lowerPrompt.contains('architecture') || lowerPrompt.contains('structure')) {
      keywords.add('architecture');
    }

    // Component-related keywords
    if (lowerPrompt.contains('component') || lowerPrompt.contains('widget') || lowerPrompt.contains('story')) {
      keywords.add('component');
    }

    // Inspector-related keywords
    if (lowerPrompt.contains('inspector') || lowerPrompt.contains('debug') || lowerPrompt.contains('debugging')) {
      keywords.add('inspector');
    }

    // UI-related keywords
    if (lowerPrompt.contains('ui') || lowerPrompt.contains('interface') || lowerPrompt.contains('toolbar')) {
      keywords.add('ui');
    }

    // Overlay-related keywords
    if (lowerPrompt.contains('overlay') || lowerPrompt.contains('dialog') || lowerPrompt.contains('bottomsheet')) {
      keywords.add('overlay');
    }

    // Performance-related keywords
    if (lowerPrompt.contains('performance') || lowerPrompt.contains('optimization') || lowerPrompt.contains('speed')) {
      keywords.add('performance');
    }

    // API-related keywords
    if (lowerPrompt.contains('api') || lowerPrompt.contains('public') || lowerPrompt.contains('interface')) {
      keywords.add('api');
    }

    return keywords;
  }

  Map<String, dynamic> getProjectContext() {
    return {
      'architecture': _docReader.getArchitectureBlueprint(),
      'documentSummary': _docReader.getDocumentSummary(),
      'availableDocuments': _docReader.getAllDocumentPaths(),
    };
  }

  String getArchitecturalGuidance(String component) {
    final blueprint = _docReader.getArchitectureBlueprint();
    if (blueprint.isEmpty) return 'No architecture blueprint found';

    final searchResults = _docReader.searchArchitecture(component);
    if (searchResults.isEmpty) return 'No specific guidance found for: $component';

    final guidance = StringBuffer();
    guidance.writeln('## Architectural Guidance for: $component');
    guidance.writeln();

    for (final result in searchResults) {
      guidance.writeln('Line ${result['line']}: ${result['content']}');
      guidance.writeln('Context:');
      for (final line in result['context']) {
        guidance.writeln('  $line');
      }
      guidance.writeln();
    }

    return guidance.toString();
  }

  List<String> getPhaseInformation() {
    final blueprint = _docReader.getArchitectureBlueprint();
    final phases = <String>[];

    if (blueprint.contains('Phase 1')) phases.add('Phase 1: Basic Studio + Story Preview');
    if (blueprint.contains('Phase 2')) phases.add('Phase 2: Runtime spacing inspection');
    if (blueprint.contains('Phase 3')) phases.add('Phase 3: Overlay support');
    if (blueprint.contains('Phase 4')) phases.add('Phase 4: Advanced QA');
    if (blueprint.contains('Phase 5')) phases.add('Phase 5: Export + ecosystem');

    return phases;
  }

  String getTechStack() {
    final blueprint = _docReader.getArchitectureBlueprint();
    if (blueprint.isEmpty) return '';

    final startIndex = blueprint.indexOf('## Recommended Tech Stack');
    if (startIndex == -1) return '';

    final endIndex = blueprint.indexOf('---', startIndex + 1);
    if (endIndex == -1) return '';

    return blueprint.substring(startIndex, endIndex);
  }

  String getApiExamples() {
    final blueprint = _docReader.getArchitectureBlueprint();
    if (blueprint.isEmpty) return '';

    final startIndex = blueprint.indexOf('# Public API Design');
    if (startIndex == -1) return '';

    final endIndex = blueprint.indexOf('# Addon System');
    if (endIndex == -1) return '';

    return blueprint.substring(startIndex, endIndex);
  }
}