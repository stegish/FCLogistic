import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'VEMagazzino.dart';
import 'Xls.dart';
import 'main.dart';

class EMagazzino extends StatefulWidget{
  EMagazzino({Key? key}) :super(key: key);
  @override
  State<EMagazzino> createState() => _EMagazzinoPageState();
}

class _EMagazzinoPageState extends State<EMagazzino>{
  _EMagazzinoPageState({Key? key});
  List<Xls> risultato = [];
  final _formKey1 = GlobalKey<FormState>();
  final input = [TextEditingController(),TextEditingController()];
  static final GlobalKey<ScaffoldState> _scaffoldkey13 = new GlobalKey<ScaffoldState>(); //per la comparsa dei pop-up

  void contiene(List<Xls> risultatoo){
    for(int i=0; i<risultatoo.length; i++){
      for(int j=i+1; j<risultato.length;j++){
        if(risultato[i].nome==risultatoo[j].nome){
          risultato.removeAt(i);
        }
      }
    }
  }

  void SpostaBancale(Xls aa, String nuovo){
    var file = File("/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx");
    var bytes = File(file.path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    var table = "magazzino";
    String Poutput = "/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx";
    Sheet a = excel[table];
    int rigaMax = a.maxRows+1;
    for(int i = rigaMax+1; i >0; i--){
      String cella = "B$i";
      if(a.cell(CellIndex.indexByString(cella)).value.toString() == aa.nome){
        print(a.cell(CellIndex.indexByString(cella)).value.toString());
        print(a.cell(CellIndex.indexByString("C$i")).value.toString());
        a.updateCell(CellIndex.indexByString(cella), nuovo);
      }
    }
    List<int>? fileBytes = excel.save();
    if (fileBytes != null) {
      File(join(Poutput))..createSync(recursive: true)..writeAsBytesSync(fileBytes);
    }
    setState(() {
      RealTimeSearch();
    });
  }

  void CancellaBancale(Xls aa){
    var file = File("/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx");
    var bytes = File(file.path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    var table = "magazzino";
    String Poutput = "/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx";
    Sheet a = excel[table];
    int rigaMax = a.maxRows;
    for(int i = rigaMax+1; i >0; i--){
      String cella = "B$i";
      if(a.cell(CellIndex.indexByString(cella)).value.toString() == aa.nome){
        print(a.cell(CellIndex.indexByString(cella)).value.toString());
        print(a.cell(CellIndex.indexByString("C$i")).value.toString());
        a.removeRow(i-1);
      }
    }
    List<int>? fileBytes = excel.save();
    if (fileBytes != null) {
      File(join(Poutput))..createSync(recursive: true)..writeAsBytesSync(fileBytes);
    }
    print("fatto");
    setState(() {
      RealTimeSearch();
    });
  }
  //chiede all'utente se è sicuro di procedere con l'eliminazione o lo spostamento
  //del bancale selezionato tramite un pop-up
  Future<void> Sicuro(String azione, Xls aa) async{
    BuildContext c= _scaffoldkey13.currentState!.context;
    if(azione!="cancella"){
      return showDialog<void>(
        context: c,
        barrierDismissible: false,
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
          TextFormField(
          keyboardType: TextInputType.text,
            controller: input[1],
            validator: (val) => (val!.isEmpty) ? "inserisci il nome del nuovo bancale" : null,
            decoration: const InputDecoration(
              icon: Icon(Icons.text_fields),
              hintText: 'nome nuovo bancale',
            ),
          ),
              TextButton(
                child: const Text('Sposta',style: const TextStyle(color:Colors.red),),
                onPressed: () {
                  Navigator.of(context).pop();
                  SpostaBancale(aa, input[1].text);
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
                  CancellaBancale(aa);
                  Navigator.of(context).pop();
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

  //ricerca in tempo reale i bancali che contengono la stringa inserita
  RealTimeSearch(){
    risultato.clear();
    if(input[0].text!=""){
      var file = File("/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx");
      var bytes = File(file.path).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      var table = "magazzino";
      Sheet a = excel[table];
      int rigaMax= a.maxRows;
      for (int i = 1; i < rigaMax+1&&risultato.length<20; i++) {
        String cella = "B$i";
        if (a.cell(CellIndex.indexByString(cella)).value.toString().contains(input[0].text)==true) {
          risultato.add(Xls(CellIndex.indexByString(cella),a.cell(CellIndex.indexByString(cella)).value.toString()));
        }
        contiene(risultato);
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldkey13,
    appBar: AppBar(
      title: const Text('ELIMINA PEZZI'),
    ),
      body: Form(
        key: _formKey1,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.all(30.0),
                child :TextFormField(
                  onChanged: (value) {
                    setState(() {
                      RealTimeSearch();
                    });
                  },
                  keyboardType: TextInputType.text,
                  controller: input[0],
                  validator: (val) => (val!.isEmpty||val.contains('.')||val.contains(',')||val.contains('-')||val.contains(' ')) ? "inserisci il codice" : null,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.numbers),
                    hintText: 'nome bancale',
                    labelText: 'nome *',
                  ),
                ),
              ),
              Container(
                height:590,
                child: ListView.builder(
                  itemCount: risultato.length,
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
                                  Sicuro("cancella", risultato[index]);
                                }
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                          title:Text("${risultato[index].nome}",
                            style: const TextStyle(fontWeight: FontWeight.bold),),
                            onTap: () =>[
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VEMagazzino(Nbancale: risultato[index].nome,)),),],
                            trailing: Container(
                              padding: const EdgeInsets.only(left: 12.0),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      left: BorderSide(width: 3.0, color: Colors.white24))),
                              child: IconButton(
                                  icon:const Icon(Icons.move_down, color: Colors.white),
                                  onPressed: ()  {
                                    Sicuro("", risultato[index]);
                                  }
                              ),
                            ),
                        ),
                      ),
                    );
                  }
                )
              )            ],
          ),
        ),
      ),
  );

  }
}