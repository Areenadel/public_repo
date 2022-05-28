import 'package:flutter/material.dart';
import 'package:svc15/screens/main%20screens/home_page_screen.dart';
import 'package:svc15/screens/main%20screens/login_screen.dart';
import 'package:svc15/screens/main%20screens/profile_screen.dart';
import 'package:svc15/screens/main%20screens/registration_screen.dart';
// import 'package:svc15/screens/main%20screens/search_screen.dart';
import 'package:svc15/screens/main%20screens/svc_screen.dart';
import 'package:svc15/screens/other%20screens/claims_screen.dart';
import 'package:svc15/screens/other%20screens/creare_svc_screen.dart';
import 'package:svc15/screens/other%20screens/create_post_screen.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SVC App',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSwatch(
        //   primarySwatch: Colors.pink
        // ),
        // primarySwatch: Colors.pink,
        primarySwatch: Colors.lightBlue,
        textTheme: TextTheme(
          // bodyText1: TextStyle(color: Colors.purple),
          // bodyText2: TextStyle(color: Colors.black),
        ),
        // appBarTheme: AppBarTheme(
        //   titleTextStyle: TextStyle(color: Colors.white, fontSize: 10),
        // )

      ),
      home: RegistrationScreen(),
      // routes: {
      //   RegistrationScreen.routeName: (context) => RegistrationScreen(),
      //   LoginScreen.routeName: (context) => LoginScreen(),
      //   HomepageScreen.routeName: (context) => HomepageScreen(),
      //   ClaimsScreen.routeName: (context) => ClaimsScreen(),
      //   ProfileScreen.routeName: (context) => ProfileScreen(),
      //   CreateSVCScreen.routeName: (context) => CreateSVCScreen(),
      //   SVCScreen.routeName: (context) => SVCScreen(),
      //   CreatePostScreen.routeName: (context) => CreatePostScreen(),
      //   SearchScreen.routeName: (context) => SearchScreen(),
      // },

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Text('svc')
      ),

    );
  }
}
