import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:excel/excel.dart';
import 'package:path/path.dart';
import 'package:untitled/snakBar.dart';

//visualizzo i banccali trovati con il codice cercato
class Backup extends StatefulWidget {

  Backup({Key? key}) : super(key: key);

  @override
  State<Backup> createState() => _BackupPageState();
}

class _BackupPageState extends State<Backup> {

  static final GlobalKey<ScaffoldState> _scaffoldKey12 = new GlobalKey<ScaffoldState>(); //key per i pop-up

  _BackupPageState({Key? key});

  Future<void> FBackup() async {
    var file1 = File("/storage/emulated/0/Android/data/com.example.untitled/files/magazzino.xlsx");
    var bytes = File(file1.path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    String data = DateTime.now().day.toString() + "-" + DateTime.now().month.toString()+"("+DateTime.now().hour.toString()+"-"+DateTime.now().minute.toString()+")";
    String Poutput = "/storage/emulated/0/Download/magazzino"+data+".xlsx";
    List<int>? fileBytes = excel.save();
    if (fileBytes != null) {
      File(join(Poutput))
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }
    var syncPath = await Poutput;
    await io.File(syncPath).exists();
    if(io.File(syncPath).existsSync()){
      GlobalValues.showSnackbar(_scaffoldKey12, "ATTENZIONE", "salvato con successo", "successo");
    }else{
      GlobalValues.showSnackbar(_scaffoldKey12, "ATTENZIONE", "Backup non riuscito", "fallito");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey12,
      appBar: AppBar(
        title: const Text("Backup"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(200.0) ,),
            Padding(padding: EdgeInsets.all(30.0),child: Text("PREMI PER ESEGUIRE IL BACKUP")),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    FBackup();
                  });
                },
                child: const Icon(Icons.backup)),
          ],
        ),
      ),
    );
  }
}
