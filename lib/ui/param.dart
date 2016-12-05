import 'package:angular2/angular2.dart';
import 'package:tctrl/nexus/simple_nexus_field.dart';
import 'package:tctrl/schema/model.dart';
import 'package:tctrl/schema/schema.dart';

@Component(
    selector: 'parameter',
    directives: const [
      NgSwitch,
      NgSwitchWhen,
      NgSwitchDefault,
      SimpleNexusFieldComponent,
    ],
    templateUrl: 'param.html')
class ParamComponent {

  @Input()
  ParamModel param;

  String get label => param?.label ?? param?.key;

  ParamType get type => param?.type ?? ParamType.other;

  String get typeName => paramTypeName(type);

  bool get isSimple => _simpleParamTypes.contains(type);
}

final _simpleParamTypes = new Set<ParamType>.from([
  ParamType.bool,
  ParamType.int,
  ParamType.float,
  ParamType.string,
  ParamType.fvec,
]);
