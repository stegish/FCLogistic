import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/snakBar.dart';
import 'DMag.dart';
import 'package:path/path.dart';


class SSMagazzino extends StatefulWidget{
   DMag file;
   SSMagazzino({Key? key, required this.file}) :super(key: key);

   @override
   State<SSMagazzino> createState() => _SSMagazzinoPageState(file: file);
}

class _SSMagazzinoPageState extends State<SSMagazzino>{

  DMag file;
  static final GlobalKey<ScaffoldState> _scaffoldKey3 = new GlobalKey<ScaffoldState>(); //key per i pop-up
  _SSMagazzinoPageState({Key? key, required this.file});

  final quantitaI = [TextEditingController()]; //quantita' da rimuovere

  void Aggiungi(String codice) async {
    int quantita = 0;
    if (quantitaI[0].text != "") {
      quantita = int.parse(quantitaI[0].text);
      print("input--");
      print(quantita);
      var file1 = File("/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx");
      var bytes = File(file1.path).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      String riga = file.riga;
      var table = "magazzino";
      Sheet a = excel[table];
      print(table);
      var magazzino = a.cell(CellIndex.indexByString("D" + riga));
      int precedenti = 0;
      print("---");
      print(magazzino.value);
      print("---");
      String Poutput = "/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx";
      if (magazzino.value != null) {
        precedenti = magazzino.value;
      }
      print(precedenti);
      if(precedenti>quantita){
        a.updateCell(CellIndex.indexByString("D" + file.riga), precedenti - quantita);
        print(DateTime.now());
        print(magazzino.value);
        List<int>? fileBytes = excel.save();
        if (fileBytes != null) {
          File(join(Poutput))..createSync(recursive: true)..writeAsBytesSync(fileBytes);
        }
        GlobalValues.showSnackbar(_scaffoldKey3, "FATTO","materiale scaricato","successo");
      }else if(precedenti==quantita){
        print(int.parse(file.riga));
        a.removeRow(int.parse(file.riga)-1);
        print(DateTime.now());
        print(magazzino.value);
        List<int>? fileBytes = excel.save();
        if (fileBytes != null) {
          File(join(Poutput))..createSync(recursive: true)..writeAsBytesSync(fileBytes);
        }
        GlobalValues.showSnackbar(_scaffoldKey3, "FATTO","materiale scaricato","successo");
      }else{
        GlobalValues.showSnackbar(_scaffoldKey3, "ATTENZIONE","scegliere se caricare o scaricare","attenzione");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey3,
      appBar: AppBar(
        title: Text(file.bancale),
      ),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(30.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: quantitaI[0],
                  decoration: const InputDecoration(
                    icon: Icon(Icons.code),
                    hintText: 'inserire la quantità',
                    labelText: 'quantità *',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {Aggiungi(quantitaI[0].text);},
        tooltip: 'ricerca',
        child: const Icon(Icons.add),
      ),
    );
  }
}