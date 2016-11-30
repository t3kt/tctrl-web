library tctrl.model;

import 'package:tctrl/schema/schema.dart';

abstract class ModelNode {
  final String key;

  ModelNode(this.key);

  String get label;
}

class ParamModel extends ModelNode {
  final ParamSpec spec;

  ParamModel(ParamSpec spec)
      : spec = spec,
        super(spec.key);

  @override
  String get label => spec.label;

  dynamic value;

  @override
  String toString() {
    return 'Param{$label ($key): $value}';
  }
}

class ModuleModel extends ModelNode {
  final ModuleSpec spec;
  final List<ParamModel> params;
  final List<ModuleSpec> children;

  ModuleModel(ModuleSpec spec)
      : spec = spec,
        params = spec.params?.map((p) => new ParamModel(p))?.toList() ?? new List<ParamModel>(),
        children = spec.children?.map((m) => new ModuleModel(m))?.toList() ?? new List<ModuleModel>(),
        super(spec.key);

  @override
  String get label => spec.label;

  @override
  String toString() {
    return 'Module{$label ($key)}';
  }
}

