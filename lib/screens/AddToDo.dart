import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddToDoPage extends StatefulWidget {
  const AddToDoPage({super.key,required this.email});
  final String email;
  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {

  TextEditingController _titleController=TextEditingController();
  TextEditingController _descriptionController=TextEditingController();
  String type="";
  String category="";
 // String email=email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:[Colors.blueGrey,Colors.white]
            ),

          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                IconButton(onPressed: (){
                  Navigator.pop(context);
                },
                    icon: Icon(CupertinoIcons.arrow_left,
                    color: Colors.white,
                    size: 30,
                    )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text("Create",
                          style: TextStyle(
                            fontSize: 33,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 4,
                          ),),
                      SizedBox(height: 8,),
                      Text("New Todo",
                        style: TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 4,
                        ),),
                      SizedBox(height: 25,),
                      label("Task Title"),
                      SizedBox(height: 15,),
                      title(),
                      SizedBox(height: 30,),
                      label("Task Type"),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          taskSelect("Important",0xff2664fa),
                          SizedBox(width: 20,),
                          taskSelect("Planned", 0xff2bc8d9)
                        ],
                      ),
                      SizedBox(height: 15,),
                      label("Description"),
                      SizedBox(height: 10,),
                      description(),
                      SizedBox(height: 15,),
                      label("Category"),
                      SizedBox(height: 15,),
                      Wrap(
                        children: [
                          categorySelect("Food",0xffff646e),
                          SizedBox(width: 20,),
                          categorySelect("WorkOut",0xfff29732),
                          SizedBox(width: 20,),
                          categorySelect("Work", 0xff6557ff),
                          SizedBox(width: 20,),
                          categorySelect("Design", 0xff234ebd),
                          SizedBox(width: 20,),
                          categorySelect("Run", 0xff2bc8d9),
                        ],
                      ),
                      SizedBox(height: 20,),
                      button()

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }
  Widget button(){
    return InkWell(
      onTap: (){
        FirebaseFirestore.instance.collection("Todo").add(
            {
            "title":_titleController.text,
            "task":type,
            "category":category,
            "description":_descriptionController.text,
            "email":widget.email,
            "check":"false"
            }
        );
        Navigator.pop(context);
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
        ),
        child: Center(child: Text("Submit",style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 25
        ),)),
      ),
    );
  }
  Widget description(){
    return Container(
      height: 155,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(15)
      ),
      child: TextFormField(
        controller: _descriptionController,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
        maxLines: null,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Description",
            hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 17
            ),
            contentPadding: EdgeInsets.only(left: 20,right: 20)
        ),
      ),
    );
  }
  Widget categorySelect(String label,int color){
    return InkWell(
        onTap: () {
          setState(() {
            category = label;
          });
        },
      child: Chip(
        backgroundColor: category==label?Colors.black87:Color(color),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        label: Text(label,style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          fontWeight: FontWeight.w600
        ),),
        labelPadding: EdgeInsets.symmetric(horizontal: 17,vertical: 3.8),
      ),
    );
  }
  Widget taskSelect(String label,int color){
    return InkWell(
      onTap: (){
        setState(() {
          type=label;

        });
      },
      child: Chip(
        backgroundColor: type==label?Colors.black87:Color(color),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        label: Text(label,style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600
        ),),
        labelPadding: EdgeInsets.symmetric(horizontal: 17,vertical: 3.8),
      ),
    );
  }
  Widget title(){
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(15)
      ),
      child: TextFormField(
        controller: _titleController,
        style: TextStyle(
            color: Colors.white,
        ),
        decoration: InputDecoration(
            border: InputBorder.none,
          hintText: "Task Title",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17
          ),
          contentPadding: EdgeInsets.only(left: 20,right: 20)
        ),
      ),
    );
  }
  Widget label(String label){
    return Text(label,
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 17,
      letterSpacing: 0.2
    ),);
  }
}
