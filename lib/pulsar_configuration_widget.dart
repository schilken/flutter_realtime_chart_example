import 'package:flutter/material.dart';

import 'app_constants.dart';
import 'services/realtime_data_service.dart';
import 'services/service_locator.dart';

class ConfigurationWidget extends StatefulWidget {
  
  @override
  _ConfigurationWidgetState createState() => _ConfigurationWidgetState();
}

class _ConfigurationWidgetState extends State<ConfigurationWidget> {

  RealtimeDataService _dataService =  locator<RealtimeDataService>();
  double _sliderValue = 0.4;
  RangeValues _sliderRange = RangeValues(25, 75);

  void updateSliderValues(double value) {
    setState(() {
      _sliderValue = value;
      _dataService.setFrequency(value);
    });
  }

  setSliderRangeValues(RangeValues range) {
    setState(() {
      _sliderRange = range;
      _dataService.setValueRange(range);
    });
  }

  @override
  Widget build(BuildContext context) {
    //print("_ConfigurationWidgetState build");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RangeSlider(
          values: _sliderRange,
          min: 0,
          max: 100,
          activeColor: kSliderColor,
          onChanged: setSliderRangeValues,
        ),
        Slider(
          value: _sliderValue,
          min: 0.1,
          max: 0.7,
          activeColor: kSliderColor,
          onChanged: updateSliderValues,
        ),
      ],
    );
  }
}