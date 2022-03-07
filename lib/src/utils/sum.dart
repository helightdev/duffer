extension SumExtension on Iterable<int> {

  int sum() => fold(0, (previousValue, element) => previousValue + element);

}