part of '../extensions.dart';

/// Default extensions on [ByteBuf] for reading and writing
/// data based on the [readerIndex] and [writerIndex].
extension ReadWriteExtension on ByteBuf {

  /// Writes the [value] as a 8 byte long signed integer
  /// at the current [writerIndex] (inclusive).
  /// 
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeInt64(int value) => writeByteData(8).setInt64(0, value);

  /// Reads the next 8 bytes as a signed integer
  /// at the current [readerIndex] (inclusive).
  /// 
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  int readInt64() => readByteData(8).getInt64(0);

  /// Writes the [value] as a 4 byte long signed integer
  /// at the current [writerIndex] (inclusive).
  /// 
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeInt32(int value) => writeByteData(4).setInt32(0, value);

  /// Reads the next 4 bytes as a signed integer
  /// at the current [readerIndex] (inclusive).
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  int readInt32() => readByteData(4).getInt32(0);

  /// Writes the [value] as a 2 byte long signed integer
  /// at the current [writerIndex] (inclusive).
  /// 
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeInt16(int value) => writeByteData(2).setInt16(0, value);

  /// Reads the next 2 bytes as a signed integer
  /// at the current [readerIndex] (inclusive).
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  int readInt16() => readByteData(2).getInt16(0);

  /// Writes the [value] as a 8 byte long unsigned integer
  /// at the current [writerIndex] (inclusive).
  /// 
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeUint64(int value) => writeByteData(8).setUint64(0, value);

  /// Reads the next 8 bytes as an unsigned integer
  /// at the current [readerIndex] (inclusive).
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  int readUint64() => readByteData(8).getUint64(0);
  
  /// Writes the [value] as a 4 byte long unsigned integer
  /// at the current [writerIndex] (inclusive).
  /// 
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeUint32(int value) => writeByteData(4).setUint32(0, value);

  /// Reads the next 4 bytes as an unsigned integer
  /// at the current [readerIndex] (inclusive).
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  int readUint32() => readByteData(4).getUint32(0);

  /// Writes the [value] as a 2 byte long unsigned integer
  /// at the current [writerIndex] (inclusive).
  /// 
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeUint16(int value) => writeByteData(2).setUint16(0, value);

  /// Reads the next 2 bytes as an unsigned integer
  /// at the current [readerIndex] (inclusive).
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  int readUint16() => readByteData(2).getUint16(0);

  /// Writes the [value] as a 8 byte long floating point number
  /// at the current [writerIndex] (inclusive).
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeFloat64(double value) => writeByteData(8).setFloat64(0, value);

  /// Reads the next 8 bytes as a floating point number
  /// at the current [readerIndex] (inclusive).
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  double readFloat64() => readByteData(8).getFloat64(0);

  /// Writes the [value] as a 4 byte long floating point number
  /// at the current [writerIndex] (inclusive).
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeFloat32(double value) => writeByteData(4).setFloat32(0, value);

  /// Reads the next 4 bytes as a floating point number
  /// at the current [readerIndex] (inclusive).
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  double readFloat32() => readByteData(4).getFloat32(0);

  /// Encodes the [value] using [encoding] and writes
  /// the resulting data prefixed by the length of the
  /// resulting buffer as an int32 at the current
  /// [writerIndex] (inclusive).
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeLPString(String value, [Encoding? encoding]) {
    var bytes = Uint8List.fromList((encoding??utf8Encoding).encode(value)); // Maybe fix double allocation?
    writeInt32(bytes.length);
    writeBytes(bytes);
  }

  /// Reads a length prepended string encoded by [encoding]
  /// at the current [readerIndex] (inclusive).
  ///
  /// ----
  /// See [writeLPString] for more details about data structure.
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  String readLPString([Encoding? encoding]) {
    int length = readInt32();
    var bytes = readBytes(length);
    return (encoding??utf8Encoding).decode(bytes);
  }

  /// Encodes the [bytes] using [canonical base64](https://datatracker.ietf.org/doc/html/rfc4648)
  /// and writes the resulting data prefixed by the length of the
  /// resulting buffer as an int32 at the current
  /// [writerIndex] (inclusive) using [writeLPString].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeLPBase64(Uint8List bytes) {
    var encodedString = base64Encode(bytes);
    writeLPString(encodedString, utf8Encoding);
  }

  /// Reads a length prepended [canonical base64](https://datatracker.ietf.org/doc/html/rfc4648)
  /// value at the current [readerIndex] (inclusive).
  ///
  /// ----
  /// See [writeLPBase64] for more details about data structure.
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  Uint8List readLPBase64() {
    var encodedString = readLPString(utf8Encoding);
    return base64Decode(encodedString);
  }
}