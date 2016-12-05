library tctrl.model;

import 'package:tctrl/schema/schema.dart';

abstract class ModelNode {
  final String key;
  final String path;

  ModelNode(this.key, this.path);

  String get label;
}

class ParamModel extends ModelNode {
  final ParamSpec spec;
  final ModuleModel parent;

  ParamModel(ParamSpec spec, ModuleModel parent)
      : spec = spec,
        parent = parent,
        super(spec.key, '${parent.path}/${spec.key}');

  @override
  String get label => spec.label;

  ParamType get type => spec.type;

  AppModel get app => parent.app;

  dynamic value;

  @override
  String toString() => 'Param{$label ($key): $value}';
}

abstract class _ContainerNode extends ModelNode {

  Map<String, ModuleModel> _children;

  _ContainerNode(String key, String path)
      : super(key, path);

  void _setChildren(Iterable<ModuleModel> children) {
    if (children == null) {
      this._children = new Map<String, ModuleModel>();
    } else {
      this._children = new Map<String, ModuleModel>.fromIterable(children, key: (m) => m.key);
    }
  }

  Map<String, ModuleModel> get children => _children;
}

class ModuleModel extends _ContainerNode {
  final ModuleSpec spec;
  final ModuleModel parent;
  final AppModel app;
  Map<String, ParamModel> _params;

  ModuleModel(ModuleSpec spec, AppModel app, [ModuleModel parent])
      : spec = spec,
        app = app,
        parent = parent,
        super(spec.key, '${parent?.path ?? app.path}/${spec.key}') {
    if (spec.params == null) {
      this._params = new Map<String, ParamModel>();
    } else {
      this._params =
      new Map<String, ParamModel>.fromIterable(spec.params.map((p) => new ParamModel(p, this)), key: (p) => key);
    }
    _setChildren(spec.children?.map((m) => new ModuleModel(m, this.app, this)));
  }

  Map<String, ParamModel> get params => _params;

  @override
  String get label => spec.label;

  @override
  String toString() => 'Module{$label ($key)}';
}

class AppModel extends _ContainerNode {
  final AppSchema schema;

  AppModel(AppSchema schema)
      : schema = schema,
        super(schema.key, '/${schema.key}') {
    _setChildren(schema.children?.map((m) => new ModuleModel(m, this)));
  }

  @override
  String get label => schema.label;

  @override
  String toString() => 'App{$label ($key)}';
}


