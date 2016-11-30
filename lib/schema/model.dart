library tctrl.model;

import 'package:property_grid/property_grid.dart';
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

  ParamType get type => spec.type;

  dynamic value;

  void registerInGridModel(PropertyGridModel gridModel) {
    gridModel.register(
        this.label,
        () => this.value,
        (val) => this.value = val,
        this._viewType,
        this._editorType,
        editorConfig: this._editorConfig,
        category: this.spec.group);
  }

  String get _viewType {
    return 'label';
  }

  String get _editorType {
    switch (this.type) {
      case ParamType.string:
        return 'textbox';
      case ParamType.int:
        return 'slider';
      default:
        throw new Exception('NOT IMPLEMENTED NOT IMPLEMENTED NOT IMPLEMENTED NOT IMPLEMENTED NOT IMPLEMENTED');
    }
  }

  dynamic get _editorConfig {
    switch (this.type) {
//      case ParamType.int:
      default:
        return null;
    }
  }

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

  PropertyGridModel buildGridModel() {
    var gridModel = new PropertyGridModel();
    // TODO: support sub modules
    for (var param in this.params) {
      param.registerInGridModel(gridModel);
    }
    return gridModel;
  }

  @override
  String toString() {
    return 'Module{$label ($key)}';
  }
}

