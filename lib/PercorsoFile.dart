import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:untitled/PercorsoFile.dart';
import 'package:untitled/VMagazzino.dart';
import 'DMag.dart';
import 'package:untitled/snakBar.dart';
import 'package:path/path.dart';


class CFile extends StatefulWidget {
  const CFile({Key? key}) : super(key: key);

  @override
  State<CFile> createState() => _CFileState();
}

class _CFileState extends State<CFile> {
  List<DMag> risultato = [];
  static final GlobalKey<ScaffoldState> _scaffoldkey7 = new GlobalKey<ScaffoldState>();

  final input = [
    TextEditingController()
  ];


  void Cerca() async {
      int q=0;
      var file1 = File("/storage/emulated/0/Android/data/com.example.untitled/files/ListaSJ21169.xlsx");
      var bytes1 = File(file1.path).readAsBytesSync();
      var excel1 = Excel.decodeBytes(bytes1);
      var table1 = "Foglio1";
      Sheet lista = excel1[table1];
      int rigaMaxL = excel1.tables[table1]!.maxRows+1;
      var file = File("/storage/emulated/0/Android/data/com.example.untitled/files/magazzinoConsegnaGS36.xlsx");
      var bytes = File(file.path).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      var table = "magazzino";
      Sheet magazzino = excel[table];
      int rigaMaxM = excel.tables[table]!.maxRows+1;
      for(int i=1;i<rigaMaxL;i++){
        for(int j=1;j<rigaMaxM;j++){
          String a= lista.cell(CellIndex.indexByString("B"+i.toString())).value.toString();
          String b= magazzino.cell(CellIndex.indexByString("C"+j.toString())).value.toString();
          if(a==b){
            lista.updateCell(CellIndex.indexByString("L"+i.toString()), magazzino.cell(CellIndex.indexByString("B"+j.toString())).value);
            q++;
            print("trovato "+q.toString());
          }
        }
      }
      String Poutput = "/storage/emulated/0/Android/data/com.example.untitled/files/ListaSJ21169.xlsx";
      List<int>? fileBytes = excel1.save();
      if (fileBytes != null) {
        File(join(Poutput))
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);
      }
      GlobalValues.showSnackbar(_scaffoldkey7, "ESEGUITO", "finito", "successo");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey7,
      appBar: AppBar(
        title: const Center(
          child: Text("COMPILA     ",
            style: TextStyle(fontWeight: FontWeight.bold),),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: Cerca,
        tooltip: 'ricerca',
        child: const Icon(Icons.search),
      ),
    );
  }
}
