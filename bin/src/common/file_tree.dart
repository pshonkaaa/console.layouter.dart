import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../globals.dart';

abstract class TEntity {
  TEntity({
    String? path,
  }) : _path = path;

  TEntity? _parent;

  String? _path;
  
  String get path => p.join(
    _parent?.path ?? '',
    _path ?? '',
  );
  
  set path(String value)
    => _path = value;

  Future<void> create();
  
  Future<void> remove();

  void _throwIfUnknownPath() {
    if(path.isEmpty)
      throw 'path == null';
  }
}

class TContainer extends TEntity {
  TContainer([
    Map<String, TEntity> entities = const {},
  ]) : _entities = entities;
  
  TContainer.withPath({
    required super.path,
    Map<String, TEntity> entities = const {},
  }) : _entities = entities;

  final Map<String, TEntity> _entities;

  Map<String, TEntity> get entities => UnmodifiableMapView(_entities);
  

  @override
  Future<void> create() async {
    // _throwIfUnknownPath();

    _initChildren();
    
    for(final entry in _entities.entries) {
      final entity = entry.value;

      await entity.create();
    }
  }
  
  @override
  Future<void> remove() async {
    // _throwIfUnknownPath();

    _initChildren();

    for(final entry in _entities.entries) {
      final entity = entry.value;
      
      await entity.remove();
    }
  }

  void _initChildren() {
    for(final entry in entities.entries) {
      final name = entry.key;
      final entity = entry.value;

      entity.path = name;
      entity._parent = this;
    }
  }
}


class TProxy extends TEntity {
  TProxy([
    List<TEntity> entities = const [],
  ]) : _entities = entities;

  final List<TEntity> _entities;

  List<TEntity> get entities => UnmodifiableListView(_entities);
  

  @override
  Future<void> create() async {
    _throwIfUnknownPath();

    _initChildren();

    for(final entity in _entities) {
      await entity.create();
    }
  }
  
  @override
  Future<void> remove() async {
    _throwIfUnknownPath();

    _initChildren();

    for(final entity in _entities) {      
      await entity.remove();
    }
  }

  void _initChildren() {
    for(final entity in entities) {
      entity._parent = this;
    }
  }
}

class TFolder extends TEntity {
  TFolder([
    Map<String, TEntity> entities = const {},
  ]) : _entities = entities;

  TFolder.withPath({
    required super.path,
    Map<String, TEntity> entities = const {},
  }) : _entities = entities;

  final Map<String, TEntity> _entities;

  Map<String, TEntity> get entities => UnmodifiableMapView(_entities);
  

  @override
  Future<void> create() async {
    _throwIfUnknownPath();

    _initChildren();

    logger.i('Creating $path');
    await Directory(path).create(recursive: true);
    
    for(final entry in _entities.entries) {
      final entity = entry.value;
      
      await entity.create();
    }
  }
  
  @override
  Future<void> remove() async {
    _throwIfUnknownPath();

    _initChildren();

    for(final entry in _entities.entries) {
      final entity = entry.value;
      
      await entity.remove();
    }

    if(await Directory(path).exists()) {
      logger.i('Deleting $path');
      await Directory(path).delete();
    }
  }

  void _initChildren() {
    for(final entry in entities.entries) {
      final name = entry.key;
      final entity = entry.value;

      entity.path = name;
      entity._parent = this;
    }
  }
}

class TFile extends TEntity {
  TFile(this.getData);

  final FutureOr<String> Function() getData;

  @override
  Future<void> create() async {
    _throwIfUnknownPath();
    
    logger.i('Creating $path');
    await File(path).writeAsString(await getData());
  }
  
  @override
  Future<void> remove() async {
    _throwIfUnknownPath();
    
    if(await File(path).exists())
      logger.i('Deleting $path');
      await File(path).delete(recursive: true);
  }
}