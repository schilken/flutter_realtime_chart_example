import 'package:flutter/material.dart';

import 'pulsar_configuration_widget.dart';
import 'realtime_chart.dart';
import 'services/realtime_data_service.dart';
import 'services/service_locator.dart';

class PulsarScreen extends StatefulWidget {
 
  @override
  _PulsarScreenState createState() => _PulsarScreenState();
}

class _PulsarScreenState extends State<PulsarScreen> {
  RealtimeChart _realtimeChart = RealtimeChart(locator<RealtimeDataService>().dataStream);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Container(height: 150, child: _realtimeChart),
          SizedBox(
            height: 10,
          ),
          ConfigurationWidget(),
        ],
      ),
    );
  }
}
