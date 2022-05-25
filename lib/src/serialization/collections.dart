part of 'polymorphic.dart';

class DataListPickle {
  List<ByteBuf> data;

  DataListPickle(this.data);
}

class DataSetPickle {
  List<ByteBuf> data;

  DataSetPickle(this.data);
}

class DataMapPickle {
  Map<ByteBuf, ByteBuf> data;

  DataMapPickle(this.data);
}

class DataMapPickler extends Pickler<DataMapPickle> {
  static const String ID = "_d{}";

  DataMapPickler() : super(ID);

  @override
  int peekSize(DataMapPickle object) {
    var dataSize = object.data.entries
        .map((e) => e.key.readableBytes + e.value.readableBytes)
        .reduce((a, b) => a + b);
    var indexSize = object.data.length * Sizes.int32 * 2;
    return dataSize + indexSize;
  }

  @override
  void pickle(ByteBuf buf, DataMapPickle object) {
    for (var element in object.data.entries) {
      buf.writeInt32(element.key.readableBytes);
      buf.writeBytes(element.key.peekAvailableBytes());
      buf.writeInt32(element.value.readableBytes);
      buf.writeBytes(element.value.peekAvailableBytes());
    }
  }

  @override
  DataMapPickle unpickle(ByteBuf buf) {
    var dataMap = <ByteBuf, ByteBuf>{};
    while (buf.readableBytes > 0) {
      var keyLen = buf.readInt32();
      var keyData = buf.readBytes(keyLen).asWrappedBuffer;
      var valLen = buf.readInt32();
      var valData = buf.readBytes(valLen).asWrappedBuffer;
      dataMap[keyData] = valData;
    }
    return DataMapPickle(dataMap);
  }
}

class DataListPickler extends Pickler<DataListPickle> {
  static const String ID = "_d[]";

  DataListPickler() : super(ID);

  @override
  int peekSize(DataListPickle object) {
    var dataSize =
        object.data.map((e) => e.readableBytes).reduce((a, b) => a + b);
    var indexSize = object.data.length * Sizes.int32;
    return dataSize + indexSize;
  }

  @override
  void pickle(ByteBuf buf, DataListPickle object) {
    for (var element in object.data) {
      buf.writeInt32(element.readableBytes);
      buf.writeBytes(element.peekAvailableBytes());
    }
  }

  @override
  DataListPickle unpickle(ByteBuf buf) {
    var dataList = List<ByteBuf>.empty(growable: true);
    while (buf.readableBytes > 0) {
      var len = buf.readInt32();
      var data = buf.readBytes(len).asWrappedBuffer;
      dataList.add(data);
    }
    return DataListPickle(dataList);
  }
}

class DataSetPickler extends Pickler<DataSetPickle> {
  static const String ID = "_ds[]";

  DataSetPickler() : super(ID);

  @override
  int peekSize(DataSetPickle object) {
    var dataSize =
        object.data.map((e) => e.readableBytes).reduce((a, b) => a + b);
    var indexSize = object.data.length * Sizes.int32;
    return dataSize + indexSize;
  }

  @override
  void pickle(ByteBuf buf, DataSetPickle object) {
    for (var element in object.data) {
      buf.writeInt32(element.readableBytes);
      buf.writeBytes(element.peekAvailableBytes());
    }
  }

  @override
  DataSetPickle unpickle(ByteBuf buf) {
    var dataList = List<ByteBuf>.empty(growable: true);
    while (buf.readableBytes > 0) {
      var len = buf.readInt32();
      var data = buf.readBytes(len).asWrappedBuffer;
      dataList.add(data);
    }
    return DataSetPickle(dataList);
  }
}
