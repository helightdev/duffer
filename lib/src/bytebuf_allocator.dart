import 'bytebuf_base.dart';

abstract class ByteBufAllocator {

  /// Allocates a [size]-long releasable child buffer
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the backing
  /// writer index is outside of the bounds of the backing
  /// buffer, i.e. the buffer is most commonly completely
  /// full
  ///
  /// * [BufferOverflowException] if the [size]
  /// of the allocated buffer would overflow the
  /// backing buffer
  ReleasableByteBuf allocate(int size);

  /// Releases the [child] buffer
  void release(ReleasableByteBuf child);

  /// Upper capacity constraint for the backing buffer
  int maxCapacity();

  /// Current capacity of the backing buffer
  int capacity();

  /// Heap occupied by allocated child buffers
  int used();

  /// Total amount of free heap inside the buffer,
  /// which also includes memory which is currently
  /// not accessible without restructuring of the
  /// byte data. This may or may not be different
  /// from [available] depending on the implementation
  /// and current state.
  int free();

  /// The amount of accessible free heap inside the
  /// buffer, which the the buffer can directly allocate.
  int available();

}

mixin ReleasableByteBuf on ByteBuf {

  void release();
  bool isReleased();

  void setReleasedInternal(bool released);

}