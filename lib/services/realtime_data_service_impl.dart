import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'realtime_data_service.dart';

class RealtimeDataServiceImpl extends RealtimeDataService {
  double _sliderValue = 0.5;
  RangeValues _sliderRange = RangeValues(25, 75);
  double _y0 = 0;
  double _y1 = 0;
  StreamController<DataSet> _streamController;
  Timer _timer;
  double _lastValue = 0;

  bool get isRunning {
    bool result = (_timer != null);
    return result;
  }

  double get _amplitude {
    return _sliderRange.end - _sliderRange.start;
  }

  RealtimeDataServiceImpl() {
    print("new RealtimeDataServiceImpl");
  }

  void nextSin() {
    _lastValue += _sliderValue;
    double yNorm = sin(_lastValue);
    double yNormPositive = (yNorm + 1.0) / 2.0;
    if (_sliderValue == 0.7) {
      yNormPositive = 1.0;
    }
    _y0 = _sliderRange.start + yNormPositive * _amplitude;
    _y1 = _sliderRange.start + (1 - yNormPositive) * _amplitude;
  }

  void tick(_) {
    nextSin();
    _streamController.add(DataSet(_y0, _y1, _sliderValue,
        _sliderRange)); // Ask stream to send counter values as event.
  }

  @override
  void start() {
    if (_timer == null) {
      _timer = Timer.periodic(Duration(milliseconds: 40), tick);
    }
  }

  @override
  void stop() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  @override
  Stream<DataSet> get dataStream {
    if (_streamController == null) {
      _streamController = StreamController.broadcast(
        onListen: start,
        onCancel: stop,
      );
    }
    return _streamController.stream;
  }

  @override
  void setSliderValue(double value) {
    _sliderValue = value;
  }

  @override
  void setSliderRangeValues(RangeValues range) {
    _sliderRange = range;
  }

  @override
  void closeDataStream() {
    _streamController.close();
  }
}
