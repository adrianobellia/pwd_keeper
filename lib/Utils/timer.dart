import 'package:flutter/scheduler.dart';

class Timer {
  late Ticker _ticker;
  late int _elapsedSeconds;
  bool _started = false;
  final int _durationInSeconds;
  DateTime? _lastSystemTime;

  Timer({required TickerProvider vsync, required int durationInSeconds}):_elapsedSeconds = 0,_durationInSeconds = durationInSeconds {
    _ticker = vsync.createTicker((elapsed) {
      DateTime currentSystemTime = DateTime.now();
      if (_lastSystemTime != null) {
        Duration systemTimeDifference = currentSystemTime.difference(_lastSystemTime!);
        if (systemTimeDifference.abs() > const Duration(milliseconds: 49)) {
          reset();
        }
      }
      _lastSystemTime = currentSystemTime;
      _elapsedSeconds = elapsed.inSeconds;
      if (_elapsedSeconds >= _durationInSeconds) {
        stop();
      }
    });
  }
  void start() {
    if (!_started) {
      _ticker.start();
      _started = true;
    }
  }
  void reset() {
    if (_started) {
      _ticker.stop();
      _elapsedSeconds = 0;
      _ticker.start();
    }
  }
  void stop() {
    if (_started) {
      _ticker.stop();
      _started = false;
      _elapsedSeconds = 0;
    }
  }
  int get elapsedSeconds => _elapsedSeconds;
  bool get started => _started;
  void dispose() {
    _ticker.dispose();
  }
}