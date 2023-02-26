import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/snakBar.dart';
import 'DMag.dart';
import 'package:path/path.dart';

class IResi extends StatefulWidget{
   DMag file;
   IResi({Key? key, required this.file}) :super(key: key);

   @override
   State<IResi> createState() => _IResiPageState(file: file);
}

class _IResiPageState extends State<IResi>{
  DMag file;
  int valore=0;
  static final GlobalKey<ScaffoldState> _scaffoldKey6 = new GlobalKey<ScaffoldState>();
  _IResiPageState({Key? key, required this.file});

  final input = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  void Aggiungi(final input2) async {
    int quantita = 0;
    if (input2[0].text != ""|| (input2[1].text != ""&& input2[1].text<=file.pezzi)) {

      //apro magazzino.xlsx
      var file1 = File("/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx");
      var bytes = File(file1.path).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      String riga = file.riga;
      var Fmagazzino = "magazzino";
      Sheet magazzino = excel[Fmagazzino];
      var Fresi = "resi";
      Sheet resi = excel[Fresi];

      //collegamenti celle utili
      String resiMax = (resi.maxRows+1).toString();
      var precedenti = magazzino.cell(CellIndex.indexByString("D"+ riga));

      //tolgo materiale da magazzino e aggiungo su resi
      if(file.pezzi==int.parse(input2[1].text)){
        magazzino.removeRow(int.parse(file.riga)-1);
        resi.updateCell(CellIndex.indexByString("A"+resiMax), input2[0].text);
        resi.updateCell(CellIndex.indexByString("B"+resiMax), file.codice);
        resi.updateCell(CellIndex.indexByString("C"+resiMax), input2[1].text);
        resi.updateCell(CellIndex.indexByString("D"+resiMax), DateTime.now().day.toString() + "/" + DateTime.now().month.toString());
        resi.updateCell(CellIndex.indexByString("E"+resiMax), input2[2].text);
      }else if(file.pezzi>int.parse(input2[1].text)){
        magazzino.updateCell(CellIndex.indexByString("D" + file.riga), precedenti.value - int.parse(input2[1].text));
        resi.updateCell(CellIndex.indexByString("A"+resiMax), input2[0].text);
        resi.updateCell(CellIndex.indexByString("B"+resiMax), file.codice);
        resi.updateCell(CellIndex.indexByString("C"+resiMax), input2[1].text);
        resi.updateCell(CellIndex.indexByString("D"+resiMax), DateTime.now().day.toString() + "/" + DateTime.now().month.toString());
        resi.updateCell(CellIndex.indexByString("E"+resiMax), input2[2].text);
      }else{
        GlobalValues.showSnackbar(_scaffoldKey6, "ATTENZIONE", "numero pezzi da rendere sbagliato", "fallito");
      }
      //42212983
      //salvo magazzino.xlsx
      String Poutput = "/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx";
      List<int>? fileBytes = excel.save();
      if (fileBytes != null) {
        File(join(Poutput))
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);
      }
      GlobalValues.showSnackbar(_scaffoldKey6, "ATTENZIONE", "salvato con successo", "successo");
    }else{
      GlobalValues.showSnackbar(_scaffoldKey6, "ATTENZIONE", "codice non trovato", "fallito");
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        key: _scaffoldKey6,
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
                    keyboardType: TextInputType.text,
                    controller: input[0],
                    decoration: const InputDecoration(
                      icon: Icon(Icons.code),
                      hintText: 'nome azienda azienda',
                      labelText: 'azienda *',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: input[1],
                    decoration: const InputDecoration(
                      icon: Icon(Icons.code),
                      hintText: 'numero pezzi',
                      labelText: 'numero *',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: input[2],
                    decoration: const InputDecoration(
                      icon: Icon(Icons.code),
                      hintText: 'commento aggiuntivo',
                      labelText: 'commento *',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            Aggiungi(input);
          },
          tooltip: 'ricerca',
          child: const Icon(Icons.add),
        ),
      );
    }
  }
