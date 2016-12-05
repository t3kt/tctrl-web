import 'package:angular2/core.dart';
import 'package:tctrl/nexus/nexus_tester.dart';

@Component(
    selector: 'my-app',
    directives: const [
      NexusTesterComponent,
    ],
    styleUrls: const ['app_component.css'],
    templateUrl: 'app_component.html')
class AppComponent {
}

