import 'dart:convert';
import 'dart:typed_data';

import 'package:duffer/duffer.dart';

void main() {
  var buffer = Unpooled.buffer();
  buffer.writeLPString("Hello World!");
  print(buffer.readLPString());
}
