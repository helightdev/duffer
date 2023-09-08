extension SumExtension on Iterable<int> {
  /// Returns the sum of all elements in the collection.
  int sum() => fold(0, (previousValue, element) => previousValue + element);
}
