import 'dart:io';

import 'package:change_case/change_case.dart';
import 'package:path/path.dart' as p;

import '../../common/generator.dart';
import '../../globals.dart';

abstract class PageGenerator {
  static Future<String> generatePage(
    String pageName,
  ) async {
    final generator = Generator(
      file: File(p.join(Globals.snippetsPath, 'page/page.dart')),
      snippets: {
        'PAGE_NAME': () => pageName.toPascalCase(),
      },
    );
    return await generator.generate();
  }

  static Future<String> generateBloc(
    String pageName,
  ) async {
    final generator = Generator(
      file: File(p.join(Globals.snippetsPath, 'page/domain/bloc.dart')),
      snippets: {
      },
    );
    return await generator.generate();
  }

  static Future<String> generateRepository(
    String pageName,
  ) async {
    final generator = Generator(
      file: File(p.join(Globals.snippetsPath, 'page/domain/repository.dart')),
      snippets: {
      },
    );
    return await generator.generate();
  }

  static Future<String> generateBlocImpl(
    String pageName,
  ) async {
    final generator = Generator(
      file: File(p.join(Globals.snippetsPath, 'page/data/bloc_impl.dart')),
      snippets: {
        'PAGE_NAME': () => pageName.toPascalCase(),
      },
    );
    return await generator.generate();
  }

  static Future<String> generateRepositoryImpl(
    String pageName,
  ) async {
    final generator = Generator(
      file: File(p.join(Globals.snippetsPath, 'page/data/repository_impl.dart')),
      snippets: {
        'PAGE_NAME': () => pageName.toPascalCase(),
      },
    );
    return await generator.generate();
  }
}