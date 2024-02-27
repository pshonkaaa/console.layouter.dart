

  // Future<bool> remove(Arguments args) async {
  //   print('AppCommand remove');

  //   final name = args.takeOne();

  //   final path = ProjectInfo.getAppPath(name);

  //   if(!Directory(path).existsSync() && !File(ProjectInfo.getMainPath(name)).existsSync()) {
  //     print('$name not exists');
  //     return false;
  //   }

  //   final tree = await getTree(name);

  //   await tree.remove();

  //   return true;
  // }
