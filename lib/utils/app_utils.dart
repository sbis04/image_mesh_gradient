T identity<T>(T t) => t;

extension DurationInt on int {
  Duration get hours => Duration(hours: this);
  Duration get minutes => Duration(minutes: this);
  Duration get seconds => Duration(seconds: this);
  Duration get millis => Duration(milliseconds: this);
  Duration get days => Duration(days: this);
  Iterable<int> get times => Iterable.generate(this, identity);
}

extension Flatten<T> on Iterable<Iterable<T>> {
  Iterable<T> get flatten => expand((i) => i);
}

extension FFIterableExtensions<T> on Iterable<T> {
  Iterable<MapEntry<int, T>> get enumerate => toList().asMap().entries;

  List<T> divide(T t) => isEmpty
      ? []
      : (enumerate.map((e) => [e.value, t]).flatten.toList()..removeLast());
}
