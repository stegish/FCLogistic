import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/snakBar.dart';
import 'DMag.dart';
import 'package:path/path.dart';

import 'Xls.dart';

//visualizza i bancali presenti in magazzino che corrispondo alla stringa cercata
class VEMagazzino extends StatefulWidget{
  String Nbancale;
  VEMagazzino({Key? key, required this.Nbancale}) :super(key:key);
  @override
  State<VEMagazzino> createState()=> _VEMagazzinoPageState(Nbancale: Nbancale);

}

class _VEMagazzinoPageState extends State<VEMagazzino>{
  String Nbancale;
  _VEMagazzinoPageState({Key? key,required this.Nbancale});
  List<Xls> lista=[];
  static final GlobalKey<ScaffoldState> _scaffoldkey23 = new GlobalKey<ScaffoldState>(); //per la comparsa dei pop-up

  //chiede all'utente se è sicuro di procedere con l'eliminazione o lo spostamento
  //del bancale selezionato tramite un pop-up
  Future<void> Sicuro(String azione, Xls aa) async{
    BuildContext c= _scaffoldkey23.currentState!.context;
    if(azione!="cancella"){
      return showDialog<void>(
        context: c,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Modifica Importante'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Sicuro di voler spostare gli oggetti?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Sposta',style: const TextStyle(color:Colors.red),),
                onPressed: () {
                  Navigator.of(context).pop();
                  CancellaCodice(aa);
                },
              ),
              TextButton(
                child: const Text('Annulla'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }else{
      return showDialog<void>(
        context: c,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Modifica Importante'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Sicuro di voler cancellare il codice?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancella',style: const TextStyle(color:Colors.red),),
                onPressed: () {
                  CancellaCodice(aa);
                },
              ),
              TextButton(
                child: const Text('Annulla'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  //permette di cancellare un singolo codice all'interno del bancale tramite
  //l'icona del cestino posta al lato del codice
  void CancellaCodice(Xls aa){
    var file = File("/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx");
    var bytes = File(file.path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    var table = "magazzino";
    Sheet a = excel[table];
    a.removeRow(aa.index.rowIndex);
    String Poutput = "/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx";
    List<int>? fileBytes = excel.save();
    if (fileBytes != null) {
      File(join(Poutput))..createSync(recursive: true)..writeAsBytesSync(fileBytes);
    }
    print("fatto");
    setState(() {
    });
  }


  //crea la lista con i risultati trovato nel magazzino che contangono la stringa cercata
  ListView CreaLista(){
    lista.clear();
    var file = File("/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx");
    var bytes = File(file.path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    var table = "magazzino";
    Sheet a = excel[table];
    int rigaMax= a.maxRows;
    for (int i = 1; i < rigaMax+1; i++) {
      String cella = "B$i";
      if (a.cell(CellIndex.indexByString(cella)).value.toString() == Nbancale) {
        String colonna = "C";
        String riga = "$i";
        lista.add(Xls(CellIndex.indexByString(colonna+riga),a.cell(CellIndex.indexByString(colonna+riga)).value.toString()));
      }
    }
    return ListView.builder(
        itemCount: lista.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index){
          return Card(
            elevation:7,
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
            child: Container(
              decoration: const BoxDecoration(color: Colors.red),
              child : ListTile(
                leading: Container(
                  padding: const EdgeInsets.only(right: 12.0),
                  decoration: const BoxDecoration(
                      border: Border(
                          right: BorderSide(width: 3.0, color: Colors.white24))),
                  child: IconButton(
                      icon:const Icon(Icons.delete, color: Colors.white),
                      onPressed: ()  {
                        Sicuro("cancella", lista[index]);
                      }
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                title:Text("${lista[index].nome}",
                  style: const TextStyle(fontWeight: FontWeight.bold),),
                onTap: () =>[
                ],
                trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
              ),
            ),
          );
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldkey23,
      appBar: AppBar(
        title: Text(Nbancale),
      ),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  height:590,
                  child: CreaLista(),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          setState(() {
            CreaLista();
          });
        },
        tooltip: 'esegui',
        child: const Icon(Icons.upload),
      ),
    );
  }
}