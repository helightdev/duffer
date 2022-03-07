part of 'bytebuf_base.dart';

abstract class BufferException implements Exception {
  String get message;
}

class BufferAllocatorUnknownChildException implements BufferException {
  @override
  String get message => "Buffer is not a child of the allocator";
}

class BufferReleasedException implements BufferException {
  @override
  String get message => "Buffer is already released";
}

class BufferOverflowException implements BufferException {
  String get message => "Write operation overflows buffer";
}

class BufferOverreadException implements BufferException {
  String get message => "Read operation overflows buffer";
}

class ReadIndexOutOfRangeException implements BufferException {
  @override
  String get message => "Read operation at an overflowing index";
}

class WriteIndexOutOfRangeException implements BufferException {
  @override
  String get message => "Write operation at an overflowing index";
}

class BufferConstrainedException implements BufferException {
  @override
  String get message =>
      "Can't allocate more heap because of buffer constraints";
}
