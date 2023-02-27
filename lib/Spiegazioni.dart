import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:untitled/PercorsoFile.dart';
import 'package:untitled/VMagazzino.dart';
import 'DMag.dart';


class Spiegazione extends StatefulWidget {
  const Spiegazione({Key? key}) : super(key: key);

  @override
  State<Spiegazione> createState() => _SpiegazioneState();
}

class _SpiegazioneState extends State<Spiegazione> {
  List<DMag> risultato = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Spiegazzioni     ",
            style: TextStyle(fontWeight: FontWeight.bold),),
        ),
      ),
      body: Scrollbar(
        child: Column(
            children: const <Widget>[
              Expanded(
                child: Text(
                  "-1 INSERIMENTO PEZZI",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontFamily: "Caveat",
                      fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: Text(
                  "Per inserire un pezzo aal'interno delle distinte bisogna come prima cosa cercare il suo codice nella schermata home. "
                      "Una volta che l'applicazzione avrà trovato dove il pezzo è presente (ci possono volere all'incirca 10 secondi) selezionare in quale distinta inserire il materiale"
                      " (se in una distinta non ci sono ne pezzi in magazzino ne mancanti vuol dire che in quella distinta il codice non è stato trovato). ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: "Caveat",
                      fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: Text(
                  "-1.1 INSERIMENTO PEZZI SENZA BANCALE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontFamily: "Caveat",
                      fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: Text(
                  "Per inserire dei pezzi senza specificare il bancale, cioè segnandoli in distinta ma non nel magazzino, basta scrivere il numero dei pezzi senza"
                      " aggiungere il nome del bancale ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: "Caveat",
                      fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: Text(
                  "-1.2 INSERIMENTO PEZZI CON BANCALE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontFamily: "Caveat",
                      fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: Text(
                  "Per inserire dei pezzi conpresi di posizione nel magazzino basta aggiungere anche il nome del bancale nella sezione appostita."
                      " in questo modo quando il pezzo verrà cercato nella sezione di caricaScarica verrà trovato con il suo bancale",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: "Caveat",
                      fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: Text(
                  "-2 CERCARE PEZZI NEL MAGAZZINO",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontFamily: "Caveat",
                      fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: Text(
                  "Per cercare i pezzi nel magazzino e sapere in che bancale si trovano bisogna andare nella sezione (carica scarica) che si trova"
                      " nel menu a tendina in alto a destra. Aperta la pagina magazzino si potra cercare il codice e visualizzare il pezzo in che bancali si trova"
                      " e in che quantità (se l'unica icona rossa visualizzata dice inesistenrte e segna 0 pezzi disponibili vuol dire che il codice non è presente in magazzino)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: "Caveat",
                      fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: Text(
                  "-3.1 INSERIRE PEZZI NEL MAGAZZINO",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontFamily: "Caveat",
                      fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: Text(
                  "Seguire i passaggi del punto 2, in seguito selezionare il bancale nel quale si vogliono inserire o prelevare i pezzi. Comparirà una casella di testo"
                      " dove si potranno inserire i pezzi che si vogliono togliere o mettere. Per prelevare i pezzi schiacciare sul bottono scarica e poi dare l'invio con il bottone "
                      "rosso in basso a destra, per inserirli schiacciare prima su carica ed in seguito sul solito bottone rosso ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: "Caveat",
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
      ),
    );
  }
}
