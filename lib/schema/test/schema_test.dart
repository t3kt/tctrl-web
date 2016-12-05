import 'package:tctrl/schema/schema.dart';
import 'package:test/test.dart';

void main() {
  group('ParamSpec.withType() should create expected parameter', () {
    test('for bool', () {
      var param = new ParamSpec.withType('foo', ParamType.bool);

      expect(param.key, equals('foo'));
      expect(param.type, equals(ParamType.bool));
      expect(param, new isInstanceOf<BoolParamSpec>());
    });

    test('for int with no length', () {
      var param = new ParamSpec.withType('foo', ParamType.int);

      expect(param.key, equals('foo'));
      expect(param.type, equals(ParamType.int));
      expect(param, new isInstanceOf<IntParamSpec>());
    });
    test('for int with length 1', () {
      var param = new ParamSpec.withType('foo', ParamType.int, length: 1);

      expect(param.key, equals('foo'));
      expect(param.type, equals(ParamType.int));
      expect(param, new isInstanceOf<IntParamSpec>());
    });
    test('for int with length 3', () {
      var param = new ParamSpec.withType('foo', ParamType.int, length: 3);

      expect(param.key, equals('foo'));
      expect(param.type, equals(ParamType.ivec));
      expect(param, new isInstanceOf<IntVectorParamSpec>());
      expect((param as IntVectorParamSpec).length, equals(3));
    });
  });
}
