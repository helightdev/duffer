import 'dart:convert';

import 'package:duffer/duffer.dart';

class Sizes {

  static const int int8 = 1;
  static const int int16 = 2;
  static const int int32 = 4;
  static const int int64 = 8;

  static const int listIndex = int32;

  static int string(String string, [Encoding? encoding]) {
    // Yes this does allocate twqice and isn't optimal but I don't know any other safe way yet so
    // TODO: Figure out another way to retrieve the length of resulting buffer
    return (encoding??utf8Encoding).encode(string).length + listIndex;
  }

  static int simpleString(String string, [Encoding? encoding]) {
    // If this doesn't contain complex unicode symbols the size will be length*8
    return string.length*8 + listIndex;
  }

}