import 'dart:typed_data';

import 'package:duffer/duffer.dart';
import 'package:duffer/src/impl/byte_data_buffer.dart';

class ArrayBuffer extends ByteBuf {
  Uint8List _buffer = Uint8List(0);

  ArrayBuffer(this._buffer);

  @override
  void allocate(int bytes) {
    if (capacity() + bytes > maxCapacity) throw BufferOverflowException();
    var newBuffer = Uint8List(capacity() + bytes);
    for (var i = 0; i < _buffer.length; i++) {
      newBuffer[i] = _buffer[i];
    }
    _buffer = newBuffer;
  }

  @override
  int getByte(int index) {
    try {
      return _buffer[index];
    } catch (_) {
      throw ReadIndexOutOfRangeException();
    }
  }

  @override
  void updateByte(int index, int byte) {
    try {
      _buffer[index] = byte;
    } catch (_) {
      throw WriteIndexOutOfRangeException();
    }
  }

  @override
  Uint8List array() => Uint8List.fromList(_buffer);

  @override
  bool isGrowable() => true;

  @override
  ByteBuf viewBuffer(int index, int length) {
    return ByteDataBuffer.fixed(
        ByteData.sublistView(_buffer, index, index + length));
  }

  @override
  ByteData viewByteData(int index, int length) {
    return ByteData.sublistView(_buffer, index, index + length);
  }

  @override
  int capacity() => _buffer.length;
}
