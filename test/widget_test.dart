import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Geo Demo',
      theme: ThemeData(useMaterial3: true),
      home: const LocationPage(),
    );
  }
}

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String _status = 'Waiting...';
  Position? _pos;

  @override
  void initState() {
    super.initState();
    _ensurePermission(); // يطلب الصلاحية عند التشغيل
  }

  Future<void> _ensurePermission() async {
    setState(() => _status = 'Checking permission...');

    // تأكد أن خدمة الموقع مفعّلة على الجهاز/المحاكي
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _status = 'Location service is OFF. Please enable it.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _status =
      'Permission denied forever. Open app settings to enable.');
      await Geolocator.openAppSettings(); // يفتح إعدادات التطبيق
      return;
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      setState(() => _status = 'Permission granted ✅');
    } else {
      setState(() => _status = 'Permission not granted.');
    }
  }

  Future<void> _getLocation() async {
    try {
      setState(() => _status = 'Getting current position...');
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _pos = position;
        _status = 'Location fetched ✅';
      });
    } catch (e) {
      setState(() => _status = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loca tion')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: $_status'),
            const SizedBox(height: 12),
            if (_pos != null)
              Text('Lat: ${_pos!.latitude}, Lng: ${_pos!.longitude}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _ensurePermission,
              child: const Text('Request permission again'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _getLocation,
              child: const Text('Get current location'),
            ),
          ],
        ),
      ),
    );
  }
}
