import 'package:angular2/angular2.dart';
import 'package:tctrl/nexus/nexus.dart';
import 'package:tctrl/nexus/nexus_adapter.dart';
import 'package:tctrl/schema/model.dart';


@Component(
    selector: 'simple-nexus-param',
    template: '''<canvas #nxcanvas></canvas>''')
class SimpleNexusParamComponent implements AfterViewInit {
//  final ManagerWrapper _manager;
  WidgetWrapper _widget;

  ParamModel _paramModel;
  NexusParam _nexusParam;

//  SimpleNexusParamComponent(this._manager);

  @Input()
  void set param(ParamModel param) {
    this._paramModel = param;
    this._nexusParam = new NexusParam(param);
  }

  NexusParam get nexusParam => _nexusParam;

  String get nexusType => this.nexusParam?.nexusType?.toString()?.replaceAll('NexusType.', '');

  WidgetOptions get widgetOptions => this.nexusParam?.widgetOptions;

  @ViewChild('nxcanvas')
  ElementRef canvas;

  @override
  void ngAfterViewInit() {
    var canvasElem = canvas.nativeElement;
    _widget = globalInstance.transformCanvas(
        canvasElem,
        this.nexusType,
        this.widgetOptions);
  }
}
