import 'dart:io';

import 'package:path/path.dart' as p;

import '../../common/generator.dart';
import '../../globals.dart';

abstract class MainGenerator {
  static Future<String> generateMain(
    String appName,
  ) async {
    String mainDart = p.join(
      Globals.projectInfo.getAppDirectory(appName).path.replaceFirst(RegExp('(.*?)lib/'), ''),
      'main.dart',
    );

    final generator = Generator(
      file: File(p.join(Globals.snippetsPath, 'main/main.dart')),
      snippets: {
        'IMPORT_PATH': () => mainDart,
      },
    );
    return await generator.generate();
  }

  static Future<String> generateAppMain(
    String name,
  ) async {
    final generator = Generator(
      file: File(p.join(Globals.snippetsPath, 'main/app_main.dart')),
      snippets: {
      },
    );
    return await generator.generate();
  }

  static Future<String> generateGlobals(
    String name,
  ) async {
    final generator = Generator(
      file: File(p.join(Globals.snippetsPath, 'main/globals.dart')),
      snippets: {
      },
    );
    return await generator.generate();
  }
}