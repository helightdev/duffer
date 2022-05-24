import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';

import '../duffer_generator.dart';

class DufferImplBuilder {
  static void build(ClassElement clazz, List<DufferFieldData> fields) {
    Class((b) => b..name = "Test");
  }
}
