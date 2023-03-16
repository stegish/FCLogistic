import 'package:flutter/material.dart';
import 'package:excel/excel.dart';

class Xls{
  CellIndex index = CellIndex.indexByString("A2");
  String nome = "";

  Xls(CellIndex indexx, String nomee){
    nome = nomee;
    index = indexx;
  }

}