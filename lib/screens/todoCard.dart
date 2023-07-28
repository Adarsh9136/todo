import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class TodoCard extends StatefulWidget {
  const TodoCard({
  //  required Key key,
    required this.title,
    required this.iconData,
    required this.iconColor,
    required this.time,
    required this.check,
    required this.iconBgColor,
    required this.id,
  });
  final String title;
  final IconData iconData;
  final Color iconColor;
  final String time;
  final String check;
  final Color iconBgColor;
  final String id;

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Theme(
              child: Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                  ),
                  activeColor: Color(0xff6cf8a9),
                  checkColor: Color(0xff0e3e26),
                  value: widget.check=="true"?true:false,
                  onChanged: (value){
                        setState(() {
                          if(widget.check=="true"){
                            FirebaseFirestore.instance.collection("Todo").doc(widget.id).update(
                                {
                                 "check":"false"
                                }
                            );
                          }else{
                            FirebaseFirestore.instance.collection("Todo").doc(widget.id).update(
                                {
                                  "check":"true"
                                }
                            );
                          }
                        });
                  },
                  ),
              ),
            data: ThemeData(
              primarySwatch: Colors.blue,
              unselectedWidgetColor: Colors.black87
            ),
          ),
          Expanded(
            child: Container(
              height: 75,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                color: Colors.grey,
                child: Row(
                  children: [
                    SizedBox(width: 15,),
                    Container(
                      height: 33,
                      width: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Icon(widget.iconData,color: widget.iconColor,),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: Text(widget.title,style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white
                      ),),
                    ),
                    IconButton(onPressed: (){
                      setState(() {

                        FirebaseFirestore.instance.collection("Todo").doc(widget.id).delete();
                      });
                    }, icon: Icon(Icons.delete)),
                    SizedBox(width: 10,),

                  ],
                ),
              ),
            ),
          )
        ],
      ),

    );
  }
}
// class Select{
//   String id;
//   bool checkValue=false;
//   Select({required this.id,required this.checkValue});
// }
