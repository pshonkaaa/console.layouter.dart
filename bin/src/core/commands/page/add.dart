import 'package:args/command_runner.dart';
import 'package:change_case/change_case.dart';
import 'package:pshondation/library.dart';

import '../../../globals.dart';

class PageAddCommand extends Command {
  static final String TAG = (PageAddCommand).toString();
  
  static final instance = PageAddCommand();

  PageAddCommand() {
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
  String get description => 'addes an page with the specified name';

  @override
  Future<void> run() async {
    logger.i('$TAG > $name');

    final pageName = argResults!.rest.tryFirst;
    if(pageName == null) {
      throw 'the [pageName] argument is not specified';
    }

    if(pageName.toSnakeCase() != pageName) {
      throw ArgumentError('[$pageName] must be snake_case');
    }

    final appName = argResults!['app'] as String?;
    final sideName = argResults!['side'] as String?;


    final app = projectInfo.layout.getAppOrThrow(
      appName,
      sideName,
    );

    await app.addPage(
      pageName,
      sideName: sideName,
    );
  }
}