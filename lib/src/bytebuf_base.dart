import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'bytebuf_iterator.dart';
import 'impl/heap_buffer.dart';

part 'exceptions.dart';

int kDefaultByteBufSize = 1024;
int kDefaultMaxByteBufSize = 4294967296;

abstract class ByteBuf with IterableMixin {

  /// Current capacity of the buffer
  int capacity();

  /// Lower constraint of the buffer capacity
  int minCapacity = 0;

  /// Upper constraint of the buffer capacity
  int maxCapacity = kDefaultMaxByteBufSize; // Did not validate this, but should be max

  /// Defines if the buffer can expand its capacity
  /// insides its own constraints
  bool isGrowable();

  /// Allocates/Grows the buffer by [bytes] inside
  /// its own constraints
  ///
  /// ----
  /// Exceptions:
  /// * [BufferOverflowException] if the new capacity
  /// overflows the buffer's [maxCapacity]
  void allocate(int bytes);

  /// Current writer index.
  ///
  /// Automatically incremented by all write* operations
  int writerIndex = 0;

  /// Current reader index.
  ///
  /// Automatically incremented by all read* operations
  int readerIndex = 0;

  /// Amount of bytes which are readable from the current
  /// [readerIndex] (inclusive)
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
  /// Can be set manually or via [markReaderIndex]
  int readMarker = 0;

  /// The marker of the [writerIndex]. Overrides the [writerIndex]
  /// with its value when [resetWriterIndex] is called.
  ///
  /// Defaults to 0.
  ///
  /// Can be set manually or via [markWriterIndex]
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
  /// is outside the bounds of the buffer
  void setByte(int index, int byte);

  /// Gets the byte at [index]
  ///
  /// This method does not expand the buffer
  /// if it reached its constraints.
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if [index]
  /// is outside the bounds of the buffer
  int getByte(int index);

  /// Sets the byte at [index] to [value].
  ///
  /// This method does not expand the buffer
  /// if it reached its constraints.
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if [index]
  /// is outside the bounds of the buffer
  operator []=(int index, int value) {
    setByte(index, value);
  }

  /// Gets the byte at [index]
  ///
  /// This method does not expand the buffer
  /// if it reached its constraints.
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if [index]
  /// is outside the bounds of the buffer
  int operator [](int index) {
    return getByte(index);
  }

  /// Reads the byte at the [readerIndex] and increments
  /// the [readerIndex] by 1 afterwards.
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if [readerIndex]
  /// is outside the bounds of the buffer
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
  /// is outside the bounds of the buffer
  void writeByte(int byte) {
    ensureWritable(1);
    assertWriteable(writerIndex, 1);
    try {
      setByte(writerIndex, byte);
    } finally {
      writerIndex++;
    }
  }

  /// Copies the whole buffer to a separate [Uint8List].
  Uint8List array();

  /// Creates a native [ByteData] view at [index] with
  /// the length of [length].
  ///
  /// ----
  /// Exceptions: Depending on the implementation
  ByteData viewByteData(int index, int length);

  /// Reads [length] bytes beginning at [readerIndex] (inclusive) as
  /// a native ByteData view and increments [readerIndex] by [length]
  /// afterwards.
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
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
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  ByteData writeByteData(int length) {
    ensureWritable(length);
    assertWriteable(writerIndex, length);
    try {
      return viewByteData(writerIndex, length);
    } finally {
      writerIndex += length;
    }
  }

  // TODO: Documentation
  ByteData getByteData(int index, int length) {
    assertReadable(index, length);
    try {
      return viewByteData(index, length);
    } finally {
      readerIndex += length;
    }
  }

  // TODO: Documentation
  ByteData setByteData(int index, int length) {
    assertWriteable(index, length);
    try {
      return viewByteData(index, length);
    } finally {
      writerIndex += length;
    }
  }

  /// Writes the [bytes] at the current [writerIndex] (inclusive)
  /// and increments the [writerIndex] by the length of the added
  /// bytes.
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeBytes(List<int> bytes) {
    ensureWritable(bytes.length);
    assertWriteable(writerIndex, bytes.length);
    for (var i = 0; i < bytes.length; i++) {
      writeByte(bytes[i]);
    }
  }

  // TODO: Documentation
  void setBytes(int index, List<int> bytes) {
    assertWriteable(index, bytes.length);
    for (var i = 0; i < bytes.length; i++) {
      setByte(index + i, bytes[i]);
    }
  }
  /// Writes the content of [buffer] at the current
  /// [writerIndex] (inclusive) and increments the [writerIndex] by
  /// the length of the [buffer].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeBuffer(ByteBuf buffer) {
    ensureWritable(buffer.length);
    assertWriteable(writerIndex, buffer.length);
    for (var i = 0; i < buffer.capacity(); i++) {
      writeByte(buffer[i]);
    }
  }


  /// Gets a [length]-long writable transaction buffer at the current
  /// [writerIndex] (inclusive) and increments the [writerIndex] by [length].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  ByteBuf writeTransactionBuffer(int length) {
    ensureWritable(length);
    assertWriteable(writerIndex, length);
    try {
      return getBuffer(writerIndex, length);
    } finally {
      writerIndex += length;
    }
  }

  // TODO: Documentation
  void setBuffer(int index, ByteBuf buffer) {
    assertWriteable(index, buffer.length);
    for (var i = 0; i < buffer.capacity(); i++) {
      setByte(index + i, buffer[i]);
    }
  }

  /// Returns a [ByteBuf] viewing a region beginning at [index] with
  /// the length of [length].
  ///
  /// ----
  /// Exceptions: Depending on the implementation
  ByteBuf getBuffer(int index, int length);

  /// Returns a [ByteBuf] viewing a region beginning at [readerIndex]
  /// with the length of [length].
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  ByteBuf readBuffer(int length) {
    assertReadable(readerIndex, length);
    try {
      return getBuffer(readerIndex, length);
    } finally {
      readerIndex += length;
    }
  }

  /// Reads the next [length] bytes at the current [readerIndex] (inclusive) and
  /// increments the [readerIndex] by [length]
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  Uint8List readBytes(int length) {
    assertReadable(readerIndex, length);
    var list = Uint8List(length);
    for (var i = 0; i < length; i++) {
      list[i] = readByte();
    }
    return list;
  }

  /// Reads all available bytes into a [Uint8List]
  Uint8List readAvailableBytes() => readBytes(readableBytes);

  // TODO: Documentation
  Uint8List getBytes(int index, int length) {
    assertReadable(index, length);
    var list = Uint8List(length);
    for (var i = 0; i < length; i++) {
      list[i] = getByte(index + i);
    }
    return list;
  }

  @override
  Iterator<int> get iterator => ByteBufIterator(this);

  //endregion
  //region Assertions

  /// Asserts the writability of the region
  ///
  /// [index] < ([index] + [length])
  void assertReadable(int index, int length) {
    if (length == 0) return;
    if (index >= capacity()) throw ReadIndexOutOfRangeException();
    if (index + length - 1>= capacity()) throw BufferOverreadException();
  }

  /// Asserts the readability of the region
  ///
  /// [index] < ([index] + [length])
  void assertWriteable(int index, int length) {
    if (length == 0) return;
    if (index >= capacity()) throw WriteIndexOutOfRangeException();
    if (index + length - 1 >= capacity()) throw BufferOverflowException();
  }

  /// Tries to expand the buffer to fit at least [minWritableBytes] and
  /// returns the amount of bytes which were allocated.
  ///
  /// ----
  /// Exceptions:
  /// * [BufferOverflowException] if [minWritableBytes] can't be allocated
  int ensureWritable(int minWritableBytes) {
    if (isGrowable()) {
      var delta = minWritableBytes - writableBytes;
      if (delta > 0) {
        if (capacity() + delta > maxCapacity) throw BufferOverflowException();
        allocate(delta);
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
    if (index + length - 1>= capacity()) return false;
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

  /// Sets both [readerIndex] and [writerIndex] to 0.
  ///
  /// ----
  /// DOES NOT change the contents of the buffer.
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
      setByte(i, getByte(readOffset + i));
    }
    readerIndex = 0;
    writerIndex = readable;
    return readOffset;
  }

  static ByteBuf fixed(int size) => HeapBuffer.fixed(ByteData(size));

  static ByteBuf size(int size) {
    var buffer = HeapBuffer(ByteData(size));
    buffer.maxCapacity = kDefaultMaxByteBufSize;
    return buffer;
  }

  static ByteBuf create({int? initialCapacity, int? maxCapacity}) {
    var buffer = HeapBuffer(ByteData(initialCapacity ?? kDefaultByteBufSize));
    buffer.maxCapacity = maxCapacity ?? initialCapacity ?? kDefaultMaxByteBufSize;
    return buffer;
  }

  static HeapBuffer createHeap({int? initialCapacity, int? maxCapacity}) {
    var buffer = HeapBuffer(ByteData(initialCapacity ?? kDefaultByteBufSize));
    buffer.maxCapacity = maxCapacity ?? initialCapacity ?? kDefaultMaxByteBufSize;
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
}