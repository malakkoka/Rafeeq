import 'package:flutter/material.dart';
import 'package:front/auth/call/livecall.dart';
import 'package:front/color.dart';
import 'package:gap/gap.dart';


class Incomming extends StatelessWidget {
  const Incomming({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // ===== Caller Avatar =====
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.blue.shade100,
              child: Icon(
                Icons.person,
                size: 60,
                color: AppColors.n4,
              ),
            ),

            const Gap(30),

            // ===== Text =====
            Text(
              "Incoming Call",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.8),
              ),
            ),

            const Gap(8),

            Text(
              "Patient is calling you",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),

            const Spacer(),

            // ===== Buttons =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Reject
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.red,
                    child: IconButton(
                      icon: const Icon(Icons.call_end,
                          color: Colors.white, size: 28),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  // Accept
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.green,
                    child: IconButton(
                      icon: const Icon(Icons.call,
                          color: Colors.white, size: 28),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const Livecall(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}


