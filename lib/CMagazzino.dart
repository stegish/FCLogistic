import 'package:flutter/material.dart';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:untitled/Carica.dart';
import 'package:untitled/snakBar.dart';
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
  int fieldCount = 1;
  List<Map<String, dynamic>> items = [];
  final _formKey = GlobalKey<FormState>();
  var codici = [TextEditingController()];
  var quantitaI = [TextEditingController()];
  static final GlobalKey<ScaffoldState> _scaffoldKey9 = new GlobalKey<ScaffoldState>(); //key per i pop-up

  _CVMagazzinoPageState({Key? key, required this.bancale});

  //carica i pezzi anche in un file excell di copi che tiene traccia
  //solo dei caricamenri con la specifica data
  void CaricaBis(String bancalee) async{
    print(codici.length);
    print(quantitaI.length);
    for (int i = 0; codici.length > i && quantitaI.length > i; i++) {
      int quantita = 0;
      if (quantitaI[i].text != "") {
        quantita = int.parse(quantitaI[i].text);
        print(quantita);
        var file1 = File("/storage/emulated/0/Android/data/com.example.untitled/files/caricati.xlsx");
        var bytes = File(file1.path).readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);
        var table = "caricati";
        Sheet a = excel[table]; // foglio magazzino
        String riga = (a.maxRows + 1).toString();
        a.updateCell(CellIndex.indexByString("A" + riga), bancalee);
        a.updateCell(CellIndex.indexByString("B" + riga), codici[i].text);
        a.updateCell(CellIndex.indexByString("C" + riga), quantita);
        a.updateCell(CellIndex.indexByString("D" + riga), "CARICATO");
        a.updateCell(CellIndex.indexByString("E" + riga), DateTime.now().day.toString() + "/" + DateTime.now().month.toString()+ "/"+DateTime.now().hour.toString()+":"+DateTime.now().minute.toString());

        //salvo il file excell modificato
        String Poutput = "/storage/emulated/0/Android/data/com.example.untitled/files/caricati.xlsx";
        List<int>? fileBytes = excel.save();
        if (fileBytes != null) {
          File(join(Poutput))
            ..createSync(recursive: true)
            ..writeAsBytesSync(fileBytes);
        }
      }
    }
  }

  //carica i codici nel rispettivo bancale
  void Carica(String bancalee) async{
    int c=0;
    print(codici.length);
    print(quantitaI.length);
    for (int i = 0; codici.length > i && quantitaI.length > i; i++) {
      int quantita = 0;
      if (quantitaI[i].text != "") {
        quantita = int.parse(quantitaI[i].text);
        print(quantita);
        var file1 = File("/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx");
        var bytes = File(file1.path).readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);
        var table = "magazzino";
        Sheet a = excel[table]; // foglio magazzino
        String riga = (a.maxRows + 1).toString();
        a.updateCell(CellIndex.indexByString("B" + riga), bancalee);
        a.updateCell(CellIndex.indexByString("C" + riga), codici[i].text);
        a.updateCell(CellIndex.indexByString("D" + riga), quantita);
        a.updateCell(CellIndex.indexByString("E" + riga), DateTime.now().day.toString() + "/" + DateTime.now().month.toString());

        //salvo il file excell modificato
        String Poutput = "/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx";
        List<int>? fileBytes = excel.save();
        if (fileBytes != null) {
          File(join(Poutput))
            ..createSync(recursive: true)
            ..writeAsBytesSync(fileBytes);
        }
        c++;
      } else {
      }
    }
    if(c==quantitaI.length){
      GlobalValues.showSnackbar(_scaffoldKey9, "ATTENZIONE", "salvato con successo", "successo");
    }else{
      GlobalValues.showSnackbar(_scaffoldKey9, "ATTENZIONE", "qualcosa è andato storto", "fallito");
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
                Column(
                    children: [
                      ListView.builder(
                        itemCount: fieldCount,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Row(children: <Widget>[
                              SizedBox(
                                width: 200,
                                height: 80,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: codici[index],
                                  decoration: const InputDecoration(
                                    hintText: 'inserire il codice',
                                    labelText: 'codice *',
                                  ),
                                  validator: (val) => (val!.isEmpty||val.contains('.')||val.length!=8||val.contains(',')||val.contains('-')||val.contains(' ')) ? "togli \". , -\" e spazi, max 8 cifre" : null,
                                ),
                              ),
                              SizedBox(
                                width: 95,
                                height: 80,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: quantitaI[index],
                                  decoration: const InputDecoration(
                                    hintText: 'inserire quantita',
                                    labelText: 'quantita *',
                                  ),
                                  validator: (val){
                                    if(val!.isEmpty || val.length>8){
                                      return "inserisci quantita";
                                    }else{
                                      return null;
                                    }}
                                ),
                              ),
                            ]),
                            trailing: InkWell(
                              child: const SizedBox(
                                  width: 16,
                                  height: 80,
                                  child: Icon(Icons.delete_outlined, color: Colors.red)),
                              onTap: () {
                                setState(() {
                                  print(fieldCount);
                                  fieldCount--;
                                  quantitaI.removeLast();
                                  codici.removeLast();
                                });
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              if(fieldCount< 7){
                                fieldCount++;
                                codici.add(TextEditingController());
                                quantitaI.add(TextEditingController());
                              }else{
                                GlobalValues.showSnackbar(_scaffoldKey9, "ATTENZIONE", "limite massimo codici raggiunto", "fallito");
                              }
                            });
                          },
                          child: const Icon(Icons.add)),
                    ],
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.download),
        backgroundColor: Colors.red,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Carica(bancale);
            CaricaBis(bancale);
            Navigator.pop(this.context);
          }
        },
      ),
    );
  }
}
