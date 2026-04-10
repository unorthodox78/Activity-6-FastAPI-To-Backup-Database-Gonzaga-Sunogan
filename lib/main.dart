import 'package:flutter/material.dart';
import 'dart:html' as html; // Used for web-based direct downloads

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BackupScreen(),
  ));
}

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  String _status = "Ready to Backup Database";

  void _startBackup() {
    setState(() {
      _status = "Requesting backup from FastAPI...";
    });

    try {
      // Direct Link to your FastAPI endpoint
      const String url = "http://127.0.0.1:8000/download-student-backup";

      // Create invisible anchor and trigger download
      html.AnchorElement anchorElement = html.AnchorElement(href: url)
        ..setAttribute("download", "student_backup.gz")
        ..click();

      setState(() {
        _status = "Backup started! Check your browser downloads.";
      });
    } catch (e) {
      setState(() {
        _status = "Error: Unable to connect to server.";
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Database Manager"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_download, size: 100, color: Colors.blue),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _status,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _startBackup,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.play_arrow),
              label: const Text(
                "Click to Backup Database",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}