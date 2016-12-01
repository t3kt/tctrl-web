import 'package:angular2/angular2.dart';
import 'package:tctrl/schema/model.dart';
import 'package:tctrl/schema/schema.dart';


@Component(
    selector: 'single-number-field',
    templateUrl: 'single_number_field.html')
class SingleNumberFieldComponent {

  @Input()
  ParamModel param;

  ParamType get type => param?.type ?? ParamType.other;
}
