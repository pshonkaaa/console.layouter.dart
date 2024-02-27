import 'dart:io';

import 'package:change_case/change_case.dart';
import 'package:path/path.dart' as p;

import '../../common/generator.dart';
import '../../globals.dart';

abstract class ModuleGenerator {
  static Future<String> generateModule(
    String moduleName,
  ) async {
    final generator = Generator(
      file: File(p.join(Globals.snippetsPath, 'module/module.dart')),
      snippets: {
        'MODULE_NAME': () => moduleName.toPascalCase(),
      },
    );
    return await generator.generate();
  }

  static Future<String> generateModuleImpl(
    String moduleName,
  ) async {
    final generator = Generator(
      file: File(p.join(Globals.snippetsPath, 'module/module_impl.dart')),
      snippets: {
        'MODULE_NAME': () => moduleName.toPascalCase(),
      },
    );
    return await generator.generate();
  }
}