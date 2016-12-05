library tctrl.schema;

enum ParamType {
  other,
  bool,
  string,
  int,
  float,
  ivec,
  fvec,
  menu,
  trigger,
}

ParamType parseParamType(String str) {
  if (str == null || str.isEmpty) {
    return null;
  }
  str = str.toLowerCase();
  return ParamType.values.firstWhere((t) => t.toString().toLowerCase() == str,
                                         orElse: () => null);
}

String paramTypeName(ParamType type) =>
    type?.toString()?.replaceFirst('ParamType.', '');

Exception _parseError(dynamic message) {
  return new Exception(message);
}

abstract class _JsonWritable {
  Map<String, Object> get jsonDict;
}

class ParamOption implements _JsonWritable {
  final String key;
  final String label;

  ParamOption(this.key, {this.label});

  factory ParamOption.fromObj(Object obj) {
    if (obj == null) {
      throw _parseError('Invalid ParamOption: $obj}');
    }
    if (obj is String) {
      return new ParamOption(obj);
    }
    if (obj is Map<String, Object>) {
      return new ParamOption(obj['key'], label: obj['label']);
    }
    throw _parseError('Invalid ParamOption: $obj}');
  }

  @override
  Map<String, Object> get jsonDict => {'key': this.key, 'label': this.label};
}

List<ParamOption> _optionsFromObj(Object obj) {
  if (obj == null) {
    return null;
  }
  if (obj is List) {
    return obj.map((o) => new ParamOption.fromObj(o)).toList(growable: false);
  }
  return null;
}

num _asNum(Object obj) {
  if (obj is num) {
    return obj;
  }
  return null;
}

int _asInt(Object obj) => _asNum(obj)?.toInt();

double _asDouble(Object obj) => _asNum(obj)?.toDouble();

bool _asBool(Object obj) {
  if (obj is bool) {
    return obj;
  }
  if (obj is num) {
    return obj != 0;
  }
  return null;
}

abstract class SpecNode implements _JsonWritable {
  final String key;
  String label;
  List<String> tags;

  SpecNode(this.key);

  @override
  Map<String, Object> get jsonDict =>
      {
        'key': this.key,
        'label': this.label,
        'tags': this.tags,
      };

  void readProperties(Map<String, Object> obj) {
    this.label = obj['label'];
    this.tags = obj['tags'];
  }
}

abstract class ParamSpec extends SpecNode {
  String style;
  String group;

  ParamType get type;

  @override
  Map<String, Object> get jsonDict =>
      _merge(super.jsonDict, second: {
        'style': this.style,
        'group': this.group,
        'type': this.type.toString(),
      });

  ParamSpec(String key) : super(key);

  @override
  void readProperties(Map<String, Object> obj) {
    super.readProperties(obj);
    this.style = obj['style'];
    this.group = obj['group'];
  }

  factory ParamSpec.withType(String key, ParamType type, {int length}) {
    switch (type) {
      case ParamType.bool:
        return new BoolParamSpec(key);
      case ParamType.string:
        return new StringParamSpec(key);
      case ParamType.int:
        if (length == null || length == 1) {
          return new IntParamSpec(key);
        }
        return new IntVectorParamSpec(key, length: length);
      case ParamType.float:
        if (length == null || length == 1) {
          return new FloatParamSpec(key);
        }
        return new FloatVectorParamSpec(key, length: length);
      case ParamType.ivec:
        return new IntVectorParamSpec(key, length: length);
      case ParamType.fvec:
        return new FloatVectorParamSpec(key, length: length);
      case ParamType.menu:
        return new MenuParamSpec(key);
      case ParamType.trigger:
        return new TriggerParamSpec(key);
      case ParamType.other:
        return new OtherParamSpec(key);
      default:
        return null;
    }
  }

  factory ParamSpec.fromObj(Map<String, Object> obj) {
    var key = obj['key'];
    var typeStr = obj['type'];
    var type = parseParamType(typeStr);
    ParamSpec param;
    if (type == null) {
      param = new OtherParamSpec(key, otherType: typeStr);
    } else {
      param = new ParamSpec.withType(key, type, length: _asInt(obj['length']));
    }
    param.readProperties(obj);
    return param;
  }

}

class OtherParamSpec extends ParamSpec {
  String otherType;
  Map<String, Object> properties;

  OtherParamSpec(String key, {this.otherType})
      : super(key);

  @override
  ParamType get type => ParamType.other;

  @override
  void readProperties(Map<String, Object> obj) {
    super.readProperties(obj);
    if (obj.containsKey('otherType')) {
      this.otherType = obj['otherType'];
      // otherwise, leave it as it is since it might have been set on construction
    }
    var props = new Map.from(obj);
    for (var key in ['key', 'type', 'otherType', '']) {
      props.remove(key);
    }
    this.properties = props;
  }
}

class TriggerParamSpec extends ParamSpec {

  TriggerParamSpec(String key)
      : super(key);

  @override
  ParamType get type => ParamType.trigger;
}

class StringParamSpec extends ParamSpec {
  String defaultValue;
  List<ParamOption> options;

  StringParamSpec(String key)
      :super(key);

  @override
  ParamType get type => ParamType.string;

  @override
  Map<String, Object> get jsonDict =>
      _merge(super.jsonDict, second: {
        'default': this.defaultValue,
        'options': this.options?.map((o) => o.jsonDict)?.toList(growable: false),
      });

  @override
  void readProperties(Map<String, Object> obj) {
    super.readProperties(obj);
    this.defaultValue = obj['default'];
    this.options = _optionsFromObj(obj['options']);
  }
}

class BoolParamSpec extends ParamSpec {
  bool defaultValue;

  BoolParamSpec(String key)
      : super(key);

  @override
  ParamType get type => ParamType.bool;

  @override
  Map<String, Object> get jsonDict =>
      _merge(super.jsonDict, second: {
        'default': this.defaultValue,
      });

  @override
  void readProperties(Map<String, Object> obj) {
    super.readProperties(obj);
    this.defaultValue = _asBool(obj['default']);
  }
}

abstract class NumberParamSpec<T> extends ParamSpec {
  T defaultValue;
  T minLimit;
  T maxLimit;
  T minNorm;
  T maxNorm;

  NumberParamSpec._(String key, this.type)
      : super(key);

  @override
  final ParamType type;

  @override
  Map<String, Object> get jsonDict =>
      _merge(super.jsonDict, second: {
        'default': this.defaultValue,
        'minLimit': this.minLimit,
        'maxLimit': this.maxLimit,
        'minNorm': this.minNorm,
        'maxNorm': this.maxNorm,
      });

  T _parseVal(Object obj);

  @override
  void readProperties(Map<String, Object> obj) {
    super.readProperties(obj);
    this.defaultValue = _parseVal(obj['default']);
    this.minLimit = _parseVal(obj['minLimit']);
    this.maxLimit = _parseVal(obj['maxLimit']);
    this.minNorm = _parseVal(obj['minNorm']);
    this.maxNorm = _parseVal(obj['maxNorm']);
  }
}

class IntParamSpec extends NumberParamSpec<int> {
  IntParamSpec(String key)
      : super._(key, ParamType.int);

  @override
  int _parseVal(Object obj) => _asInt(obj);
}

class FloatParamSpec extends NumberParamSpec<double> {
  FloatParamSpec(String key)
      : super._(key, ParamType.float);

  @override
  double _parseVal(Object obj) => _asDouble(obj);
}

abstract class VectorParamSpec<T> extends ParamSpec {
  int length;
  List<T> defaultValue;
  List<T> minLimit;
  List<T> maxLimit;
  List<T> minNorm;
  List<T> maxNorm;

  VectorParamSpec._(String key, {this.length: 1})
      : super(key);

  @override
  Map<String, Object> get jsonDict =>
      _merge(super.jsonDict, second: {
        'length': this.length,
        'default': this.defaultValue,
        'minLimit': this.minLimit,
        'maxLimit': this.maxLimit,
        'minNorm': this.minNorm,
        'maxNorm': this.maxNorm,
      });

  List<T> _parseList(Object obj);

  @override
  void readProperties(Map<String, Object> obj) {
    super.readProperties(obj);
    this.length = _asInt(obj['length']);
    this.defaultValue = _fillToLength(_parseList(obj['default']), this.length);
    this.minLimit = _fillToLength(_parseList(obj['minLimit']), this.length);
    this.maxLimit = _fillToLength(_parseList(obj['maxLimit']), this.length);
    this.minNorm = _fillToLength(_parseList(obj['minNorm']), this.length);
    this.maxNorm = _fillToLength(_parseList(obj['maxNorm']), this.length);
  }
}

List _fillToLength(List vals, int length) {
  length ??= 1;
  if (vals == null || vals.isEmpty) {
    return new List.filled(length, null, growable: false);
  }
  if (vals.length >= length) {
    return vals.take(length).toList(growable: false);
  }
  var results = new List.from(vals);
  while (results.length < length) {
    results.add(vals.last);
  }
  return results.toList(growable: false);
}

class FloatVectorParamSpec extends VectorParamSpec<double> {
  FloatVectorParamSpec(String key, {int length: 1}) : super._(key, length: length);

  @override
  ParamType get type => ParamType.fvec;

  @override
  List<double> _parseList(Object obj) {
    if (obj is num) {
      return [obj.toDouble()];
    }
    if (obj is List) {
      return obj.map((o) => _asDouble(0)).toList();
    }
    return null;
  }
}

class IntVectorParamSpec extends VectorParamSpec<int> {
  IntVectorParamSpec(String key, {int length: 1}) : super._(key, length: length);

  @override
  get type => ParamType.ivec;

  @override
  List<int> _parseList(Object obj) {
    if (obj is num) {
      return [obj.toInt()];
    }
    if (obj is List) {
      return obj.map((o) => _asInt(0)).toList();
    }
    return null;
  }
}

class MenuParamSpec extends ParamSpec {
  String defaultValue;
  List<ParamOption> options;

  @override
  ParamType get type => ParamType.menu;

  MenuParamSpec(String key) : super(key);

  @override
  Map<String, Object> get jsonDict =>
      _merge(super.jsonDict, second: {
        'default': this.defaultValue,
        'options': this.options?.map((o) => o.jsonDict)?.toList(growable: false),
      });

  @override
  void readProperties(Map<String, Object> obj) {
    super.readProperties(obj);
    this.defaultValue = obj['default'];
    this.options = _optionsFromObj(obj['options']);
  }
}

class ModuleSpec extends SpecNode {
  String moduleType;
  String group;
  List<ParamSpec> params;
  List<ModuleSpec> children;

  ModuleSpec(String key) : super(key);

  factory ModuleSpec.fromObj(Map<String, Object> obj) {
    var key = obj['key'];
    var module = new ModuleSpec(key);
    module.readProperties(obj);
    var paramObjs = obj['params'];
    if (paramObjs != null && paramObjs is List<Map<String, Object>>) {
      module.params = paramObjs.map((p) => new ParamSpec.fromObj(p)).toList(growable: false);
    }
    var childrenObjs = obj['children'];
    if (childrenObjs != null && childrenObjs is List<Map<String, Object>>) {
      module.children = childrenObjs.map((m) => new ModuleSpec.fromObj(m)).toList(growable: false);
    }
    return module;
  }

  ParamSpec addParam(String key, ParamType type, {int length}) {
    ParamSpec param = new ParamSpec.withType(key, type, length: length);
    if (this.params == null) {
      this.params = [];
    }
    this.params.add(param);
    return param;
  }

  ModuleSpec addModule(String key) {
    ModuleSpec module = new ModuleSpec(key);
    if (this.children == null) {
      this.children = [];
    }
    this.children.add(module);
    return module;
  }

  @override
  Map<String, Object> get jsonDict =>
      _merge(super.jsonDict, second: {
        'moduleType': this.moduleType,
        'group': this.group,
        'params': this.params?.map((p) => p.jsonDict)?.toList(growable: false),
        'children': this.children?.map((p) => p.jsonDict)?.toList(growable: false),
      });

  @override
  void readProperties(Map<String, Object> obj) {
    super.readProperties(obj);
    this.moduleType = obj['moduleType'];
    this.group = obj['group'];
    // this method does not include .params or .children
  }
}

class AppSchema extends SpecNode {
  String description;
  List<ModuleSpec> children = [];

  AppSchema(String key) : super(key);

  factory AppSchema.fromObj(Map<String, Object> obj) {
    AppSchema app = new AppSchema(obj['key']);
    app.readProperties(obj);
    var childrenObjs = obj['children'];
    if (childrenObjs != null && childrenObjs is List<Map<String, Object>>) {
      app.children = childrenObjs.map((m) => new ModuleSpec.fromObj(m)).toList(growable: false);
    }
    return app;
  }

  ModuleSpec addModule(String key) {
    ModuleSpec module = new ModuleSpec(key);
    if (this.children == null) {
      this.children = [];
    }
    this.children.add(module);
    return module;
  }

  @override
  Map<String, Object> get jsonDict =>
      _merge(super.jsonDict, second: {
        'description': this.description,
        'children': this.children?.map((p) => p.jsonDict)?.toList(growable: false),
      });

  @override
  void readProperties(Map<String, Object> obj) {
    super.readProperties(obj);
    this.description = obj['description'];
    // this method does not include .children
  }
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


