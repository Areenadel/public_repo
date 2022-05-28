//need edit:
//1- tag post with topic (in mutation)
//Tid need to be list not tostring?
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:search_choices/search_choices.dart';
// import 'package:search_choices/search_choices.dart';
import 'package:svc15/widgets/app_drawer.dart';
import 'package:svc15/widgets/bottom_navigation_Bar.dart';

class CreatePostScreen extends StatefulWidget {
  final id;
  CreatePostScreen(this.id);

  // static const routeName = '/createPostScreen';

  // const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState(this.id);
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final myClient = GetIt.I<GraphQLClient>();
  final id;
  _CreatePostScreenState(this.id);
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
          home: CreatePostScreenHomePage(this.id),
        ),
      ),
    );
  }
}
class CreatePostScreenHomePage extends StatefulWidget {
  final id;
  CreatePostScreenHomePage(this.id);
  @override
  State<CreatePostScreenHomePage> createState() => _CreatePostScreenHomePageState(this.id);
}

class _CreatePostScreenHomePageState extends State<CreatePostScreenHomePage> {
  final id;
  _CreatePostScreenHomePageState(this.id);
  final String createPostMutation= """
  mutation CreatePosts(\$content:String!,\$Uid:ID!,\$Tid:[ID!]) {
  createPosts(input: {topics:{
    connect:{
      where:{
        node:{
          id_IN:\$Tid
        }
      }
    }
  },content:\$content,
  userW:{connect:{where:{node:{id:\$Uid}}}},
  }) {
    info {
      nodesCreated
      relationshipsCreated
    }
  }
}

  """;
  //need to add svc that the user following
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
  List svcItems=[];
  List svcValues=[];
  List<DropdownMenuItem<String>> svcMenuItems=[];
  //for dropDown:
  String _svcDropDownValue ="";

  final String topicsQuery="""
  query Topics(\$svcID:ID!) {
  topics(where: {
    svcs:{
      id:\$svcID
    }
  }) {
    id
    title
  }
}
  """;
  List topicItems=[];
  List topicValues=[];
  List<DropdownMenuItem<String>> topicMenuItems=[];
  //for dropDown:
  String _topicDropDownValue ="";




  final postController = TextEditingController();

  bool isButtonActive = false;




  @override
  void initState() {
    super.initState();
  }

  //activate the Post button when the text field is not empty
  void activateButton(){
    postController.addListener(() {
      setState(() {
        this.isButtonActive = postController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Post'),),
      // drawer: AppDrawer(),
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10,top: 5),
                    child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Add Post',
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.left,
                        )
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'Write your post here ...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        )
                    ),
                    onChanged: (value) => activateButton(),
                    controller: postController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                  Query(
                      options: QueryOptions(
                          document: gql(svcsQuery),
                          variables: {
                            'Uid':widget.id
                          }
                      ),
                      builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore}) {
                        svcItems=[];
                        svcValues=[];
                        svcMenuItems=[];
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
                          svcItems.add(svc['title']);
                          svcValues.add(svc['id']);

                        });
                        print("items is" );
                        print(svcItems);
                        print("values is" );
                        print(svcValues);
                        print("menuItems is" );
                        // print(menuItems);
                        for ( var i=0;i < svcItems.length;i++){

                          svcMenuItems.add(
                              DropdownMenuItem(
                                value: svcValues[i],
                                child: Text(svcItems[i]),

                              )
                          ) ;
                        };

                        return
                          SearchChoices.single(
                            items: svcMenuItems,
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
                                _svcDropDownValue = '';
                              });
                            },
                            isExpanded: true,
                          );
                      }),
                  Query(
                      options: QueryOptions(
                          document: gql(topicsQuery),
                          variables: {
                            'svcID':_svcDropDownValue.toString()
                          }
                      ),
                      builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore}) {
                        topicItems=[];
                        topicValues=[];
                        topicMenuItems=[];
                        if (result.hasException) {
                          return Text(result.exception.toString());
                        }

                        if (result.isLoading) {
                          return const Text('Loading');
                        }

                        List? topics = result.data?['topics'];

                        if (topics == null) {
                          return const Text('No topics');
                        }

                        topics.forEach((topic) {
                          topicItems.add(topic['title']);
                          topicValues.add(topic['id']);

                        });
                        print("items is" );
                        print(topicItems);
                        print("values is" );
                        print(topicValues);
                        // print("menuItems is" );
                        // print(menuItems);
                        for ( var i=0;i < topicItems.length;i++){

                          topicMenuItems.add(
                              DropdownMenuItem(
                                value: topicValues[i],
                                child: Text(topicItems[i]),

                              )
                          ) ;
                        };

                        return
                          SearchChoices.single(
                            items: topicMenuItems,
                            value: _topicDropDownValue,
                            hint: "Select Topic",
                            searchHint: "Select Topic",
                            onChanged: (value) {
                              setState(() {
                                _topicDropDownValue = value;
                              });
                            },
                            onClear: () {
                              setState(() {
                                _topicDropDownValue = '';
                              });
                            },
                            isExpanded: true,
                          );
                      }),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Mutation(
                        options: MutationOptions(
                          document: gql(createPostMutation),
                          onCompleted: (dynamic resultData) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('post created')),
                            );
                            print(resultData);

                          },
                        ),

                          builder: (
                              RunMutation runMutation,
                              QueryResult? result,
                              ) {
                            if (result != null) {
                              if (result.isLoading) {
                                return Text("load");
                                // return const LoadingSpinner();
                              }
                              if (result.hasException) {
                                // return Text("exp");
                                return Text(result.exception.toString());
                                // context.showError
                              }
                            }
                            return

                              ElevatedButton(
                                onPressed: isButtonActive
                                    ? () {
                                  //Tid need to be list not tostring?
                                  if(_svcDropDownValue!='' && _topicDropDownValue!='') {
                                    runMutation({
                                      'content': postController.text,
                                      'Uid': widget.id,
                                      'Tid':_topicDropDownValue.toString()
                                    });
                                  }
                                  else {
                                    runMutation({
                                      'content': postController.text,
                                      'Uid': widget.id,
                                      'Tid':[]
                                    });
                                  }
                                }
                                    : null,
                                child: Text('Post Now'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(10, 5),
                                  padding: EdgeInsets.all(6),
                                  textStyle: TextStyle(fontSize: 15),
                                ),
                              );
                          }
                      ),
                    ],
                  ),
                  MyBottomNavigationBar(1,widget.id)
                ],
              ),
            ],
          )
      ),
    );
  }
}