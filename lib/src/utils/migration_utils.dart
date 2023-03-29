import 'dart:typed_data';

import '../bytebuf_base.dart';

class MigrationUtils {
  MigrationUtils._() {
    throw Exception("Can't construct static utility class");
  }

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

  static void readTo(ByteBuf a, ByteBuf b) {
    for (int i = 0; i < a.readableBytes; i++) {
      b[i] = a.readByte();
    }
  }

  static void copyTo(ByteBuf a, ByteBuf b) {
    for (int i = 0; i < a.capacity(); i++) {
      b[i] = a[i];
    }
  }
}
