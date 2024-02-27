import 'dart:io';

import 'package:collection/collection.dart';
import 'package:yaml/yaml.dart';

import 'package:path/path.dart' as p;

Future<String> findPackagePath() async {
  return p.dirname((await findPubspecPath(Platform.script.path))!);
}

Future<String?> findPubspecPath(String path) async {
  File file;
  
  while(true) {
    if(p.isRootRelative(path))
      return null;
    
    file = File(p.join(path, 'pubspec.yaml'));
    if(await file.exists())
      return file.path;
    path = p.dirname(path);
  }
  
  // if(!path.contains('.dart_tool'))
  //   return null;
  
  // while(p.basename(path) != '.dart_tool') {
  //   path = p.dirname(path);
  // } return p.dirname(path);
}

dynamic unmodToMod(
  dynamic input, {
    Map mapConverter(Map map)?,
    List listConverter(List list)?,
}) {
  if(input is UnmodifiableMapMixin) {
    input = Map.from(input);
    if(mapConverter != null)
      input = mapConverter(input);
  } else if(input is YamlList) {
    input = List.from(input);
    if(listConverter != null)
      input = listConverter(input);
  }


  final List keys = input is List ? Iterable.generate(input.length).toList() : (input as Map).keys.toList();
  for(final key in keys) {
    if(input[key] is Map) {
      input[key] = unmodToMod(
        input[key],
        mapConverter: mapConverter,
        listConverter: listConverter,
      );
    } else if(input[key] is List) {
      input[key] = unmodToMod(
        input[key],
        mapConverter: mapConverter,
        listConverter: listConverter,
      );
    }
  }

  return input;
}