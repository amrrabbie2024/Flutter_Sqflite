import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_db/ui/persons_db/personslist.dart';
import 'package:flutter_db/ui/persons_db/searchperson.dart';

import 'package:sqflite/sqflite.dart';

import '../../db/db_helper.dart';
import '../../model/persons.dart';

class AddPerson extends StatefulWidget {
  const AddPerson({Key? key}) : super(key: key);

  @override
  _AddPersonState createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson> {

  Database? _db;
  var _helper=Db_Helper();

  var _namecontroller=TextEditingController();
  var _mobcontroller=TextEditingController();
  var _agecontroller=TextEditingController();
  var _addresscontroller=TextEditingController();
  var _jobcontroller=TextEditingController();
  var _formKey=GlobalKey<FormState>();

  @override
  void initState() {
    _helper.createDbInstance().then((value) => _db=value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        //title: MyTabBar(),
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Form(key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _namecontroller,
                      validator: (value){
                        if(value!.isEmpty){
                          return "must enter person name";
                        }else
                          return null;
                      },
                      decoration: InputDecoration(hintText: "person name"),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _mobcontroller,
                      validator: (value){
                        if(value!.isEmpty){
                          return "must enter person mobile";
                        }else
                          return null;
                      },
                      decoration: InputDecoration(hintText: "person mobile"),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _agecontroller,
                      decoration: InputDecoration(hintText: "person age"),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _addresscontroller,
                      decoration: InputDecoration(hintText: "person address"),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _jobcontroller,
                      decoration: InputDecoration(hintText: "person job"),
                    ),
                    ElevatedButton(onPressed: (){
                      if(_formKey.currentState!.validate()){
                        var person=Person(personName: _namecontroller.value.text, persomMob: _mobcontroller.value.text,personAge: _agecontroller.value.text ,personAddress: _addresscontroller.value.text,personJob: _jobcontroller.value.text);
                        insertPerson(person);
                      }
                    },
                        child: Text("Save person data"))
                  ],
                ),
              ),
            )
          ],
        ),
      )

    );
  }

  Widget MyDrawer() {
    return Drawer(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 180,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage("https://images.app.goo.gl/9cdpQfKNx9fvkmYq6"),
                      fit: BoxFit.cover
                  )
              ),
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(radius: 50,
                      backgroundImage: NetworkImage(""),),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Persons Information",style: TextStyle(fontSize: 20,color: Colors.blue),)
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Persons list',style: TextStyle(fontSize: 18,color: Colors.yellow),),
              onTap: (){
                navigateToPersonsList();
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add person',style: TextStyle(fontSize: 18,color: Colors.yellow)),
              onTap: (){
                navigateToAddPerson();
              },
            ),
            Divider(color: Colors.black,),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Search persons',style: TextStyle(fontSize: 18,color: Colors.yellow)),
              onTap: (){
                navigateToSearchPerson();
              },
            )
          ],
        ),
      ),
    );
  }

  void navigateToPersonsList() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PersonsList()));
  }

  void navigateToAddPerson() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddPerson()));
  }

  void navigateToSearchPerson() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchPerson()));
  }

  void insertPerson(Person person) {
    _helper.insertPerson(person).then((value)  {
      if(value != null)
        print("person data added");
    }).catchError((error){
      print(error);
    });
  }
}
