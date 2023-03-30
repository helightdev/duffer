import 'package:duffer/duffer.dart';

part 'advanced.dart';
part 'collections.dart';
part 'primitives.dart';

final pickles = PickleRegistry();

class PickleRegistry {
  Map<Type, String> typeMappings = {
    IdentifiedPickle: IdentifiedPicklePickler.ID,
    DataListPickle: DataListPickler.ID,
    DataSetPickle: DataSetPickler.ID,
    DataMapPickle: DataMapPickler.ID,
    String: StringPickler.ID,
    int: IntPickler.ID,
    double: DoublePickler.ID,
    bool: BoolPickler.ID,
    DateTime: DateTimePickler.ID,
    Duration: DurationPickler.ID
  };

  Map<String, Pickler> picklers = {
    IdentifiedPicklePickler.ID: IdentifiedPicklePickler(),
    DataListPickler.ID: DataListPickler(),
    DataSetPickler.ID: DataSetPickler(),
    DataMapPickler.ID: DataMapPickler(),
    StringPickler.ID: StringPickler(),
    IntPickler.ID: IntPickler(),
    DoublePickler.ID: DoublePickler(),
    BoolPickler.ID: BoolPickler(),
    DateTimePickler.ID: DateTimePickler(),
    DurationPickler.ID: DurationPickler()
  };

  void register(Type type, Pickler pickler) {
    var id = pickler.id;
    typeMappings[type] = id;
    if (picklers[id] == null) picklers[id] = pickler;
  }

  /// Serializes the [value] recursively using the registered [Pickler]s and returns
  /// a [ByteBuf] containing the serialized binary data.
  ByteBuf dump(dynamic value) {
    if (value is List) {
      return _dumpVarList(value);
    } else if (value is Set) {
      return _dumpVarSet(value);
    } else if (value is Map) {
      return _dumpVarMap(value);
    }
    var picklerId = typeMappings[value.runtimeType];
    var pickler = picklers[picklerId]!;
    var childData = pickleObject(value, pickler);
    var idPickle = IdentifiedPickle(picklerId!, childData);
    var idPicklePickler =
        picklers[IdentifiedPicklePickler.ID] as Pickler<IdentifiedPickle>;
    var data = pickleObject(idPickle, idPicklePickler);
    return data;
  }

  ByteBuf _dumpVarList(List list) {
    var buffers = List<ByteBuf>.empty(growable: true);
    for (var element in list) {
      var child = dump(element);
      buffers.add(child);
    }
    return dump(DataListPickle(buffers));
  }

  ByteBuf _dumpVarSet(Set list) {
    var buffers = List<ByteBuf>.empty(growable: true);
    for (var element in list) {
      var child = dump(element);
      buffers.add(child);
    }
    return dump(DataSetPickle(buffers));
  }

  ByteBuf _dumpVarMap(Map map) {
    var dataMap = <ByteBuf, ByteBuf>{};
    for (var element in map.entries) {
      dataMap[dump(element.key)] = dump(element.value);
    }
    return dump(DataMapPickle(dataMap));
  }

  /// Deserializes the serialized binary contents of the [buffer] recursively using the
  /// registered [Pickler]s and returns the decoded value
  dynamic load(ByteBuf buffer) {
    var idPicklePickler =
        picklers[IdentifiedPicklePickler.ID] as Pickler<IdentifiedPickle>;
    var idPickle = idPicklePickler.unpickle(buffer);
    var pickler = picklers[idPickle.pickler]!;
    var data = pickler.unpickle(idPickle.data);
    if (data is DataListPickle) return data.data.map((e) => load(e)).toList();
    if (data is DataSetPickle) {
      return data.data.map((e) => load(e)).toList().toSet();
    }
    if (data is DataMapPickle) {
      var map = {};
      for (var element in data.data.entries) {
        map[load(element.key)] = load(element.value);
      }
      return map;
    }
    return data;
  }

  dynamic loadAs<T>(ByteBuf buffer) {
    var value = load(buffer);
    return value as T;
  }

  dynamic loadAsList<T>(ByteBuf buffer) {
    var value = loadAs<List>(buffer);
    return value.cast<T>();
  }

  dynamic loadAsSet<T>(ByteBuf buffer) {
    var value = loadAs<Set>(buffer);
    return value.cast<T>();
  }
}

class IdentifiedPickle {
  String pickler;
  ByteBuf data;

  IdentifiedPickle(this.pickler, this.data);
}

class IdentifiedPicklePickler extends Pickler<IdentifiedPickle> {
  static const String ID = "_t";

  IdentifiedPicklePickler() : super(ID);

  @override
  int peekSize(IdentifiedPickle object) =>
      (Sizes.listIndex) +
      object.data.readableBytes +
      Sizes.string(object.pickler);

  @override
  void pickle(ByteBuf buf, IdentifiedPickle object) {
    buf.writeLPString(object.pickler);
    buf.writeInt32(object.data.readableBytes);
    buf.writeBuffer(object.data);
  }

  @override
  IdentifiedPickle unpickle(ByteBuf buf) {
    var pickler = buf.readLPString();
    var dataLen = buf.readInt32();
    var data = buf.readBytes(dataLen).asWrappedBuffer;
    return IdentifiedPickle(pickler, data);
  }
}
