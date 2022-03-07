import 'bytebuf_base.dart';
import 'bytebuf_allocator.dart';
import 'allocators/instant_restructuring_allocator.dart';

class Pooled {

  Pooled._() {
    throw Exception("Can't construct static utility class");
  }

  /// Creates a new [ByteBufAllocator] with the default [ByteBufAllocator.capacity] of [kDefaultByteBufSize] or if specified [initialCapacity] and
  /// the default [ByteBufAllocator.maxCapacity] of [kDefaultMaxByteBufSize] or if specified [maxCapacity].
  static ByteBufAllocator allocator({int? initialCapacity, int? maxCapacity}) {
    var backingBuffer = ByteBuf.createHeap(initialCapacity: initialCapacity, maxCapacity: maxCapacity);
    return InstantRestructuringAllocator(backingBuffer);
  }

  /// Creates a new [ByteBufAllocator] with both [ByteBufAllocator.capacity] and [ByteBufAllocator.maxCapacity]
  /// being set to [size].
  static ByteBufAllocator fixedAllocator(int size) => allocator(
    initialCapacity: size,
    maxCapacity: size
  );

}