import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/common_interfaces.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_line_data_set.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/axis_dependency.dart';
import 'package:mp_chart/mp/core/enums/legend_form.dart';
import 'package:mp_chart/mp/core/highlight/highlight.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';

import 'util.dart';
import 'app_constants.dart';
import 'services/realtime_data_service.dart';
import 'services/service_locator.dart';

class RealtimeChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RealtimeChartState();
  }
}

class RealtimeChartState extends State<RealtimeChart>
    implements OnChartValueSelectedListener {
  LineChartController controller;

  static const int VISIBLE_COUNT = 60;
  int _removalCounter = 0;
  Stream<DataSet> _dataStream = locator<RealtimeDataService>().dataStream;
  StreamSubscription<DataSet> _streamSubscription;

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    print("initState RealtimeChartState");
    _initController();
    _streamSubscription = _dataStream.listen((dataSet) {
      //print("dataSet: ${dataSet.y0}");
      addEntry(dataSet.y0, dataSet.y1);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          right: 0,
          left: 0,
          top: 0,
          bottom: 0,
          child: LineChart(controller),
        ),
      ],
    );
  }

  LineDataSet _createSet(int ix) {
    LineDataSet set = LineDataSet(null, "y$ix");
    set.setAxisDependency(AxisDependency.LEFT);
    set.setColor1(ix == 0 ? Colors.red : Colors.orangeAccent);
    set.setCircleColor(ColorUtils.WHITE);
    set.setLineWidth(ix == 0 ? 6.0 : 3.0);
    set.setDrawValues(false);
    set.setDrawCircles(false);
    return set;
  }

  void addWithRemove(ILineDataSet set0, LineData data, double y0, double y1) {
    double x = (set0.getEntryCount() + _removalCounter).toDouble();
    //print("x0: $x  entryCount: ${set0.getEntryCount()}: $y0 $y1 ");
    data.addEntry(
        Entry(
          x: x,
          y: y0,
        ),
        0);
    data.addEntry(
        Entry(
          x: x,
          y: y1,
        ),
        1);
    //remove entry which is out of visible range
    if (set0.getEntryCount() > VISIBLE_COUNT) {
      data.removeEntry2(_removalCounter.toDouble(), 0);
      data.removeEntry2(_removalCounter.toDouble(), 1);
      _removalCounter++;
    }
  }

  void _initController() {
    // print("_initController");
    var desc = Description()..enabled = false;
    controller = LineChartController(
        legendSettingFunction: (legend, controller) {
          legend
            ..shape = LegendForm.LINE
            ..typeface = Util.LIGHT
            ..textColor = ColorUtils.BLUE
            ..enabled = false;
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis
            ..typeface = Util.LIGHT
            ..textColor = ColorUtils.WHITE
            ..drawGridLines = false
            ..avoidFirstLastClipping = true
            ..enabled = false;
          //xAxis.drawLabels = false;
        },
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft
            ..typeface = Util.LIGHT
            ..textColor = ColorUtils.BLUE
            ..drawGridLines = false
            ..enabled = false;
          axisLeft.setAxisMaximum(105.0);
          axisLeft.setAxisMinimum(-5.0);
          axisLeft.setDrawZeroLine(false);
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight.enabled = false;
        },
        drawGridBackground: false,
        dragXEnabled: false,
        dragYEnabled: false,
        scaleXEnabled: true,
        scaleYEnabled: false,
        backgroundColor: kBackgroundColor,
        selectionListener: this,
        pinchZoomEnabled: false,
        autoScaleMinMaxEnabled: false,
        minOffset: 0,
        description: desc,
        infoTextColor: kSliderColor,
        maxVisibleCount: 60,
        infoBgColor: kBackgroundColor);

    LineData data = controller?.data;

    if (data == null) {
      data = LineData();
      controller.data = data;
      if (data != null) {
        ILineDataSet set0 = data.getDataSetByIndex(0);
        if (set0 == null) {
          print("createSet");
          set0 = _createSet(0);
          data.addDataSet(set0);
          data.addDataSet(_createSet(1));
          for (var nn = 0; nn < VISIBLE_COUNT; nn++) {
            addWithRemove(set0, data, 50, 50);
            //controller.moveViewToX(data.getEntryCount().toDouble());
          }
        }
      }
    }
  }

  @override
  void onNothingSelected() {}

  @override
  void onValueSelected(Entry e, Highlight h) {}

  void addEntry(double y0, double y1) {
    //print("y: ${y0.toInt()} ${y1.toInt()}");
    LineData data = controller.data;
    if (data != null) {
      ILineDataSet set0 = data.getDataSetByIndex(0);
      addWithRemove(set0, data, y0, y1);
      controller.setVisibleXRangeMaximum(VISIBLE_COUNT.toDouble());
      controller.moveViewToX(data.getEntryCount().toDouble());
      controller.state?.setStateIfNotDispose();
    }
  }
}
