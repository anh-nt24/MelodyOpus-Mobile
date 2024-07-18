class DurationState {
  final Duration progress;
  final Duration buffer;
  final Duration? total;

  DurationState({
    required this.progress,
    required this.buffer,
    this.total
  });
}