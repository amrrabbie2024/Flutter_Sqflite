
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/persons.dart';
import 'constants.dart';

class Db_Helper{
  static Db_Helper? _helper;

  Db_Helper._Instance();

  factory Db_Helper(){
    if(_helper == null){
      _helper=Db_Helper._Instance();
    }
    return _helper!;
  }

  Future<Database> createDbInstance () async {
    String dbpath=await getDatabasesPath();
    String path=join(dbpath,Constants.Db_Name);
    return openDatabase(
        path,
      version: 1,
      onCreate: (db,version)=>createPersonsDb(db,version),
      onUpgrade: (db,oldversion,newversion)=>updatePersondDb(db,newversion)
    );
  }

  createPersonsDb(Database db, int version) {
    String sql=
        "create table ${Constants.Table_Name} (${Constants.Col_Id} integer primary key autoincrement,${Constants.Col_Name} text,${Constants.Col_Mob} text,${Constants.Col_Age} text,${Constants.Col_Adress} text,${Constants.Col_Job} text)";
    print(sql);
    db.execute(sql);
  }

  updatePersondDb(Database db, int newversion) {
    String sql="drop table if exists ${Constants.Table_Name}";
    print(sql);
    db.execute(sql);
    createPersonsDb(db, newversion);
  }

  Future <List<Person>> getAllPersons() async{
    List<Person> list=[];
    Database db= await createDbInstance();

    List<Map<String,dynamic>> rsults=await db.query(Constants.Table_Name,
        orderBy: Constants.Col_Age + " desc");

    rsults.forEach((element) { 
      list.add(Person.fromMap(element));
    });
    return list;
  }

  Future<int> deletePerson(Person person) async {
    Database db=await  createDbInstance();
    return db.delete(Constants.Table_Name,
    where: Constants.Col_Id+"=?",whereArgs: [person.personId]);
  }

  Future<int> insertPerson(Person person) async {
    Database db=await createDbInstance();
    return db.insert(Constants.Table_Name, person.toMap());
  }

  Future<int> updatePerson(Person person) async {
    Database db=await createDbInstance();
    return db.update(Constants.Table_Name, person.toMap(),
    where: Constants.Col_Id+"=?",whereArgs: [person.personId]);
  }


  Future <List<Person>> searchPersonsByName(String name) async{
    List<Person> list=[];
    String s="%$name%";
    Database db= await createDbInstance();

    List<Map<String,dynamic>> rsults=await db.query(Constants.Table_Name,
        orderBy: Constants.Col_Age + " desc",

    where: Constants.Col_Name+"=?",whereArgs: [name]);

    rsults.forEach((element) {
      list.add(Person.fromMap(element));
    });
    return list;
  }







}