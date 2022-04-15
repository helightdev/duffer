import 'package:duffer/duffer.dart';
import 'package:test/test.dart';

void main() {
  group("Encoding", () {
    test("Base64", () {
      var src = List.filled(5, 0x22).asBuffer;
      var encoded = src.base64;
      var decoded = encoded.parseBase64();
      expect(decoded.array(), src.array());

      // Test writability
      decoded.setByte(0, 0x12);
      expect(decoded.getByte(0), 0x12);
    });

    test("Hex", () {
      var src = List.filled(5, 0x22).asBuffer;
      var encoded = src.hex;
      var decoded = encoded.parseHex();
      expect(decoded.array(), src.array());

      // Test writability
      decoded.setByte(0, 0x12);
      expect(decoded.getByte(0), 0x12);
    });
  });
}