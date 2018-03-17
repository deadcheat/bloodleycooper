class Timing {
  final int value;
  const Timing({
    this.value,
  });

  static const int evening = 1;
  static const int morning = 2;

  static const Timing EVENING = const Timing(
    value: evening,
  );
  static const Timing MORNING = const Timing(
    value: morning,
  );
  @override
  String toString() {
    switch (this.value) {
      case evening:
        return "Evening";
      case morning:
        return "Morning";
      default:
        throw new StateError("value is unexpected");
    }
  }

  int toCode() {
    return this.value;
  }

  @override
  bool operator ==(o) => o is Timing && o.value == this.value;
  @override
  int get hashCode => this.value.hashCode;
}
