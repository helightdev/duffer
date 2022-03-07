part of '../extensions.dart';

extension Uint8ListMigrationExtension on Uint8List {

  /// Migrates this list by wrapping it using [ListBuffer]
  ByteBuf get asWrappedBuffer => ListBuffer(this);

}

extension IntListMigrationExtension on List<int> {

  /// Migrates this list to a [ByteBuf] by copying it.
  ByteBuf get asBuffer => ByteBuf.fromData(this); // Also applies to uint8 list for non wrapping migration

}