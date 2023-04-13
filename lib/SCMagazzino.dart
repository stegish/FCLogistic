import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/snakBar.dart';
import 'DMag.dart';
import 'package:path/path.dart';

import 'main.dart';


class SSMagazzino extends StatefulWidget{
   DMag file;
   String? cliente;
   String? commessa;
   SSMagazzino({Key? key, required this.file, this.cliente, this.commessa}) :super(key: key);

   @override
   State<SSMagazzino> createState() => _SSMagazzinoPageState(file: file, cliente: cliente, commessa: commessa);
}

class _SSMagazzinoPageState extends State<SSMagazzino>{
  String? cliente; //cliente per cui fare il reso se ce
  DMag file;
  String? commessa;
  static final GlobalKey<ScaffoldState> _scaffoldKey3 = new GlobalKey<ScaffoldState>(); //key per i pop-up
  _SSMagazzinoPageState({Key? key, required this.file, this.cliente, this.commessa});

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
      var resit = "resi";
      var impegnatot = "impegnato";
      Sheet impegnato = excel[impegnatot];
      Sheet a = excel[table];
      Sheet resi = excel[resit];
      var magazzino = a.cell(CellIndex.indexByString("D" + riga));
      int precedenti = 0;
      print(magazzino.value);
      String resiMax = (resi.maxRows+1).toString();
      String impegnatoMax = (impegnato.maxRows+1).toString();
      String Poutput = "/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx";
      if (magazzino.value != null) {
        precedenti = magazzino.value;
      }
      print(precedenti);
      if(precedenti>quantita){
        a.updateCell(CellIndex.indexByString("D" + file.riga), precedenti - quantita);
        print(DateTime.now());
        print(magazzino.value);
        if(cliente!=null&&commessa==null){
          resi.updateCell(CellIndex.indexByString("B"+resiMax), file.bancale);
          resi.updateCell(CellIndex.indexByString("C"+resiMax), file.codice);
          resi.updateCell(CellIndex.indexByString("D"+resiMax), quantita);
          resi.updateCell(CellIndex.indexByString("E"+resiMax), cliente);
          resi.updateCell(CellIndex.indexByString("F"+resiMax), DateTime.now().day.toString() + "/" + DateTime.now().month.toString());
        }else{
          impegnato.updateCell(CellIndex.indexByString("B"+impegnatoMax), file.bancale);
          impegnato.updateCell(CellIndex.indexByString("C"+impegnatoMax), file.codice);
          impegnato.updateCell(CellIndex.indexByString("D"+impegnatoMax), quantita);
          impegnato.updateCell(CellIndex.indexByString("E"+impegnatoMax), commessa);
          impegnato.updateCell(CellIndex.indexByString("F"+impegnatoMax), DateTime.now().day.toString() + "/" + DateTime.now().month.toString());
        }
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
        if(cliente!=null&&commessa==null){
          resi.updateCell(CellIndex.indexByString("B"+resiMax), file.bancale);
          resi.updateCell(CellIndex.indexByString("C"+resiMax), file.codice);
          resi.updateCell(CellIndex.indexByString("D"+resiMax), quantita);
          resi.updateCell(CellIndex.indexByString("E"+resiMax), cliente);
          resi.updateCell(CellIndex.indexByString("F"+resiMax), DateTime.now().day.toString() + "/" + DateTime.now().month.toString());
        }else{
          impegnato.updateCell(CellIndex.indexByString("B"+impegnatoMax), file.bancale);
          impegnato.updateCell(CellIndex.indexByString("C"+impegnatoMax), file.codice);
          impegnato.updateCell(CellIndex.indexByString("D"+impegnatoMax), quantita);
          impegnato.updateCell(CellIndex.indexByString("E"+impegnatoMax), commessa);
          impegnato.updateCell(CellIndex.indexByString("F"+impegnatoMax), DateTime.now().day.toString() + "/" + DateTime.now().month.toString());
        }
        List<int>? fileBytes = excel.save();
        if (fileBytes != null) {
          File(join(Poutput))..createSync(recursive: true)..writeAsBytesSync(fileBytes);
        }
        GlobalValues.showSnackbar(_scaffoldKey3, "FATTO","materiale scaricato","successo");
      }else{
        GlobalValues.showSnackbar(_scaffoldKey3, "ATTENZIONE","quantita da togliere maggiore di magazzino","attenzione");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey3,
      appBar: AppBar(
        title: Center(child: Text(file.bancale)),
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
        child: const Icon(Icons.upload),
      ),
    );
  }
}