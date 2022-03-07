import 'dart:typed_data';

import '../bytebuf_base.dart';
import '../extensions.dart';
import 'heap_buffer.dart';

class ListBuffer extends ByteBuf {

  final Uint8List _backing;

  ListBuffer(this._backing);

  @override
  int capacity() => _backing.lengthInBytes;

  @override
  int getByte(int index) {
    if (index >= capacity()) throw ReadIndexOutOfRangeException();
    return _backing[index];
  }

  @override
  void setByte(int index, int byte) {
    if (index >= capacity()) throw WriteIndexOutOfRangeException();
    _backing[index] = byte;
  }
  @override
  Uint8List array() => _backing.uint8List;

  @override
  ByteData viewByteData(int index, int length) => _backing.buffer.asByteData(index, length);

  @override
  ByteBuf getBuffer(int index, int length) {
    return HeapBuffer.fixed(ByteData.view(_backing.buffer, index, index + length));
  }

  @override
  void allocate(int bytes) {
    if (capacity() + bytes > maxCapacity) throw BufferOverflowException();
    for (int i = 0; i < bytes; i++) {
      _backing.add(0x00);
    }
  }

  @override
  bool isGrowable() => true;
}
