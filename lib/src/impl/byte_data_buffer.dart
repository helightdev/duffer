import 'dart:typed_data';

import '../bytebuf_base.dart';
import '../extensions.dart';
import '../utils/migration_utils.dart';

class ByteDataBuffer extends ByteBuf {
  ByteData data;

  bool _isGrowableInternal = true;

  @override
  bool isGrowable() => _isGrowableInternal;

  ByteDataBuffer(this.data);

  factory ByteDataBuffer.fixed(ByteData data) => ByteDataBuffer(data)
    ..maxCapacity = data.lengthInBytes
    .._isGrowableInternal = false;

  @override
  int capacity() => data.lengthInBytes;

  @override
  int getByte(int index) {
    if (index >= capacity()) throw ReadIndexOutOfRangeException();
    return data.getUint8(index);
  }

  @override
  void updateByte(int index, int byte) {
    if (index >= capacity()) throw WriteIndexOutOfRangeException();
    data.setUint8(index, byte);
  }

  @override
  Uint8List array() => data.uint8list;

  @override
  ByteData viewByteData(int index, int length) =>
      ByteData.sublistView(data, index, index + length);

  @override
  ByteDataBuffer viewBuffer(int index, int length) {
    return ByteDataBuffer.fixed(ByteData.sublistView(data, index, index + length));
  }

  @override
  void allocate(int bytes) {
    if (capacity() + bytes > maxCapacity) throw BufferOverflowException();
    data = MigrationUtils.migrate(data, capacity() + bytes);
  }
}
