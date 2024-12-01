import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_db/ui/persons_db/searchperson.dart';

import 'package:sqflite/sqflite.dart';

import '../../db/db_helper.dart';
import '../../model/persons.dart';
import 'addpersons.dart';
import 'home.dart';

class PersonsList extends StatefulWidget {
  const PersonsList({Key? key}) : super(key: key);

  @override
  _PersonsListState createState() => _PersonsListState();
}

class _PersonsListState extends State<PersonsList> {

  Database? _db;
  var _helper=Db_Helper();
  List<Person> list=[];
  var _formKey=GlobalKey<FormState>();


  @override
  void initState() {
    _helper.createDbInstance().then((value) => _db=value);
    viewPersonsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        //title: MyTabBar(),
      ),
      drawer: MyDrawer(),
      body: ListView.builder(
        shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context,index){
          return itemView(list[index]);
          })

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

  void viewPersonsList() {
    _helper.getAllPersons().then((value) => {
      setState((){
        list=value;
      })
    });
  }

  Widget itemView(Person list) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.person,color: Colors.blue,),
        title: Text("${list.personName}"),
        subtitle: Text("${list.persomMob}"),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(onPressed: (){
                openUpdateDialogPerson(list);
              },
                  icon: Icon(Icons.edit)),
              IconButton(onPressed: (){
                openDeleteDialogPerson(list);
              },
                  icon: Icon(Icons.delete))
            ],
          ),
        ),
        onTap: (){
          print('${list.personName} - ${list.persomMob}');
        },
      ),
    );

  }

  void openUpdateDialogPerson(Person person) {
    var _updatenamecontroller=TextEditingController(text: '${person.personName}');
    var _updatemobcontroller=TextEditingController(text: '${person.persomMob}');

    showDialog(context: context, builder: (context)=>
        SimpleDialog(
          title: Text('Update person'),
          children: [
            Container(
              color: Colors.yellow,
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              height: 180,
              child:Form(key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _updatenamecontroller,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'must enter person name';
                      }else
                        return null;
                    },
                    decoration: InputDecoration(hintText: 'person name'),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _updatemobcontroller,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'must enter person phone';
                      }else
                        return null;
                    },
                    decoration: InputDecoration(hintText: 'person phone'),
                  ),
                  ElevatedButton(onPressed: (){
                    if(_formKey.currentState!.validate()){
                      person.personName=_updatenamecontroller.value.text;
                      person.persomMob=_updatemobcontroller.value.text;
                      updatePerson(person);
                    }
                  },
                      child: Text('Update'))
                ],
              ),
                  )

            )
          ],
        )
    );
  }

  void openDeleteDialogPerson(Person person) {
    showDialog(context: context, builder: (context)=>
        SimpleDialog(
          title: Text('Confirm delete'),
          children: [
            Container(
              color: Colors.grey,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              height: 150,
              child: Column(
                children: [
                  Text('Are you sure you want to delete this?!',style: TextStyle(fontSize: 21,color: Colors.black),),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ElevatedButton(onPressed: (){

                          deletePerson(person);
                        }, child: Text("Yes")),
                        ElevatedButton(onPressed: (){
                          Navigator.pop(context);
                        },
                            child: Text('No'))
                      ],
                    ),
                  )
                  
                ],
              ),
            )
          ],
        )
    );
  }

  void deletePerson(Person person) {
    _helper.deletePerson(person).then((value)  {
      if(value != null){
        print("Person data deleted");
        Navigator.pop(context);
        viewPersonsList();
      }
    });
  }

  void updatePerson(Person person) {
    _helper.updatePerson(person).then((value) {
      if(value != null){
        print('person data updated');
        Navigator.pop(context);
        viewPersonsList();
      }
    } );
  }
}
