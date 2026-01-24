import 'package:flutter/material.dart';
import 'package:front/color.dart';
import 'package:front/component/customdrawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//LatLng احداثيات مكان=خطوط الطول وخطودوائر العرض  
  LatLng patientLocation = const LatLng(31.9539, 35.9106);
  GoogleMapController? mapController;

class Assistent extends StatefulWidget {
  const Assistent({super.key});

  

  @override
  State<Assistent> createState() => _AssistentState();
}
class _AssistentState extends State<Assistent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c7,
      appBar: AppBar(
        backgroundColor:AppColors.c2,
        title: Text("Assistent Page",style:
          TextStyle(color: AppColors.c8),),
      ),
      drawer: 
      
      CustomDrawer(),
      body: Container(
  padding: const EdgeInsets.all(8.0),
  color: AppColors.c8,
  child: Column(
    children: [
      Container(
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: AppColors.c8,
        ),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: patientLocation,
            zoom: 14,
          ),
          onMapCreated: (controller) {
            mapController = controller;
          },
          markers: {
            Marker(
              markerId: const MarkerId("patient"),
              position: patientLocation,
              infoWindow: const InfoWindow(
                title: "Patient Location",
              ),
            ),
          },
        ),
      ),
    ],
  ),
),
    );
  }
}