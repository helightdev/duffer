import 'package:duffer/duffer.dart';
import 'package:duffer/src/impl/streamed.dart';

void main() async {
  var buffer = StreamedByteBuf(Unpooled.buffer());
  buffer.consume(Stream.periodic(Duration(milliseconds: 250), (_) {
    return [0x00, 0xFF, 0xAB];
  }));
  print("Starting to wait!");
  await buffer.untilReadable(3);
  print("Now readable!");
  await buffer.untilNextFrame();
  print("Now next frame!");
  await buffer.untilReceived(3);
  print("Received some more!");
}
