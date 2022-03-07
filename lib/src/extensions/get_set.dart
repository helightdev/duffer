part of '../extensions.dart';

//TODO: Documentation
/// Default extensions on [ByteBuf] for setting and getting
/// data at specific indices.
extension GetSetExtension on ByteBuf {

  void setInt64(int index, int value) => setByteData(index, 8).setInt64(0, value);
  int getInt64(int index) => getByteData(index, 8).getInt64(0);

  void setInt32(int index, int value) => setByteData(index, 4).setInt32(0, value);
  int getInt32(int index) => getByteData(index, 4).getInt32(0);

  void setInt16(int index, int value) => setByteData(index, 2).setInt16(0, value);
  int getInt16(int index) => getByteData(index, 2).getInt16(0);

  void setUint64(int index, int value) => setByteData(index, 8).setUint64(0, value);
  int getUint64(int index) => getByteData(index, 8).getUint64(0);

  void setUint32(int index, int value) => setByteData(index, 4).setUint32(0, value);
  int getUint32(int index) => getByteData(index, 4).getUint32(0);

  void setUint16(int index, int value) => setByteData(index, 2).setUint16(0, value);
  int getUint16(int index) => getByteData(index, 2).getUint16(0);

  void setFloat64(int index, double value) => setByteData(index, 8).setFloat64(0, value);
  double getFloat64(int index) => getByteData(index, 8).getFloat64(0);

  void setFloat32(int index, double value) => setByteData(index, 4).setFloat32(0, value);
  double getFloat32(int index) => getByteData(index, 4).getFloat32(0);

  void setLPString(int index, String string, [Encoding? encoding]) {
    var bytes = Uint8List.fromList((encoding??utf8Encoding).encode(string));
    setInt32(index, bytes.length);
    setBytes(index + 4, bytes);
  }

  String getLPString(int index, [Encoding? encoding]) {
    int length = getInt32(index);
    var bytes = getBytes(index + 4, length);
    return (encoding??utf8Encoding).decode(bytes);
  }

  void setLPBase64(int index, Uint8List bytes) {
    var encodedString = base64Encode(bytes);
    setLPString(index, encodedString, utf8Encoding);
  }

  Uint8List getLPBase64(int index) {
    var encodedString = getLPString(index, utf8Encoding);
    return base64Decode(encodedString);
  }
}