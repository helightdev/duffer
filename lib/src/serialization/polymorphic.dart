import 'package:duffer/duffer.dart';

class PickleRegistry {
  Map<Type, String> typeMappings = {};
  Map<String, Pickler> picklers = {};

//TODO: Implement

}

class IdentifiedPickle {
  String pickler;
  ByteBuf data;

  IdentifiedPickle(this.pickler, this.data);
}

class IdentifiedPicklePickler extends Pickler<IdentifiedPickle> {
  IdentifiedPicklePickler() : super("_t");

  @override
  int peekSize(IdentifiedPickle object) =>
      (Sizes.listIndex) + object.data.length + Sizes.string(object.pickler);

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
    var data = buf.readBuffer(dataLen);
    return IdentifiedPickle(pickler, data);
  }
}
