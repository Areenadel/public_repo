import 'package:flutter/material.dart';
import 'package:svc15/screens/main%20screens/svc_screen.dart';

class ListItem extends StatefulWidget {
  final name; //svc name or profile name
  final id;
  final Uid;
  const ListItem({this.name,this.id,this.Uid});
  // const ListItem({Key? key}) : super(key: key);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        // color: Colors.black38,
        child: GestureDetector(

          onTap: () => Navigator.pushReplacement(context, new MaterialPageRoute(
              builder: (context) =>
              new SVCScreen(widget.id,widget.name,widget.Uid))),//change it
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 15, 10),
                child: CircleAvatar(radius: 23,),
              ),
              Text(widget.name),
            ],
          ),
        ),
      ),
    );
  }
}