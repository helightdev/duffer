part of '../extensions.dart';

//TODO: Documentation
/// Default extensions on [ByteBuf] for setting and getting
/// data at specific indices.
extension GetSetExtension on ByteBuf {
  void setBool(int index, bool value) => setByte(index, value ? 0xFF : 0x00);
  bool getBool(int index) => getByte(index) == 0xFF;

  void setInt64(int index, int value, [Endian? endian]) =>
      setByteData(index, 8).setInt64(0, value, endian ?? kEndianness);
  int getInt64(int index, [Endian? endian]) =>
      getByteData(index, 8).getInt64(0, endian ?? kEndianness);

  void setInt32(int index, int value, [Endian? endian]) =>
      setByteData(index, 4).setInt32(0, value, endian ?? kEndianness);
  int getInt32(int index, [Endian? endian]) =>
      getByteData(index, 4).getInt32(0, endian ?? kEndianness);

  void setInt16(int index, int value, [Endian? endian]) =>
      setByteData(index, 2).setInt16(0, value, endian ?? kEndianness);
  int getInt16(int index, [Endian? endian]) =>
      getByteData(index, 2).getInt16(0, endian ?? kEndianness);

  void setInt8(int index, int value) => setByteData(index, 1).setInt8(0, value);
  int getInt8(int index) => getByteData(index, 1).getInt8(0);

  void setUint64(int index, int value, [Endian? endian]) =>
      setByteData(index, 8).setUint64(0, value, endian ?? kEndianness);
  int getUint64(int index, [Endian? endian]) =>
      getByteData(index, 8).getUint64(0, endian ?? kEndianness);

  void setUint32(int index, int value, [Endian? endian]) =>
      setByteData(index, 4).setUint32(0, value, endian ?? kEndianness);
  int getUint32(int index, [Endian? endian]) =>
      getByteData(index, 4).getUint32(0, endian ?? kEndianness);

  void setUint16(int index, int value, [Endian? endian]) =>
      setByteData(index, 2).setUint16(0, value, endian ?? kEndianness);
  int getUint16(int index, [Endian? endian]) =>
      getByteData(index, 2).getUint16(0, endian ?? kEndianness);

  void setUint8(int index, int value) =>
      setByteData(index, 2).setUint8(0, value);
  int getUint8(int index) => getByteData(index, 2).getUint8(0);

  void setFloat64(int index, double value, [Endian? endian]) =>
      setByteData(index, 8).setFloat64(0, value, endian ?? kEndianness);
  double getFloat64(int index, [Endian? endian]) =>
      getByteData(index, 8).getFloat64(0, endian ?? kEndianness);

  void setFloat32(int index, double value, [Endian? endian]) =>
      setByteData(index, 4).setFloat32(0, value, endian ?? kEndianness);
  double getFloat32(int index, [Endian? endian]) =>
      getByteData(index, 4).getFloat32(0, endian ?? kEndianness);

  void setLPString(int index, String string,
      [Encoding? encoding, Endian? endian]) {
    var bytes = Uint8List.fromList((encoding ?? utf8Encoding).encode(string));
    setInt32(index, bytes.length, endian);
    setBytes(index + 4, bytes);
  }

  String getLPString(int index, [Encoding? encoding, Endian? endian]) {
    int length = getInt32(index, endian);
    var bytes = getBytes(index + 4, length);
    return (encoding ?? utf8Encoding).decode(bytes);
  }

  void setLPBase64(int index, Uint8List bytes, [Endian? endian]) {
    var encodedString = base64Encode(bytes);
    setLPString(index, encodedString, utf8Encoding, endian);
  }

  Uint8List getLPBase64(int index, [Endian? endian]) {
    var encodedString = getLPString(index, utf8Encoding, endian);
    return base64Decode(encodedString);
  }
}
