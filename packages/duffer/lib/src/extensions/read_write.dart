part of '../extensions.dart';

/// Default extensions on [ByteBuf] for reading and writing
/// data based on the [readerIndex] and [writerIndex].
extension ReadWriteExtension on ByteBuf {

  /// Reads the next 8 bytes as a signed integer
  /// at the current [readerIndex] (inclusive).
  ///
  /// [endian] the endianness of the number, defaults to [kEndianness] which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  Int64 readFixNumInt64([Endian? endian]) => readByteData(8)
      .getInt64FN(0, endian ?? kEndianness);

  /// Writes the [value] as a 8 byte long signed integer
  /// at the current [writerIndex] (inclusive).
  ///
  /// [endian] the endianness of the number, defaults to [kEndianness] which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeFixNumInt64(Int64 value, [Endian? endian]) => writeByteData(8)
      .setInt64FN(0, value, endian ?? kEndianness);

  /// Store nullability information about [value] in a single byte, representing
  /// null as 0x00 and any value as 0xFF and executes [converter] if the value
  /// is not null.
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeNullable<T>(T? value, Function(T) converter) {
    writeByte(value == null ? 0x00 : 0xFF);
    if (value != null) {
      converter(value);
    }
  }

  /// Reads the first byte to determine if the value is null and executes
  /// [converter] if a value is present.
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  T? readNullable<T>(T Function() converter) {
    if (readByte() != 0xFF) return null;
    return converter();
  }

  /// Writes the [value] as a single byte using 0xFF as true and 0x00 as false
  /// at the current [writerIndex] (inclusive).
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeBool(bool value) => writeByte(value ? 0xFF : 0x00);

  /// Reads the next byte as a [bool] using 0xFF as true and other values as
  /// false at the current [readerIndex] (inclusive).
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  bool readBool() => readByte() == 0xFF;

  /// Writes the [value] as a 8 byte long signed integer
  /// at the current [writerIndex] (inclusive).
  ///
  /// [endian] the endianness of the number, defaults to [kEndianness] which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeInt64(int value, [Endian? endian]) =>
      writeByteData(8).setInt64Duffer(0, value, endian ?? kEndianness);

  /// Reads the next 8 bytes as a signed integer
  /// at the current [readerIndex] (inclusive).
  ///
  /// [endian] the endianness of the number, defaults to [kEndianness] which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  int readInt64([Endian? endian]) =>
      readByteData(8).getInt64Duffer(0, endian ?? kEndianness);

  /// Writes the [value] as a 4 byte long signed integer
  /// at the current [writerIndex] (inclusive).
  ///
  /// [endian] the endianness of the number, defaults to [kEndianness] which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeInt32(int value, [Endian? endian]) =>
      writeByteData(4).setInt32(0, value, endian ?? kEndianness);

  /// Reads the next 4 bytes as a signed integer
  /// at the current [readerIndex] (inclusive).
  ///
  /// [endian] the endianness of the number, defaults to [kEndianness] which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  int readInt32([Endian? endian]) =>
      readByteData(4).getInt32(0, endian ?? kEndianness);

  /// Writes the [value] as a 2 byte long signed integer
  /// at the current [writerIndex] (inclusive).
  ///
  /// [endian] the endianness of the number, defaults to [kEndianness] which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeInt16(int value, [Endian? endian]) =>
      writeByteData(2).setInt16(0, value, endian ?? kEndianness);

  /// Reads the next 2 bytes as a signed integer
  /// at the current [readerIndex] (inclusive).
  ///
  /// [endian] the endianness of the number, defaults to [kEndianness] which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  int readInt16([Endian? endian]) =>
      readByteData(2).getInt16(0, endian ?? kEndianness);

  /// Writes the [value] as a 1 byte long signed integer
  /// at the current [writerIndex] (inclusive).
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeInt8(int value) => writeByteData(1).setInt8(0, value);

  /// Reads the next 1 byte as a signed integer
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
  int readInt8() => readByteData(1).getInt8(0);

  /// Writes the [value] as a 8 byte long unsigned integer
  /// at the current [writerIndex] (inclusive).
  ///
  /// [endian] the endianness of the number, defaults to [kEndianness] which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeUint64(int value, [Endian? endian]) =>
      writeByteData(8).setUint64Duffer(0, value, endian ?? kEndianness);

  /// Reads the next 8 bytes as an unsigned integer
  /// at the current [readerIndex] (inclusive).
  ///
  /// [endian] the endianness of the number, defaults to [kEndianness] which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  int readUint64([Endian? endian]) =>
      readByteData(8).getUint64Duffer(0, endian ?? kEndianness);

  /// Writes the [value] as a 4 byte long unsigned integer
  /// at the current [writerIndex] (inclusive).
  ///
  /// [endian] the endianness of the number, defaults to [kEndianness] which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeUint32(int value, [Endian? endian]) =>
      writeByteData(4).setUint32(0, value, endian ?? kEndianness);

  /// Reads the next 4 bytes as an unsigned integer
  /// at the current [readerIndex] (inclusive).
  ///
  /// [endian] the endianness of the number, defaults to [kEndianness] which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  int readUint32([Endian? endian]) =>
      readByteData(4).getUint32(0, endian ?? kEndianness);

  /// Writes the [value] as a 2 byte long unsigned integer
  /// at the current [writerIndex] (inclusive).
  ///
  /// [endian] the endianness of the number, defaults to [kEndianness] which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeUint16(int value, [Endian? endian]) =>
      writeByteData(2).setUint16(0, value, endian ?? kEndianness);

  /// Reads the next 2 bytes as an unsigned integer
  /// at the current [readerIndex] (inclusive).
  ///
  /// [endian] the endianness of the number, defaults to [kEndianness] which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  int readUint16([Endian? endian]) =>
      readByteData(2).getUint16(0, endian ?? kEndianness);

  /// Writes the [value] as a 1 byte long unsigned integer
  /// at the current [writerIndex] (inclusive).
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeUint8(int value) => writeByteData(1).setUint8(0, value);

  /// Reads the next 1 byte as an unsigned integer
  /// at the current [readerIndex] (inclusive).
  ///
  /// [endian] the endianness of the number, defaults to [kEndianness] which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  int readUint8() => readByteData(1).getUint8(0);

  /// Writes the [value] as a 8 byte long floating point number
  /// at the current [writerIndex] (inclusive).
  ///
  /// [endian] the endianness of the number, defaults to [kEndianness] which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeFloat64(double value, [Endian? endian]) =>
      writeByteData(8).setFloat64(0, value, endian ?? kEndianness);

  /// Reads the next 8 bytes as a floating point number
  /// at the current [readerIndex] (inclusive).
  ///
  /// [endian] the endianness of the number, defaults to [kEndianness] which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  double readFloat64([Endian? endian]) =>
      readByteData(8).getFloat64(0, endian ?? kEndianness);

  /// Writes the [value] as a 4 byte long floating point number
  /// at the current [writerIndex] (inclusive).
  ///
  /// [endian] the endianness of the number, defaults to [kEndianness] which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeFloat32(double value, [Endian? endian]) =>
      writeByteData(4).setFloat32(0, value, endian ?? kEndianness);

  /// Reads the next 4 bytes as a floating point number
  /// at the current [readerIndex] (inclusive).
  ///
  /// [endian] the endianness of the number, defaults to [kEndianness] which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  double readFloat32([Endian? endian]) =>
      readByteData(4).getFloat32(0, endian ?? kEndianness);

  /// Encodes the [value] using [encoding] and writes
  /// the resulting data prefixed by the length of the
  /// resulting buffer as an int32 at the current
  /// [writerIndex] (inclusive).
  ///
  /// [endian] the endianness of the prepending length integer, defaults to [kEndianness]
  /// which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeLPString(String value, [Encoding? encoding, Endian? endian]) {
    var bytes = Uint8List.fromList((encoding ?? utf8Encoding)
        .encode(value)); // Maybe fix double allocation?
    writeInt32(bytes.length, endian);
    writeBytes(bytes);
  }

  /// Reads a length prepended string encoded by [encoding]
  /// at the current [readerIndex] (inclusive).
  ///
  /// [endian] the endianness of the prepending length integer, defaults to [kEndianness]
  /// which is initialized with [Endian.big].
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
  String readLPString([Encoding? encoding, Endian? endian]) {
    int length = readInt32(endian);
    var bytes = readBytes(length);
    return (encoding ?? utf8Encoding).decode(bytes);
  }

  /// Writes the readable data of the [buffer], prefixed by the amount of
  /// readable bytes at the [writerIndex] (inclusive).
  ///
  /// [endian] the endianness of the prepending length integer, defaults to [kEndianness]
  /// which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeLPBuffer(ByteBuf buffer, [Endian? endian]) {
    // Maybe fix double allocation?
    writeInt32(buffer.readableBytes, endian);
    writeBytes(buffer.peekAvailableBytes());
  }

  /// Reads a length prepended buffer at the current [readerIndex] (inclusive).
  ///
  /// [endian] the endianness of the prepending length integer, defaults to [kEndianness]
  /// which is initialized with [Endian.big].
  ///
  /// ----
  /// See [writeLPBuffer] for more details about data structure.
  ///
  /// ----
  /// Exceptions:
  /// * [ReadIndexOutOfRangeException] if the current
  /// reader index is outside of the bounds of the buffer
  ///
  /// * [BufferOverreadException] if the length
  /// of the [readerIndex] + length is outside of the
  /// bounds of the buffer
  ByteBuf readLPBuffer([Endian? endian]) {
    int length = readInt32(endian);
    var bytes = readBytes(length);
    return bytes.asWrappedBuffer;
  }

  /// Encodes the [bytes] using [canonical base64](https://datatracker.ietf.org/doc/html/rfc4648)
  /// and writes the resulting data prefixed by the length of the
  /// resulting buffer as an int32 at the current
  /// [writerIndex] (inclusive) using [writeLPString].
  ///
  /// [endian] the endianness of the prepending length integer, defaults to [kEndianness]
  /// which is initialized with [Endian.big].
  ///
  /// ----
  /// Exceptions:
  /// * [WriteIndexOutOfRangeException] if the current
  /// writer index is outside of the bounds of the buffer
  ///
  /// * [BufferOverflowException] if the length
  /// of the resulting bytes would overflow the buffer
  void writeLPBase64(Uint8List bytes, [Endian? endian]) {
    var encodedString = base64Encode(bytes);
    writeLPString(encodedString, utf8Encoding, endian);
  }

  /// Reads a length prepended [canonical base64](https://datatracker.ietf.org/doc/html/rfc4648)
  /// value at the current [readerIndex] (inclusive).
  ///
  /// [endian] the endianness of the prepending length integer, defaults to [kEndianness]
  /// which is initialized with [Endian.big].
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
  Uint8List readLPBase64([Endian? endian]) {
    var encodedString = readLPString(utf8Encoding, endian);
    return base64Decode(encodedString);
  }
}
