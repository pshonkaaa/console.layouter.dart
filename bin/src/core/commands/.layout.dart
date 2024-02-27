// import 'dart:io';

// import 'package:path/path.dart' as p;

// import '../../../.trash/arguments.dart';
// import '../project_info.dart';
// import '../../../.trash/base_command.dart';

// class LayoutCommand extends BaseCommand {
//   static final instance = LayoutCommand();

//   LayoutCommand() : super(
//     name: 'layout',
//   );

//   @override
//   Map<String, OnAction> get actions => {
//     'create': create,
//     // 'remove': remove,
//   };

//   Future<void> create(Arguments args) async {
//     final tree = TFolder({
//       'lib': TFolder({
//         'apps': TFolder({
//           '_common': TFolder({
//             'core': TFolder({
              
//             }),
//             'ui': TFolder({
              
//             }),
//           }),
//         }),
//         'libs': TFolder({
          
//         })
//       }),
//     });
//     await tree.create();
//   }
// }