import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mvvm_todo/model/user_model.dart';
import 'package:mvvm_todo/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvvm_todo/screens/AddToDo.dart';
import 'package:mvvm_todo/screens/todoCard.dart';

import 'ViewData.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user=FirebaseAuth.instance.currentUser;
  UserModel loggedInUser=UserModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
    .collection("users")
    .doc(user!.uid)
    .get()
    .then((value){
      this.loggedInUser=UserModel.fromMap(value.data());
      setState(() {});
    });
  }
  final Stream<QuerySnapshot> _stream=
            FirebaseFirestore.instance.collection("Todo").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: "My Todo List".text.bold.amber50.xl4.make().shimmer(
            primaryColor:Colors.purple,
            secondaryColor:Colors.white,
          ),
      ),
        
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size:32,
                color: Colors.black87,
              ),
              label: ""
            ),
            BottomNavigationBarItem(
                icon: InkWell(
                  child: Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue
                    ),
                    child: Icon(
                      Icons.add,
                      size:32,
                      color: Colors.white,
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                                builder: (context) => AddToDoPage(
                                  email:loggedInUser.email.toString()
                                )));
                  },
                ),
                label: ""
            ),
            BottomNavigationBarItem(
                icon: InkWell(
                  child: Icon(
                    Icons.logout,
                    size:32,
                    color: Colors.black87,
                  ),
                  onTap: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginPage()));
                    Fluttertoast.showToast(msg: "Logout Successfully");
                  },
                ),
                label: ""
            ),
          ],
        ),
        drawer:Drawer(
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Image.asset("assets/images/man.png",
                    fit: BoxFit.contain,),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.blue,
                    height: 40,
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 10,),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text("${loggedInUser.firstName} ${loggedInUser.lastName}",style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                            ),),
                          ),
                        ),
                        Icon(Icons.verified_user_outlined,color: Colors.green,),
                      ],
                    )
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 5, 0),
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: Row(
                      children: [
                        Icon(Icons.email),
                        SizedBox(width: 10,),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text("${loggedInUser.email}",style: TextStyle(
                                color: Colors.black,
                                fontSize: 20
                            ),),
                          ),
                        ),
                      ],
                    )
                ),
                Divider(thickness: 1,color: Colors.grey,),
                GestureDetector(
                  onTap: (){
                    logout(context);
                  },
                  child: Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 5, 0),
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 10,),
                          Text("Logout",style: TextStyle(
                              color: Colors.black,
                              fontSize: 20
                          ),),
                        ],
                      )
                  ),
                ),
                Divider(thickness: 1,color: Colors.grey,),
              ],
            ),
          ),
        ),
      body:   StreamBuilder<Object>(
          stream: _stream,
        builder: (BuildContext context,AsyncSnapshot snapshot){
            if(!snapshot.hasData){
              return CircularProgressIndicator();
            }
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context,index){
                IconData iconData;
                Color iconColor;
                Map<String,dynamic> document =snapshot.data.docs[index].data() as Map<String,dynamic>;
                switch(document["category"]){
                  case "Work":
                      iconData=Icons.work_history_outlined;
                      iconColor=Colors.black87;
                      break;
                  case "Food":
                    iconData=Icons.fastfood_rounded;
                    iconColor=Colors.amber;
                    break;
                  case "WorkOut":
                    iconData=Icons.run_circle_rounded;
                    iconColor=Colors.red;
                    break;
                  case "Design":
                    iconData=Icons.draw;
                    iconColor=Colors.blue;
                    break;
                  case "Run":
                    iconData=Icons.run_circle_outlined;
                    iconColor=Colors.green;
                    break;

                  default:
                      iconData=Icons.arrow_circle_left_rounded;
                      iconColor=Colors.black87;
                    break;
                }
                return loggedInUser.email==document["email"]?InkWell(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder)=> ViewData(
                            document:document,id: snapshot.data.docs[index].id
                        )));
                  },
                  child: TodoCard(
                    title: document["title"]==null?"Untitled":document["title"],
                    iconData: iconData,
                    iconColor: iconColor,
                    time: "9 AM",
                    check:document["check"]=="true"?"true":"false",
                    iconBgColor: Colors.red,
                    id: snapshot.data.docs[index].id
                  ),
                ):SizedBox(height: 0,);
            },

            );
        }
      ),
        
    );
  }
  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginPage()));
    Fluttertoast.showToast(msg: "Logout Successfully");
  }
}
