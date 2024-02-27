import 'package:args/command_runner.dart';

import 'app/analyze.dart';
import 'app/create.dart';

class AppCommand extends Command {
  static final instance = AppCommand();
  
  AppCommand() {
    addSubcommand(AppAnalyzeCommand.instance);
    addSubcommand(AppCreateCommand.instance);
    // addSubcommand(AppRemoveCommand.instance);
  }

  @override
  String get name => 'app';
  
  @override
  String get description => 'null';

  @override
  bool get takesArguments => false;
}