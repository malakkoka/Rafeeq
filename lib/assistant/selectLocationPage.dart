//شو بصير هون؟
//المستخدم يضغط على الخريطة
//ينحط Pin
//لما يضغط Confirm Location نرجّع الإحداثيات



// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:front/color.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({super.key});

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  LatLng selectedPosition = const LatLng(31.9539, 35.9106); // Amman default
  Marker? marker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Select Location'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: selectedPosition,
              zoom: 15,
            ),
            onTap: (latLng) {
              setState(() {
                selectedPosition = latLng;
                marker = Marker(
                  markerId: const MarkerId('selected'),
                  position: latLng,
                );
              });
            },
            markers: marker != null ? {marker!} : {},
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, {
                  'lat': selectedPosition.latitude,
                  'lng': selectedPosition.longitude,
                });
              },
              child: const Text(
                'Confirm Location',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
