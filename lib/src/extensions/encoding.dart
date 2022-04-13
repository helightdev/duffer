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
  String get base64 {
    var marker = createReadMarker();
    var data = readAvailableBytes();
    marker.jump();
    return base64Encode(data);
  }

  /// Encodes the buffers readable bytes in hex while not updating the [ByteBuf.readerIndex]
  /// or resetting user markers
  ///
  /// ----
  /// Example:
  /// ```
  ///0000000b48656c6c6f20576f726c64
  /// ```
  String get hex {
    var marker = createReadMarker();
    var data = readAvailableBytes();
    marker.jump();
    return data.hexdump;
  }

}