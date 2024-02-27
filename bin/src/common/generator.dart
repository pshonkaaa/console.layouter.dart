import 'dart:io';

typedef OnMatch = String Function();

class Generator {
  Generator({
    required this.file,
    required this.snippets,
  });

  final File file;
  final Map<String, OnMatch> snippets;

  Future<String> generate() async {
    final regexp = RegExp(
      r'\$(.*?)\$',
      multiLine: true,
    );

    String data = await file.readAsString();

    return data.replaceAllMapped(regexp, (match) {
      final snippet = match.group(1)!;
      final function = snippets[snippet];
      if(function == null) {
        throw 'Snippet [$snippet] not found';
      }
      return function();
    });    
  }
}