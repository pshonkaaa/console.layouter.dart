import 'package:args/command_runner.dart';

import '../../../globals.dart';

class AppAnalyzeCommand extends Command {
  static final String TAG = (AppAnalyzeCommand).toString();
  
  static final instance = AppAnalyzeCommand();

  AppAnalyzeCommand() {
  }
  
  @override
  String get name => 'analyze';
  
  @override
  String get description => 'analyzes the application for incorrect imports';

  @override
  Future<void> run() async {
    logger.i('$TAG > $name');
    
    // TODO
  }
}