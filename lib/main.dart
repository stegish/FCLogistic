import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:untitled/VMagazzino.dart';
import 'DMag.dart';
import 'package:untitled/snakBar.dart';

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
      home: const SMagazzino(),
    );
  }
}

class SMagazzino extends StatefulWidget {
  const SMagazzino({Key? key}) : super(key: key);

  @override
  State<SMagazzino> createState() => _SMagazzinoState();
}

class _SMagazzinoState extends State<SMagazzino> {

  List<DMag> risultato = []; //lista con i vari risultati trovati
  static final GlobalKey<ScaffoldState> _scaffoldkey2 = new GlobalKey<ScaffoldState>(); //per la comparsa dei pop-up
  final input = [TextEditingController()]; //variabile per l'input
  bool isChecked = false; //controlla se è un reso o no

  //cerca nel foglio excell il codice immesso in inpput[0] e salva ogni ccorrispondenza su risultato tramite il formato DMag
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
          coll.add(DMag(necessari.value, riga, bancale.value, codice));
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

  //Reindirizzamento alla pagina VMagazzino
  void VaiVMagazzino() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => VMagazzino(file: risultato)),);
  }

  //esegue la funzione cerca e capisce se ha trovato risultati o no
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
              leading: Icon(Icons.file_download),
              title: Text('Carica'),
              onTap: VaiVMagazzino,
            ),
            ListTile(
              leading: Icon(Icons.file_upload),
              title: Text('Scarica'),
              onTap: VaiVMagazzino,
            ),
            ListTile(
              leading: Icon(Icons.outbond),
              title: Text('Resi'),
              onTap: VaiVMagazzino,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Center(
          child: Text("SCARICA",
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
                  icon: Icon(Icons.numbers),
                  hintText: 'inserire il codice',
                  labelText: 'codice *',
                ),
              ),
            ),
              Padding(padding: EdgeInsets.all(30.0),
                child : Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.all(Colors.red),
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
            ),
            Padding(padding: EdgeInsets.all(30.0),
              child :TextFormField(
                keyboardType: TextInputType.number,
                controller: input[0],
                enabled: isChecked,
                decoration: const InputDecoration(
                  icon: Icon(Icons.wrap_text),
                  hintText: 'nome azienda',
                  labelText: 'nome azienda reso',
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
