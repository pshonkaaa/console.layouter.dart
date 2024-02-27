import 'package:args/command_runner.dart';
import 'package:pshondation/library.dart';

import '../../../globals.dart';

class AppCreateCommand extends Command {
  static final String TAG = (AppCreateCommand).toString();
  
  static final instance = AppCreateCommand();

  AppCreateCommand() {
  }
  
  @override
  String get name => 'create';
  
  @override
  String get description => 'creates an application with the specified name';

  @override
  Future<void> run() async {
    logger.i('$TAG > $name');

    final appName = argResults!.rest.tryFirst;
    if(appName == null) {
      throw 'the [name] argument is not specified';
    }

    final app = Globals.projectInfo.layout.apps[appName];
    if(app == null) {
      throw 'the [$appName] application is not configured in the layout';
    }

    await app.create();
  }
}