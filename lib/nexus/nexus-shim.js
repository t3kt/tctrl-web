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
    return this.mgr.widgets[widgetId];
  };
  ManagerWrapper.prototype.transformCanvas = function(canvasElem, typename) {
    return this.mgr.transform(canvasElem, typename);
  };
  nxshim.ManagerWrapper = ManagerWrapper;

  nxshim.globalInstance = new ManagerWrapper(nx);
  return nxshim;
})();
