import 'package:flutter/material.dart';
import 'package:front/color.dart';
import 'package:front/component/custom_button_auth.dart';
import 'package:front/component/customdrawer.dart';
import 'package:front/component/customtextformfield.dart';
import 'package:front/component/editprofile.dart';
import 'package:front/provider/user_provider.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';


//import 'package:gap/gap.dart';

enum ProfileMode { assistant, patient }

enum UserRole { assistant, volunteer }

bool hasDrivingLicense = false;

class ViewInfo extends StatefulWidget {
  const ViewInfo({super.key});

  @override
  State<ViewInfo> createState() => _ViewInfoState();
}

class _ViewInfoState extends State<ViewInfo> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ProfileMode currentMode = ProfileMode.assistant;
  UserRole userRole = UserRole.assistant;

  @override
  void initState() {
    super.initState();
    if (userRole == UserRole.assistant) {
      currentMode = ProfileMode.assistant;
    }
  }

  //================== MOCK DATA ==================

  // final Map<String, String> volunteerData = {
  //   "username": "volunteer name",
  //   "phone": "079xxxxxxx",
  //   "address": "Amman",
  // };

  // final Map<String, String> assistantData = {
  //   "username": "moka",
  //   "email": "moka@gmail.com",
  //   "age": "22",
  //   "phone": "0795461724",
  //   "address": "Amman",
  // };

  // final Map<String, String> patientData = {
  //   "username": "patient name",
  //   "age": "22",
  //   "phone": "0795461724",
  //   "address": "Amman",
  //   "type": "deaf/blind",
  // };

  //================== CURRENT DATA ==================

  // Map<String, String> get currentData {
  //   if (userRole == UserRole.volunteer) {
  //     return volunteerData;
  //   }

  //   return currentMode == ProfileMode.assistant ? assistantData : patientData;
  // }
Map<String, String> get currentData {
  final user = context.read<UserProvider>();

  if (user.role == 'volunteer') {
    return {
      "username": user.name ?? '',
      "phone": user.phone ?? '',
      "address": '',
    };
  }

  if (currentMode == ProfileMode.assistant) {
    return {
      "username": user.name ?? '',
      "email": user.email ?? '',
      "phone": user.phone ?? '',
      "address": '',
    };
  } else {
    // patient (blind / deaf)
    return {
      "username": user.name ?? '',
      "phone": user.phone ?? '',
      "address": '',
      "type": user.role ?? '',
    };
  }
}

  //================== BUILD TABS ==================

  Widget buildTabs() {
    if (userRole == UserRole.volunteer) {
      return const SizedBox();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        tabItem(
          title: "Assistant",
          selected: currentMode == ProfileMode.assistant,
          onTap: () {
            setState(() {
              currentMode = ProfileMode.assistant;
            });
          },
        ),
        const SizedBox(width: 30),
        tabItem(
          title: "Patient",
          selected: currentMode == ProfileMode.patient,
          onTap: () {
            setState(() {
              currentMode = ProfileMode.patient;
            });
          },
        ),
      ],
    );
  }

  Widget tabItem({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: selected
                  ? AppColors.n10
                  : const Color.fromARGB(255, 124, 123, 123),
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: selected ? 60 : 0,
            color: AppColors.n10,
          ),
        ],
      ),
    );
  }

  //================== HEADER ==================

  Widget _buildHeader() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.n1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(200, 171, 215, 255),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(Icons.support_agent_rounded,
                  size: 60,
                  color: AppColors.n4,),
          ),
          
        ],
      ),
    );
  }

  //================== WHITE CONTAINER ==================

  Widget _buildWhiteContainer() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 590,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListView(padding: const EdgeInsets.all(16), children: [
          buildTabs(),
          const SizedBox(height: 20),
      CustomTextFormField(
  labeltext: "User Name",
  hinttext: currentData["username"],
  readonly: true,
),

          if (currentMode == ProfileMode.assistant)
            CustomTextFormField(
              labeltext: "Email",
              hinttext: currentData["email"],
              readonly: true,
            ),

            if (currentMode == ProfileMode.assistant)
              CustomTextFormField(
                labeltext: "Email",
                hinttext: currentData["email"],
                readonly: true,
              ),

            if (currentMode == ProfileMode.patient) ...[
              CustomTextFormField(
                labeltext: "Age",
                hinttext: currentData["age"],
                readonly: true,
              ),
              CustomTextFormField(
                labeltext: "Phone",
                hinttext: currentData["phone"],
                readonly: true,
              ),
              CustomTextFormField(
                labeltext: "Address",
                hinttext: currentData["address"],
                readonly: true,
              ),
            ],

            //const SizedBox(height: 20,),
            Padding(
              padding: EdgeInsetsGeometry.only(top: 10, left: 50,right: 50),
              child: CustomButtonAuth(
                
                title: currentMode == ProfileMode.assistant
                    ? "Edit My Profile"
                    : "Edit Patient Profile",
                onPressed: () {
                        Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfile(
                    userRole: userRole, 
                    isPatient: currentMode == ProfileMode.patient,
                  ),
                ),
              );
              },
                        ),
            ),
        ]),
      ),
    );
  }

  //================== BUILD ==================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            _buildHeader(),
            _buildWhiteContainer(),
          ],
        ),
      ),
    );
  }
}
