import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_db/ui/persons_db/personslist.dart';
import 'package:flutter_db/ui/persons_db/searchperson.dart';


import 'addpersons.dart';

class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage2> with TickerProviderStateMixin {
  var _tabcontroller;
  var intial_index=0;

  @override
  void initState() {
    // TODO: implement initState
    _tabcontroller=TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /*appBar: AppBar(
        //title: MyTabBar(),
      ),*/
      //drawer: MyDrawer(),
      /*body: TabBarView(
        children: [PersonsList(),AddPerson(),SearchPerson()],
        controller: _tabcontroller,
      ),*/

      body: bottomNavigationPages(intial_index),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: intial_index,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list),label: "Persons list"),
          BottomNavigationBarItem(icon: Icon(Icons.add),label: "Add person"),
          BottomNavigationBarItem(icon: Icon(Icons.search),label: "Search persons")
        ],
        onTap: (index){
          setState(() {
            intial_index=index;
            print(intial_index);
          });
        },
      ),

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

 Widget MyTabBar() {
    return  TabBar(
        labelColor: Colors.black,
        tabs: [
          Tab(
            icon: Icon(Icons.list),
            text: "Persons list",
          ),
          Tab(
            icon: Icon(Icons.add),
            text: "Add person",
          ),
          Tab(
            icon: Icon(Icons.search),
            text: "Search person",
          )
        ],
        onTap: (index){
          print(index);
        },

    );
 }

  Widget bottomNavigationPages(int index) {

    if(index == 0){
      return PersonsList();
    }else if(index == 1){
      return AddPerson();
    }else if(index == 2){
      return SearchPerson();
    }else{
      return PersonsList();
    }
  }


}
