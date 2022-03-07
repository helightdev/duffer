import 'dart:math';

import 'package:duffer/duffer.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test("Valid", () {
    var allocator = Pooled.fixedAllocator(16);
    expect(allocator.free(), 16);
    expect(allocator.used(), 0);
    var a = allocator.allocate(4);
    var b = allocator.allocate(4);
    expect(allocator.free(), 8);
    expect(allocator.used(), 8);
    a.release();
    expect(allocator.free(), 12);
    expect(allocator.used(), 4);
    var c = allocator.allocate(12);
    expect(allocator.free(), 0);
    expect(allocator.used(), 16);
    b.release();
    c.release();
    expect(allocator.free(), 16);
    expect(allocator.used(), 0);
  });

  test("Integrity after release", () {
    var allocator = Pooled.fixedAllocator(16);
    var a = allocator.allocate(4);
    var b = allocator.allocate(4);
    var c = allocator.allocate(4);
    a.writeBytes(List.filled(4, 0x11));
    b.writeBytes(List.filled(4, 0x22));
    c.writeBytes(List.filled(4, 0x33));
    expect(allocator.used(), 12);
    expect(a.getByte(0), 0x11);
    expect(b.getByte(0), 0x22);
    expect(c.getByte(0), 0x33);
    b.release();
    expect(allocator.used(), 8);
    expect(a.getByte(0), 0x11);
    expect(c.getByte(0), 0x33);
    var d = allocator.allocate(8);
    expect(allocator.used(), 16);
    d.release();
    expect(allocator.used(), 8);
    a.release();
    expect(allocator.used(), 4);
    expect(c.getByte(0), 0x33);
  });

  test("Access after release", () {
    var allocator = Pooled.fixedAllocator(16);
    var a = allocator.allocate(4);
    expect(a.isReleased(), false);
    a.release();
    expect(a.isReleased(), true);
    expect(() {
      a.readByte();
    }, throwsException);
    expect(() {
      a.writeByte(0xFF);
    }, throwsException);
  });

  test("Constraints", () {
    var allocator = Pooled.allocator(initialCapacity: 1, maxCapacity: 32);
    expect(() {
      allocator.allocate(16);
      return true;
    }(), true);
    expect(() {
      allocator.allocate(16);
      return true;
    }(), true);
    expect(() {
      allocator.allocate(8);
    }, throwsException);
  });
}