import 'package:flutter/material.dart';

import 'pulsar_configuration_widget.dart';
import 'realtime_chart.dart';

class PulsarScreen extends StatefulWidget {
 
  @override
  _PulsarScreenState createState() => _PulsarScreenState();
}

class _PulsarScreenState extends State<PulsarScreen> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Container(height: 150, child: RealtimeChart()),
          SizedBox(
            height: 10,
          ),
          ConfigurationWidget(),
        ],
      ),
    );
  }
}
