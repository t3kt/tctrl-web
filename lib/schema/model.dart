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
  String toString() {
    return 'Param{$label ($key): $value}';
  }
}

class ModuleModel extends ModelNode {
  final ModuleSpec spec;
  final ModuleModel parent;
  final AppModel app;
  List<ParamModel> _params;
  List<ModuleModel> _children;

  ModuleModel(ModuleSpec spec, AppModel app, [ModuleModel parent])
      : spec = spec,
        app = app,
        parent = parent,
        super(spec.key, '${parent?.path ?? app.path}/${spec.key}') {
    this._params = spec.params?.map((p) => new ParamModel(p, this))?.toList() ?? new List<ParamModel>(0);
    this._children = spec.children?.map((m) => new ModuleModel(m, this.app, this))?.toList() ?? new List<ModuleModel>(0);
  }

  List<ParamModel> get params => _params;

  List<ModuleModel> get children => _children;

  @override
  String get label => spec.label;

  @override
  String toString() {
    return 'Module{$label ($key)}';
  }
}

class AppModel extends ModelNode {
  final AppSchema schema;

  List<ModuleModel> _children;

  AppModel(AppSchema schema)
      : schema = schema,
        super(schema.key, '/${schema.key}') {
    this._children = schema.children?.map((m) => new ModuleModel(m, this))?.toList() ?? new List<ModuleModel>(0);
  }

  List<ModuleModel> get children => _children;

  @override
  String get label => schema.label;

  @override
  String toString() {
    return 'App{$label ($key)}';
  }
}


