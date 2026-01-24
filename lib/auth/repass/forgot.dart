import 'package:flutter/material.dart';
import 'package:front/color.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class Forgot extends StatefulWidget{
  const Forgot({super.key});

  @override
  State<Forgot>createState()=>_Forgotstate();

}

class _Forgotstate extends State<Forgot>{


  final TextEditingController email = TextEditingController();

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.dialogcolor,
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: SizedBox(
                  width:MediaQuery.of(context).size.width * 0.85,
                  child: Card(
                    color: AppColors.background,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 28,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                  179, 170, 234, 245),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Icon(
                              Icons.lock_open_rounded,
                              color: AppColors.n1,
                              size: 50,
                            ),
                          ),

                          const Gap(16),

                          Text(
                            'Forgot password?',
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: AppColors.n1,
                            ),
                          ),

                          const Gap(15),

                          SizedBox(
                            width: 230,
                            child: Text(
                              "Enter your email and we'll send you a reset code.",
                              textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 27, 27, 27),
                              ),
                            ),
                          ),
                          Gap(30),
                          
                          TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email_rounded,
                                color: AppColors.n1,
                                size: 35,),
                                hintText: "Enter your email",
                                filled: true,
                                fillColor: AppColors.dialogcolor,
                                border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: AppColors.n1),
                              ),
                              enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(color: AppColors.n1),
                              ),
                              focusedBorder:OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                color: AppColors.n1,
                                width: 2.5),
                              )
                            ),
                            
                          ),
                          
                          Gap(20),
                          SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.60,
                                child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all( 5),
                                backgroundColor:AppColors.n10,
                                shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                ),
                                  ),
                          onPressed: (){
                            Navigator.of(context)
                                      .pushReplacementNamed("getcode");
                          },
                              child: Text(
                                "send code",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                color: AppColors.dialogcolor,
                                fontSize: 26,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Gap(10),
                        InkWell(
  onTap: () {
    Navigator.of(context).pushReplacementNamed("login");
  },
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: const [
      Icon(Icons.arrow_back_rounded,color: AppColors.n1,),
      SizedBox(width: 8),
      Text("Back to login",
      style: TextStyle(
        color: AppColors.n1,
      ),),
    ],
  ),
),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  ),
  );
}


}

