import 'dart:io';

class DocumentReaderAgent {

  DocumentReaderAgent._internal();
  static String get docsPath {
    final currentDir = Directory.current.path;
    // Check if we're in the agent_system directory or workspace root
    if (currentDir.contains('agent_system')) {
      return '../';
    } else {
      return 'docs/';
    }
  }
  static DocumentReaderAgent? _instance;

  final Map<String, dynamic> _documentCache = {};
  final List<String> _supportedExtensions = ['.md', '.txt', '.json'];

  static DocumentReaderAgent get instance {
    _instance ??= DocumentReaderAgent._internal();
    return _instance!;
  }

  Future<void> loadDocuments() async {
    final docsDir = Directory(docsPath);
    if (!await docsDir.exists()) {
      print('Docs directory not found: $docsPath');
      return;
    }

    await _scanDirectory(docsDir);
  }

  Future<void> _scanDirectory(Directory dir) async {
    await for (final entity in dir.list()) {
      if (entity is File) {
        await _loadFile(entity);
      } else if (entity is Directory) {
        await _scanDirectory(entity);
      }
    }
  }

  Future<void> _loadFile(File file) async {
    final extension = '.${file.path.split('.').last}';
    if (!_supportedExtensions.contains(extension)) return;

    try {
      final content = await file.readAsString();
      final relativePath = file.path.replaceAll('${Directory.current.path}/', '');

      _documentCache[relativePath] = {
        'path': relativePath,
        'content': content,
        'extension': extension,
        'lastModified': await file.lastModified(),
        'size': await file.length(),
      };

      print('Loaded document: $relativePath');
    } catch (e) {
      print('Error loading file ${file.path}: $e');
    }
  }

  List<Map<String, dynamic>> getDocumentsByKeyword(String keyword) {
    final results = <Map<String, dynamic>>[];

    for (final entry in _documentCache.entries) {
      final doc = entry.value as Map<String, dynamic>;
      final content = doc['content'] as String;
      final path = doc['path'] as String;

      if (content.toLowerCase().contains(keyword.toLowerCase()) ||
          path.toLowerCase().contains(keyword.toLowerCase())) {
        results.add(doc);
      }
    }

    return results;
  }

  Map<String, dynamic>? getDocumentByPath(String path) {
    return _documentCache[path] as Map<String, dynamic>?;
  }

  List<Map<String, dynamic>> getAllDocuments() {
    return _documentCache.values.map((e) => e as Map<String, dynamic>).toList();
  }

  String? getDocumentContent(String path) {
    final doc = _documentCache[path] as Map<String, dynamic>?;
    return doc?['content'] as String?;
  }

  List<String> getAllDocumentPaths() {
    return _documentCache.keys.toList();
  }

  Map<String, dynamic> getDocumentSummary() {
    return {
      'totalDocuments': _documentCache.length,
      'documentsByType': _getDocumentsByType(),
      'totalSize': _getTotalSize(),
      'documents': getAllDocumentPaths(),
    };
  }

  Map<String, int> _getDocumentsByType() {
    final typeCount = <String, int>{};

    for (final doc in _documentCache.values) {
      final extension = doc['extension'] as String;
      typeCount[extension] = (typeCount[extension] ?? 0) + 1;
    }

    return typeCount;
  }

  int _getTotalSize() {
    int total = 0;
    for (final doc in _documentCache.values) {
      total += doc['size'] as int;
    }
    return total;
  }

  String getArchitectureBlueprint() {
    // Try all possible path variations
    const possiblePaths = [
      'docs/guidelines/gapscope_studio_master_architecture_blueprint.md',
      'guidelines/gapscope_studio_master_architecture_blueprint.md',
      '../guidelines/gapscope_studio_master_architecture_blueprint.md',
      '../agent_system/../guidelines/gapscope_studio_master_architecture_blueprint.md',
    ];

    for (final path in possiblePaths) {
      final content = getDocumentContent(path);
      if (content != null && content.isNotEmpty) {
        return content;
      }
    }

    return '';
  }

  List<Map<String, dynamic>> searchArchitecture(String query) {
    final blueprint = getArchitectureBlueprint();
    if (blueprint.isEmpty) return [];

    final results = <Map<String, dynamic>>[];
    final lines = blueprint.split('\n');

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].toLowerCase().contains(query.toLowerCase())) {
        results.add({
          'line': i + 1,
          'content': lines[i],
          'context': _getContext(lines, i),
        });
      }
    }

    return results;
  }

  List<String> _getContext(List<String> lines, int index) {
    final start = (index - 2).clamp(0, lines.length - 1);
    final end = (index + 3).clamp(0, lines.length - 1);
    return lines.sublist(start, end);
  }

  void clearCache() {
    _documentCache.clear();
  }

  Future<void> reloadDocuments() async {
    clearCache();
    await loadDocuments();
  }
}