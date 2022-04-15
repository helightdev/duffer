import 'dart:collection';

import 'package:duffer/duffer.dart';

class ImmutableListView with ListMixin<int> {
  ByteBuf buf;

  late int start;

  @override
  late int length;

  ImmutableListView(this.buf) {
    start = buf.readerIndex;
    length = buf.readableBytes;
  }

  @override
  operator [](int index) {
    return buf.getByte(start + index);
  }

  @override
  void operator []=(int index, value) {
    throw UnsupportedError("Not available in immutable lists");
  }
}
