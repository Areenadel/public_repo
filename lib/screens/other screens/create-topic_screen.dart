//pass user id as member
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:search_choices/search_choices.dart';
import 'package:svc15/widgets/app_drawer.dart';

class CreateTopicScreen extends StatefulWidget {
  // static const routeName = '/createTopicScreen'; //add to navigation bar
  final id;
  CreateTopicScreen(this.id);
  @override
  _CreateTopicScreenState createState() => _CreateTopicScreenState(this.id);
}

class _CreateTopicScreenState extends State<CreateTopicScreen> {
  final myClient = GetIt.I<GraphQLClient>();
  final id;
  _CreateTopicScreenState(this.id);
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
          home: CreateTopicScreenHomePage(this.id),
        ),
      ),
    );
  }

}

class CreateTopicScreenHomePage extends StatefulWidget{
  final id;
  CreateTopicScreenHomePage(this.id);
  @override
  State<CreateTopicScreenHomePage> createState() => _CreateTopicScreenHomePageState(this.id);
}

class _CreateTopicScreenHomePageState extends State<CreateTopicScreenHomePage> {
  final id;
  _CreateTopicScreenHomePageState(this.id);
  final String addTopicMutation="""
  mutation CreateTopics(\$title:String!,\$svcID:ID!,\$uID:ID!) {
  createTopics(input: {
   title:\$title,
   svcs:{
     connect:{
       where:{
         node:{
           id:\$svcID
         }
       }
     }
   },
   member:{
     connect:{
       where:{
         node:{
         svcs_SINGLE:{
             id:\$svcID
           }
           user:{
             id:\$uID
           }
         }
       }
     }
   }
  }) {
    info {
      nodesCreated
      relationshipsCreated
    }
  }
}
  
  """;

  final String svcsQuery="""
  
  query Svcs(\$Uid:ID!) {
  svcs(where: {
    members_SINGLE:{
      user:{
        id:\$Uid
      }
    }
  }) {
    id
    title
  }
}
  """;
  final _globalKey = GlobalKey<FormState>();
  final topicNameController = TextEditingController();
  List items=[];
  List values=[];
  List<DropdownMenuItem<String>> menuItems=[];

  //for dropDown:
  String _svcDropDownValue ="";
  // SVC initial value


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Create topic'),),
        // drawer: AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Form(
                  key: _globalKey,
                  child: Column(
                    children: [
                      Query(
                          options: QueryOptions(
                            document: gql(svcsQuery),
                            variables: {
                              'Uid':widget.id
                            }
                          ),
                          builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore}) {
                            items=[];
                            values=[];
                            menuItems=[];
                            if (result.hasException) {
                              return Text(result.exception.toString());
                            }

                            if (result.isLoading) {
                              return const Text('Loading');
                            }

                            List? svcs = result.data?['svcs'];

                            if (svcs == null) {
                              return const Text('No svcs');
                            }

                            svcs.forEach((svc) {
                              items.add(svc['title']);
                              values.add(svc['id']);

                            });
                            print("items is" );
                            print(items);
                            print("values is" );
                            print(values);
                            print("menuItems is" );
                            // print(menuItems);
                            for ( var i=0;i < items.length;i++){

                              menuItems.add(
                                  DropdownMenuItem(
                                    value: values[i],
                                    child: Text(items[i]),

                                  )
                              ) ;
                            };


                            return
                            SearchChoices.single(
                              items: menuItems,
                              value: _svcDropDownValue,
                              hint: "Select SVC",
                              searchHint: "Select SVC",
                              onChanged: (value) {
                                setState(() {
                                  _svcDropDownValue = value;
                                });
                              },
                              onClear: () {
                                setState(() {
                                  _svcDropDownValue = " ";
                                });
                              },
                              isExpanded: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'you should choose SVC';
                                }
                              },
                            );
                          }
                      ),

                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'topic name',
                        ),
                        controller: topicNameController,
                        validator: (value) {
                          if(value == null || value.isEmpty){
                            return 'Topic name can\'t be empty';
                          }
                        },
                      ),

                    ],
                  )
              ),
              Mutation(
                options: MutationOptions(
                  document: gql(addTopicMutation),
                  // update: ( cache,  result) {
                  //   return cache;
                  // },
                  onCompleted: (dynamic resultData) {
                    // final myIDs= resultData['createUsers']['users'][0]['id'];
                    // print(resultData);
                    // print(myIDs);

                    print('crated');
                    print(resultData);
                    print(_svcDropDownValue);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Topic created')),
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
                  ) {
                    if(result!= null){
                      if(result.isLoading){
                        // return const LoadingSpinner();
                      }
                      if(result.hasException){
                        print("error until creat");
                        return Text(result.exception.toString());

                        // context.showError
                      }
                    }
                    return ElevatedButton(
                      onPressed: () {
                        print(_svcDropDownValue);
                        print(topicNameController.text);

                        if (_globalKey.currentState!.validate()) {
                          runMutation({
                            "title": topicNameController.text,
                            "svcID": _svcDropDownValue,
                            "uID": widget.id
                          });
                        }
                      },
                      child: Text('Create'),

                      // print(_svcDropDownValue.toString());
                    );
                  }
              )
            ],
          ),
        )
    );
  }
}