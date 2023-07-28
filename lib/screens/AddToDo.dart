
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:[Colors.black,Colors.pinkAccent]
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
                  child: Center(
                    child: Container(
                      width: width>1000?800:null,
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
                              categorySelect("WorkOut",0xfff29732),
                              categorySelect("Work", 0xff6557ff),
                              categorySelect("Design", 0xff234ebd),
                              categorySelect("Run", 0xff2bc8d9),
                            ],
                          ),
                          SizedBox(height: 20,),
                          button()

                        ],
                      ),
                    ),
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
        Fluttertoast.showToast(msg: "Added successfully");
        Navigator.pop(context);
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Colors.black,
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
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
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
      child: Padding(
        padding: const EdgeInsets.all(4.0),
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
      child: Padding(
        padding: const EdgeInsets.all(4.0),
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
      ),
    );
  }
  Widget title(){
    return Container(
      height: 55,
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
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
