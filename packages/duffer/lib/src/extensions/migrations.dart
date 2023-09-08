part of '../extensions.dart';

// This function takes a hexadecimal string as input and converts it into a int list.
Uint8List hexDecode(String string) {
  var bytes = List<int>.empty(growable: true);
  var unformatted = string.replaceAll(" ", "").toLowerCase();
  if (unformatted.length % 2 != 0) {
    throw FormatException(
        "Length of an unformatted hex string has to be a multiple of 2");
  }
  for (var i = 0; i < unformatted.length; i += 2) {
    bytes.add(int.parse(unformatted.substring(i, i + 2), radix: 16));
  }
  return Uint8List.fromList(bytes);
}

extension Uint8ListMigrationExtension on Uint8List {
  /// Migrates this list by wrapping it using [ListBuffer]
  ByteBuf get asWrappedBuffer {
    var buffer = ListBuffer(this);
    buffer.writerIndex = length;
    return buffer;
  }
}

extension StringDecodingExtension on String {
  /// Decodes the [base64](https://tools.ietf.org/html/rfc4648) string using [base64Decode] and wraps the
  /// resulting uint8 list using [ByteBuf.asWrappedBuffer] resulting in a **fixed length** buffer.
  ByteBuf parseBase64() {
    var buffer = base64Decode(this);
    return buffer.asWrappedBuffer;
  }

  /// Decodes the [hex](https://en.wikipedia.org/wiki/Hexadecimal) string using [hexDecode] and wraps the
  /// resulting uint8 list using [ByteBuf.asBuffer] resulting in a **fixed length** buffer.
  ByteBuf parseHex() {
    var buffer = hexDecode(this);
    return buffer.asWrappedBuffer;
  }
}

extension IntListMigrationExtension on List<int> {
  /// Migrates this list to a [ByteBuf] by copying it.
  ByteBuf get asBuffer => ByteBuf.fromData(
      this); // Also applies to uint8 list for non wrapping migration

  /// Migrates this list by wrapping it using [Uint8List.fromList].
  Uint8List get uint8List => Uint8List.fromList(this);

}

extension ByteDataExtensions on ByteData {

  /// Creates a [Uint8List] from the bytes in this [ByteData].
  Uint8List get uint8list {
    var bytes = Uint8List(lengthInBytes);
    for (var i = 0; i < lengthInBytes; i++) {
      bytes[i] = getUint8(i);
    }
    return bytes;
  }

  /// Creates a [Uint8List] from a subset of the bytes in this [ByteData].
  /// [offset] represents the start index and [length] the amount of bytes to copy.
  Uint8List getBytes(int offset, int length) {
    var bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = getUint8(i + offset);
    }
    return bytes;
  }
}
