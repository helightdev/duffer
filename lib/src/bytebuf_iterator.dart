import 'dart:collection';

import 'bytebuf_base.dart';

class ByteBufIterator extends Iterator<int> {

  ByteBuf buffer;
  int index = 0;
  int length = 0;

  ByteBufIterator(this.buffer) {
    length = buffer.capacity();
  }

  @override
  int get current => buffer[index];

  @override
  bool moveNext() {
    index++;
    if (index < length) {
      return true;
    }
    return false;
  }
}