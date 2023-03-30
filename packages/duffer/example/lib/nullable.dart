import 'package:duffer/duffer.dart';

void main() {
  var buffer = Unpooled.buffer();
  Person? a = Person("Max", 19);
  Person? b;
  buffer.writeNullable<Person>(a, (p0) => personPickler.pickle(buffer, p0));
  buffer.writeNullable<Person>(b, (p0) => personPickler.pickle(buffer, p0));

  var readA = buffer.readNullable(() => personPickler.unpickle(buffer));
  var readB = buffer.readNullable(() => personPickler.unpickle(buffer));
  print(readA); // Max (19)
  print(readB); // null
}

final personPickler = Pickler<Person>.create(pickle: (buf, obj) {
  buf.writeLPString(obj.name);
  buf.writeInt64(obj.age);
}, unpickle: (buf) {
  return Person(buf.readLPString(), buf.readInt64());
});

class Person {
  String name;
  int age;
  Person(this.name, this.age);
  @override
  String toString() => '$name ($age)';
}
