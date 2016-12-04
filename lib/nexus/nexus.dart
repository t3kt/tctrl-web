@JS('nxshim')
library nexus;

import 'package:js/js.dart';

external ManagerWrapper get globalInstance;


@JS()
class ManagerWrapper {
  external void setDestinationType(String destination);

//  external void setSendCallback();
//  external void transmit();

  external void setColor(String aspect, String hexcolor);

  external void startPulse();

  external void stopPulse();

  external void pulse();

  external void setGlobalWidgets(bool enable);

//  external dynamic getWidget(String widgetId);
//  external dynamic transformCanvas(dynamic canvasElem, String typename);
  external dynamic addWidget(String typename, [WidgetOptions options]);
}

@JS()
@anonymous
class WidgetOptions {
  external int get x;
  external void set x(int v);

  external int get y;
  external void set y(int v);

  external int get w;
  external void set w(int v);

  external int get h;
  external void set h(int v);

  // TODO: support passing in parent element
  external String get parent;
  external void set parent(String v);

  external String get name;
  external void set name(String v);
}
