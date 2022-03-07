part of '../extensions.dart';

extension Uint8ListLoggingExtensions on Uint8List{

  /// Creates a hexdump of the Uint8List
  ///
  /// ----
  /// Example:
  /// ```
  ///0000000b48656c6c6f20576f726c64
  /// ```
  String get hexdump {
    String string = "";
    for (var i = 0; i < length; i++) {
      string += this[i].toRadixString(16).padLeft(2, "0");
    }
    return string;
  }

  /// Creates a spaced hexdump of the Uint8List
  ///
  /// ----
  /// Example:
  /// ```
  ///00 00 00 0b 48 65 6c 6c 6f 20 57 6f 72 6c 64
  /// ```
  String get spacedHexdump {
    String string = "";
    for (var i = 0; i < length; i++) {
      string += this[i].toRadixString(16).padLeft(2, "0") + " ";
    }
    return string.trimRight();
  }
}

extension ByteBufLoggingExtensions on ByteBuf {

  /// Creates a hexdump of the Uint8List
  ///
  /// ----
  /// Example:
  /// ```
  ///0000000b48656c6c6f20576f726c64
  /// ```
  String get hexdump {
    String string = "";
    for (var i = 0; i < capacity(); i++) {
      string += this[i].toRadixString(16).padLeft(2, "0");
    }
    return string;
  }

  /// Creates a spaced hexdump of the Uint8List
  ///
  /// ----
  /// Example:
  /// ```
  ///00 00 00 0b 48 65 6c 6c 6f 20 57 6f 72 6c 64
  /// ```
  String get spacedHexdump {
    String string = "";
    for (var i = 0; i < capacity(); i++) {
      string += this[i].toRadixString(16).padLeft(2, "0") + " ";
    }
    return string.trimRight();
  }
}