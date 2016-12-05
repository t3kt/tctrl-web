@JS('nxshim')
library nexus;

import 'dart:html';
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

  external WidgetWrapper getWidget(String widgetId);

  external WidgetWrapper transformCanvas(CanvasElement canvasElem, [String typename, WidgetOptions options]);

  external WidgetWrapper transformCanvasById(String canvasId, [String typename, WidgetOptions options]);

  external WidgetWrapper addWidget(String typename, [WidgetOptions options]);
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

  external String get label;
  external void set label(String v);

  external String get oscPath;
  external void set oscPath(String v);

  external int get sliders;
  external void set sliders(int v);

  external bool get hslider;
  external void set hslider(bool v);

  external WidgetSize get defaultSize;
  external void set defaultSize(WidgetSize v);

  external factory WidgetOptions();
}

@JS()
@anonymous
class WidgetSize {
  external int get width;
  external void set width(int v);
  external int get height;
  external void set height(int v);

  external factory WidgetSize();

  factory WidgetSize.simple({int width, int height}) =>
      new WidgetSize()
        ..width = width
        ..height = height;
}

@JS()
class WidgetWrapper {
  external CanvasElement getCanvas();
  external void setOscPath(String v);
}
