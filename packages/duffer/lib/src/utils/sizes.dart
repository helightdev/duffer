import 'dart:convert';

import 'package:duffer/duffer.dart';

/// Utility class containing the sizes of different data types and helper
/// methods to calculate the size of variable length data types.
class Sizes {
  /// The size of a **bool** in bytes.
  static const int bool = 1;
  /// The size of a **int8** in bytes.
  static const int int8 = 1;
  /// The size of a **int16** in bytes.
  static const int int16 = 2;
  /// The size of a **int32** in bytes.
  static const int int32 = 4;
  /// The size of a **int64** in bytes.
  static const int int64 = 8;
  /// The size of a **float32** in bytes.
  static const int float32 = 4;
  /// The size of a **float64** in bytes.
  static const int float64 = 8;

  /// The size of a **listIndex** in bytes.
  static const int listIndex = int32;

  /// Calculates the size of a string that uses the [encoding] or [utf8Encoding] by default.
  static int string(String string, [Encoding? encoding]) {
    // Yes this does allocate twice and isn't optimal but I don't know any other safe way yet so
    // TODO: Figure out another way to retrieve the length of resulting buffer
    return (encoding ?? utf8Encoding).encode(string).length + listIndex;
  }

  static int simpleString(String string, [Encoding? encoding]) {
    // If this doesn't contain complex unicode symbols the size will be length*8
    return string.length * 8 + listIndex;
  }
}
