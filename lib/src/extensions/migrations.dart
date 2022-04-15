part of '../extensions.dart';

List<int> hexDecode(String string) {
  var bytes = List<int>.empty(growable: true);
  var unformatted = string.replaceAll(" ", "").toLowerCase();
  if (unformatted.length % 2 != 0) {
    throw FormatException(
        "Length of an unformatted hex string has to be a multiple of 2");
  }
  for (var i = 0; i < unformatted.length; i += 2) {
    bytes.add(int.parse(unformatted.substring(i, i + 2), radix: 16));
  }
  return bytes;
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
  /// resulting uint8 list using [asWrappedBuffer] resulting in a **fixed length** buffer
  ByteBuf parseBase64() {
    var buffer = base64Decode(this);
    return buffer.asWrappedBuffer;
  }

  ByteBuf parseHex() {
    var buffer = hexDecode(this);
    return buffer.asBuffer;
  }
}

extension IntListMigrationExtension on List<int> {
  /// Migrates this list to a [ByteBuf] by copying it.
  ByteBuf get asBuffer => ByteBuf.fromData(
      this); // Also applies to uint8 list for non wrapping migration

}
