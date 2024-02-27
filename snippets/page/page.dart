import 'package:flutter/material.dart';

import 'domain/bloc.dart';

class $PAGE_NAME$Page extends StatefulWidget {
  const $PAGE_NAME$Page({
    super.key,
    required this.bloc,
  });
  
  final PageBloc bloc;

  @override
  State<$PAGE_NAME$Page> createState() => _State();
}

class _State extends State<$PAGE_NAME$Page> {
  PageBloc get bloc => widget.bloc;

  @override
  void initState() {
    super.initState();

    bloc.initState(context);
  }

  @override
  void dispose() {
    bloc.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder(
    );
  }
}