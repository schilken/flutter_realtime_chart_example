
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
 
  void setSliderValue(double value);

  void setSliderRangeValues(RangeValues range);

  void closeDataStream();

  void start();

  void stop();

  bool isRunning;
  }