import 'package:flutter/material.dart';
import 'package:untitled/SCMagazzino.dart';
import 'package:untitled/InserisciResi.dart';
import 'DMag.dart';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/snakBar.dart';
import 'DMag.dart';
import 'package:path/path.dart';

//visualizzo i banccali trovati con il codice cercato
class CVMagazzino extends StatefulWidget {
  String bancale;

  CVMagazzino({Key? key, required this.bancale}) : super(key: key);

  @override
  State<CVMagazzino> createState() => _CVMagazzinoPageState(bancale: bancale);
}

class _CVMagazzinoPageState extends State<CVMagazzino> {
  String bancale;
  List<Widget> list = [];
  int fieldCount = 0;
  List<Map<String, dynamic>> items = [];
  final _formKey = GlobalKey<FormState>();
  var codici = [];
  var quantitaI = [];
  static final GlobalKey<ScaffoldState> _scaffoldKey9 =
      new GlobalKey<ScaffoldState>(); //key per i pop-up

  _CVMagazzinoPageState({Key? key, required this.bancale});

  //permette di aggiungere i TextFormField alla lista
  Widget buildField(int i) {
    codici.add(TextEditingController());
    quantitaI.add(TextEditingController());
    return ListTile(
      title: Row(children: <Widget>[
        SizedBox(
          width: 200,
          height: 80,
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: codici.last,
            decoration: const InputDecoration(
              hintText: 'inserire il codice',
              labelText: 'codice *',
            ),
            validator: (val) => val!.isEmpty ? "inserisci codice" : null,
          ),
        ),
        SizedBox(
          width: 100,
          height: 80,
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: quantitaI.last,
            decoration: const InputDecoration(
              hintText: 'inserire quantita',
              labelText: 'quantita *',
            ),
            validator: (val) => val!.isEmpty ? "inserisci quantita" : null,
          ),
        ),
      ]),
      trailing: InkWell(
        child: SizedBox(
            width: 25,
            height: 80,
            child: Icon(Icons.delete_outlined, color: Colors.red)),
        onTap: () {
          setState(() {
            fieldCount--;
            list.removeAt(i);
            items.removeAt(i);
          });
        },
      ),
    );
  }

  //carica i codici nel rispettivo bancale
  Carica() {
    for (int i = 0; codici.length > i && quantitaI.length > i; i++) {
      int quantita = 0;
      if (quantitaI[i].text != "") {
        quantita = int.parse(quantitaI[i].text);
        print(quantita);
        var file1 = File(
            "/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx");
        var bytes = File(file1.path).readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);
        var table = "magazzino";
        Sheet a = excel[table]; // foglio magazzino
        String riga = (a.maxRows + 1).toString();
        a.updateCell(CellIndex.indexByString("B" + riga), bancale);
        a.updateCell(CellIndex.indexByString("C" + riga), codici[i].text);
        a.updateCell(CellIndex.indexByString("D" + riga), quantita);
        a.updateCell(
            CellIndex.indexByString("E" + riga),
            DateTime.now().day.toString() +
                "/" +
                DateTime.now().month.toString());

        //salvo il file excell modificato
        String Poutput =
            "/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx";
        List<int>? fileBytes = excel.save();
        if (fileBytes != null) {
          File(join(Poutput))
            ..createSync(recursive: true)
            ..writeAsBytesSync(fileBytes);
        }
        GlobalValues.showSnackbar(
            _scaffoldKey9, "ATTENZIONE", "salvato con successo", "successo");
      } else {
        GlobalValues.showSnackbar(
            _scaffoldKey9, "ATTENZIONE", "quantita non valida", "fallito");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey9,
      appBar: AppBar(
        title: const Text("inserire codici"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            fieldCount == 0
                ? const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "schiaccia \"+\"",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      ListView.builder(
                        itemCount: list.length,
                        shrinkWrap: true,
                        itemBuilder: (_, i) => buildField(i),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          onPressed: () {
                            Carica;
                          },
                          child: const Text("CARICA")),
                    ],
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: () {
          setState(() {
            fieldCount++;
            list.add(buildField(fieldCount));
          });
        },
      ),
    );
  }
}
