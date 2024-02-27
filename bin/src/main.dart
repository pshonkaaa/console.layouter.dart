import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import 'package:pshondation/library.dart';

import 'core/commands/app.dart';
import 'core/commands/module.dart';
import 'core/commands/page.dart';
import 'core/project_info.dart';
import 'globals.dart';
import 'utils.dart';

class AppMain extends BaseAppMain {
  static final instance = AppMain();
  
  @override
  Future<void> run() async {
    await super.run();

    List<String> arguments = this.arguments.toList();
    // dart path
    // Platform.executable

    // script path (.dart or snapshot)
    // Platform.script
    
    if(arguments.isEmpty) {
      Directory.current = '/Users/pshonka/_dev/projects/flutter/app.vk_music_ex.extension.dart';
      arguments = [
        'module',
        'create',
        'hello_kurwa',
        
        // '--test=true',
      ];
    }

    logger.i('Directory.current = ${Directory.current.path}');
    logger.i('arguments = ${arguments}');
    
    Globals.packageDir = Directory(await findPackagePath());

    Globals.snippetsDir = Directory(p.join(
      Globals.packagePath,
      'snippets',
    ));
    
    logger.i('packageDir = ${Globals.packageDir}');

    Globals.projectInfo = await ProjectInfo.read(Directory.current);

    final runner = CommandRunner(
      'layouter',
      'null',
    );

    final List<Command> commands = [
      AppCommand.instance,
      ModuleCommand.instance,
      PageCommand.instance,
      // LayoutCommand.instance,
    ];

    for(final command in commands) {
      runner.addCommand(command);
    }
    
    try {
      await runner.run(arguments);
    } catch(error) {
      if (error is! UsageException) {
        rethrow;
      }

      logger.e(error);
      
      exit(64); // Exit code 64 indicates a usage error.
    }
  }
}