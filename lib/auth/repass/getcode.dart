import 'package:flutter/material.dart';
import 'package:front/color.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class Getcode extends StatefulWidget{
  const Getcode({super.key});

  @override
  State<Getcode>createState()=>_Getcodestate();

}

class _Getcodestate extends State<Getcode>{


  final TextEditingController email = TextEditingController();

    late final List<TextEditingController> controllers;
    late final List<FocusNode> focusNodes;

@override
void initState() {
  super.initState();
  controllers = List.generate(4, (_) => TextEditingController());
  focusNodes = List.generate(4, (_) => FocusNode());
}

String getOtpCode() {
  return controllers.map((c) => c.text).join();
}

@override
void dispose() {
  for (final c in controllers) {
    c.dispose();
  }
  for (final f in focusNodes) {
    f.dispose();
  }
  super.dispose();
}

  
Widget otpBox(int index){
  return SizedBox(
    width: 60,
    height: 60,
    child: TextFormField(
      controller: controllers[index],
      focusNode: focusNodes[index],
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: 1,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      
      ),
      
      decoration: InputDecoration(
      counterText: "",
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      isDense: true,
        filled: true,
        fillColor: AppColors.dialogcolor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.n1,width: 2)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.n1,width: 2)
        ),
      ),
    
  onChanged: (value) {
        if (value.isNotEmpty && index < 3) {
          FocusScope.of(context)
              .requestFocus(focusNodes[index + 1]);
        }
        if (value.isEmpty && index > 0) {
          FocusScope.of(context)
              .requestFocus(focusNodes[index - 1]);
        }
      },
    ),
  );
}


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
                              Icons.verified_user_sharp,
                              color: AppColors.n1,
                              size: 50,
                            ),
                          ),

                          const Gap(16),

                          Text(
                            'Verify Code',
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
                              "we have sent a 4-digit code to your email.",
                              textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 27, 27, 27),
                              ),
                            ),
                          ),
                          Gap(30),
                          Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: List.generate(4, (index) => otpBox(index)),
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
                                      .pushReplacementNamed("reset");
                          },
                              child: Text(
                                "Verify",
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children:  [
                            Text("Didn't receve the code?"),
                            InkWell(
                              onTap: (){

                              },
                              child: Text("Resend",
                              style: TextStyle(color: AppColors.n1,fontWeight: FontWeight.w400),),
                            )
                            
                          ],
                        ),
                        Gap(10),
                        InkWell(
  onTap: () {
    Navigator.of(context).pushReplacementNamed("forgot");
  },
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: const [
      Icon(Icons.arrow_back_rounded,color: AppColors.n1,),
      SizedBox(width: 8),
      Text("Back",
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



