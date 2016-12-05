import 'package:angular2/angular2.dart';
import 'package:tctrl/nexus/nexus.dart';
import 'package:tctrl/nexus/nexus_adapter.dart';


@Component(
    selector: 'simple-nexus-param',
    template: '''<canvas #nxcanvas></canvas>''')
class SimpleNexusParamComponent implements AfterViewInit {
//  final ManagerWrapper _manager;
  WidgetWrapper _widget;

  NexusParam _param;

//  SimpleNexusParamComponent(this._manager);

  @Input()
  void set param(NexusParam param) {
    this._param = param;
    //..
  }

  NexusParam get param => _param;

  String get nexusType => this.param?.nexusType?.toString();

  WidgetOptions get widgetOptions => this.param?.widgetOptions;

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
