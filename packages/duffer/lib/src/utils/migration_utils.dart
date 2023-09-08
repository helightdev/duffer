import 'dart:typed_data';

import '../bytebuf_base.dart';

/// A utility class for migrating [ByteData]s or [ByteBuf]s.
class MigrationUtils {
  MigrationUtils._() {
    throw Exception("Can't construct static utility class");
  }

  /// Migrates a [ByteData] to a new capacity.
  static ByteData migrate(ByteData original, int newCapacity) {
    var delta = newCapacity - original.lengthInBytes;
    if (delta < 0) {
      throw UnimplementedError("Shrinking buffers is currently not supported");
    }
    var data = ByteData(newCapacity);
    for (var i = 0; i < original.lengthInBytes; i++) {
      data.setUint8(i, original.getUint8(i));
    }
    return data;
  }

  /// Reads the contents of [a] into [b] using [ByteBuf.readByte] of [a].
  /// Does ignore the writer index of [b].
  static void readTo(ByteBuf a, ByteBuf b) {
    for (int i = 0; i < a.readableBytes; i++) {
      b[i] = a.readByte();
    }
  }

  /// Copies the contents of [a] into [b].
  /// Does ignore the writer index of [b].
  static void copyTo(ByteBuf a, ByteBuf b) {
    for (int i = 0; i < a.capacity(); i++) {
      b[i] = a[i];
    }
  }
}
