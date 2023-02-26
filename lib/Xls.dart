import 'package:flutter/material.dart';
class Xls{
  String riga="";
  String NFile="";
  int PMancanti=0;
  String NFoglio="";
  String Bancale = "";
  int PMagazzino = 0;
  String data ="";
  String codice="";

  Xls(String NFilee, int PMancantii, String rigaa, String NFolgioo, String Bancalee, int PMagazzinoo, String dataa, String codicee){
    riga=rigaa;
    NFile=NFilee;
    PMancanti=PMancantii;
    NFoglio=NFolgioo;
    Bancale=Bancalee;
    PMagazzino=PMagazzinoo;
    data=dataa;
    codice=codicee;
  }

  void SetNFile(String NFilee){
    NFile==NFilee;
  }

  void SetRiga(String rigaa){
    riga=rigaa;
  }

  void SetPMancanti(int PMancantii){
    PMancanti=PMancantii;
  }

  void SetNFoglio(String NFolgioo){
    NFoglio=NFolgioo;
  }

  void setBancale(String Bancalee){
    Bancale = Bancalee;
  }

  void setPMagazzino(int PMagazzinoo){
    PMagazzino = PMagazzinoo;
  }

  void setData(String Dataa){
    data = Dataa;
  }
  void setCodice(String codicee){
    codice = codicee;
  }

}