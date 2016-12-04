window.nxshim = (function() {
  var nx = window.nx;
  var nxshim = {};

  function ManagerWrapper(manager) {
    this.mgr = manager;
  }
  ManagerWrapper.prototype.setDestinationType = function(dest) {
    this.mgr.sendsTo(dest);
  };
  ManagerWrapper.prototype.setSendCallback = function(callback) {
    this.mgr.sendsTo(callback);
  };
  ManagerWrapper.prototype.addWidget = function(typename, options) {
    var wgt = this.mgr.add(typename, options);
    return wgt ? new WidgetWrapper(wgt) : null;
  };
  ManagerWrapper.prototype.transmit = function(dataobj) {
    this.mgr.transmit(dataobj);
  };
  ManagerWrapper.prototype.setColor = function(aspect, hexcolor) {
    this.mgr.colorize(aspect, hexcolor);
  };
  ManagerWrapper.prototype.startPulse = function () {
    this.mgr.startPulse();
  };
  ManagerWrapper.prototype.stopPulse = function () {
    this.mgr.stopPulse();
  };
  ManagerWrapper.prototype.pulse = function () {
    this.mgr.pulse();
  };
  ManagerWrapper.prototype.setGlobalWidgets = function(enable) {
    this.mgr.globalWidgets = enable;
  };
  ManagerWrapper.prototype.getWidget = function(widgetId) {
    var wgt = this.mgr.widgets[widgetId];
    return wgt ? new WidgetWrapper(wgt) : null;
  };
  ManagerWrapper.prototype.transformCanvas = function(canvasElem, typename, options) {
    var wgt = this.mgr.transform(canvasElem, typename, options);
    return wgt ? new WidgetWrapper(wgt) : null;
  };
  ManagerWrapper.prototype.transformCanvasById = function(canvasId, typename, options) {
    var wgt = this.mgr.transform(canvasId, typename, options);
    return wgt ? new WidgetWrapper(wgt) : null;
  };
  nxshim.ManagerWrapper = ManagerWrapper;

  function WidgetWrapper(widget) {
    this.wgt = widget;
  }
  WidgetWrapper.prototype.getCanvas = function() {
    return this.wgt.canvas;
  };
  WidgetWrapper.prototype.setOscPath = function(oscPath) {
    this.wgt.oscPath = oscPath;
  };
  nxshim.WidgetWrapper = WidgetWrapper;

  nxshim.globalInstance = new ManagerWrapper(nx);
  return nxshim;
})();
