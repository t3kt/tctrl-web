import 'package:angular2/angular2.dart';
import 'package:tctrl/schema/model.dart';
import 'package:tctrl/schema/schema.dart';
import 'package:tctrl/ui/single_number_field.dart';

@Component(
    selector: 'parameter',
    directives: const [
      NgSwitch,
      NgSwitchWhen,
      NgSwitchDefault,
      SingleNumberFieldComponent,
    ],
    templateUrl: 'single_number_field.html')
class ParamComponent {

  dynamic get PTypes => ParamType;

  @Input()
  ParamModel param;

  String get label => param?.label ?? param?.key ?? '';

  ParamType get type => param?.type ?? ParamType.other;
}
