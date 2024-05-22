import 'package:flutter/material.dart';

typedef LoadLibraryBuilder = Future<dynamic> Function();

typedef DeferredWidgetBuilder = Widget Function();

class DeferredWidget extends StatefulWidget {
  const DeferredWidget({
    super.key,
    required this.loadLibrary,
    required this.builder,
    Widget? placeholder,
  }) : placeholder = placeholder ?? const DeferredLoading();

  final LoadLibraryBuilder loadLibrary;
  final DeferredWidgetBuilder builder;
  final Widget placeholder;

  static final Map<LoadLibraryBuilder, Future<dynamic>> _moduleLoaders = {};
  static final Set<LoadLibraryBuilder> _loadedModules = {};

  /// 预加载
  static Future<dynamic> preload(LoadLibraryBuilder loadLibrary) {
    if (!_moduleLoaders.containsKey(loadLibrary)) {
      _moduleLoaders[loadLibrary] = loadLibrary().then((_) {
        _loadedModules.add(loadLibrary);
      });
    }
    return _moduleLoaders[loadLibrary]!;
  }

  @override
  State<DeferredWidget> createState() => _DeferredWidgetState();
}

class _DeferredWidgetState extends State<DeferredWidget> {
  Widget? _loadChild;
  DeferredWidgetBuilder? _loadBuilder;

  @override
  void initState() {
    super.initState();
    if (DeferredWidget._moduleLoaders.containsKey(widget.loadLibrary)) {
      _onLibraryLoaded();
    } else {
      DeferredWidget.preload(widget.loadLibrary)
          .then((_) => _onLibraryLoaded());
    }
  }

  void _onLibraryLoaded() {
    setState(() {
      _loadBuilder = widget.builder;
      _loadChild = _loadBuilder?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadBuilder != widget.builder && _loadChild != null) {
      _loadBuilder = widget.builder;
      _loadChild = _loadBuilder?.call();
    }
    return _loadChild ?? widget.placeholder;
  }
}

class DeferredLoading extends StatelessWidget {
  const DeferredLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.onSurface,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
