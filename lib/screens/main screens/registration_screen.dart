//for test : delete dialog for verify + add push to homepage when complete (this edit must delete)
//need edit : go to homepage after success reg?
import 'package:email_auth/email_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:svc15/auth.dart';
import 'package:svc15/screens/main%20screens/home_page_screen.dart';
import 'package:svc15/screens/main%20screens/login_screen.dart';
import 'package:svc15/screens/main%20screens/profile_screen.dart';
import 'package:svc15/screens/main%20screens/svc_screen.dart';
import 'package:svc15/screens/other%20screens/creare_svc_screen.dart';

import '../other screens/claims_screen.dart';
import '../other screens/create-topic_screen.dart';
import '../other screens/create_post_screen.dart';
// import 'package:email_auth_example/auth.config.dart';

//Form widget
class RegistrationScreen extends StatefulWidget {
  static const routeName = '/registration';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
          home: RegistrationScreenHomePage(),
        ),
      ),
    );
  }

}

class RegistrationScreenHomePage extends StatefulWidget{
  @override
  State<RegistrationScreenHomePage> createState() => _RegistrationScreenHomePageState();
}

class _RegistrationScreenHomePageState extends State<RegistrationScreenHomePage> {
  // final deviceSize = MediaQuery.of(context).size;
  final usernameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final otpController = TextEditingController();

  // final password2Controller = TextEditingController();
  final _globalKey = GlobalKey<FormState>();

  late EmailAuth emailAuth;

  /// The boolean to handle the dynamic operations
  bool isEmailValid = false;

  bool isOtpValid = false;

  bool isSignUpDisabled = true;

  static String addUserMutation="""
  mutation SignUp(\$username: String!, \$password: String!, \$email: String!) {
  signUp(username: \$username, password: \$password, email: \$email){
    token
    id
  }
}


  """;
  void initState(){
    super.initState();
    //Initialize the package
    emailAuth = new EmailAuth(
        sessionName: "sample session"
    );
    /// Configuring the remote server ,,,if present
    // emailAuth.config(remoteServerConfiguration);
  }

  /// a void function to verify if the Data provided is true
  /// Convert it into a boolean function to match your needs.
  void verify() {
    bool result = emailAuth.validateOtp(
        recipientMail: emailController.value.text,
        userOtp: otpController.value.text);
    setState(() {
      isOtpValid = result;
    });
    print(isOtpValid);
  }

  /// a void funtion to send the OTP to the user
  /// Can also be converted into a Boolean function and render accordingly for providers
  sendOtp() async {
    bool result = await emailAuth.sendOtp(
        recipientMail: emailController.value.text, otpLength: 6);
    // if (result) {
    setState(() {
      isEmailValid = result;
    });
    // }
  }

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
                      Text('Create new account'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('already registered?'),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(context, new MaterialPageRoute(
                                    builder: (context) =>
                                    new LoginScreen())
                                );
                                // Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                              },
                              child: Text('Login')
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
                            labelText: 'username',
                            icon: Icon(Icons.person)
                        ),
                        controller: usernameController,
                        validator: (value) {
                          if(value == null || value.isEmpty){
                            return 'Username can not be empty';
                          }
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'email',
                            icon: Icon(Icons.alternate_email)
                        ),
                        onChanged: (value) => sendOtp(),


                        controller: emailController,

                        // The validator receives the text that the user has entered, it return a string
                        validator: (value) {
                          if(value == null || !value.contains('@') || !isEmailValid){
                            return 'Invalid email';
                          }
                          return null;
                        },
                      ),
                      // Card(
                      //   margin: EdgeInsets.only(top: 20),
                      //   elevation: 6,
                      //   child: Container(
                      //     height: 50,
                      //     width: 200,
                      //     color: Colors.green[400],
                      //     child: GestureDetector(
                      //       onTap: sendOtp,
                      //       child: Center(
                      //         child: Text(
                      //           "Request OTP",
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.white,
                      //             fontSize: 20,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      /// A dynamically rendering text field
                      // (submitValid)
                      //     ? TextField(
                      //   controller: otpcontroller,
                      // )
                      //     : Container(height: 1),
                      // (submitValid)
                      //     ? Container(
                      //   margin: EdgeInsets.only(top: 20),
                      //   height: 50,
                      //   width: 200,
                      //   color: Colors.green[400],
                      //   child: GestureDetector(
                      //     onTap: verify,
                      //     child: Center(
                      //       child: Text(
                      //         "Verify",
                      //         style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.white,
                      //           fontSize: 20,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // )
                      //     : SizedBox(height: 1),

                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'password',
                            icon: Icon(Icons.password)
                        ),
                        obscureText: true,
                        controller: passwordController,
                        validator: (value) {
                          if(value == null || value.length < 8){
                            return 'Password should be more than 8 characters';
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Mutation(
                    options: MutationOptions(
                      document: gql(addUserMutation),
                      // update: ( cache,  result) {
                      //   return cache;
                      // },
                      onCompleted: (dynamic resultData) {
                        // final myIDs= resultData['createUsers']['users'][0]['id'];
                        // print(resultData);
                        // print(myIDs);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('You have successfully registered ')),

                        );
                        // Navigator.pushReplacement(context, new MaterialPageRoute(
                        //     builder: (context) =>
                        //     new HomepageScreen())
                        // );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text('Verify your email'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Enter the code that we sent to your email'),
                                TextField(
                                  controller: otpController,
                                  onChanged: (value) => verify(),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: isOtpValid ?
                                      (){
                                    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                                  }
                                      : null,
                                  child: Text('Verify')
                              )
                            ],
                          ),
                        );
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
                        onPressed:
                            isEmailValid ?
                            () {
                              if(_globalKey.currentState!.validate()){
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   const SnackBar(content: Text('You have successfully registered')),
                                // );
                                // sendOtp();

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
                                runMutation({
                                  'username':usernameController.text,'email':emailController.text , 'password':passwordController.text
                                });
                                print("username: " + usernameController.text);
                                // List? myId=result?.data?['createusers'];
                                // print(myId.toString());
                              }


                          // });
                        }
                        :null,


                        child: Text('Sign up'),

                      );
                    }


                )
              ],
            )
        )
    );
  }
}