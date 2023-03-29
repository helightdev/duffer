import 'dart:typed_data';

import 'package:duffer/duffer.dart';
import 'package:test/test.dart';

void main() {
  group("Migrate", () {
    test("As Buffer", () {
      var list = List.filled(4, 0x01);
      var buffer = list.asBuffer;
      expect(list, buffer.readAvailableBytes());
    });

    test("As Wrapped Buffer", () {
      var list = List.filled(4, 0x01).uint8List;
      var buffer = list.asWrappedBuffer;
      expect(list, buffer.readAvailableBytes());
    });
  });

  group('Buffer Read Write', () {
    final byteBuf = Unpooled.fixed(8);

    setUp(() {
      byteBuf.clear();
    });

    test('Single Byte Read/Write', () {
      expect(byteBuf.writerIndex, 0);
      byteBuf.writeByte(0x00);
      byteBuf.writeByte(0xFF);
      expect(byteBuf.writerIndex, 2);
      expect(byteBuf.readerIndex, 0);
      expect(byteBuf.readByte(), 0x00);
      expect(byteBuf.readByte(), 0xFF);
      expect(byteBuf.readerIndex, 2);
    });

    test('Multi Byte Read/Write', () {
      expect(byteBuf.writerIndex, 0);
      byteBuf.writeBytes(Uint8List.fromList([0xAA, 0xBB]));
      expect(byteBuf.writerIndex, 2);
      expect(byteBuf.readerIndex, 0);
      expect(byteBuf.readBytes(2), Uint8List.fromList([0xAA, 0xBB]));
      expect(byteBuf.readerIndex, 2);
    });

    test('Indexed Single Byte Read/Write', () {
      expect(byteBuf.writerIndex, 0);
      byteBuf.updateByte(3, 0xEE);
      expect(byteBuf.writerIndex, 0);
      expect(byteBuf.readerIndex, 0);
      expect(byteBuf.getByte(3), 0xEE);
      expect(byteBuf.readerIndex, 0);
    });

    test('Indexed Multi Byte Read/Write', () {
      expect(byteBuf.writerIndex, 0);
      byteBuf.setBytes(4, Uint8List.fromList([0xAA, 0xBB]));
      expect(byteBuf.writerIndex, 0);
      expect(byteBuf.readerIndex, 0);
      expect(byteBuf.getBytes(4, 2), Uint8List.fromList([0xAA, 0xBB]));
      expect(byteBuf.readerIndex, 0);
    });
  });
  group("Buffer Constraints", () {
    final byteBuf = Unpooled.fixed(8);

    setUp(() {
      byteBuf.clear();
    });

    test("Valid", () {
      expect(() {
        byteBuf.writeBytes(Uint8List(8));
        byteBuf.setBytes(4, Uint8List(4));
        byteBuf.readBytes(8);
        byteBuf.getBytes(4, 4);
        return true;
      }(), true);
    });

    test("Overflow", () {
      expect(() {
        byteBuf.writeBytes(Uint8List(9));
      }, throwsException);
      expect(() {
        byteBuf.writeBytes(Uint8List(32));
      }, throwsException);
      expect(() {
        byteBuf.setBytes(4, Uint8List(5));
      }, throwsException);
    });

    test("Overread", () {
      expect(() {
        byteBuf.readBytes(9);
      }, throwsException);
      expect(() {
        byteBuf.readBytes(32);
      }, throwsException);
      expect(() {
        byteBuf.getBytes(4, 5);
      }, throwsException);
    });

    test("Read Index Validation", () {
      var buffer = Unpooled.fixed(32);
      buffer.writeUint64(0x0123456789ABCDEF);
      var child0 = buffer.viewBuffer(2, 2);
      expect(child0.readableBytes, 0);
      expect(() {
        child0.readBytes(2);
      }, throwsException);
    });
  });

  group("Special RW Methods", () {
    final byteBuf = Unpooled.fixed(32);

    setUp(() {
      byteBuf.clear();
    });

    test("Int8", () {
      byteBuf.writeInt8(16);
      expect(byteBuf.readInt8(), 16);
      byteBuf.writeInt8(-16);
      expect(byteBuf.readInt8(), -16);
      byteBuf.writeInt8(0x7FFF7E7E);
      expect(byteBuf.readInt8(), 0x7E);
    });

    test("Int16", () {
      byteBuf.writeInt16(16);
      expect(byteBuf.readInt16(), 16);
      byteBuf.writeInt16(-16);
      expect(byteBuf.readInt16(), -16);
      byteBuf.writeInt16(0x7FFF7EEE);
      expect(byteBuf.readInt16(), 0x7EEE);
    });

    test("Int32", () {
      byteBuf.writeInt32(16);
      expect(byteBuf.readInt32(), 16);
      byteBuf.writeInt32(-16);
      expect(byteBuf.readInt32(), -16);
      byteBuf.writeInt32(0x7FFFFFFF);
      expect(byteBuf.readInt32() == -1, false);
      byteBuf.writeInt32(0x7FFFFFFF7EEEEEEE);
      expect(byteBuf.readInt32(), 0x7EEEEEEE);
    });

    test("Int64", () {
      byteBuf.writeInt64(16);
      expect(byteBuf.readInt64(), 16);
      byteBuf.writeInt64(-16);
      expect(byteBuf.readInt64(), -16);
      byteBuf.writeInt64(0x7FFFFFFFFFFFFFFF);
      expect(byteBuf.readInt32() == -1, false);
    });

    test("Uint8", () {
      byteBuf.writeUint8(0x13);
      expect(byteBuf.readUint8(), 0x13);
      byteBuf.writeUint8(0xFF);
      expect(byteBuf.readUint8(), 0xFF);
      byteBuf.writeUint8(0x11223344);
      expect(byteBuf.readUint8(), 0x44);
    });

    test("Uint16", () {
      byteBuf.writeUint16(0x1337);
      expect(byteBuf.readUint16(), 0x1337);
      byteBuf.writeUint16(0xFFFF);
      expect(byteBuf.readUint16(), 0xFFFF);
      byteBuf.writeUint16(0x11112222);
      expect(byteBuf.readUint16(), 0x2222);
    });

    test("Uint32", () {
      byteBuf.writeUint32(0x1337);
      expect(byteBuf.readUint32(), 0x1337);
      byteBuf.writeUint32(0xFFFFFFFF);
      expect(byteBuf.readUint32(), 0xFFFFFFFF);
      byteBuf.writeUint32(0x1111222233334444);
      expect(byteBuf.readUint32(), 0x33334444);
    });

    test("Uint64", () {
      byteBuf.writeUint64(0x1337);
      expect(byteBuf.readUint64(), 0x1337);
      byteBuf.writeUint64(0xFFFFFFFFFFFFFFFF);
      expect(byteBuf.readUint64(), 0xFFFFFFFFFFFFFFFF);
    });

    test("String", () {
      byteBuf.writeLPString("Hello World", utf8Encoding);
      expect(byteBuf.readLPString(utf8Encoding), "Hello World");
      byteBuf.discardReadBytes();
      byteBuf.writeLPString("Example", asciiEncoding);
      expect(byteBuf.readLPString(asciiEncoding), "Example");
      byteBuf
          .discardReadBytes(); // Yea could also have called this test "discardReadBytes"
      expect(() {
        byteBuf.writeLPString("Too looooooooooooooong string", utf8Encoding);
      }, throwsException);
      expect(byteBuf.readerIndex, 0); // Just wanted too test this too
    });
  });
  group("Control Functions", () {
    final byteBuf = Unpooled.fixed(32);

    setUp(() {
      byteBuf.readMarker = 0;
      byteBuf.writeMarker = 0;
      byteBuf.clear();
    });

    test("Reader Marker", () {
      expect(byteBuf.readerIndex, 0); // Test normal behaviour
      byteBuf.readerIndex = 10;
      expect(byteBuf.readerIndex, 10);
      byteBuf.resetReaderIndex();
      expect(byteBuf.readerIndex, 0);
      byteBuf.readerIndex = 5; // Set marker at 5
      expect(byteBuf.readerIndex, 5);
      byteBuf.markReaderIndex();
      expect(byteBuf.readerIndex, 5);
      expect(byteBuf.readMarker, 5);
      byteBuf.readerIndex = 10; // Go to 10 and reset to marker
      expect(byteBuf.readerIndex, 10);
      byteBuf.resetReaderIndex();
      expect(byteBuf.readerIndex, 5);
    });

    test("Write Marker", () {
      expect(byteBuf.writerIndex, 0); // Test normal behaviour
      byteBuf.writerIndex = 10;
      expect(byteBuf.writerIndex, 10);
      byteBuf.resetWriterIndex();
      expect(byteBuf.writerIndex, 0);
      byteBuf.writerIndex = 5; // Set marker at 5
      expect(byteBuf.writerIndex, 5);
      byteBuf.markWriterIndex();
      expect(byteBuf.writerIndex, 5);
      expect(byteBuf.writeMarker, 5);
      byteBuf.writerIndex = 10; // Go to 10 and reset to marker
      expect(byteBuf.writerIndex, 10);
      byteBuf.resetWriterIndex();
      expect(byteBuf.writerIndex, 5);
    });

    test("Readable", () {
      expect(byteBuf.writableBytes, byteBuf.capacity());
      expect(byteBuf.readableBytes, 0);
      while (byteBuf.isWritable) {
        byteBuf.writeByte(0xFF);
      }
      expect(byteBuf.writableBytes, 0);
      expect(byteBuf.readableBytes, byteBuf.capacity());
      while (byteBuf.isReadable) {
        var byte = byteBuf.readByte();
        expect(byte, 0xFF);
      }
      expect(byteBuf.writableBytes, 0);
      expect(byteBuf.readableBytes, 0);
    });
  });

  group("Growable", () {
    test("Grow", () {
      var buffer = Unpooled.buffer(initialCapacity: 1, maxCapacity: 32);
      expect(buffer.writableBytes, 1);
      buffer.allocate(15);
      expect(buffer.capacity(), 16);
      expect(buffer.writableBytes, 16);
      buffer.allocate(16);
      expect(buffer.capacity(), 32);
      expect(buffer.writableBytes, 32);
    });
  });

  group("Sibling buffers", () {
    test("Child Size", () {
      var buffer = Unpooled.fixed(32);
      buffer.writeUint64(0x0123456789ABCDEF);
      var child0 = buffer.readBuffer(2);
      expect(child0.readableBytes, 2);
      expect(child0.readAvailableBytes(), [0x01, 0x23]);
      var child1 = buffer.getBuffer(2, 2);
      expect(child1.readableBytes, 2);
      expect(child1.readBytes(2), [0x45, 0x67]);
      var child2 = buffer.viewBuffer(2, 2);
      expect(child2.readableBytes, 0);
    });
  });
}
