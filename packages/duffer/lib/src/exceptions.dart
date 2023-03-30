part of 'bytebuf_base.dart';

/// Exceptions relating to duffer buffers
abstract class BufferException implements Exception {
  String get message;
}

/// Buffer is not a child of the allocator
class BufferAllocatorUnknownChildException implements BufferException {
  @override
  String get message => "Buffer is not a child of the allocator";
}

/// Buffer is already released
class BufferReleasedException implements BufferException {
  @override
  String get message => "Buffer is already released";
}

/// Write operation overflows buffer
class BufferOverflowException implements BufferException {
  @override
  String get message => "Write operation overflows buffer";
}

/// Read operation overflows buffer
class BufferOverreadException implements BufferException {
  @override
  String get message => "Read operation overflows buffer";
}

/// Read operation at an overflowing index
class ReadIndexOutOfRangeException implements BufferException {
  @override
  String get message => "Read operation at an overflowing index";
}

/// Write operation at an overflowing index
class WriteIndexOutOfRangeException implements BufferException {
  @override
  String get message => "Write operation at an overflowing index";
}

/// Can't allocate more heap because of buffer constraints
class BufferConstrainedException implements BufferException {
  @override
  String get message =>
      "Can't allocate more heap because of buffer constraints";
}

/// The current index is not available
class IndexNotAvailableException implements BufferException {
  @override
  String get message => "The current index is not available";
}
