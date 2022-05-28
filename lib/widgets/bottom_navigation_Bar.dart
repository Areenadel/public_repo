//i should add it
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:svc15/screens/main%20screens/home_page_screen.dart';
import 'package:svc15/screens/main%20screens/profile_screen.dart';
import 'package:svc15/screens/other%20screens/create_post_screen.dart';

class MyBottomNavigationBar extends StatefulWidget {
  int _selectedIndex;
  final id;


  MyBottomNavigationBar(
      this._selectedIndex,this.id);
  // const MyBottomNavigationBar({Key? key, items}) : super(key: key);

  @override
  _BottomNavigationBarState createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home Page'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.post_add),
              label: 'Add Post'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile'
          ),
        ],
      currentIndex: widget._selectedIndex,
      onTap: _onItemTapped,
      selectedIconTheme: IconThemeData(size: 40),

    );
  }
  void _onItemTapped(int index){
    setState(() {
      widget._selectedIndex = index;
      if(widget._selectedIndex == 0)
        Navigator.pushReplacement(context, new MaterialPageRoute(
            builder: (context) =>
            new HomepageScreen(widget.id))
        );
        // Navigator.pushReplacementNamed(context, HomepageScreen.routeName);
      else if(widget._selectedIndex == 1)
        Navigator.pushReplacement(context, new MaterialPageRoute(
            builder: (context) =>
            new CreatePostScreen(widget.id))
        );
        // Navigator.pushReplacementNamed(context, CreatePostScreen.routeName);
      else if(widget._selectedIndex == 2)
        Navigator.pushReplacement(context, new MaterialPageRoute(
            builder: (context) =>
            new ProfileScreen(widget.id))
        );
    });

  }
}

