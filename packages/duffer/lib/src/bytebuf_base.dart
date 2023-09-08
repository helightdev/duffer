import 'dart:math';
import 'dart:typed_data';

import 'package:duffer/src/immutable_list_view.dart';
import 'package:duffer/src/impl/array_buffer.dart';

import 'impl/byte_data_buffer.dart';

part 'exceptions.dart';

int kDefaultByteBufSize = 1024;
int kDefaultMaxByteBufSize =
    4294967296; // Did not validate this, but should be max
int kMaxGrowth = 1024;

bool kAlwaysCheckReadIndices = true;
Endian kEndianness = Endian.big;

abstract class ByteBuf {
  /// Current capacity of the buffer
  int capacity();

  /// Lower constraint of the buffer capacity.
  int minCapacity = 0;

  /// Upper constraint of the buffer capacity.
  int maxCapacity = kDefaultMaxByteBufSize;

  /// Defines if the buffer can expand its capacity
  /// insides its own constraints.
  bool isGrowable();

  /// Allocates/Grows the buffer by [bytes] inside
  /// its own constraints.
  ///
  /// ----
  /// Exceptions:
  /// * [BufferOverflowException] if the new capacity
  /// overflows the buffer's [maxCapacity].
  void allocate(int bytes);

  /// Current writer index.
  ///
  /// Automatically incremented by all write* operations.
  int writerIndex = 0;

  /// Current reader index.
  ///
  /// Automatically incremented by all read* operations.
  int readerIndex = 0;

  /// Amount of bytes which are readable from the current
  /// [readerIndex] (inclusive).
  ///
  ///
  /// ----
  /// Bytes are considered readable if the index of the position,
  /// in this case the [readerIndex], is smaller than the current writer index
  /// and is not discardable, i.E. smaller than the current [readerIndex].
  int get readableBytes => writerIndex - readerIndex;

  /// Amount of free bytes inside the buffer from the
  /// current [writerIndex] (inclusive).
  ///
  /// Does not take [maxCapacity] into account.
  int get writableBytes => capacity() - writerIndex;

  /// Returns true if there are any readable bytes left.
  bool get isReadable => readableBytes > 0;

  /// Returns true if there are writeable bytes left.
  bool get isWritable => writableBytes > 0;

  /// The marker of the [readerIndex]. Overrides the [readerIndex]
  /// with its value when [resetReaderIndex] is called.
  ///
  /// Defaults to 0.
  ///
  /// Can be set manually or via [markReaderIndex].
  int readMarker = 0;

  /// The marker of the [writerIndex]. Overrides the [writerIndex]
  /// with its value when [resetWriterIndex] is called.
  ///
  /// Defaults to 0.
  ///
  /// Can be set manually or via [markWriterIndex].
  int writeMarker = 0;

  //region Data Access
  /// Sets the byte at [index] to [byte].
  ///
  /// This method does not expand the buffer
  /// if it reached its constraints.
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if [index]
  /// is outside the bounds of the buffer.
  void updateByte(int index, int byte);

  //region Data Access
  /// Sets the byte at [index] to [byte].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if [index]
  /// is outside the bounds of the buffer.
  void setByte(int index, int byte) {
    updateByte(index, byte);
  }

  /// Gets the byte at [index].
  ///
  /// This method does not expand the buffer
  /// if it reached its constraints.
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if [index]
  /// is outside the bounds of the buffer.
  int getByte(int index);

  /// Sets the byte at [index] to [value].
  ///
  /// This method does not expand the buffer
  /// if it reached its constraints.
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if [index]
  /// is outside the bounds of the buffer.
  operator []=(int index, int value) {
    updateByte(index, value);
  }

  /// Gets the byte at [index].
  ///
  /// This method does not expand the buffer
  /// if it reached its constraints.
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if [index]
  /// is outside the bounds of the buffer.
  int operator [](int index) {
    return getByte(index);
  }

  /// Reads the byte at the [readerIndex] and increments
  /// the [readerIndex] by 1 afterwards.
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if [readerIndex]
  /// is outside the bounds of the buffer.
  int readByte() {
    try {
      return getByte(readerIndex);
    } finally {
      readerIndex++;
    }
  }

  /// Write one byte with the value of [byte] at the
  /// [writerIndex] and increments the [writerIndex]
  /// by 1 afterwards.
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if [writerIndex]
  /// is outside the bounds of the buffer.
  void writeByte(int byte) {
    ensureWritable(1);
    assertWriteable(writerIndex, 1);
    try {
      updateByte(writerIndex, byte);
    } finally {
      writerIndex++;
    }
  }

  /// Copies the whole buffer to a separate [Uint8List].
  ///
  /// ----
  /// The resulting list may or may not include unwritten as well
  /// as discardable regions.
  Uint8List array();

  /// Creates a native [ByteData] view at [index] with
  /// the length of [length].
  ///
  /// ----
  /// Exceptions: Depending on the implementation.
  ByteData viewByteData(int index, int length);

  /// Reads [length] bytes beginning at [readerIndex] (inclusive) as
  /// a native ByteData view and increments [readerIndex] by [length]
  /// afterwards.
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer.
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer.
  ByteData readByteData(int length) {
    assertReadable(readerIndex, length);
    try {
      return viewByteData(readerIndex, length);
    } finally {
      readerIndex += length;
    }
  }

  /// Returns a [length]-long native [ByteData] view beginning at
  /// [readerIndex] (inclusive) and increments the [writerIndex] by
  /// [length].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer.
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer.
  ByteData writeByteData(int length) {
    ensureWritable(length);
    assertWriteable(writerIndex, length);
    try {
      return viewByteData(writerIndex, length);
    } finally {
      writerIndex += length;
    }
  }

  /// Reads [length] bytes beginning at [index] (inclusive) as
  /// a native ByteData view.
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer.
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer.
  ByteData getByteData(int index, int length) {
    assertWriteable(index, length);
    return viewByteData(index, length);
  }

  /// Returns a writeable native ByteData view of the [buffer]
  /// at [index] (inclusive) with an length of [length].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer.
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer.
  ByteData setByteData(int index, int length) {
    assertWriteable(index, length);
    return viewByteData(index, length);
  }

  /// Writes the [bytes] at the current [writerIndex] (inclusive)
  /// and increments the [writerIndex] by the length of the added
  /// bytes.
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer.
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer.
  void writeBytes(List<int> bytes) {
    var j = bytes.length;
    ensureWritable(j);
    assertWriteable(writerIndex, j);
    for (var i = 0; i < j; i++) {
      updateByte(writerIndex + i, bytes[i]);
    }
    writerIndex = writerIndex + j;
  }

  /// Writes the content of [bytes] at [index] (inclusive).
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer.
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer.
  void setBytes(int index, List<int> bytes) {
    assertWriteable(index, bytes.length);
    for (var i = 0; i < bytes.length; i++) {
      updateByte(index + i, bytes[i]);
    }
  }

  /// Writes the content of [buffer] at the current
  /// [writerIndex] (inclusive) and increments the [writerIndex] by
  /// the length of the [buffer].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer.
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer.
  void writeBuffer(ByteBuf buffer) {
    ensureWritable(buffer.readableBytes);
    assertWriteable(writerIndex, buffer.readableBytes);
    writeBytes(buffer.listView);
  }

  /// Gets a [length]-long writable transaction buffer at the current
  /// [writerIndex] (inclusive) and increments the [writerIndex] by [length].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer.
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer.
  ByteBuf writeTransactionBuffer(int length) {
    ensureWritable(length);
    assertWriteable(writerIndex, length);
    try {
      return viewBuffer(writerIndex, length);
    } finally {
      writerIndex += length;
    }
  }

  /// Writes the content of [buffer] at [index] (inclusive).
  ///
  /// Updates the [writerIndex] to at least be at [index] + [buffer.readableBytes]
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer.
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer.
  void setBuffer(int index, ByteBuf buffer) {
    assertWriteable(index, buffer.readableBytes);
    setBytes(index, buffer.listView);
  }

  /// Returns a [ByteBuf] viewing a region beginning at [index] with
  /// the length of [length].
  ///
  /// The resulting buffer has both [ByteBuf.readerIndex] as well as
  /// [ByteBuf.writerIndex] set to 0 and all operations performed on
  /// the buffer do not affect the markers and indices of the root
  /// buffer.
  ///
  /// ----
  /// Exceptions: Depending on the implementation.
  ByteBuf viewBuffer(int index, int length);

  /// Returns a [ByteBuf] viewing a region beginning at [index] with
  /// the length of [length].
  ///
  /// The resulting buffer has both is completely readable
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer.
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting buffer would overflow the buffer.
  ByteBuf getBuffer(int index, int length) {
    assertReadable(index, length);
    return viewBuffer(index, length)..writerIndex += length;
  }

  /// Returns a [ByteBuf] viewing a region beginning at [readerIndex]
  /// with the length of [length].
  ///
  /// The [ByteBuf.writerIndex] is set to [length] and
  /// the [ByteBuf.readerIndex] is set to 0, making
  /// the whole region readable via [ByteBuf.readAvailableBytes].
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer.
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer.
  ByteBuf readBuffer(int length) {
    assertReadable(readerIndex, length);
    try {
      return viewBuffer(readerIndex, length)..writerIndex += length;
    } finally {
      readerIndex += length;
    }
  }

  /// Reads the next [length] bytes at the current [readerIndex] (inclusive) and
  /// increments the [readerIndex] by [length].
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer.
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer.
  Uint8List readBytes(int length) {
    assertReadable(readerIndex, length);
    var list = Uint8List(length);
    for (var i = 0; i < length; i++) {
      list[i] = readByte();
    }
    return list;
  }

  /// Reads all available bytes into a [Uint8List].
  ///
  /// ----
  /// Bytes are considered available if the index of the position,
  /// in this case the [readerIndex], is smaller than the current writer index
  /// and is not discardable, i.E. smaller than the current [readerIndex].
  Uint8List readAvailableBytes() => readBytes(readableBytes);

  /// Reads all available bytes into a [Uint8List] without incrementing
  /// the reader index.
  Uint8List peekAvailableBytes() => getBytes(readerIndex, readableBytes);

  /// Reads [length] bytes beginning at [index] (inclusive) into
  /// a [Uint8List].
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer.
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer.
  Uint8List getBytes(int index, int length) {
    assertWriteable(index, length);
    var list = Uint8List(length);
    for (var i = 0; i < length; i++) {
      list[i] = getByte(index + i);
    }
    return list;
  }

  List<int> get listView => ImmutableListView(this);

  //endregion
  //region Assertions

  /// Asserts the writability of the region.
  ///
  /// [length] >= 0
  /// [index] < [capacity]
  /// [index] + [length] - 1 < [capacity]
  /// if [validateIndices] [index] + [length] - 1 < [writerIndex]
  void assertReadable(int index, int length) {
    if (length == 0) return;
    if (length < 0) throw Exception();
    if (index >= capacity()) throw ReadIndexOutOfRangeException();
    if (index + length - 1 >= capacity()) throw BufferOverreadException();
    if (kAlwaysCheckReadIndices && (index + length - 1) >= writerIndex) {
      throw IndexNotAvailableException();
    }
  }

  /// Asserts the readability of the region.
  ///
  /// [length] >= 0
  /// [index] < [capacity]
  /// [index] + [length] - 1 < [capacity]
  void assertWriteable(int index, int length) {
    if (length == 0) return;
    if (length < 0) throw Exception();
    if (index >= capacity()) throw WriteIndexOutOfRangeException();
    if (index + length - 1 >= capacity()) throw BufferOverflowException();
  }

  /// Tries to expand the buffer to fit at least [minWritableBytes] and
  /// returns the amount of bytes which were allocated.
  ///
  /// ----
  /// Exceptions:
  /// * [BufferOverflowException] if [minWritableBytes] can't be allocated.
  int ensureWritable(int minWritableBytes) {
    if (isGrowable()) {
      var delta = minWritableBytes - writableBytes;
      if (delta > 0) {
        var cap = capacity();
        if (cap + delta > maxCapacity) throw BufferOverflowException();
        var growth =
            max(min(cap * 2, kMaxGrowth), delta); // Dynamic Array Growth
        var newSize = min(cap + growth, maxCapacity);
        var allocated = newSize - cap;
        allocate(allocated);
        return allocated;
      }
    } else {
      if (writableBytes < minWritableBytes) throw BufferOverflowException();
    }
    return 0;
  }

  /// Checks the readability of the region while not taking buffer growth
  /// into account. Doesn't throw exceptions.
  ///
  /// [index] < ([index] + [length])
  bool checkReadable(int index, int length) {
    if (index >= capacity()) return false;
    if (index + length - 1 >= capacity()) return false;
    return true;
  }

  /// Checks the writability of the region while not taking buffer growth
  /// into account. Doesn't throw exceptions.
  ///
  /// [index] < ([index] + [length])
  bool checkWriteable(int index, int length) {
    if (index >= capacity()) return false;
    if (index + length - 1 >= capacity()) return false;
    return true;
  }

  //endregion
  //region Control Operations
  /// Resets the [readerIndex] to [readMarker].
  void resetReaderIndex() => readerIndex = readMarker;

  /// Resets the [writerIndex] to [writeMarker].
  void resetWriterIndex() => writerIndex = writeMarker;

  /// Sets the [readMarker] to [readerIndex].
  void markReaderIndex() => readMarker = readerIndex;

  /// Sets the [writeMarker] to [writerIndex].
  void markWriterIndex() => writeMarker = writerIndex;

  /// Creates a read marker which doesn't depend on the buffers own markers.
  LinkedReadMarker createReadMarker() => LinkedReadMarker(this, readerIndex);

  /// Creates a write marker which doesn't depend on the buffers own markers.
  LinkedWriteMarker createWriteMarker() => LinkedWriteMarker(this, writerIndex);

  /// Sets both [readerIndex] and [writerIndex] to 0.
  ///
  /// ----
  /// **DOES NOT change the contents of the buffer**
  void clear() {
    readerIndex = 0;
    writerIndex = 0;
  }
  //endregion

  /// Discards all already read bytes and shifts all contents to the left,
  /// so that [readerIndex] is 0 again. The [writerIndex] gets decreased by
  /// the amount of bytes freed.
  ///
  /// ----
  /// Returns the amount of bytes freed.
  int discardReadBytes() {
    var readOffset = readerIndex;
    var readable = readableBytes;
    for (var i = 0; i < readable; i++) {
      updateByte(i, getByte(readOffset + i));
    }
    readerIndex = 0;
    writerIndex = readable;
    return readOffset;
  }

  static ByteBuf fixed(int size) => ByteDataBuffer.fixed(ByteData(size));

  static ByteBuf size(int size) {
    var buffer = ArrayBuffer(Uint8List(size));
    buffer.maxCapacity = kDefaultMaxByteBufSize;
    return buffer;
  }

  static ByteBuf create({int? initialCapacity, int? maxCapacity}) {
    var buffer = ArrayBuffer(Uint8List(initialCapacity ?? kDefaultByteBufSize));
    buffer.maxCapacity = maxCapacity ?? kDefaultMaxByteBufSize;
    return buffer;
  }

  static ArrayBuffer createHeap({int? initialCapacity, int? maxCapacity}) {
    var buffer = ArrayBuffer(Uint8List(initialCapacity ?? kDefaultByteBufSize));
    buffer.maxCapacity = maxCapacity ?? kDefaultMaxByteBufSize;
    return buffer;
  }

  static ByteBuf fromData(List<int> data) {
    var buf = fixed(data.length);
    for (int i = 0; i < data.length; i++) {
      buf[i] = data[i];
    }
    buf.writerIndex = data.length;
    return buf;
  }

  /// Searches for the first occurrence of a [needle] within a [haystack] and returns
  /// the index of the first occurrence, or -1 if not found.
  ///
  /// This method iterates through the [haystack] byte-by-byte, attempting to match
  /// it with the [needle]. If a match is found, it returns the starting index of
  /// the match within the [haystack].
  ///
  /// If the [needle] is not found in the [haystack], the method returns -1.
  ///
  /// The search begins at the current reader index of the [haystack], and it does
  /// not modify the reader index during the search.
  ///
  /// Example:
  /// ```dart
  /// ByteBuf haystack = ByteBuf.fromData([1, 2, 3, 4, 5, 6, 7]);
  /// ByteBuf needle = ByteBuf.fromData([3, 4]);
  /// int index = ByteBuf.indexOf(haystack, needle); // Returns 2
  /// ```
  ///
  /// If the [needle] is longer than the remaining bytes in the [haystack] from
  /// the current reader index, the method will not find a match.
  static int indexOf(ByteBuf haystack, ByteBuf needle) {
    if (needle.readableBytes > haystack.readableBytes) return -1;
    int needleIndex;
    for (int i = haystack.readerIndex; i < haystack.writerIndex; i ++) {
      int haystackIndex = i;
      for (needleIndex = 0; needleIndex < needle.capacity(); needleIndex ++) {
        if (haystack.getByte(haystackIndex) != needle.getByte(needleIndex)) {
          // If a mismatch is found, break out of the inner loop.
          break;
        } else {
          haystackIndex ++;
          if (haystackIndex == haystack.writerIndex &&
              needleIndex != needle.capacity() - 1) {
            // If the end of the haystack is reached before the needle, return -1.
            return -1;
          }
        }
      }

      if (needleIndex == needle.capacity()) {
        // Found a complete match for the needle in the haystack.
        return i - haystack.readerIndex;
      }
    }
    // If no match is found, return -1.
    return -1;
  }

}

class LinkedWriteMarker {
  final ByteBuf _delegate;
  int _index;
  LinkedWriteMarker(this._delegate, this._index);

  /// Manually sets the marker index
  void set(int i) {
    _index = i;
  }

  /// Sets the marker to the current [ByteBuf.writerIndex]
  void update() {
    _index = _delegate.writerIndex;
  }

  /// Sets the [ByteBuf.writerIndex] to the markers position
  void jump() {
    _delegate.writerIndex = _index;
  }
}

class LinkedReadMarker {
  final ByteBuf _delegate;
  int _index;
  LinkedReadMarker(this._delegate, this._index);

  /// Manually sets the marker index
  void set(int i) {
    _index = i;
  }

  /// Sets the marker to the current [ByteBuf.readerIndex]
  void update() {
    _index = _delegate.readerIndex;
  }

  /// Sets the [ByteBuf.readerIndex] to the markers position
  void jump() {
    _delegate.readerIndex = _index;
  }
}

/// [ByteBuf] implementation that forwards all methods to [backing].
abstract class DelegatingByteBuf extends ByteBuf {

  ByteBuf get backing;

  @override
  void allocate(int bytes) => backing.allocate(bytes);

  @override
  Uint8List array() => backing.array();

  @override
  int capacity() => backing.capacity();

  @override
  int getByte(int index) => backing.getByte(index);

  @override
  bool isGrowable() => backing.isGrowable();

  @override
  void updateByte(int index, int byte) => backing.updateByte(index, byte);

  @override
  ByteBuf viewBuffer(int index, int length) => backing.viewBuffer(index, length);

  @override
  ByteData viewByteData(int index, int length) => backing.viewByteData(index, length);
}