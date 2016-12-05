import 'package:angular2/angular2.dart';
import 'package:tctrl/schema/model.dart';
import 'package:tctrl/schema/schema.dart';
import 'package:tctrl/ui/control_app.dart';


AppSchema _buildTestAppSchema() {
  var app = new AppSchema('nxTestApp');
  var mod1 = app.addModule('mod1')
    ..label = 'Module 1';
  mod1.addParam('someBool', ParamType.bool)
    ..label = 'Some bool';
  mod1.addParam('thingCount', ParamType.int)
    ..label = 'Thing count';
  var mod2 = app.addModule('mod2')
    ..label = 'Module 2';
  mod2.addParam('fooText', ParamType.string)
    ..label = 'Foo text';
  mod2.addParam('asdf', ParamType.float)
    ..label = 'Asdf';
  var subMod1 = mod2.addModule('subMod1')
    ..label = 'Sub Module 1';
  subMod1.addParam('whatever', ParamType.float)
    ..label = 'Whatever';
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
