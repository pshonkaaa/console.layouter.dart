import 'package:args/command_runner.dart';
import 'package:change_case/change_case.dart';
import 'package:pshondation/library.dart';

import '../../../globals.dart';

class ModuleAddCommand extends Command {
  static final String TAG = (ModuleAddCommand).toString();
  
  static final instance = ModuleAddCommand();

  ModuleAddCommand() {
    argParser.addOption(
      'app',
      mandatory: false,
    );

    argParser.addOption(
      'side',
      mandatory: false,
    );
  }
  
  @override
  String get name => 'add';
  
  @override
  String get description => 'addes an module with the specified name';

  @override
  Future<void> run() async {
    logger.i('$TAG > $name');

    final moduleName = argResults!.rest.tryFirst;
    if(moduleName == null) {
      throw 'the [moduleName] argument is not specified';
    }

    if(moduleName.toSnakeCase() != moduleName) {
      throw ArgumentError('[$moduleName] must be snake_case');
    }

    final appName = argResults!['app'] as String?;
    final sideName = argResults!['side'] as String?;


    final app = projectInfo.layout.getAppOrThrow(
      appName,
      sideName,
    );

    await app.addModule(
      moduleName,
      sideName: sideName,
    );
  }
}