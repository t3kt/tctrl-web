import 'package:angular2/angular2.dart';
import 'package:tctrl/nexus/simple_nexus_field.dart';
import 'package:tctrl/schema/model.dart';
import 'package:tctrl/schema/schema.dart';
import 'package:tctrl/ui/control_app.dart';


AppSchema _buildTestAppSchema() {
  var app = new AppSchema('nxTestApp');
  var mod1 = app.addModule('mod1');
  mod1.addParam('someBool', ParamType.bool)
    ..label = 'Some bool';
  mod1.addParam('thingCount', ParamType.int)
    ..label = 'Thing count';
  var mod2 = app.addModule('mod2');
  mod2.addParam('fooText', ParamType.string)
    ..label = 'Foo text';
  return app;
}


@Component(
    selector: 'nexus-tester',
    directives: const [
      ControlAppComponent,
    ],
    templateUrl: 'nexus_tester.html')
class NexusTesterComponent {

  AppSchema appSchema;

  AppModel appModel;

  ParamModel get param1 => appModel?.children['mod1']?.params['someBool'];

  NexusTesterComponent() {
    appSchema = _buildTestAppSchema();
    appModel = new AppModel(appSchema);
  }
}
