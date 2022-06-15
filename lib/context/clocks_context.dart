typedef ClockTime = DateTime;

class ClocksContext {
  Stream<ClockTime>? get getWatch =>
      Stream.periodic(const Duration(milliseconds: 1000), (_) {
        return ClockTime.now();
      });
}
