import 'package:duffer/duffer.dart';

void main() {
  // You can directly dump primitives and basic types like DateTime and Duration
  pickles.dump("Hello World!");

  pickles.register(Person, personPickler); // Register pickler for Person
  pickles.register(House, housePickler); // Register pickler for House

  var expected =
      House("Some Street 12", [Person("Anna", 42), Person("Andrew", 45)]);
  var encoded = pickles.dump(expected);
  print(encoded.base64); // 00000008756e6b6e6f776e310000006c...

  var decoded = pickles.load(encoded);
  print(decoded); // Some Street 12: [Anna (42), Andrew (45)]

  // You can also directly pickle...
  var directlyPickled = pickleObject(expected, housePickler);
  // ...and unpickle the data, which is way faster
  unpickleObject(directlyPickled, housePickler);
}

final personPickler = Pickler<Person>.create(pickle: (buf, obj) {
  buf.writeLPString(obj.name);
  buf.writeInt64(obj.age);
}, unpickle: (buf) {
  return Person(buf.readLPString(), buf.readInt64());
});

final housePickler = Pickler<House>.create(pickle: (buf, obj) {
  buf.writeLPString(obj.address);
  buf.writeLPBuffer(pickles.dump(obj.persons)); // Use dump to serialize a child
}, unpickle: (buf) {
  var address = buf.readLPString();
  var persons = pickles.loadAsList<Person>(
      buf.readLPBuffer()); // Load the child list from the buffer
  return House(address, persons);
});

class Person {
  String name;
  int age;
  Person(this.name, this.age);
  @override
  String toString() => '$name ($age)';
}

class House {
  String address;
  List<Person> persons;
  House(this.address, this.persons);
  @override
  String toString() => '$address: $persons';
}
