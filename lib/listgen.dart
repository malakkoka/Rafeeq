import 'package:flutter/material.dart';

class Listw extends StatefulWidget {
  final data ;
  const Listw({super.key, this.data});

  @override
  State<Listw> createState() => _Listwstate();
  } 
  class _Listwstate extends State<Listw>{
    List uname = [
      { "name": "malak", "age":21},
      { "name": "moka", "age":20},
      { "name": "koka", "age":22},


    ];
    @override 
    Widget build(BuildContext context){
      return Scaffold(
        appBar: AppBar(title:Text ("list gen "),),
        body: ListView(
          children: [
            ...List.generate(uname.length,(i){
              return Card(
              child: ListTile(title: Text(uname[i]),),
            );
            })


          ],
        ),
      );
    }
  }