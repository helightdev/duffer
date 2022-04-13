import 'dart:io';
import 'dart:math';

import 'package:test/test.dart';
import 'package:duffer/duffer.dart';

void main() {
  group("Pickle", () {
    var fun = ExampleObject.pickler;
    test("Single", () {
      var obj0 = ExampleObject("Hans",  30);
      var buf = pickleObject(obj0, fun);
      var obj1 = unpickleObject(buf, fun);
      expect(obj1, obj0);
    });

    test("List", () {
      var obj0 = [
        ExampleObject("Anna", 10),
        ExampleObject("Bert", 20),
        ExampleObject("Conan", 30)
      ];
      var pickler = MonotoneListPickler(fun);
      var buf = pickleObject(obj0, pickler);
      var obj1 = unpickleObject(buf, pickler);
      expect(obj1, obj0);
    });
  });
}

class ExampleObject extends Picklable {

  static final Pickler<ExampleObject> pickler = Pickler.create(pickle: (buf,obj) {
    buf.writeLPString(obj.name);
    buf.writeInt32(obj.age);
  }, unpickle: (buf) {
    var name = buf.readLPString();
    var age = buf.readInt32();
    return ExampleObject(name, age);
  }, size: (obj) => Sizes.string(obj.name) + Sizes.int32, name: "example-object");

  String name;
  int age;

  ExampleObject(this.name, this.age);


  @override
  String toString() {
    return 'ExampleObject{name: $name, age: $age}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExampleObject &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          age == other.age;

  @override
  int get hashCode => name.hashCode ^ age.hashCode;

  @override
  Pickler<ExampleObject> getPickler() => pickler;
}