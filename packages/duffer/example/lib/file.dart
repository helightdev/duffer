import 'dart:io';

import 'package:duffer/duffer.dart';
import 'package:duffer/src/impl/file.dart';

void main() async {
  var file = File("test.bin");
  await file.create();
  var handle = await file.open(mode: FileMode.write);
  var buffer = RandomAccessFileByteBuf(handle);
  while (true) {
    buffer.writeBytes([0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF]);
  }
}
