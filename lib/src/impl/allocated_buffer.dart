import 'dart:typed_data';

import '../bytebuf_base.dart';
import '../extensions.dart';
import '../bytebuf_allocator.dart';
import 'heap_buffer.dart';

class FixedAllocatedBuffer extends ByteBuf with ReleasableByteBuf {
  ByteData data;
  ByteBufAllocator allocator;

  FixedAllocatedBuffer(this.allocator, this.data);

  bool released = false;

  @override
  bool isReleased() => released;

  @override
  void setReleasedInternal(bool released) {
    this.released = true;
  }

  @override
  void release() {
    if (released) return;
    allocator.release(this);
  }

  @override
  int capacity() {
    if (released) throw BufferReleasedException();
    return data.lengthInBytes;
  }

  @override
  int getByte(int index) {
    if (released) throw BufferReleasedException();
    if (index >= capacity()) throw ReadIndexOutOfRangeException();
    return data.getUint8(index);
  }

  @override
  void setByte(int index, int byte) {
    if (released) throw BufferReleasedException();
    if (index >= capacity()) throw WriteIndexOutOfRangeException();
    data.setUint8(index, byte);
  }

  @override
  Uint8List array() {
    if (released) throw BufferReleasedException();
    return data.uint8list;
  }

  @override
  ByteData viewByteData(int index, int length) {
    if (released) throw BufferReleasedException();
    return ByteData.sublistView(data, index, index + length);
  }

  @override
  ByteBuf getBuffer(int index, int length) {
    if (released) throw BufferReleasedException();
    return HeapBuffer.fixed(ByteData.sublistView(data, index, index + length));
  }

  @override
  void allocate(int bytes) => throw UnimplementedError("Not supported");

  @override
  bool isGrowable() => false;
}
