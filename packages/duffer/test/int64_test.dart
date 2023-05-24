import 'package:duffer/duffer.dart';
import 'package:fixnum/fixnum.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group("Int64", () {
    test("Basic", () {
      var num = Int64(0xFFFFFFFF).toUnsigned(64);
      num += num;
      var buf = Unpooled.fixed(8);
      buf.writeFixNumInt64(num);
      print(buf.hexdump);
      var read = buf.readFixNumInt64().toUnsigned(64);
      expect(num, read);
    });
    test("Bounds", () {
      var num = Int64.parseHex("FFFFFFFFFFFFFFFF");
      var buf = Unpooled.fixed(8);
      buf.writeFixNumInt64(num);
      print(buf.hexdump);
      var read = buf.readFixNumInt64();
      expect(num, read);
    });
  });
}