import 'package:flutter/material.dart';
import 'package:untitled/SCMagazzino.dart';
import 'DMag.dart';

class VResi extends StatelessWidget {

  List<DMag> file=[];
  VResi({Key? key, required this.file}):super(key:key);


  @override
  Widget build(BuildContext context) {
    const title = '           BANCALI';
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
                        leading: Container(
                          padding: const EdgeInsets.only(right: 12.0),
                          decoration: const BoxDecoration(
                              border: Border(
                                  right: BorderSide(width: 3.0, color: Colors.white24))),
                          child: const Icon(Icons.file_open, color: Colors.white),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                        title:Text(
                          "${file[index].codice}\n agiunto il:${file[index].data}\n pezzi:${file[index].pezzi}\n bancale:${file[index].bancale}",
                          style: const TextStyle(fontWeight: FontWeight.bold),),
                        /*onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => IResi(file: file[index])),),
                        trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),*/
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