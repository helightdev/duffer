import 'package:duffer/duffer.dart';

void main() {
  var buffer = Unpooled.buffer();
  buffer.writeLPString("Hello World!");
  buffer.writeInt32(42);

  print(buffer.readLPString()); // Hello World!
  print(buffer.readInt32()); // 42
}
