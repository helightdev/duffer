import 'dart:collection';

import 'package:duffer/duffer.dart';

//TODO: Rename to ReadOnlyListView
class ImmutableListView with ListMixin<int> {
  ByteBuf buf;

  int get start => buf.readerIndex;

  @override
  int get length => buf.readableBytes;

  ImmutableListView(this.buf);

  @override
  operator [](int index) {
    return buf.getByte(start + index);
  }

  @override
  void operator []=(int index, value) {
    throw UnsupportedError("Not available in immutable lists");
  }

  @override
  set length(int newLength) {
    throw UnsupportedError("Not available in immutable lists");
  }
}
