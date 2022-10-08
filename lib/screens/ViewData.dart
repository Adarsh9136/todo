import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewData extends StatefulWidget {
  const ViewData({super.key,required this.document,required this.id});
  final Map<String,dynamic> document;
  final String id;
  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String type;
  late String category;
  // String email=email;
  bool edit=false;
  @override
  void initState(){
    _titleController=widget.document["title"]==null?
        TextEditingController(text: "Untitled")
        :TextEditingController(text: widget.document["title"]);
    _descriptionController=widget.document["description"]==null?
    TextEditingController(text: "")
        :TextEditingController(text: widget.document["description"]);
    type=widget.document["task"]==null?"no":widget.document["task"];
    category=widget.document["category"]==null?"no":widget.document["category"];

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors:[Colors.blue,Colors.black26]
          ),

        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  },
                      icon: Icon(CupertinoIcons.arrow_left,
                        color: Colors.white,
                        size: 30,
                      )
                  ),
                  IconButton(onPressed: (){
                    setState(() {
                      if(edit==false) edit=true;
                    });

                  },
                      icon: Icon(Icons.edit,

                        color: edit==false?Colors.white:Colors.red,
                        size: 30,
                      )
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(edit==false?"View":"Edit",
                      style: TextStyle(
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),),
                    SizedBox(height: 8,),
                    Text("Your Todo",
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
                    edit==false?Text(""):button()

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
        FirebaseFirestore.instance.collection("Todo").doc(widget.id).update(
            {
              "title":_titleController.text,
              "task":type,
              "category":category,
              "description":_descriptionController.text,
              //"email"=email;
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
        child: Center(child: Text("Update",style: TextStyle(
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
        enabled: edit==false?false:true,
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
          edit==false?null:category=label;
        });
      },
      child: Chip(
        backgroundColor: category==label?Colors.white:Color(color),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        label: Text(label,style: TextStyle(
            color: category==label?Colors.black:Colors.white,
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
          edit==false?null:type=label;

        });
      },
      child: Chip(
        backgroundColor: type==label?Colors.white:Color(color),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        label: Text(label,style: TextStyle(
            color: type==label?Colors.black:Colors.white,
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
        enabled: edit==false?false:true,
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
