import 'package:angular2/angular2.dart';
import 'package:tctrl/nexus/nexus.dart';
import 'package:tctrl/schema/model.dart';
import 'package:tctrl/schema/schema.dart';

List<Object> get bindings =>
    [
//      provide(ManagerWrapper, useFactory: () => globalInstance),
    ];

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

class NexusParam {
  final ParamModel model;
  final NexusType nexusType;
  final WidgetOptions widgetOptions;

  NexusParam._(this.model, {this.nexusType, this.widgetOptions});

  factory NexusParam(ParamModel param) =>
      _handlerForType(param.type)(param);
}

typedef NexusParam _ParamTypeNexusHandler(ParamModel param);

WidgetOptions _basicWidgetOptions(ParamModel param) =>
    new WidgetOptions()
//      ..label = param.label
//      ..oscPath = param.path
;

_ParamTypeNexusHandler _simpleHandler(NexusType nexusType) {
  return (ParamModel param) =>
  new NexusParam._(
      param,
      nexusType: nexusType,
      widgetOptions: _basicWidgetOptions(param));
}

final _handlers = <ParamType, _ParamTypeNexusHandler>{
  ParamType.bool: _simpleHandler(NexusType.toggle),
  ParamType.string: _simpleHandler(NexusType.text),
  ParamType.int: _simpleHandler(NexusType.number),
  ParamType.float: _simpleHandler(NexusType.slider),
};
//TODO: support other types

_ParamTypeNexusHandler _handlerForType(ParamType type) {
  if (!_handlers.containsKey(type)) {
    throw new UnsupportedError('Unsupported param type: $type');
  }
  return _handlers[type];
}

