library tctrl.ui;

import 'package:angular2/angular2.dart';
import 'package:property_grid/property_grid.dart';


@Component(
    selector: 'property-grid-host',
    template: '''
    <div>i am a property grid!</div>
    <div #placeholder style="height: 300px;"></div>
    '''
)
class PropertyGridHost implements AfterViewInit {

  @ViewChild('placeholder')
  ElementRef placeholder;

  PropertyGrid _grid;
  PropertyGridModel _model;

  @Input()
  set model(PropertyGridModel model) {
    _model = model;
    _grid?.model = model;
  }

  PropertyGridModel get model => _model;

  @override
  ngAfterViewInit() {
    _grid = new PropertyGrid(placeholder.nativeElement);
    if (_model != null) {
      _grid.model = model;
    }
  }

}
