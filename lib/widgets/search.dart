import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:search_choices/search_choices.dart';
import 'package:svc15/screens/main%20screens/svc_screen.dart';
import 'package:svc15/widgets/app_drawer.dart';
import 'package:svc15/widgets/search_item.dart';

import '../screens/main screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  // const SearchScreen(id, {Key? key}) : super(key: key);
  final id;
  SearchScreen(this.id);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  String dropDownValue = '';  // SVC initial value
  // Widget ab = Row(children: [Text('SVC 16')],);
  // Widget a = Row(
  //   children: [
  //     Text('SVC 12'),
  //     CircleAvatar(radius: 20,),
  //     Text('SVC 11'),
  // ],);

  final String searchQuery="""
  
 query Users{
  users(options: {limit:10}) {
    id
    username
  }
  svcs (options: {limit:10}){
    id
    title
  }
}
  """;
  List svcItems=[];
  List svcValues=[];
  List<DropdownMenuItem<String>> svcMenuItems=[];
  //for dropDown:

  List userItems=[];
  List userValues=[];
  List<DropdownMenuItem<String>> userMenuItems=[];
  List<DropdownMenuItem<String>> menuItems=[];

  @override
  Widget build(BuildContext context) {
    return
      // Scaffold(
      // appBar: AppBar(title: Text('search'),),
      // drawer: AppDrawer(),
      // body:
      // Column(
      //   children: [

      Query(
        options: QueryOptions(
        document: gql(searchQuery),
    ),
    builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore}) {
      svcItems = [];
      svcValues = [];
      svcMenuItems = [];
      userItems = [];
      userValues = [];
      userMenuItems = [];
      menuItems=[];
      if (result.hasException) {
        return Text(result.exception.toString());
      }

      if (result.isLoading) {
        return const Text('Loading');
      }

      List? svcs = result.data ? ['svcs'];
      List? users = result.data ? ['users'];
      if (svcs == null) {
        return const Text('No svcs');
      }
      if (users == null) {
        return const Text('No users');
      }
      svcs.forEach((svc) {
        svcItems.add(svc['title']);
        svcValues.add(svc['id']);
      });
      users.forEach((user) {
        userItems.add(user['username']);
        userValues.add(user['id']);
      });

      for (var i = 0; i < svcItems.length; i++) {
        svcMenuItems.add(
            DropdownMenuItem(
              value: svcValues[i],
              child: Text(svcItems[i]),

            )
        );
      }
      for (var i = 0; i < userItems.length; i++) {
        userMenuItems.add(
            DropdownMenuItem(
              value: userValues[i],
              child: Text(userItems[i]),

            )
        );
      }

      // allMenuItems=svcMenuItems+userMenuItems;
      // print(svcMenuItems);
      // print(allMenuItems.length);
      menuItems=svcMenuItems + userMenuItems;
      return SearchChoices.single(
        items:  menuItems,
        value: dropDownValue,
        // hint: "Select SVC or profile",
        searchHint: "Select SVC or profile",
        onChanged: (value) {
          setState(() {
            dropDownValue = value;
            print("id is");
            print(dropDownValue);
            print("item is");
            print(menuItems.single.value==dropDownValue);

            // (userItems.firstWhere((user) => dropDownValue==user))?
            // Navigator.pushReplacement(context, new MaterialPageRoute(
            //     builder: (context) =>
            //     new ProfileScreen(value)))
            //     :
            // Navigator.pushReplacement(context, new MaterialPageRoute(
            //     builder: (context) =>
            //     new SVCScreen(value,menuItems.single.value==value,widget.id)))
            // ;

            // print(value);

            // print(dropDownValue);

            // var flist=userItems.firstWhere((user) => dropDownValue==user);
            // if(flist.length >0){
            //   print('user');
            // }
            // else if(svcValues.firstWhere((svc) => dropDownValue==svc)){
            //   print(dropDownValue);
            // }
            //go to the selected page
          });
        },
        onClear: () {
          setState(() {
            dropDownValue = '';
          });
        },
        isExpanded: false,
        displayClearIcon: false,
        icon: Icon(Icons.search, color: Colors.white,),
        underline: Container(
          height: 1.0,
          decoration: BoxDecoration(
              border: null
          ),
        ),


        //   ),
        //
        // ],
      );
    }
      );
    // );
  }
}