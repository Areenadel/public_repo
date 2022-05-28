//need edit {find totat post in all topics in svc}+ pass svc id
// see line 227 about assume of topics
// need edit(unfollow+unclaim)
//if following or claiming their button being undo
//edit done: delete memberW in svcquery
//expext the user how send claim even if him is one of the follower

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:svc15/widgets/app_drawer.dart';
import 'package:svc15/widgets/post.dart';

class SVCScreen extends StatefulWidget {
  final id;
  final name;
  final Uid;
  SVCScreen(this.id,this.name,this.Uid);

  // static const routeName = '/SVCScreen';
  // const SVCScreen({Key? key}) : super(key: key);

  @override
  _SVCScreenState createState() => _SVCScreenState(this.id,this.name,this.Uid);
}

class _SVCScreenState extends State<SVCScreen> {
  final id;
  final name;
  final Uid;
  _SVCScreenState(this.id,this.name,this.Uid);
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
          home: SVCScreenHomePage(this.id,this.name,this.Uid),
        ),
      ),
    );
  }
}

class SVCScreenHomePage extends StatefulWidget{
  final id;
  final name;
  final Uid;
  SVCScreenHomePage(this.id,this.name,this.Uid);
  @override
  State<SVCScreenHomePage> createState() => _SVCScreenHomePageState(this.id,this.name,this.Uid);
}

class _SVCScreenHomePageState extends State<SVCScreenHomePage> {
  final id;
  final name;
  final Uid;
  _SVCScreenHomePageState(this.id,this.name,this.Uid);
  final String svcQuery="""
  query Svcs(\$SVCid:ID!) {
  svcs (where: {id:\$SVCid}){
    title
    description
    topics(where: {
      postsAggregate: {
      count_GT: 0
    } 
    }) {
      postsConnection {
        totalCount
      }
      posts {
        content
        userW {
          username
        }
        topics {
          title
          svcsConnection {
            edges {
              node {
                title
              }
            }
          }
        }
        
      }
      
    }
    userFAggregate {
      count
    }
    membersAggregate {
      count
    }
    
  }
}
  """;
  final String followSVCMutation="""
  mutation UpdateSvcs(\$SVCid:ID,\$Uid:ID) {
  updateSvcs(
    where: {id:\$SVCid},
    update: {
      userF:{
        connect:{
          where:{
            node:{
              id:\$Uid
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
  final String unfollowSVCMutation="""""";
  final String claimSVCMutation="""
  mutation CreateClaims(\$SVCid:ID!,\$Uid:ID!) {
  createClaims(
    input:{
      svcID:\$SVCid,
      userS:{
        connect:{
          where:{
            node:{
              id:\$Uid
            }
          }
        }
      }
      member:{
        connect:{
          where:{
            node:{
              svcsConnection_SINGLE:{
                node:{
                  id:\$SVCid
                }
              }
            }
          }
        }
      }
      userP:{
        connect:{
          where:{
            node:{
              svcF_SINGLE:{
                id:\$SVCid
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
  final String unClaimSVCMutation="""""";
  List postuser=[];
  List postcontent=[];
  List postsvc=[];
  List posttopic=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name),),
      // drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Query(
            options: QueryOptions(
                document: gql(svcQuery),
                variables: {
                  'SVCid':widget.id
                }
            ),
            builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore}) {
              postuser=[];
              postcontent=[];
              postsvc=[];
              posttopic=[];
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.isLoading) {
                return const Text('Loading');
              }

              final svc = result.data ? ['svcs'][0];
              if (svc == null) {
                return const Text('No svc');
              }
              final svcTitle=svc['title'];
              final svcDescription=svc['description'];
              final followers=(svc['userFAggregate']['count']).toString();
              final qulifiedUsers=(svc['membersAggregate']['count']).toString();
              final topics=svc['topics'];
              final List topicsList=[];
              final List postsList=[];
              int postcount=0;
              topics.forEach((topic){
                postcount+=int.parse((topic['postsConnection']['totalCount']).toString());
                topicsList.add(topic);
              });

              List posts=[];
              topicsList.forEach((topic) {
                postsList.add(topic['posts']);
              });
              postsList.forEach((post) {
                posts.add(post);
              });
              print(posts.length.toString());
              // posts=postsList[0];
              // print(posts.length);
              return ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 13),
                        child: CircleAvatar(radius: 50,),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(svcTitle,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight
                                .bold),),
                          Container(
                              child: Text(svcDescription)
                          ),
                          // Column(
                          //   children: [
                          //     Flexible(child: Text('SVC Description,', style: TextStyle(backgroundColor: Colors.pink),)),
                          //   ],
                          // )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    margin: EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromRGBO(215, 215, 215, 0.5),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(postcount.toString(), style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),),
                            Text('Posts')
                          ],
                        ),
                        // Column(
                        //   children: [
                        //     Text('5', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        //     Text('Topics')
                        //   ],
                        // ),
                        Column(
                          children: [
                            Text(followers, style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),),
                            Text('Followers')
                          ],
                        ),
                        Column(
                          children: [
                            Text(qulifiedUsers, style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),),
                            Text('Qualified users')
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Mutation(
                          options: MutationOptions(
                            document: gql(followSVCMutation),
                            // update: ( cache,  result) {
                            //   return cache;
                            // },
                            onCompleted: (dynamic resultData) {
                              // final myIDs= resultData['createUsers']['users'][0]['id'];
                              // print(resultData);
                              // print(myIDs);
                              print(resultData);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('following successfully  ')),

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
                                // context.showError
                              }
                            }
                            return
                              ElevatedButton(
                                  onPressed: () {
                                    runMutation({
                                      'Uid':widget.Uid,
                                      'SVCid':widget.id
                                    });
                                  },
                                  child: Text('Follow'));
                          }
                      ),
                      Mutation(
                          options: MutationOptions(
                            document: gql(claimSVCMutation),
                            // update: ( cache,  result) {
                            //   return cache;
                            // },
                            onCompleted: (dynamic resultData) {
                              // final myIDs= resultData['createUsers']['users'][0]['id'];
                              // print(resultData);
                              // print(myIDs);
                              print(resultData);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('claiming successfully  ')),

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
                                // context.showError
                              }
                            }
                            return
                              ElevatedButton(
                                  onPressed: () {
                                    runMutation({
                                      'Uid':widget.Uid,
                                      'SVCid':widget.id
                                    });
                                  },
                                  child: Text('Claim partnership'));
                          }
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        // final post = posts[index];
                        // print(posts.length);
                        // print(posts.length);
                        // final content = posts['content'];
                        // final content = posts[0][0]['content'];

                        // final user=post['userW']??post['memberW']['user'];
                        // final user=post['userW'];
                        // final username=user['username'];
                        //i assume that post tag with one topic
                        // final topic=post['topics'][0]['title'];
                        //based on before assume we dont need to find svc name as bellow
                        // final svcName=post['topics'][0]['svcsConnection']['edges'][0]['node']['title'];
                        // final username='',topic='';
                        // print("post is here post0");
                        // print(posts[0]);
                        // print("post is here post1");
                        // print(posts[1]);
                        //
                        // print("post is herepost 0 0");
                        // print(posts[0][0]);

                        // print(posts);
                        // print(content);
                        final topichere=topics[index];
                        print(topichere);
                        List postshere=topichere['topic'];
                        postshere.forEach((post) {
                          postuser.add(post['userW']['username']);
                          postcontent.add(['content']);
                          // postsvc.add();
                          // posttopic=;
                        });

                        return Column(
                          children: [
                            Post(
                              username: postsvc,
                              postContent: postcontent,
                              svcName: 'a',
                              topicName: 'b',),
                            SizedBox(height: 10,),
                          ],
                        );
                      }
                  ),


                ],
              );
            }

        ),
      ),
    );
  }
  }


//   double getSVCImpact(){
//     //database
//     return 2.2;
//   }
//
//   void impactOfSVC(){
//     // sum of usefuls
//     double svcImpact = getSVCImpact();
//
//     // normalized impact
//     double normalizedSVCImpact;
//
//     double minSVCImpact = getMinSVCImpact();
//     double maxSVCImpact = getMaxSVCImpact();
//     normalizedSVCImpact = (svcImpact-minSVCImpact) / (maxSVCImpact-minSVCImpact);
//
//   }
//
//   double getMinSVCImpact(){
//     //from database
//     return 1.1;
//   }
//
//   double getMaxSVCImpact(){
//     //from database
//     return 2.5;
//   }
//
// }
//
//
//
//
//
//
//
//
//
//
