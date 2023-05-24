import 'dart:typed_data';

import 'package:duffer/duffer.dart';
import 'package:fixnum/fixnum.dart';

const bool _kIsWeb = bool.fromEnvironment('dart.library.js_util');

DufferPlatformProvider dufferPlatform = _getProvider();

DufferPlatformProvider _getProvider() {
  if (_kIsWeb) {
    return DufferWebProvider();
  } else {
    return DufferVmProvider();
  }
}

abstract class DufferPlatformProvider {
  int getInt64(ByteData data, int offset, Endian endian);
  void setInt64(ByteData data, int offset, int value, Endian endian);
  int getUint64(ByteData data, int offset, Endian endian);
  void setUint64(ByteData data, int offset, int value, Endian endian);
}

class DufferVmProvider extends DufferPlatformProvider {
  @override
  int getInt64(ByteData data, int offset, Endian endian) {
    return data.getInt64(offset, endian);
  }

  @override
  int getUint64(ByteData data, int offset, Endian endian) {
    return data.getUint64(offset, endian);
  }

  @override
  void setInt64(ByteData data, int offset, int value, Endian endian) {
    return data.setInt64(offset, value, endian);
  }

  @override
  void setUint64(ByteData data, int offset, int value, Endian endian) {
    return data.setUint64(offset, value, endian);
  }

}

class DufferWebProvider extends DufferPlatformProvider {
  @override
  int getInt64(ByteData data, int offset, Endian endian) {
    var bytes = data.getBytes(offset, 8);
    if (endian == Endian.big) {
      return Int64.fromBytesBigEndian(bytes).toInt();
    } else {
      return Int64.fromBytes(bytes).toInt();
    }
  }

  @override
  int getUint64(ByteData data, int offset, Endian endian) {
    var bytes = data.getBytes(offset, 8);
    if (endian == Endian.big) {
      return Int64.fromBytesBigEndian(bytes).toUnsigned(64).toInt();
    } else {
      return Int64.fromBytes(bytes).toUnsigned(64).toInt();
    }
  }

  @override
  void setInt64(ByteData data, int offset, int value, Endian endian) {
    var bytes = Int64(value).toBytes();
    if (endian == Endian.little) {
      data.setUint8(offset + 0, bytes[0]);
      data.setUint8(offset + 1, bytes[1]);
      data.setUint8(offset + 2, bytes[2]);
      data.setUint8(offset + 3, bytes[3]);
      data.setUint8(offset + 4, bytes[4]);
      data.setUint8(offset + 5, bytes[5]);
      data.setUint8(offset + 6, bytes[6]);
      data.setUint8(offset + 7, bytes[7]);
    } else {
      data.setUint8(offset + 0, bytes[7]);
      data.setUint8(offset + 1, bytes[6]);
      data.setUint8(offset + 2, bytes[5]);
      data.setUint8(offset + 3, bytes[4]);
      data.setUint8(offset + 4, bytes[3]);
      data.setUint8(offset + 5, bytes[2]);
      data.setUint8(offset + 6, bytes[1]);
      data.setUint8(offset + 7, bytes[0]);
    }
  }

  @override
  void setUint64(ByteData data, int offset, int value, Endian endian) {
    var bytes = Int64(value).toBytes();
    if (endian == Endian.little) {
      data.setUint8(offset + 0, bytes[0]);
      data.setUint8(offset + 1, bytes[1]);
      data.setUint8(offset + 2, bytes[2]);
      data.setUint8(offset + 3, bytes[3]);
      data.setUint8(offset + 4, bytes[4]);
      data.setUint8(offset + 5, bytes[5]);
      data.setUint8(offset + 6, bytes[6]);
      data.setUint8(offset + 7, bytes[7]);
    } else {
      data.setUint8(offset + 0, bytes[7]);
      data.setUint8(offset + 1, bytes[6]);
      data.setUint8(offset + 2, bytes[5]);
      data.setUint8(offset + 3, bytes[4]);
      data.setUint8(offset + 4, bytes[3]);
      data.setUint8(offset + 5, bytes[2]);
      data.setUint8(offset + 6, bytes[1]);
      data.setUint8(offset + 7, bytes[0]);
    }
  }

}