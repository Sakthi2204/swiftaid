import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'login_screen.dart';
import 'report_screen.dart';

class UserSelectionScreen extends StatefulWidget {
  @override
  _UserSelectionScreenState createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermissions(); // Request permissions as soon as screen loads
  }

  Future<void> _requestPermissions() async {
    // Request foreground location permission
    PermissionStatus locationStatus = await Permission.location.request();

    // Request background location if foreground is granted
    if (locationStatus.isGranted) {
      await Permission.locationAlways.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select User Type")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()), // Driver Login
                );
              },
              child: Text("I am a Driver"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportScreen()), // Accident Reporting
                );
              },
              child: Text("I am a Regular User"),
            ),
          ],
        ),
      ),
    );
  }
}
