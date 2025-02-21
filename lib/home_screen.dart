import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radar/flutter_radar.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _trackingStatus = "Not Started";
  String _location = "Unknown";

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  /// Request location and foreground service permissions (Android 14+)
  Future<void> _requestPermissions() async {
    // Request foreground location permission
    PermissionStatus locationStatus = await Permission.location.request();

    // Request background location permission if foreground is granted
    if (locationStatus.isGranted) {
      await Permission.locationAlways.request();
    }

    // Manually request Foreground Service Location Permission for Android 14+
    if (Platform.isAndroid && int.parse(Platform.version.split('.')[0]) >= 14) {
      const MethodChannel _channel = MethodChannel('flutter_radar_permissions');
      try {
        await _channel.invokeMethod('requestForegroundServicePermission');
      } catch (e) {
        print("Error requesting Foreground Service Permission: $e");
      }
    }

    // Check Radar SDK permission status
    String? radarStatus = await Radar.getPermissionsStatus();
    if (radarStatus == "NOT_DETERMINED" || radarStatus == "DENIED") {
      await Radar.requestPermissions(true);
    }

    setState(() {
      _trackingStatus = radarStatus ?? "Unknown";
    });
  }

  /// Track user location once (Foreground tracking)
  Future<void> _trackOnce() async {
    try {
      var res = await Radar.trackOnce();

      if (res != null && res['location'] != null) {
        double lat = res['location']['latitude'] ?? 0.0;
        double lng = res['location']['longitude'] ?? 0.0;

        setState(() {
          _location = "Lat: $lat, Lng: $lng";
        });
      } else {
        setState(() {
          _location = "Location not available";
        });
      }
    } catch (e) {
      print("🚨 Error tracking location: $e");
      setState(() {
        _location = "Error retrieving location";
      });
    }
  }

  /// Start background tracking
  Future<void> _startTracking() async {
    await Radar.startTracking('continuous'); // Options: 'efficient', 'responsive', 'continuous'
    setState(() {
      _trackingStatus = "Tracking Started";
    });
  }

  /// Stop background tracking
  Future<void> _stopTracking() async {
    await Radar.stopTracking();
    setState(() {
      _trackingStatus = "Tracking Stopped";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Radar Tracking")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tracking Status: $_trackingStatus", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Location: $_location", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _trackOnce,
              child: Text("Track Once"),
            ),
            ElevatedButton(
              onPressed: _startTracking,
              child: Text("Start Tracking"),
            ),
            ElevatedButton(
              onPressed: _stopTracking,
              child: Text("Stop Tracking"),
            ),
          ],
        ),
      ),
    );
  }
}
