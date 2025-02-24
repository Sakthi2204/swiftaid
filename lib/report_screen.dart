import 'package:flutter/material.dart';
import 'package:flutter_radar/flutter_radar.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String _status = "Idle";

  Future<void> _sendAccidentAlert() async {
    var res = await Radar.trackOnce();
    if (res != null && res['location'] != null) {
      double lat = res['location']['latitude'] ?? 0.0;
      double lng = res['location']['longitude'] ?? 0.0;

      setState(() {
        _status = "Accident reported at Lat: $lat, Lng: $lng";
      });

      // TODO: Implement backend call to notify ambulances
    } else {
      setState(() {
        _status = "Failed to get location";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Report an Accident")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Status: $_status"),
            ElevatedButton(onPressed: _sendAccidentAlert, child: Text("Report Accident")),
          ],
        ),
      ),
    );
  }
}
