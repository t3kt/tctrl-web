import 'package:angular2/core.dart';
import 'package:property_grid/property_grid.dart';

@Component(
    selector: 'my-app',
    styleUrls: const ['app_component.css'],
    templateUrl: 'app_component.html')
class AppComponent {
  var model = new PropertyGridModel();
}


