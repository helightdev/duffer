part of '../extensions.dart';

extension ByteBufEncoding on ByteBuf {
  /// Encodes the buffers readable bytes using [base64](https://tools.ietf.org/html/rfc4648)
  /// while not updating the [ByteBuf.readerIndex] or resetting user markers
  ///
  /// ----
  /// Example:
  /// ```
  ///SGVsbG8gV29ybGQ=
  /// ```
  String get base64 => base64Encode(peekAvailableBytes());

  /// Encodes the buffers readable bytes in hex while not updating the [ByteBuf.readerIndex]
  /// or resetting user markers
  ///
  /// ----
  /// Example:
  /// ```
  ///0000000b48656c6c6f20576f726c64
  /// ```
  String get hex => peekAvailableBytes().hexdump;
}

extension DufferPlatformExt on ByteData {
  /// Reads an int64 from the [ByteData] at [offset] using [endian].
  int getInt64Duffer(int offset, Endian endian) {
    return dufferPlatform.getInt64(this, offset, endian);
  }

  /// Reads an uint64 from the [ByteData] at [offset] using [endian].
  int getUint64Duffer(int offset, Endian endian) {
    return dufferPlatform.getUint64(this, offset, endian);
  }

  /// Writes an int64 to the [ByteData] at [offset] using [endian].
  void setInt64Duffer(int offset, int value, Endian endian) {
    dufferPlatform.setInt64(this, offset, value, endian);
  }

  /// Writes an uint64 to the [ByteData] at [offset] using [endian].
  void setUint64Duffer(int offset, int value, Endian endian) {
    dufferPlatform.setUint64(this, offset, value, endian);
  }

  /// Reads an [Int64] from the [ByteData] at [offset] using [endian].
  Int64 getInt64FN(int offset, Endian endian) {
    var bytes = getBytes(offset, 8);
    if (endian == Endian.big) {
      return Int64.fromBytesBigEndian(bytes);
    } else {
      return Int64.fromBytes(bytes);
    }
  }

  /// Writes an [Int64] to the [ByteData] at [offset] using [endian].
  void setInt64FN(int offset, Int64 value, Endian endian) {
    var bytes = value.toBytes();
    if (endian == Endian.little) {
      setUint8(offset + 0, bytes[0]);
      setUint8(offset + 1, bytes[1]);
      setUint8(offset + 2, bytes[2]);
      setUint8(offset + 3, bytes[3]);
      setUint8(offset + 4, bytes[4]);
      setUint8(offset + 5, bytes[5]);
      setUint8(offset + 6, bytes[6]);
      setUint8(offset + 7, bytes[7]);
    } else {
      setUint8(offset + 0, bytes[7]);
      setUint8(offset + 1, bytes[6]);
      setUint8(offset + 2, bytes[5]);
      setUint8(offset + 3, bytes[4]);
      setUint8(offset + 4, bytes[3]);
      setUint8(offset + 5, bytes[2]);
      setUint8(offset + 6, bytes[1]);
      setUint8(offset + 7, bytes[0]);
    }
  }
}
