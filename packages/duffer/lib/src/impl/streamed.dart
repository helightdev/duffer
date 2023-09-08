import 'dart:async';
import 'dart:typed_data';

import 'package:duffer/duffer.dart';

/// A [ByteBuf] that allows to consume a [Stream] of [List]s or [Uint8List]s.
class StreamedByteBuf extends DelegatingByteBuf {

  @override
  ByteBuf backing;

  StreamedByteBuf(this.backing);

  final StreamController _doneController = StreamController.broadcast();
  final StreamController<int> _dataController = StreamController<int>.broadcast();
  bool _isDone = false;
  bool _isSubscribed = false;

  /// Consumes a int [List] or [Uint8List] and writes the bytes to the backing
  /// buffer. Returns the [StreamSubscription] created by the [Stream.listen].
  StreamSubscription consume(Stream stream) {
    if (_isSubscribed) throw Exception("Buffer is already subscribed to a stream");
    _isSubscribed = true;
    return stream.listen((event) {
      writeBytes(event);
      _dataController.add(event.length);
    }, onDone: () {
      _dataController.add(-1);
      _doneController.add(null);
      _isDone = true;
      _isSubscribed = false;
    });
  }

  /// Waits until a total of [len] bytes is readable.
  Future untilReadable(int len) async {
    if (_isDone) throw Exception("Stream is already done.");
    len -= readableBytes;
    if (len <= 0) return;
    await _dataController.stream.takeWhile((element) {
      if (element == -1) return false;
      len -= element;
      return len > 0;
    }).drain();
    if (len > 0) throw Exception("Stream is already done. ($len bytes left)");
  }

  /// Waits until [len] bytes haven been received.
  Future untilReceived(int len) async {
    if (_isDone) throw Exception("Stream is already done.");
    if (len <= 0) return;
    await _dataController.stream.takeWhile((element) {
      if (element == -1) return false;
      len -= element;
      return len > 0;
    }).drain();
    if (len > 0) throw Exception("Stream is already done. ($len bytes left)");
  }

  Future untilNextFrame() async {
    if (_isDone) throw Exception("Stream is already done.");
    await _dataController.stream.first;
  }

  Future untilDone() async {
    if (_isDone) return;
    await _doneController.stream.first;
  }

  void reset() {
    _isDone = false;
  }

}