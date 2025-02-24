import 'package:flutter/material.dart';
import 'package:flutter_radar/flutter_radar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  final bool isDriver;
  HomeScreen({required this.isDriver});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _trackingStatus = "Not Started";
  String _location = "Unknown";

  @override
  void initState() {
    super.initState();
    if (widget.isDriver) {
      _startTracking();
    }
  }

  Future<void> _trackOnce() async {
    try {
      var res = await Radar.trackOnce();
      if (res != null && res['location'] != null) {
        double lat = res['location']['latitude'] ?? 0.0;
        double lng = res['location']['longitude'] ?? 0.0;
        setState(() {
          _location = "Lat: $lat, Lng: $lng";
        });
      }
    } catch (e) {
      setState(() {
        _location = "Error retrieving location";
      });
    }
  }

  Future<void> _startTracking() async {
    await Radar.startTracking('continuous');
    setState(() {
      _trackingStatus = "Tracking Started";
    });
  }

  Future<void> _stopTracking() async {
    await Radar.stopTracking();
    setState(() {
      _trackingStatus = "Tracking Stopped";
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Driver Tracking"), actions: [
        IconButton(icon: Icon(Icons.logout), onPressed: _logout),
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tracking Status: $_trackingStatus"),
            Text("Location: $_location"),
            ElevatedButton(onPressed: _trackOnce, child: Text("Track Once")),
            ElevatedButton(onPressed: _stopTracking, child: Text("Stop Tracking")),
          ],
        ),
      ),
    );
  }
}
