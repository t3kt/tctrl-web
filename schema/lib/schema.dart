library tctrl.schema;

enum ParamType {
  unknown,
  other,
  bool,
  string,
  int,
  float,
  ivec,
  fvec,
  bvec,
  menu,
  trigger,
}

ParamType parseParamType(String str) {
  if (str == null || str.isEmpty) {
    return ParamType.unknown;
  }
  str = str.toLowerCase();
  return ParamType.values.firstWhere((t) => t.toString().toLowerCase() == str,
      orElse: () => ParamType.other);
}

abstract class _JsonWritable {
  Map<String, Object> get jsonDict;
}

class ParamOption implements _JsonWritable {
  final String key;
  final String label;

  ParamOption(this.key, {this.label});

  @override
  Map<String, Object> get jsonDict => {'key': this.key, 'label': this.label};
}

abstract class SpecNode implements _JsonWritable {
  final String key;
  String label;
  List<String> tags;

  SpecNode(this.key, {this.label, this.tags});

  @override
  Map<String, Object> get jsonDict =>
      {
        'key': this.key,
        'label': this.label,
        'tags': this.tags,
      };
}

abstract class ParamSpec extends SpecNode {
  int length = 1;
  String style;
  String group;

  ParamType get type;

  ParamSpec(String key) : super(key);

  @override
  Map<String, Object> get jsonDict =>
      _merge(super.jsonDict, second: {
        'length': this.length == 1 ? null : this.length,
        'style': this.style,
        'group': this.group,
        'type': this.type.toString(),
      });
}

class _RangedParamSpec<T> extends ParamSpec {
  List<T> minLimit;
  List<T> maxLimit;
  List<T> minNorm;
  List<T> maxNorm;
  List<T> defaultValue;

  @override
  final ParamType type;

  _RangedParamSpec(String key, this.type)
      : super(key);

  @override
  Map<String, Object> get jsonDict =>
      _merge(super.jsonDict, second: {
        'minLimit':this.minLimit,
        'maxLimit':this.maxLimit,
        'minNorm': this.minNorm,
        'maxNorm': this.maxNorm,
        'default': this.defaultValue,
      });
}

class _MenuParamSpec extends ParamSpec {
  String defaultValue;
  List<ParamOption> options;

  @override
  ParamType get type => ParamType.menu;

  _MenuParamSpec(String key) : super(key);

  @override
  Map<String, Object> get jsonDict =>
      _merge(super.jsonDict, second: {
        'default': this.defaultValue,
        'options': this.options?.map((o) => o.jsonDict),
      });
}

class ModuleSpec extends SpecNode {
  String moduleType;
  String group;
  List<ParamSpec> params;
  List<ModuleSpec> children;

  ModuleSpec(String key) : super(key);

  @override
  Map<String, Object> get jsonDict =>
      _merge(super.jsonDict, second: {
        'moduleType': this.moduleType,
        'group': this.group,
        'params': this.params?.map((p) => p.jsonDict),
        'children':this.children?.map((p) => p.jsonDict),
      });
}

class AppSchema extends SpecNode {
  String description;
  List<ModuleSpec> children;

  AppSchema(String key) : super(key);

  @override
  Map<String, Object> get jsonDict =>
      _merge(super.jsonDict, second: {
        'description': this.description,
        'children': this.children?.map((p) => p.jsonDict),
      });
}

Map<String, Object> _cleanJsonObject(Map<String, Object> obj) {
  var result = new Map<String, Object>();
  obj.forEach((key, val) {
    if (val == null || val == '') {
      return;
    }
    if (val is List && (val as List).isEmpty) {
      return;
    }
    if (val is Map) {
      result[key] = _cleanJsonObject(val);
    } else {
      result[key] = val;
    }
  });
  return result;
}

Map<String, Object> _merge(Map<String, Object> first,
    {Map<String, Object> second,
    List<Map<String, Object>> more}) {
  var result = new Map<String, Object>.from(first);
  if (second != null) {
    result.addAll(second);
  }
  for (var map in more) {
    if (map != null) {
      result.addAll(map);
    }
  }
  return result;
}
