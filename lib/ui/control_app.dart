import 'package:angular2/angular2.dart';
import 'package:tctrl/schema/model.dart';
import 'package:tctrl/ui/module.dart';

@Component(
    selector: 'control-app',
    directives: const [
      ModuleComponent,
    ],
    templateUrl: 'control_app.html'
    )
class ControlAppComponent {

  @Input()
  AppModel app;

  String get label => app?.label ?? app?.key;

  List<ModuleModel> get children => app?.children?.values?.toList();

}
