class Range {
  final double start;
  final double end;
  Range(this.start, this.end);

  bool overlaps(Range other) {
    if (other.start > start && other.start < end) return true;
    if (other.end > end && other.end < end) return true;
    return false;
  }

  static bool between(int number, int floor, int ciel) {
    return number > floor && number <= ciel;
  }
}

extension Between on num {
  bool between(num floor, num ceiling) {
    return this > floor && this <= ceiling;
  }
}
