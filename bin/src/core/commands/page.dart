import 'package:args/command_runner.dart';

import 'page/add.dart';

class PageCommand extends Command {
  static final instance = PageCommand();
  
  PageCommand() {
    addSubcommand(PageAddCommand.instance);
  }

  @override
  String get name => 'page';
  
  @override
  String get description => 'null';

  @override
  bool get takesArguments => false;
}