import 'package:flutter/material.dart';
import 'package:svc15/screens/main%20screens/home_page_screen.dart';
import 'package:svc15/screens/main%20screens/login_screen.dart';
import 'package:svc15/screens/main%20screens/profile_screen.dart';
// import 'package:svc15/screens/main%20screens/search_screen.dart';
import 'package:svc15/screens/main%20screens/svc_screen.dart';
import 'package:svc15/screens/other%20screens/claims_screen.dart';
import 'package:svc15/screens/other%20screens/creare_svc_screen.dart';
import 'package:svc15/screens/other%20screens/create-topic_screen.dart';
import 'package:svc15/screens/other%20screens/create_post_screen.dart';
import 'package:svc15/widgets/search.dart';

import '../screens/main screens/my_svcs_member_screen.dart';
import '../screens/main screens/my_svcs_screen.dart';

class AppDrawer extends StatelessWidget {
  final id;
  const AppDrawer(this.id);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // AppBar(
          //   title: Text('app bar'),
          //   automaticallyImplyLeading: false,
          // ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () => Navigator.pushReplacement(context, new MaterialPageRoute(
                builder: (context) =>
                new ProfileScreen(id))
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home page'),
            onTap: () => Navigator.pushReplacement(context, new MaterialPageRoute(
                builder: (context) =>
                new HomepageScreen(id))
            ),
                // Navigator.of(context).pushNamed(HomepageScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text('Claims'),
            onTap: () => Navigator.pushReplacement(context, new MaterialPageRoute(
                builder: (context) =>
                new ClaimsScreen(id))
            ),
                // Navigator.of(context).pushNamed(ClaimsScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.group_add),
            title: Text('Create SVC'),
            onTap: () => Navigator.pushReplacement(context, new MaterialPageRoute(
                builder: (context) =>
                new CreateSVCScreen(id))
            ),
                // Navigator.of(context).pushNamed(CreateSVCScreen.routeName),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.group),
            title: Text('SVC I follow'),
            onTap: () => Navigator.pushReplacement(context, new MaterialPageRoute(
                builder: (context) =>
                new MySVCsScreen(id))
            ),
            // Navigator.of(context).pushNamed(SVCScreen.routeName),
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('SVC I member in'),
            onTap: () => Navigator.pushReplacement(context, new MaterialPageRoute(
                builder: (context) =>
                new MySVCsMemberScreen(id))
            ),
            // Navigator.of(context).pushNamed(SVCScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.post_add),
            title: Text('Add Post'),
            onTap: () => Navigator.pushReplacement(context, new MaterialPageRoute(
                builder: (context) =>
                new CreatePostScreen(id))
            ),
                // Navigator.of(context).pushNamed(CreatePostScreen.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.topic),
            title: Text('Create Topic'),
            onTap: () => Navigator.pushReplacement(context, new MaterialPageRoute(
                builder: (context) =>
                new CreateTopicScreen(id))
            ),
          ),
          Divider(),
          // ListTile(
          //   leading: Icon(Icons.search),
          //   title: Text('Search'),
          //   onTap: () => Navigator.pushReplacement(context, new MaterialPageRoute(
          //       builder: (context) =>
          //       new SearchScreen())
          //   ),
          //       // Navigator.of(context).pushNamed(SearchScreen.routeName),
          // ),
          // Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            //it needs edit
            onTap: () => Navigator.pushReplacement(context, new MaterialPageRoute(
                builder: (context) =>
                new LoginScreen())
            ),
                // Navigator.of(context).pushNamed(LoginScreen.routeName),
          ),



        ],
      ),
    );
  }
}
