import 'package:tctrl/schema/model.dart';
import 'package:tctrl/schema/schema.dart';

enum NexusType {
  banner,
  button,
  colors,
  comment,
  crossfade,
  dial,
  envelope,
  ghost,
  joints,
  keyboard,
  matrix,
  message,
  meter,
  metro,
  metroball,
  motion,
  mouse,
  multislider,
  multitouch,
  number,
  position,
  range,
  select,
  slider,
  string,
  tabs,
  text,
  tilt,
  toggle,
  typewriter,
  vinyl,
  waveform,
  windows,
}

Map<ParamType, NexusType> _paramNexusTypeMappings = {
  ParamType.bool: NexusType.toggle,
};

NexusType _paramTypeToNexusType(ParamType type) {
  if (_paramNexusTypeMappings.containsKey(type)) {
    return _paramNexusTypeMappings[type];
  }
  return null;
}

class NexusParam {
  final ParamModel model;
  final NexusType nexusType;

  NexusParam._(this.model, {this.nexusType});

  factory NexusParam(ParamModel model) {
    var nType = _paramTypeToNexusType(model.type);
    return new NexusParam._(model, nexusType: nType);
  }
}

