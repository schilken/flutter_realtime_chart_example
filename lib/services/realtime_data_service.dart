
import 'package:flutter/material.dart';

class DataSet {
  double y0;
  double y1;

  double slidervalue;
  RangeValues continuousValues = const RangeValues(25, 75);

  DataSet(this.y0, this.y1, this.slidervalue, this.continuousValues);
}

abstract class RealtimeDataService {

  Stream<DataSet> dataStream;
  void closeDataStream();
  void setFrequency(double value);
  void setValueRange(RangeValues range);
  void start();
  void stop();
  bool isRunning;
  }