import 'package:pshondation/library.dart';

class AppMain extends BaseAppMain {
  static final instance = AppMain();

  @override
  Future<void> preInit() async {
    // WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Future<void> init() async {
    
  }

  @override
  Future<void> postInit() async {
    // init services
  }

  @override
  Future<void> run() async {
    // runApp();
  }
}