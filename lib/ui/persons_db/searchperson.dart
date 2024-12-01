import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_db/ui/persons_db/personslist.dart';

import 'package:sqflite/sqflite.dart';

import '../../db/db_helper.dart';
import '../../model/persons.dart';
import 'addpersons.dart';

class SearchPerson extends StatefulWidget {
  const SearchPerson({Key? key}) : super(key: key);

  @override
  _SearchPersonState createState() => _SearchPersonState();
}

class _SearchPersonState extends State<SearchPerson> {

  Database? _db;
  var _helper=Db_Helper();
  var _formKey=GlobalKey<FormState>();
  var _namecontroller=TextEditingController();
  List<Person> list=[];

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
      body: Container(
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
              ElevatedButton(onPressed: (){
                if(_formKey.currentState!.validate()){
                  String name=_namecontroller.value.text;
                  searchByName(name);
                }
              },
                  child: Text("Search ...")),
              ListView.builder(
                shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (context,index){
                  return itemView(list[index]);
                  })
            ],
          ),
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

  void searchByName(String name) {
    _helper.searchPersonsByName(name).then((value) {
     if(value != null){
       setState(() {
         list=value;
       });
     }
    });
  }

  Widget itemView(Person list) {
    return Card(
      child: InkWell(

        child:Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        color: Colors.grey,
        child: Column(
          children: [
            Text("${list.personName}",style: TextStyle(fontSize: 25,color: Colors.red),),
            Text("${list.persomMob}",style: TextStyle(fontSize: 30,color: Colors.blue),),
            Text("${list.personAge}",style: TextStyle(fontSize: 30,color: Colors.green),),
            Text("${list.personAddress}",style: TextStyle(fontSize: 22,color: Colors.deepOrangeAccent),),
            Text("${list.personJob}",style: TextStyle(fontSize: 24,color: Colors.cyanAccent),),
          ],
        ),
      ),
        onTap: (){
          print('${list.personName} , ${list.persomMob}');
        },
    ));
  }

}
