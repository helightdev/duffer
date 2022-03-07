part of '../extensions.dart';

extension IntListExtensions on List<int> {

  Uint8List get uint8List => Uint8List.fromList(this);

}

extension ByteDataExtensions on ByteData {

  Uint8List get uint8list {
    var bytes = Uint8List(lengthInBytes);
    for (var i = 0; i < lengthInBytes; i++) {
      bytes[i] = getUint8(i);
    }
    return bytes;
  }

}