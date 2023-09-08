import 'package:duffer/duffer.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test("Find match", () {
    var haystack = ByteBuf.fromData([1, 2, 3, 4, 5, 6, 7]);
    var needle = ByteBuf.fromData([3, 4]);
    int index = ByteBuf.indexOf(haystack, needle);
    expect(index, 2);
  });

  test("Find same", () {
    var haystack = ByteBuf.fromData([1, 2, 3, 4, 5, 6, 7]);
    var needle = ByteBuf.fromData([1, 2, 3, 4, 5, 6, 7]);
    int index = ByteBuf.indexOf(haystack, needle);
    expect(index, 0);
  });

  test("Find first", () {
    var haystack = ByteBuf.fromData([
      1,
      2,
      3,
      4,
      1,
      2,
      3,
      4,
    ]);
    var needle = ByteBuf.fromData([3, 4]);
    int index = ByteBuf.indexOf(haystack, needle);
    expect(index, 2);
  });

  test("Find invalid", () {
    var haystack = ByteBuf.fromData([1, 2, 3, 4, 5, 6, 7]);
    var needle = ByteBuf.fromData([5, 7]);
    int index = ByteBuf.indexOf(haystack, needle);
    expect(index, -1);
  });

  test("Find longer", () {
    var haystack = ByteBuf.fromData([1, 2, 3, 4, 5, 6, 7]);
    var needle = ByteBuf.fromData([1, 2, 3, 4, 5, 6, 7, 8]);
    int index = ByteBuf.indexOf(haystack, needle);
    expect(index, -1);
  });
}
