import 'bytebuf_base.dart';

//TODO: Add tests, this is untested but should work now as intended probably
class ByteBufIterator extends Iterator<int> {

  ByteBuf buffer;
  int index = 0;

  ByteBufIterator(this.buffer);

  @override
  int get current => buffer[index];

  @override
  bool moveNext() {
    index++;
    if (index < buffer.writerIndex) {
      return true;
    }
    return false;
  }
}