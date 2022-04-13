import 'package:duffer/duffer.dart';

void main() {
  var buffer = Unpooled.fixed(16);
  buffer.ensureWritable(8); // Set operations do not grow the buffer by default

  buffer.setByte(0, 0xAA);
  buffer.setByte(1, 0xBB);
  buffer.setByte(2, 0xCC);

  buffer.setByte(5, 0xFF);
  buffer.setUint16(6, 0x1234);

  print(buffer.writerIndex); // 0
  print(buffer.readerIndex); // 0
  print(buffer.hexdump); // aabbcc0000ff12340000000000000000
}
