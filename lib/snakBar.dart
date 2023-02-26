import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class GlobalValues {
  static showSnackbar(GlobalKey key, String titolo,String msg ,String type) {
    BuildContext c= key.currentState!.context;
    if(type=="successo") {
      ScaffoldMessenger.of(c).showSnackBar(SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: titolo,
          message: msg,
          contentType: ContentType.success,
        ),
      ),
      );
    }else if(type=="fallito"){
      ScaffoldMessenger.of(c).showSnackBar(SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: titolo,
          message: msg,
          contentType: ContentType.failure,
        ),
      ),
      );
    }else{
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
    title: titolo,
    message: msg,
    contentType: ContentType.warning,
    ),
    ),
    );
    }
  }
}