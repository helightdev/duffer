import 'dart:typed_data';

import 'utils/migration_utils.dart';
import 'bytebuf_base.dart';
import 'extensions.dart';

class Unpooled {

  Unpooled._() {
    throw Exception("Can't construct static utility class");
  }

  /// Creates a new [ByteBuf] with the default [ByteBuf.capacity] of [kDefaultByteBufSize] or if specified [initialCapacity] and
  /// the default [ByteBuf.maxCapacity] of [kDefaultMaxByteBufSize] or if specified [maxCapacity].
  static ByteBuf buffer({int? initialCapacity, int? maxCapacity}) => ByteBuf.create(
    initialCapacity: initialCapacity,
    maxCapacity: maxCapacity
  );

  /// Creates a new [ByteBuf] with both [ByteBuf.capacity] and [ByteBuf.maxCapacity]
  /// being set to [size].
  static ByteBuf fixed(int size) => ByteBuf.create(
      initialCapacity: size,
      maxCapacity: size
  );

  /// Copies the [bytes] to a new [ByteBuf].
  static ByteBuf copyBytes(List<int> bytes) => bytes.asBuffer;

  /// Copies the contents of [original] to a new [ByteBuf].
  /// The capacity parameters of the returned [ByteBuf] are
  /// equal to [original].
  static ByteBuf copyBuffer(ByteBuf original) {
    var buffer = ByteBuf.create(initialCapacity: original.capacity(), maxCapacity: original.maxCapacity);
    MigrationUtils.copyTo(original, buffer);
    return buffer;
  }

  /// Wraps the [native] buffer using a [ListBuffer], not allocating more memory.
  static ByteBuf wrapBuffer(Uint8List native) => native.asWrappedBuffer;

}