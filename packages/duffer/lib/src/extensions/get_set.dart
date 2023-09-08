part of '../extensions.dart';

/// Default extensions on [ByteBuf] for setting and getting data at specific indices.
extension GetSetExtension on ByteBuf {
  /// Writes the [value] as a single byte using 0xFF as true and 0x00 as false at [index].
  void setBool(int index, bool value) => setByte(index, value ? 0xFF : 0x00);

  /// Reads a single byte at [index] and returns true if it is 0xFF and false otherwise.
  bool getBool(int index) => getByte(index) == 0xFF;

  /// Writes the [value] to the next 8 bytes at [index] (inclusive).
  /// [endian] defaults to [Endian.big].
  void setFixNumInt64(int index, Int64 value, [Endian? endian]) =>
      setByteData(index, 8).setInt64FN(0, value, endian ?? kEndianness);

  /// Writes the [value] to the next 4 bytes at [index] (inclusive).
  /// [endian] defaults to [Endian.big].
  Int64 getFixNumInt64(int index, [Endian? endian]) =>
      getByteData(index, 8).getInt64FN(0, endian ?? kEndianness);

  /// Writes the [value] to the next 8 bytes at [index] (inclusive).
  /// [endian] defaults to [Endian.big].
  void setInt64(int index, int value, [Endian? endian]) =>
      setByteData(index, 8).setInt64Duffer(0, value, endian ?? kEndianness);

  /// Reads the next 8 bytes at [index] (inclusive) and returns the value.
  /// [endian] defaults to [Endian.big].
  int getInt64(int index, [Endian? endian]) =>
      getByteData(index, 8).getInt64Duffer(0, endian ?? kEndianness);

  /// Writes the [value] to the next 4 bytes at [index] (inclusive).
  /// [endian] defaults to [Endian.big].
  void setInt32(int index, int value, [Endian? endian]) =>
      setByteData(index, 4).setInt32(0, value, endian ?? kEndianness);

  /// Reads the next 4 bytes at [index] (inclusive) and returns the value.
  /// [endian] defaults to [Endian.big].
  int getInt32(int index, [Endian? endian]) =>
      getByteData(index, 4).getInt32(0, endian ?? kEndianness);

  /// Writes the [value] to the next 2 bytes at [index] (inclusive).
  /// [endian] defaults to [Endian.big].
  void setInt16(int index, int value, [Endian? endian]) =>
      setByteData(index, 2).setInt16(0, value, endian ?? kEndianness);

  /// Reads the next 2 bytes at [index] (inclusive) and returns the value.
  /// [endian] defaults to [Endian.big].
  int getInt16(int index, [Endian? endian]) =>
      getByteData(index, 2).getInt16(0, endian ?? kEndianness);

  /// Writes the [value] to the next 1 byte at [index] (inclusive).
  /// [endian] defaults to [Endian.big].
  void setInt8(int index, int value) => setByteData(index, 1).setInt8(0, value);
  int getInt8(int index) => getByteData(index, 1).getInt8(0);

  /// Writes the [value] to the next 8 bytes at [index] (inclusive).
  /// [endian] defaults to [Endian.big].
  void setUint64(int index, int value, [Endian? endian]) =>
      setByteData(index, 8).setUint64Duffer(0, value, endian ?? kEndianness);

  /// Reads the next 8 bytes at [index] (inclusive) and returns the value.
  /// [endian] defaults to [Endian.big].
  int getUint64(int index, [Endian? endian]) =>
      getByteData(index, 8).getUint64Duffer(0, endian ?? kEndianness);

  /// Writes the [value] to the next 4 bytes at [index] (inclusive).
  /// [endian] defaults to [Endian.big].
  void setUint32(int index, int value, [Endian? endian]) =>
      setByteData(index, 4).setUint32(0, value, endian ?? kEndianness);

  /// Reads the next 4 bytes at [index] (inclusive) and returns the value.
  /// [endian] defaults to [Endian.big].
  int getUint32(int index, [Endian? endian]) =>
      getByteData(index, 4).getUint32(0, endian ?? kEndianness);

  /// Writes the [value] to the next 2 bytes at [index] (inclusive).
  /// [endian] defaults to [Endian.big].
  void setUint16(int index, int value, [Endian? endian]) =>
      setByteData(index, 2).setUint16(0, value, endian ?? kEndianness);

  /// Reads the next 2 bytes at [index] (inclusive) and returns the value.
  /// [endian] defaults to [Endian.big].
  int getUint16(int index, [Endian? endian]) =>
      getByteData(index, 2).getUint16(0, endian ?? kEndianness);

  /// Writes the [value] to the next 1 byte at [index] (inclusive).
  /// [endian] defaults to [Endian.big].
  void setUint8(int index, int value) =>
      setByteData(index, 2).setUint8(0, value);

  /// Reads the next 1 byte at [index] (inclusive) and returns the value.
  /// [endian] defaults to [Endian.big].
  int getUint8(int index) => getByteData(index, 2).getUint8(0);

  /// Writes the [value] to the next 8 bytes at [index] (inclusive).
  /// [endian] defaults to [Endian.big].
  void setFloat64(int index, double value, [Endian? endian]) =>
      setByteData(index, 8).setFloat64(0, value, endian ?? kEndianness);

  /// Reads the next 8 bytes at [index] (inclusive) and returns the value.
  /// [endian] defaults to [Endian.big].
  double getFloat64(int index, [Endian? endian]) =>
      getByteData(index, 8).getFloat64(0, endian ?? kEndianness);

  /// Writes the [value] to the next 4 bytes at [index] (inclusive).
  /// [endian] defaults to [Endian.big].
  void setFloat32(int index, double value, [Endian? endian]) =>
      setByteData(index, 4).setFloat32(0, value, endian ?? kEndianness);

  /// Reads the next 4 bytes at [index] (inclusive) and returns the value.
  /// [endian] defaults to [Endian.big].
  double getFloat32(int index, [Endian? endian]) =>
      getByteData(index, 4).getFloat32(0, endian ?? kEndianness);

  /// Writes a length-prepended string to the next bytes at [index] (inclusive).
  /// [encoding] defaults to [utf8Encoding] and [endian] defaults to [Endian.big].
  void setLPString(int index, String string,
      [Encoding? encoding, Endian? endian]) {
    var bytes = Uint8List.fromList((encoding ?? utf8Encoding).encode(string));
    setInt32(index, bytes.length, endian);
    setBytes(index + 4, bytes);
  }

  /// Reads a length-prepended string from the next bytes at [index] (inclusive).
  /// [encoding] defaults to [utf8Encoding] and [endian] defaults to [Endian.big].
  String getLPString(int index, [Encoding? encoding, Endian? endian]) {
    int length = getInt32(index, endian);
    var bytes = getBytes(index + 4, length);
    return (encoding ?? utf8Encoding).decode(bytes);
  }

  /// Converts the [bytes] to a [String] using [base64Encode] and writes it to the next
  /// bytes at [index] (inclusive) using [setLPString].
  /// [endian] defaults to [Endian.big].
  void setLPBase64(int index, Uint8List bytes, [Endian? endian]) {
    var encodedString = base64Encode(bytes);
    setLPString(index, encodedString, utf8Encoding, endian);
  }

  /// Reads a length-prepended [String] from the next bytes at [index] (inclusive) using [getLPString]
  /// and converts it to a [Uint8List] using [base64Decode]. [endian] defaults to [Endian.big].
  Uint8List getLPBase64(int index, [Endian? endian]) {
    var encodedString = getLPString(index, utf8Encoding, endian);
    return base64Decode(encodedString);
  }
}
