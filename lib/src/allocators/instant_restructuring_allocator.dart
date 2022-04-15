import '../bytebuf_allocator.dart';
import '../impl/heap_buffer.dart';
import '../impl/allocated_buffer.dart';
import '../utils/sum.dart';

class InstantRestructuringAllocator extends ByteBufAllocator {
  final HeapBuffer _backing;
  List<FixedAllocatedBuffer> children = List.empty(growable: true);

  InstantRestructuringAllocator(this._backing);

  @override
  ReleasableByteBuf allocate(int size) {
    var nativeRegion = _backing.writeByteData(size);
    var buffer = FixedAllocatedBuffer(this, nativeRegion);
    children.add(buffer);
    return buffer;
  }

  @override
  void release(ReleasableByteBuf child) {
    var removedIndex = children.indexOf(child as FixedAllocatedBuffer);
    var removedBytes = child.capacity();
    var precedingBytes =
        children.take(removedIndex).map((e) => e.capacity()).sum();
    var succeedingBuffers = children.skip(removedIndex + 1);
    var succeedingBytes = succeedingBuffers.map((e) => e.capacity()).sum();

    if (succeedingBytes == 0) {
      children.removeAt(removedIndex);
    } else {
      var prb = precedingBytes + removedBytes;
      for (var i = 0; i < succeedingBytes; i++) {
        _backing.updateByte(precedingBytes + i, _backing.getByte(prb + i));
      }
      for (var value in succeedingBuffers) {
        value.data = _backing.viewByteData(
            value.data.offsetInBytes - removedBytes, value.capacity());
      }
      children.removeAt(removedIndex);
    }
    _backing.writerIndex -= removedBytes;

    child.setReleasedInternal(true);
  }

  @override
  int available() => _backing.writableBytes;

  @override
  int capacity() => _backing.capacity();

  @override
  int free() => _backing.writableBytes;

  @override
  int maxCapacity() => _backing.maxCapacity;

  @override
  int used() => _backing.writerIndex;
}
