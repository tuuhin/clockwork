typedef ClockTime = DateTime;

class ClocksContext {
  Stream<ClockTime>? getWatch() =>
      Stream.periodic(const Duration(milliseconds: 1000), (_) {
        return ClockTime.now();
      });
}
