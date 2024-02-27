import 'package:logger/logger.dart';

import 'main.dart';

abstract class Globals {
  static final Logger logger = AppMain.instance.logger;
}

Logger get logger => Globals.logger;