// ignore_for_file: constant_identifier_names

part of 'polymorphic.dart';

class StringPickler extends Pickler<String> {
  static const ID = "s";

  StringPickler() : super(ID);

  @override
  int peekSize(String object) => Sizes.string(object);

  @override
  void pickle(ByteBuf buf, String object) {
    buf.writeLPString(object);
  }

  @override
  String unpickle(ByteBuf buf) {
    return buf.readLPString();
  }
}

class IntPickler extends Pickler<int> {
  static const ID = "i";

  IntPickler() : super(ID);

  @override
  int peekSize(int object) => Sizes.int64;

  @override
  void pickle(ByteBuf buf, int object) {
    buf.writeInt64(object);
  }

  @override
  int unpickle(ByteBuf buf) {
    return buf.readInt64();
  }
}

class DoublePickler extends Pickler<double> {
  static const ID = "d";

  DoublePickler() : super(ID);

  @override
  int peekSize(double object) => Sizes.int64;

  @override
  void pickle(ByteBuf buf, double object) {
    buf.writeFloat64(object);
  }

  @override
  double unpickle(ByteBuf buf) {
    return buf.readFloat64();
  }
}

class BoolPickler extends Pickler<bool> {
  static const ID = "b";

  BoolPickler() : super(ID);

  @override
  int peekSize(bool object) => Sizes.int64;

  @override
  void pickle(ByteBuf buf, bool object) {
    buf.writeByte(object ? 0xFF : 0x00);
  }

  @override
  bool unpickle(ByteBuf buf) {
    return buf.readByte() == 0xFF ? true : false;
  }
}
