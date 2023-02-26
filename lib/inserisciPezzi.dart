import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled/snakBar.dart';
import 'Xls.dart';
import 'package:path/path.dart';


class IPezzi extends StatefulWidget{
  Xls file;
  IPezzi({Key? key, required this.file}):super(key:key);

   @override
   State<IPezzi> createState() => _IPezziPageState(file: file);
}

class _IPezziPageState extends State<IPezzi>{

  Xls file;
  _IPezziPageState({Key? key, required this.file});
  static final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  final quantitaI = [
    TextEditingController()
  ];

  final bancaleI = [
    TextEditingController()
  ];

  void Aggiungi(String codice, String bancale) async{
    int quantita = 0;
    if (quantitaI[0].text != "") {
      quantita = int.parse(quantitaI[0].text);
      print("input--");
      print(quantita);

      //aggiunta distina
      var file1 = File("/storage/emulated/0/Android/data/com.example.untitled/files/"+file.NFile);
      var bytes = File(file1.path).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      var table = file.NFoglio;
      Sheet a = excel[table];

      //apertura magazzino
      var file2 = File("/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx");
      var bytes2 = File(file2.path).readAsBytesSync();
      var excel2 = Excel.decodeBytes(bytes2);
      var table2 = "magazzino";
      Sheet a2 = excel2[table2];

      String riga = file.riga;
      String Inecessari = "I" + riga;
      String Igiorno = "J" + riga;
      String Ibancale = "K"+ riga;
      var magazzino = a.cell(CellIndex.indexByString(Inecessari));
      int precedenti = 0;
      print("---");
      print(magazzino.value);
      print("---");
      if (magazzino.value != null) {
        precedenti = magazzino.value;
      }
      print(precedenti);
      String bancaleU = bancaleI[0].text;
      String VBancale="";
      var PBancale = a.cell(CellIndex.indexByString(Ibancale));
      if(PBancale.value!=null){
        VBancale=PBancale.value+";";
        a.updateCell(CellIndex.indexByString(Ibancale),VBancale+bancaleU);
      }else{
        a.updateCell(CellIndex.indexByString(Ibancale),bancaleU);
      }

      //modifico distinta
      a.updateCell(CellIndex.indexByString(Inecessari), quantita + precedenti);
      a.updateCell(CellIndex.indexByString(Igiorno),DateTime.now().day.toString()+"/"+DateTime.now().month.toString());
      print(DateTime.now());
      print(magazzino.value);

      if(bancaleU!="") {
        //modifico magazzino
        String rigaMax = ((excel2.tables[table2]!.maxRows)+1).toString();
        a2.updateCell(CellIndex.indexByString("B" + rigaMax), bancaleU);
        a2.updateCell(CellIndex.indexByString("D" + rigaMax), quantita);
        a2.updateCell(CellIndex.indexByString("C" + rigaMax), file.codice);
        a2.updateCell(CellIndex.indexByString("E" + rigaMax), DateTime.now().day.toString() + "/" + DateTime.now().month.toString());

        //salvo magazzino
        String Poutput = "/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx";
        List<int>? fileBytes = excel2.save();
        if (fileBytes != null) {
          File(join(Poutput))
            ..createSync(recursive: true)
            ..writeAsBytesSync(fileBytes);
        }
      }
      //salvo distinta
      String Poutput = "/storage/emulated/0/Android/data/com.example.untitled/files/";
      List<int>? fileBytes = excel.save();
      if (fileBytes != null) {
        File(join(Poutput+file.NFile))
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);
      }

      GlobalValues.showSnackbar(_scaffoldkey, "INSERITO","magazzino e distinta salvati","successo");
    }else{
      GlobalValues.showSnackbar(_scaffoldkey, "ATTENZIONE","INSERIRE IL NUMERO DI PEZI","fallito");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(file.NFile),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(30.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: quantitaI[0],
                  decoration: const InputDecoration(
                    icon: Icon(Icons.code),
                    hintText: 'inserire la quantità',
                    labelText: 'quantità *',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: bancaleI[0],
                  decoration: const InputDecoration(
                    icon: Icon(Icons.code),
                    hintText: 'macchina-data-numero',
                    labelText: 'bancale *',
                  ),
                ),
              ),
            ],
          ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {Aggiungi(quantitaI[0].text ,bancaleI[0].text);
        },
        tooltip: 'ricerca',
        child: const Icon(Icons.add),
      ),
    );
  }

}