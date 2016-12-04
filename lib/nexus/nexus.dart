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
}
