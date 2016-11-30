library tctrl.schema;

import 'package:dartson/dartson.dart';

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

class ParamOption {
  final String key;
  final String label;

  ParamOption(this.key, {this.label});
}

abstract class SpecNode {
  final String key;
  String label;
  List<String> tags;

  SpecNode(this.key, {this.label, this.tags});
}

abstract class ParamSpec extends SpecNode {
  int length = 1;
  String style;
  String group;

  ParamType get type;

  ParamSpec(String key) : super(key);
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
}

class _MenuParamSpec extends ParamSpec {
  String group;
  String defaultValue;
  List<ParamOption> options;

  @override
  ParamType get type => ParamType.menu;

  _MenuParamSpec(String key) : super(key);
}

class ModuleSpec extends SpecNode {
  String moduleType;
  List<ParamSpec> params;
  List<ModuleSpec> children;

  ModuleSpec(String key) : super(key);
}

class AppSchema extends SpecNode {
  String description;
  List<ModuleSpec> children;

  AppSchema(String key) : super(key);
}
