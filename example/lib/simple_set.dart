import 'package:duffer/duffer.dart';

void main() {
  var buffer = Unpooled.fixed(16);
  buffer.ensureWritable(8); // Set operations do not grow the buffer by default

  buffer.updateByte(0, 0xAA);
  buffer.updateByte(1, 0xBB);
  buffer.updateByte(2, 0xCC);

  buffer.updateByte(5, 0xFF);
  print(buffer.writerIndex); // 0
  buffer.writerIndex += 6;
  print(buffer.writerIndex); // 6

  buffer.setUint16(6, 0x1234); // This increments because its a multi byte write operation

  print(buffer.writerIndex); // 8
  print(buffer.readerIndex); // 0
  print(buffer.hexdump); // aabbcc0000ff12340000000000000000
}
