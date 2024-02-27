import 'package:args/command_runner.dart';

import 'module/add.dart';

class ModuleCommand extends Command {
  static final instance = ModuleCommand();
  
  ModuleCommand() {
    addSubcommand(ModuleAddCommand.instance);
  }

  @override
  String get name => 'module';
  
  @override
  String get description => 'null';

  @override
  bool get takesArguments => false;
}