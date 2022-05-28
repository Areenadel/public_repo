//need edit : pass id to homepage after sucess login
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:svc15/auth.dart';
import 'package:svc15/screens/main%20screens/home_page_screen.dart';
import 'package:svc15/screens/main%20screens/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final myClient = GetIt.I<GraphQLClient>();
  @override

  Widget build(BuildContext context) {


    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      myClient,
    );

    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          title: 'GraphQLTest',
          home: LoginScreenHomePage(),
        ),
      ),
    );
  }
}
 class LoginScreenHomePage extends StatefulWidget {
  @override
  State<LoginScreenHomePage> createState() => _LoginScreenHomePageState();
}

class _LoginScreenHomePageState extends State<LoginScreenHomePage> {
   final _globalKey = GlobalKey<FormState>();

   final emailController = TextEditingController();

   final passwordController = TextEditingController();

   static String LogInMutation="""
   mutation LogIn(\$email: String!, \$password: String!) {
  logIn(email: \$email, password: \$password){
    token
    id
  }
}
   """;
   @override
   Widget build(BuildContext context) {
     // Auth auth = new Auth();
     return Scaffold(
         body: Padding(
           padding: EdgeInsets.all(20),
           child: ListView(
             children: [
               Container(
                 padding: EdgeInsets.only(top: 50, bottom: 10),
                 child: Column(
                   children: [
                     Text('Login to SVC'),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text("don't have an account?"),
                         TextButton(
                             onPressed: () {
                               Navigator.push(context, new MaterialPageRoute(
                                   builder: (context) =>
                                   new RegistrationScreen())
                               );
                               // Navigator.pushNamed(context, RegistrationScreen.routeName);
                             },
                             child: Text('Register')
                         ),
                       ],
                     )
                   ],
                 ),
               ),
               Form(
                 key: _globalKey,
                 child: Column(
                   children: [
                     TextFormField(
                       decoration: const InputDecoration(
                           labelText: 'email',
                           icon: Icon(Icons.alternate_email)
                       ),
                       controller: emailController,
                       validator: (value) {
                         if(value == null || !value.contains('@')){
                           return 'Invalid email';
                         }
                       },
                     ),
                     TextFormField(
                       decoration: const InputDecoration(
                           labelText: 'password',
                           icon: Icon(Icons.password)
                       ),
                       controller: passwordController,
                       obscureText: true,
                     ),
                   ],
                 ),
               ),
               Mutation(
                   options: MutationOptions(
                     document: gql(LogInMutation),
                     // update: ( cache,  result) {
                     //   return cache;
                     // },
                     onCompleted: (dynamic resultData) {
                       // final myIDs= resultData['createUsers']['users'][0]['id'];
                       // print(resultData);
                       // print(myIDs);
                       print(resultData);
                       final id=resultData['logIn']['id'];
                       print(id);

                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('You have successfully login ')),

                       );
                       Navigator.pushReplacement(context, new MaterialPageRoute(
                           builder: (context) =>
                           new HomepageScreen(id))
                       );
                       // Navigator.pushReplacement(context, new MaterialPageRoute(
                       //     builder: (context) =>
                       //     new HomepageScreen())
                       // );
                       // showDialog(
                       //   context: context,
                       //   builder: (BuildContext context) => AlertDialog(
                       //     title: Text('Verify your email'),
                       //     content: Column(
                       //       mainAxisSize: MainAxisSize.min,
                       //       children: [
                       //         Text('Enter the code that we sent to your email'),
                       //         TextField(
                       //           controller: otpController,
                       //           onChanged: (value) => verify(),
                       //         ),
                       //       ],
                       //     ),
                       //     actions: [
                       //       TextButton(
                       //           onPressed: isOtpValid ?
                       //               (){
                       //             Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                       //           }
                       //               : null,
                       //           child: Text('Verify')
                       //       )
                       //     ],
                       //   ),
                       // );
                     },
                   ),
                   builder: (
                       RunMutation runMutation,
                       QueryResult? result,
                       ){
                     if(result!= null){
                       if(result.isLoading){
                         // return const LoadingSpinner();
                       }
                       if(result.hasException){
                         // context.showError
                       }
                     }
                     return ElevatedButton(
                       onPressed: () {
                         // auth.checkPassword('user1', passwordController.text).then((value) => {
                         if(_globalKey.currentState!.validate()){
                           runMutation(
                               {  "email": emailController.text,
                                 "password": passwordController.text
                               }
                           );
                         };
                         print('email:' + emailController.text);
                         // });
                       },
                       child: Text('Login'),
                     );
                   }
               )


             ]
           )
         )
     );
   }
}