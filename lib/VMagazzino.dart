import 'package:flutter/material.dart';
import 'package:untitled/SCMagazzino.dart';
import 'DMag.dart';

//visualizzo i banccali trovati con il codice cercato
class VMagazzino extends StatefulWidget {
  List<int> dropDownValue = []; //numero risultati dropdown
  List<DMag> file = []; //lista risultati
  String? cliente;
  String? commessa;

  VMagazzino({Key? key, required this.file, this.cliente, this.commessa}) :super(key: key);

  @override
  State<VMagazzino> createState() => _VMagazzinoPageState(file: file, cliente: cliente, commessa: commessa);
}
  class _VMagazzinoPageState extends State<VMagazzino>{
    List<int> dropDownValue = []; //numero risultati dropdown
    List<DMag> file = []; //lista risultati
    String? cliente;
    String? commessa;
  _VMagazzinoPageState({Key? key, required this.file, this.cliente, this.commessa});

  void prova(int index) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SSMagazzino(file: file[index], cliente: cliente, commessa: commessa)),);
  }
  @override
  Widget build(BuildContext context) {
    const title = '          BANCALI';
    return MaterialApp(
      title: title,
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
      home: Scaffold(
          appBar: AppBar(
            title: const Text(title),
          ),
          body: Container(
            height: 1000,
            child: ListView.builder(
                itemCount: file.length,
                scrollDirection: Axis.vertical,
                prototypeItem: Padding(
                  padding: EdgeInsets.all(20),
                  child: ListTile(
                    title: Text(file.first.bancale),
                  ),
                ),
                itemBuilder: (BuildContext context, int index){
                  return Card(
                    elevation: 10.0,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.red),
                      child : ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                        title:Text(
                          "codice: ${file[index].codice}\nagiunto il: ${file[index].data}\npezzi: ${file[index].pezzi}\nbancale: ${file[index].bancale}",
                          style: const TextStyle(fontWeight: FontWeight.bold),),
                        onTap: () =>[
                          print(commessa),
                          print(cliente),
                          prova(index),],
                        trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 60),
                      ),
                    ),
                  );
                }
            ),
          )
      ),
    );
  }
}