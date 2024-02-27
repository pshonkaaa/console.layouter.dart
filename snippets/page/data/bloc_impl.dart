import 'package:flutter/material.dart';
import 'package:bloc/library.dart';

import '../domain/bloc.dart';
import '../domain/repository.dart';

class $PAGE_NAME$BlocImpl extends BaseBloc<PageRepository, EPageEventType> implements PageBloc {
  $PAGE_NAME$BlocImpl({
    required super.repository,
  });

  @override
  void initState(BuildContext context) {
    super.initState(context);
  }

  @override
  void onEvent(
    EPageEventType type, [
      IBlocEvent event = IBlocEvent.empty,
  ]) {
    super.onEvent(type, event);
    switch(type) {
      case EPageEventType.none:
        // action
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}