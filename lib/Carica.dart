import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:untitled/VMagazzino.dart';
import 'DMag.dart';
import 'package:untitled/snakBar.dart';

class CMagazzino extends StatefulWidget {
  const CMagazzino({Key? key}) : super(key: key);

@override
State<CMagazzino> createState() => _CMagazzinoState();
}

class _CMagazzinoState extends State<CMagazzino> {
  List<DMag> risultato = [];
  static final GlobalKey<ScaffoldState> _scaffoldkey2 = new GlobalKey<ScaffoldState>();

  final input = [TextEditingController()];

  Future<List<DMag>> Cerca() async {
    String codice = "";
    List<DMag> coll = [];
    if(input[0]!="") {
      codice = input[0].text;
      int dim = 0;
      var file = File("/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx");
      var bytes = File(file.path).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      var table = "magazzino";
        print(table);
        Sheet a = excel[table];
        int rigaMax = excel.tables[table]!.maxRows+1;
        print(rigaMax);
        for (int i = 1; i < rigaMax; i++) {
          String cella = "C" + i.toString();
          //int prova = 42205482;
          print(a.cell(CellIndex.indexByString(cella)).value);
          if (a.cell(CellIndex.indexByString(cella)).value.toString() == codice) {
            print("trovato");
            String colonna = "D";
            String riga = (i).toString();
            String Inecessari = colonna + riga;
            var necessari = a.cell(CellIndex.indexByString(Inecessari));
            print(necessari.value);
            String Ibancale = "B" + riga;
            var bancale = a.cell(CellIndex.indexByString(Ibancale));
            var data = a.cell(CellIndex.indexByString("E" + riga));
            coll.add(DMag(necessari.value, riga, bancale.value, codice, "carica"));
            if (data.value == null) {
              coll[dim].setData("");
            } else {
              coll[dim].setData(data.value);
            }
            dim++;
            print(dim);
          }
        }
      return coll;
    }else{
      return coll;
    }
  }

  void VaiVMagazzino() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => VMagazzino(file: risultato)),);
  }

  void avviaRicerca() async {
      risultato = await Cerca();
      if (risultato.isEmpty) {
        GlobalValues.showSnackbar(
            _scaffoldkey2, "ATTENZIONE", "codice non trovato", "fallito");
      } else {
      VaiVMagazzino();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey2,
      appBar: AppBar(
        title: const Center(
          child: Text("MAGAZZINO     ",
            style: TextStyle(fontWeight: FontWeight.bold),),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(30.0),
              child :TextFormField(
                keyboardType: TextInputType.number,
                controller: input[0],
                decoration: const InputDecoration(
                  icon: Icon(Icons.code),
                  hintText: 'inserire il codice',
                  labelText: 'codice *',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: avviaRicerca,
        tooltip: 'ricerca',
        child: const Icon(Icons.search),
      ),
    );
  }
}
