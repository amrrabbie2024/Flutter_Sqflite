class Person{
  int? personId;
  String? personName;
  String? persomMob;
  String? personAge;
  String? personAddress;
  String? personJob;

  Person({this.personId, required this.personName,required this.persomMob, this.personAge, this.personAddress,
      this.personJob});

  Map<String,dynamic> toMap(){
    return {"personId":personId,"personName":personName,"persomMob":persomMob,
      "personAge":personAge,"personAddress":personAddress,"personJob":personJob};
  }

  Person.fromMap(Map<String,dynamic> map){
    personId=map['personId'];
    personName=map['personName'];
    persomMob=map['persomMob'];
    personAge=map['personAge'];
    personAddress=map['personAddress'];
    personJob=map['personJob'];
  }


}