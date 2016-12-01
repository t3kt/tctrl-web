import 'package:angular2/angular2.dart';
import 'package:tctrl/schema/model.dart';
import 'package:tctrl/ui/param.dart';

@Component(
    selector: 'param-list',
    directives: const [
      NgFor,
      ParamComponent,
    ],
    templateUrl: 'param_list.html')
class ParamListComponent {

  @Input()
  List<ParamModel> params = <ParamModel>[];

}
