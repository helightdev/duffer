import 'dart:typed_data';
import 'dart:io';

import 'package:duffer/duffer.dart';
import 'package:duffer/src/impl/byte_data_buffer.dart';
import 'package:meta/meta.dart';

@experimental
class RandomAccessFileByteBuf extends ByteBuf {

  RandomAccessFile file;

  RandomAccessFileByteBuf(this.file);

  List<MapEntry<int, Uint8List>> activeViews = [];

  @override
  void allocate(int bytes) {
    file.setPositionSync(file.lengthSync());
    file.writeFromSync(List.filled(bytes, 0x00));
  }

  @override
  Uint8List array() {
    writeActiveBuffers();
    file.setPositionSync(0);
    var targetBuffer = Uint8List(capacity());
    file.readIntoSync(targetBuffer);
    return targetBuffer;
  }

  @override
  int capacity() => file.lengthSync();

  @override
  int getByte(int index) {
    writeActiveBuffers();
    file.setPositionSync(index);
    return file.readByteSync();
  }

  @override
  void writeBytes(List<int> bytes) {
    writeActiveBuffers();
    var j = bytes.length;
    ensureWritable(j);
    assertWriteable(writerIndex, j);
    file.setPositionSync(writerIndex);
    file.writeFromSync(bytes);
    writerIndex = writerIndex + j;
  }

  @override
  void setBytes(int index, List<int> bytes) {
    writeActiveBuffers();
    assertWriteable(index, bytes.length);
    file.setPositionSync(index);
    file.writeFromSync(bytes);
  }

  @override
  Uint8List readBytes(int length) {
    writeActiveBuffers();
    assertReadable(readerIndex, length);
    file.setPositionSync(readerIndex);
    readerIndex += length;
    return file.readSync(length);
  }

  @override
  Uint8List getBytes(int index, int length) {
    writeActiveBuffers();
    assertWriteable(index, length);
    file.setPositionSync(index);
    return file.readSync(length);
  }

  @override
  bool isGrowable() => true;

  @override
  void updateByte(int index, int byte) {
    file.setPositionSync(index);
    file.writeByteSync(byte);
  }

  @override
  ByteBuf viewBuffer(int index, int length) {
    return ByteDataBuffer(viewByteData(index, length));
  }

  @override
  ByteData viewByteData(int index, int length) {
    writeActiveBuffers();
    file.setPositionSync(index);
    var array = Uint8List(length);
    file.readIntoSync(array);
    activeViews.add(MapEntry(index, array));
    var data = ByteData.sublistView(array);
    return data;
  }

  @override
  ByteData writeByteData(int length) {
    ensureWritable(length);
    assertWriteable(writerIndex, length);
    file.setPositionSync(writerIndex);
    var array = file.readSync(length);
    activeViews.add(MapEntry(writerIndex, array));
    var data = ByteData.sublistView(array);
    writerIndex += length;
    return data;
  }

  @override
  ByteData readByteData(int length) {
    writeActiveBuffers();
    assertReadable(readerIndex, length);
    file.setPositionSync(readerIndex);
    var array = file.readSync(length);
    var data = ByteData.sublistView(array);
    readerIndex += length;
    return data;
  }

  @override
  ByteData getByteData(int index, int length) {
    writeActiveBuffers();
    assertWriteable(index, length);
    file.setPositionSync(index);
    var array = file.readSync(length);
    var data = ByteData.sublistView(array);
    return data;
  }

  @override
  ByteData setByteData(int index, int length) {
    assertWriteable(index, length);
    file.setPositionSync(index);
    var array = file.readSync(length);
    activeViews.add(MapEntry(index, array));
    var data = ByteData.sublistView(array);
    return data;
  }

  void writeActiveBuffers() {
    for (var value in activeViews) {
      file.setPositionSync(value.key);
      file.writeFromSync(value.value);
    }
  }

  void flush() {
    writeActiveBuffers();
    file.flushSync();
  }

  void close() {
    flush();
    file.closeSync();
  }

}