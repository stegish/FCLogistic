import 'dart:io';
import 'package:excel/excel.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:untitled/Backup.dart';
import 'package:untitled/VMagazzino.dart';
import 'Carica.dart';
import 'DMag.dart';
import 'package:untitled/snakBar.dart';

import 'Xls.dart';

class EMagazzino extends StatefulWidget{
  EMagazzino({Key? key}) :super(key: key);
  @override
  State<EMagazzino> createState() => _EMagazzinoPageState();
}

class _EMagazzinoPageState extends State<EMagazzino>{
  _EMagazzinoPageState({Key? key});
  List<Xls> risultato = [];
  final _formKey1 = GlobalKey<FormState>();
  final input = [TextEditingController()];
  static final GlobalKey<ScaffoldState> _scaffoldkey13 = new GlobalKey<ScaffoldState>(); //per la comparsa dei pop-up

  bool contiene(String nomee, List<Xls> risultatoo){
    int c=0;
    for(int i=0; i<risultatoo.length; i++){
      if(risultatoo[i].nome==nomee){
        c++;
      }
    }
    if(c==0){
      return false;
    }else{
      return true;
    }
  }

  RealTimeSearch(){
    //if(input[0].text!=""){
      risultato.clear();
      var file = File("/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx");
      var bytes = File(file.path).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      var table = "magazzino";
      Sheet a = excel[table];
      for (int row = 0; row < a.maxRows; row++) {
        a.row(row).forEach((Data? cell1) {
          print(cell1?.value);
          if (cell1?.value.toString().contains(input[0].text)!=null&&contiene(input[0].text,risultato)==false) {
            print(cell1!.cellIndex);
            print(cell1.value);
            risultato.add(Xls(cell1.cellIndex, cell1.value));
            print(risultato);
          }
        });
      }
   // }else{
      //GlobalValues.showSnackbar(_scaffoldkey13, "ATTENZIONE", "inserire codice da cercare", "fallito");
    //}
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldkey13,
    appBar: AppBar(
      title: const Text('Search Page'),
    ),
      body: Form(
        key: _formKey1,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.all(30.0),
                child :TextFormField(
                  onChanged: RealTimeSearch(),
                  keyboardType: TextInputType.text,
                  controller: input[0],
                  validator: (val) => (val!.isEmpty||val.contains('.')||val.contains(',')||val.contains('-')||val.contains(' ')) ? "inserisci il codice" : null,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.numbers),
                    hintText: 'inserire il codice',
                    labelText: 'codice *',
                  ),
                ),
              ),
              Container(
                height:1000,
                child: ListView.builder(
                  itemCount: risultato.length,
                  scrollDirection: Axis.vertical,
                  prototypeItem: Padding(
                    padding: EdgeInsets.all(20),
                    child: ListTile(
                      title: Text("risultati"),
                    ),
                  ),
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
                                icon:const Icon(Icons.outbox, color: Colors.white),
                                onPressed: ()  {}
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                          title:Text(
                            "${risultato[index].nome}",
                            style: const TextStyle(fontWeight: FontWeight.bold),),
                          onTap: () =>[
                            ],
                          trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
                        ),
                      ),
                    );
                  }
                )
              )            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        child: Icon(Icons.exit_to_app),
        onPressed: () {
          setState(() {
            RealTimeSearch();
            print(risultato);
          });
        },
      ),
  );

  }
}