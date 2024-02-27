import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:json_ex/library.dart';
import 'package:path/path.dart' as p;

import '../common/file_tree.dart';
import '../common/pubspec.dart';
import '../globals.dart';
import 'generators/main.dart';
import 'generators/module.dart';
import 'generators/page.dart';

class ProjectInfo {
  static Future<ProjectInfo> read(Directory directory) async {
    final file = File(p.join(directory.path, 'pubspec.yaml'));
    if(!file.existsSync()) {
      throw Exception('pubspec.yaml not found');
    }

    final pubspec = await Pubspec.read(file);

    final layouter = _LayouterInfo.parse(pubspec.map);
    
    return ProjectInfo._(
      directory: directory,
      pubspec: pubspec,
      layouter: layouter,
    );
  }

  ProjectInfo._({
    required this.directory,
    required this.pubspec,
    required this.layouter,
  });

  final Directory directory;
  
  final Pubspec pubspec;

  final _LayouterInfo layouter;

  String get path => directory.path;

  LayoutInfo get layout => layouter.layout;

  Directory getAppDirectory(
    String appName,
  ) {
    return Directory(p.join(
      path,
      'lib',
      'apps',
      appName,
    ));
  }

  Directory getCoreDirectory(
    String appName,
    String? sideName,
  ) {
    return Directory(p.join(
      getAppDirectory(appName).path,
      sideName ?? '',
      'core',
    ));
  }

  Directory getUiDirectory(
    String appName,
    String? sideName,
  ) {
    return Directory(p.join(
      getAppDirectory(appName).path,
      sideName ?? '',
      'ui',
    ));
  }

  Directory getModulesDirectory(
    String appName,
    String? sideName,
  ) {
    return Directory(p.join(
      getCoreDirectory(
        appName,
        sideName,
      ).path,
      'modules',
    ));
  }

  Directory getPagesDirectory(
    String appName,
    String? sideName,
  ) {
    return Directory(p.join(
      getUiDirectory(
        appName,
        sideName,
      ).path,
      'presentation',
      'pages',
    ));
  }

  Directory getModuleDirectory(
    String appName,
    String? sideName,
    String moduleName,
  ) {
    return Directory(p.join(
      getModulesDirectory(
        appName,
        sideName,
      ).path,
      moduleName,
    ));
  }

  Directory getPageDirectory(
    String appName,
    String? sideName,
    String pageName,
  ) {
    return Directory(p.join(
      getPagesDirectory(
        appName,
        sideName,
      ).path,
      pageName,
    ));
  }
  
  File getMainFile(
    String appName,
  ) {
    return File(p.join(
      path,
      'lib',
      '$appName.dart',
    ));
  }

  // String getAppMainPath(String name) {
  //   return p.joinAll([
  //     getAppPath(name),
  //     'main.dart',
  //   ]);
  // }

  // String getPagePath(
  //   String appName,
  //   String pageName,
  // ) {
  //   return p.joinAll([
  //     'lib',
  //     'apps',
  //     appName,
  //     'ui',
  //     'presentation',
  //     'pages',
  //     pageName,
  //   ]);
  // }
}

class _LayouterInfo {
  
  static _LayouterInfo parse(Map<String, dynamic> data) {
    final jLayouter = ValueParser.tryParseJsonObject(data['layouter']);
    // if(jLayouter == null) {
    //   throw Exception('layouter field not found');
    // }

    final jLayout = ValueParser.tryParseJsonObject(jLayouter?['layout']);
    // if(jLayout == null) {
    //   throw Exception('projector.layout field not found');
    // }

    return _LayouterInfo(
      layout: LayoutInfo.parse(jLayout),
    );
  }

  
  _LayouterInfo({
    required this.layout,
  });

  final LayoutInfo layout;
}

class LayoutInfo {
  
  static LayoutInfo parse(Map<String, dynamic>? json) {
    final Map<String, dynamic> jApps = ValueParser.tryParseJsonObject(json?['apps']) ?? {};
    return LayoutInfo(
      apps: jApps.map((name, jApp) => MapEntry(name, AppInfo.parse(name, jApp))),
    );
  }

  LayoutInfo({
    required Map<String, AppInfo> apps,
  }) {
    _apps = apps;
  }

  late final Map<String, AppInfo> _apps;

  Map<String, AppInfo> get apps => UnmodifiableMapView(_apps);

  AppInfo getAppOrThrow(
    String? appName,
    String? sideName,
  ) {
    final AppInfo app;

    if(appName == null) {
      if(projectInfo.layout.apps.isEmpty) {
        throw ArgumentError('Apps not found');
      } else if(projectInfo.layout.apps.length > 1) {
        throw ArgumentError.notNull('app');
      }
      
      app = projectInfo.layout.apps.values.first;
    } else {
      if(projectInfo.layout.apps[appName] == null) {
        throw ArgumentError.value(appName, 'app', 'not found');
      }
      
      app = projectInfo.layout.apps[appName]!;
    }
    
    app.checkSideOrThrow(
      sideName,
    );

    return app;
  }
}

class AppInfo {
  
  static AppInfo parse(String name, Map<String, dynamic>? json) {
    final List<String>? sides = ValueParser.tryParseArray<String>(json?['sides']);
    
    return AppInfo(
      name: name,
      sides: sides,
    );
  }

  AppInfo({
    required this.name,
    required this.sides,
  });

  final String name;

  final List<String>? sides;

  void checkSideOrThrow(
    String? sideName,
  ) {
    if(sides != null) {
      if(sideName == null) {
        throw ArgumentError.notNull('side');
      }

      if(!sides!.contains(sideName)) {
        throw ArgumentError.value(sideName, 'side', 'not found');
      }
    }
  }

  Future<void> create() async {
    final dir = Globals.projectInfo.getAppDirectory(name);
    final file = Globals.projectInfo.getMainFile(name);

    if(dir.existsSync() || file.existsSync()) {
      logger.i('The [$name] application already exists');
      return;
    }

    final tree = _getTree();

    await tree.create();
  }

  Future<void> addModule(
    String moduleName, {
      required String? sideName,
  }) async {
    checkSideOrThrow(sideName);

    final moduleDir = projectInfo.getModuleDirectory(
      name,
      sideName,
      moduleName,
    );

    if(await moduleDir.exists()) {
      throw 'The module [$moduleName] already exists';
    }

    final tree = _getModuleTree(
      sideName,
      moduleName,
    );

    await tree.create();
  }

  Future<void> addPage(
    String pageName, {
      required String? sideName,
  }) async {
    checkSideOrThrow(sideName);

    final pageDir = projectInfo.getPageDirectory(
      name,
      sideName,
      pageName,
    );

    if(await pageDir.exists()) {
      throw 'The page [$pageName] already exists';
    }

    final tree = _getPageTree(
      sideName,
      pageName,
    );

    await tree.create();
  }

  TEntity _getModuleTree(
    String? sideName,
    String moduleName,
  ) {
    final moduleDir = projectInfo.getModuleDirectory(
      name,
      sideName,
      moduleName,
    );

    return TContainer({
      moduleDir.path: TFolder({
        'external': TFolder(),
        'internal': TFolder({
          "module_impl.dart": TFile(
            () => ModuleGenerator.generateModuleImpl(moduleName),
          ),
        }),
        'module.dart': TFile(
          () => ModuleGenerator.generateModule(moduleName),
        ),
      }),
    });
  }

  TEntity _getPageTree(
    String? sideName,
    String pageName,
  ) {
    final pageDir = projectInfo.getPageDirectory(
      name,
      sideName,
      pageName,
    );

    return TContainer({
      pageDir.path: TFolder({
        'data': TFolder({
          "bloc_impl.dart": TFile(
            () => PageGenerator.generateBlocImpl(pageName),
          ),
          "repository_impl.dart": TFile(
            () => PageGenerator.generateRepositoryImpl(pageName),
          ),
        }),
        'domain': TFolder({
          "bloc.dart": TFile(
            () => PageGenerator.generateBloc(pageName),
          ),
          "repository.dart": TFile(
            () => PageGenerator.generateRepository(pageName),
          ),
        }),
        'page.dart': TFile(
          () => PageGenerator.generatePage(pageName),
        ),
      }),
    });
  }

  TEntity _getTree() {
    final appDir = Globals.projectInfo.getAppDirectory(name);
    final mainFile = Globals.projectInfo.getMainFile(name);

    final appPath = p.join(
      appDir.path,
    );

    final mainPath = mainFile.path;

    return TContainer({
      appPath: _getAppTree(),

      mainPath: TFile(
        () => MainGenerator.generateMain(name),
      ),
    });
  }

  TEntity _getAppTree() {
    final List<TEntity> trees = [];

    if(sides != null) {
      for(final side in sides!) {
        trees.add(_getSideTree(side));
      }
    } else {
      trees.add(_getSideTree(null));
    }

    return TProxy([
      ...trees,
      TContainer({
        'globals.dart': TFile(
          () => MainGenerator.generateGlobals(name),
        ),

        'main.dart': TFile(
          () => MainGenerator.generateAppMain(name),
        ),
      }),
    ]);
  }

  TEntity _getSideTree(String? side) {
    final folder = TFolder({
      'core': _getCoreTree(),
      'ui': _getUiTree(),
    });

    if(side == null) {
      return TProxy([
        folder,
      ]);
    } return TFolder({
      side: folder,
    });
  }

  TEntity _getCoreTree() {
    return TContainer({
      'data': TFolder({
        'databases': TFolder({
          
        }),
        'models': TFolder({
          
        }),
      }),
      'modules': TFolder({
        
      }),
      'services': TFolder({
        
      }),
    });
  }

  TEntity _getUiTree() {
    return TContainer({
      'data': TFolder({
        'models': TFolder({
          
        }),
        'repositories': TFolder({
          
        }),
      }),
      'domain': TFolder({
        'models': TFolder({
          
        }),
        'repositories': TFolder({
          
        }),
        
      }),
      'presentation': TFolder({
        'dialogs': TFolder({
          
        }),
        'modals': TFolder({
          
        }),
        'pages': TFolder({
          
        }),
        'routers': TFolder({
          
        }),
        'widgets': TFolder({
          
        }),
        
        'main_widget': TFile(
          () => 'generateMainWidget(appName)',
        ),
      }),
    });
  }
}
