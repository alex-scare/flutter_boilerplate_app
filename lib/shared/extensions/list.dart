extension ListExt<T> on List<T> {
  void toggle(T item) {
    if (contains(item)) {
      remove(item);
    } else {
      add(item);
    }
  }
}

extension IterableExt<T> on Iterable<T> {
  R foldWithIndex<R>(R initialValue, R Function(R, T, int) callback) {
    var index = 0;
    var result = initialValue;
    for (var element in this) {
      result = callback(result, element, index);
      index++;
    }
    return result;
  }

  void forEachWithIndex(void Function(T, int) callback) {
    var index = 0;
    for (var element in this) {
      callback(element, index);
      index++;
    }
  }
}
