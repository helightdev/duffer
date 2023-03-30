part of 'polymorphic.dart';

class DateTimePickler extends Pickler<DateTime> {
  static const String ID = "dt";

  DateTimePickler() : super(ID);

  @override
  int peekSize(DateTime object) {
    return Sizes.int64;
  }

  @override
  void pickle(ByteBuf buf, DateTime object) {
    buf.writeInt64(object.millisecondsSinceEpoch);
  }

  @override
  DateTime unpickle(ByteBuf buf) {
    return DateTime.fromMillisecondsSinceEpoch(buf.readInt64());
  }
}

class DurationPickler extends Pickler<Duration> {
  static const String ID = "du";

  DurationPickler() : super(ID);

  @override
  int peekSize(Duration object) {
    return Sizes.int64;
  }

  @override
  void pickle(ByteBuf buf, Duration object) {
    buf.writeInt64(object.inMilliseconds);
  }

  @override
  Duration unpickle(ByteBuf buf) {
    return Duration(milliseconds: buf.readInt64());
  }
}
