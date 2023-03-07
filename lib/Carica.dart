import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:untitled/CMagazzino.dart';
import 'package:untitled/VMagazzino.dart';
import 'DMag.dart';
import 'package:untitled/snakBar.dart';

class CMagazzino extends StatefulWidget {
  const CMagazzino({Key? key}) : super(key: key);

@override
State<CMagazzino> createState() => _CMagazzinoState();
}

class _CMagazzinoState extends State<CMagazzino> {

  static final GlobalKey<ScaffoldState> _scaffoldkey2 = new GlobalKey<ScaffoldState>(); //key per i pop-up
  final input = [TextEditingController()]; //bancale

  VaiCVMagazzino(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => CVMagazzino(bancale: input[0].text)),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey2,
      appBar: AppBar(
        title: const Center(
          child: Text("CARICA     ",
            style: TextStyle(fontWeight: FontWeight.bold),),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(30.0),
              child :TextFormField(
                keyboardType: TextInputType.text,
                controller: input[0],
                decoration: const InputDecoration(
                  icon: Icon(Icons.code),
                  hintText: 'inserire nome bancale',
                  labelText: 'bancale *',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: VaiCVMagazzino,
        tooltip: 'ricerca',
        child: const Icon(Icons.search),
      ),
    );
  }
}
