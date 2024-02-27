import 'dart:io';

import 'package:logger/logger.dart';

import 'core/project_info.dart';
import 'main.dart';

abstract class Globals {
  static late final ProjectInfo projectInfo;


  static late final Directory packageDir;

  static String get packagePath => packageDir.path;


  static late final Directory snippetsDir;

  static String get snippetsPath => snippetsDir.path;
}

Logger get logger => AppMain.instance.logger;

ProjectInfo get projectInfo => Globals.projectInfo;