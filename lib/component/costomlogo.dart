import 'package:flutter/material.dart';

class Customlogo extends StatelessWidget {
  const Customlogo({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: 80,
                    height: 80,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(70),
                    ),
                    child:
                      Image.asset(
                          "images/37697d6e01e2feb56ae523e8c486fe82.jpg",
                          width: 50,height: 50,//fit: BoxFit.fill,
                          )
                  ),
                );
  }

}