class DMag{
  String riga="";
  int pezzi=0;
  String bancale = "";
  String data ="";
  String codice="";
  List<int> A=[];

  DMag(int pezzii, String rigaa, String bancalee,String codicee){
    riga = rigaa;
    pezzi = pezzii;
    bancale = bancalee;
    codice = codicee;
  }

  void SetRiga(String rigaa){
    riga=rigaa;
  }

  void setData(String Dataa){
    data = Dataa;
  }

  void setA(List<int> a){
    for(int i=0;i<a.length;i++){
      A.add(a[i]);
    }
    A=a;
  }
}