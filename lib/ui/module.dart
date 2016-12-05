import 'package:angular2/angular2.dart';
import 'package:tctrl/schema/model.dart';
import 'package:tctrl/ui/param_list.dart';

@Component(
    selector: 'module',
    directives: const [
      ParamListComponent,
      ModuleComponent,
    ],
    templateUrl: 'module.html'
    )
class ModuleComponent {

  @Input()
  ModuleModel module;

  String get label => module?.label ?? module?.key;

  List<ParamModel> get params => module?.params?.values?.toList();

  List<ModuleModel> get children => module?.children?.values?.toList();
}
