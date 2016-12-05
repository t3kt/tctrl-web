import 'package:angular2/angular2.dart';
import 'package:tctrl/schema/model.dart';
import 'package:tctrl/ui/param.dart';

@Component(
    selector: 'module',
    directives: const [
      ParamComponent,
      ModuleComponent,
    ],
    templateUrl: 'module.html',
    styleUrls: const ['module.css'],
    )
class ModuleComponent {

  @Input()
  ModuleModel module;

  String get label => module?.label ?? module?.key;

  List<ParamModel> get params => module?.params?.values?.toList();

  bool get hasParams => params?.isNotEmpty ?? false;

  List<ModuleModel> get children => module?.children?.values?.toList();
}
