import 'dart:io';

import 'package:yaml/yaml.dart';

import '../utils.dart';

class Pubspec {
  final Map<String, dynamic> map;
  Pubspec({
    required this.map,
  });

  static Future<Pubspec> read(File file) async {
    final yaml = loadYaml(await file.readAsString());
    final map = unmodToMod(yaml, mapConverter: (map) => Map<String, dynamic>.from(map)) as Map<String, dynamic>;

    map['name']!;
    
    return Pubspec(
      map: map,
    );
  }
}