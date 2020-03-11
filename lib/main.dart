import 'package:flutter/material.dart';

import 'app_constants.dart';
import 'pulsar_screen.dart';
import 'services/realtime_data_service.dart';
import 'services/service_locator.dart';

void main() {
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(title: 'Flutter Realtime Chart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RealtimeDataService _dataService = locator<RealtimeDataService>();

  void _togglePulsar() {
    if (_dataService.isRunning) {
      _dataService.stop();
    } else {
      _dataService.start();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: kBackgroundColor,
      ),
      backgroundColor: kBackgroundColorDark,
      body: PulsarScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePulsar,
        child: Icon(
          _dataService.isRunning ? Icons.pause : Icons.play_arrow,
          color: kBackgroundColorDark,
        ),
      ),
    );
  }
}
