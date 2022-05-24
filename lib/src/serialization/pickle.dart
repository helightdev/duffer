import 'package:duffer/duffer.dart';

abstract class Pickler<T> {
  final String id;
  int peekSize(T object);
  void pickle(ByteBuf buf, T object);
  T unpickle(ByteBuf buf);

  const Pickler(this.id);

  factory Pickler.create(
      {required PickleFun<T> pickle,
      required UnpickleFun<T> unpickle,
      SizeFun<T>? size,
      String? name}) {
    return PicklerImpl<T>(
        pickleFun: pickle,
        unpickleFun: unpickle,
        sizeFun: size,
        name: name ?? "unknown");
  }
}

typedef PickleFun<T> = Function(ByteBuf, T);
typedef UnpickleFun<T> = T Function(ByteBuf);
typedef SizeFun<T> = int Function(T);

class PicklerImpl<T> extends Pickler<T> {
  final PickleFun<T> pickleFun;
  final UnpickleFun<T> unpickleFun;
  final SizeFun<T>? sizeFun;

  const PicklerImpl(
      {required this.pickleFun,
      required this.unpickleFun,
      this.sizeFun,
      name = "unknown"})
      : super(name);

  @override
  int peekSize(T object) {
    if (sizeFun != null) {
      return sizeFun!(object);
    } else {
      var tempBuffer = ByteBuf.create();
      pickleFun(tempBuffer, object);
      return tempBuffer.readableBytes;
    }
  }

  @override
  void pickle(ByteBuf buf, T object) {
    pickleFun(buf, object);
  }

  @override
  T unpickle(ByteBuf buf) {
    return unpickleFun(buf);
  }
}

abstract class Picklable<T> {
  Pickler<T> getPickler();
}

class MonotoneListPickler<T> extends Pickler<List<T>> {
  final Pickler<T> elementPickler;

  const MonotoneListPickler(this.elementPickler) : super("m[]");

  @override
  int peekSize(List<T> object) =>
      object.map((e) => elementPickler.peekSize(e)).reduce((x, y) => x + y) +
      Sizes.listIndex +
      (object.length * Sizes.listIndex);

  @override
  void pickle(ByteBuf buf, List<T> object) {
    buf.writeInt32(object.length);
    for (var element in object) {
      var elementSize = elementPickler.peekSize(element);
      buf.writeInt32(elementSize);
      var transaction = buf.writeTransactionBuffer(elementSize);
      elementPickler.pickle(transaction, element);
    }
  }

  @override
  List<T> unpickle(ByteBuf buf) {
    var list = List<T>.empty(growable: true);
    var size = buf.readInt32();
    for (var i = 0; i < size; i++) {
      var elementSize = buf.readInt32();
      var child = buf.readBuffer(elementSize);
      list.add(elementPickler.unpickle(child));
    }
    return list;
  }
}

ByteBuf pickleObject<T>(T obj, Pickler<T> pickler) {
  var buffer = ByteBuf.fixed(pickler.peekSize(obj));
  pickler.pickle(buffer, obj);
  return buffer;
}

T unpickleObject<T>(ByteBuf buf, Pickler<T> pickler) => pickler.unpickle(buf);

class PickleSerializable {
  const PickleSerializable();
}
