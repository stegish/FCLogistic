import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:untitled/Magazzino.dart';
import 'package:untitled/PercorsoFile.dart';
import 'package:untitled/Spiegazioni.dart';
import 'package:untitled/snakBar.dart';
import 'package:untitled/visualizzazzioneFile.dart';
import 'Resi.dart';
import 'Xls.dart';

void main() {
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.red,
      fontFamily: 'Arial',
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.normal),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Arial'),
      ),
    ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int value = 0;
  int dim=4;
  int cambio=0;
  List<Xls> distinte = [
    Xls("GS36-SJ21167.xlsx",0,"","","",0,"",""),
    Xls("GS18-SJ21091.xlsx",0,"","","",0,"",""),
    Xls("GS24-SJ22089-1.xlsx",0,"","","",0,"",""),
    Xls("GS36-SJ21101.xlsx",0,"","","",0,"","")];
  List<Xls> risultato = [];
  static final GlobalKey<ScaffoldState> _scaffoldkey1 = new GlobalKey<ScaffoldState>();

  final input = [TextEditingController()];
  var files;

  void Cerca(String nome) async {
    if(input[0].text!=""){
      String codice = input[0].text;
      codice = codice + "";
      var file = File("/storage/emulated/0/Android/data/com.example.untitled/files/"+nome);
      var bytes = File(file.path).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        Sheet a = excel[table];
        int rigaMax = excel.tables[table]!.maxRows;
        for (int i = 1; i < rigaMax; i++) {
          String cella = "B" + i.toString();
          print(a.cell(CellIndex.indexByString(cella)).value);

          //se trova il codice
          if (a.cell(CellIndex.indexByString(cella)).value == codice||a.cell(CellIndex.indexByString(cella)).value == codice+" ") {
            print("trovato");
            String riga = (i).toString();
            var necessari = a.cell(CellIndex.indexByString("H" + riga));
            var magazzino = a.cell(CellIndex.indexByString("I" + riga));
            var bancale = a.cell(CellIndex.indexByString("K" + riga));
            var data = a.cell(CellIndex.indexByString("J" + riga));
            var dataI = "";
            var bancaleI = "";
            var codiceI = "";
            if (data.value != null) {
              dataI=data.value;
            }
            if (bancale.value != null) {
              bancaleI=bancale.value;
            }
            codiceI = input[0].text;

            //se non ci sono pezzi in magazzino
            if (magazzino.value == null) {
              print("da aggiungere");
              risultato.add(Xls(nome,necessari.value,riga,table,bancaleI,0,dataI,codiceI));
            } else if (necessari.value > magazzino.value) {
              risultato.add(Xls(nome,necessari.value-magazzino.value,riga,table,bancaleI,magazzino.value,dataI,codiceI));
            } else {
              risultato.add(Xls(nome,0,riga,table,bancaleI,magazzino.value,dataI,codiceI));
            }
          }
        }
      }
    }
  }

  //navigator a VMagazzino
  void VaiVMagazzino(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Magazzino()),);
  }

  void VaiResi(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Resi()),);
  }

  //navigator a Spiegazione
  void VaiSpiegazione(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Spiegazione()),);
  }

  //navigator a VFile
  void VaiVFile(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VFile(file: risultato)),);
  }
  //47015825

  //avvia la ricerca nei file specificati in rusultato[]
  void avviaRicerca() async {
    risultato.clear();
    for (int i = 0; i < dim; i++) {
      Cerca(distinte[i].NFile);
    }
    int c = 0;
    for (int i = 0; i < risultato.length; i++) {
      if (risultato[i].riga == "") {
        c++;
      }
    }
    if (c == risultato.length) {
      GlobalValues.showSnackbar(_scaffoldkey1, "ATTENZIONE", "codice non trovato", "fallito");
    } else {
      VaiVFile();
    }
  }

  void VaiPFile(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CFile()),);
  }

  void VaiMagazzino(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Magazzino()),);
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        key: _scaffoldkey1,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                    color: Colors.black38,),
                child: Image(
                  image: AssetImage("assets/logoFC.png"),
                ),
              ),
              ListTile(
                leading: Icon(Icons.text_fields),
                title: Text('Spiegazioni'),
                onTap: VaiSpiegazione,
              ),
              ListTile(
                leading: Icon(Icons.border_color),
                title: Text('Carica Scarica'),
                onTap: VaiMagazzino,
              ),
              ListTile(
                leading: Icon(Icons.file_upload),
                title: Text('Salva nel Nas'),
                onTap: VaiPFile,
              ),
              ListTile(
                leading: Icon(Icons.file_upload),
                title: Text('Resi'),
                onTap: VaiPFile,
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Center(
            child: Text("FC LOGISTIC",
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
