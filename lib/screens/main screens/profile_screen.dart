//expanded while loading ?
// edit : post contain *zero or  more than one topic
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:svc15/widgets/app_drawer.dart';
import 'package:svc15/widgets/bottom_navigation_Bar.dart';
import 'package:svc15/widgets/post.dart';

class ProfileScreen extends StatefulWidget {
  // static const routeName = '/ProfileScreen';

  final id;

  const ProfileScreen(this.id);

  @override
  _ProfileScreenState createState() => _ProfileScreenState(this.id);
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  final myClient = GetIt.I<GraphQLClient>();
  final id;
  _ProfileScreenState(this.id);
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
          home: ProfileScreenHomePage(this.id),
        ),
      ),
    );
  }
}

class ProfileScreenHomePage extends StatefulWidget{
  final id;
  const ProfileScreenHomePage(this.id);
  @override
  State<ProfileScreenHomePage> createState() => _ProfileScreenHomePageState(this.id);
}

class _ProfileScreenHomePageState extends State<ProfileScreenHomePage> {
  final id;
  _ProfileScreenHomePageState(this.id);
  final String userQuery="""
  query Users(\$id:ID) {
  users (where: {id:\$id}) {
    
  username
    postWAggregate {
      count
    }
    svcFAggregate {
      count
    }
    memberAggregate {
      count
    }
    postW {
      content
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
}
  """;
  List topicName=[];
  List svcName=[];
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: Text('Profile'),),
       drawer: AppDrawer(widget.id),
       body: Padding(
         padding: const EdgeInsets.all(6.0),
         child: Column(
           children: [
             Query(
               options: QueryOptions(
                 document: gql(userQuery),
                 variables: {
                   'id':widget.id
                 }
               ),
                 builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore}) {
                    topicName=[];
                    svcName=[];
                 if (result.hasException) {
                     return Text(result.exception.toString());
                   }

                   if (result.isLoading) {
                     return const Text('Loading');
                   }

                   final user = result.data ? ['users'][0];
                   if (user == null) {
                     return const Text('No user');
                   }
                   final username=user['username'];
                   final postsCount=(user['postWAggregate']['count']).toString();
                   final followingCount=(user['svcFAggregate']['count']).toString();
                   final qulifiedUsersCount=(user['memberAggregate']['count']).toString();
                   final posts=user['postW'];
                   print(qulifiedUsersCount);

                   // final topics=svc['topics'];
                   // final List allposts=[];
                   // List posts=[];
                   // topics.forEach((topic) {
                   //   allposts.add(topic['posts']);
                   // });
                   // posts=allposts[0];
                   return Expanded(
                     child: ListView(
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
                                 Text(username, style: TextStyle(
                                     fontSize: 24, fontWeight: FontWeight.bold),),
                                 // Container(
                                 //   child: Text('SVC description SVC description \nSVC description SVC description \nSVC description'),
                                 // ),
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
                                   Text(postsCount, style: TextStyle(
                                       fontSize: 18, fontWeight: FontWeight.bold),),
                                   Text('Posts')
                                 ],
                               ),
                               Column(
                                 children: [
                                   Text(followingCount, style: TextStyle(
                                       fontSize: 18, fontWeight: FontWeight.bold),),
                                   Text('Following')
                                 ],
                               ),
                               Column(
                                 children: [
                                   Text(qulifiedUsersCount, style: TextStyle(
                                       fontSize: 18, fontWeight: FontWeight.bold),),
                                   Text('Qualified user')
                                 ],
                               ),
                             ],
                           ),
                         ),
                         Divider(),
                         SizedBox(height: 10,),
                         ListView.builder(
                             scrollDirection: Axis.vertical,
                             shrinkWrap: true,
                             itemCount: posts.length,
                             itemBuilder: (context, index) {
                               final post = posts[index];
                               print(posts.length);
                               // print(posts.length);
                               final content = post['content'];
                               List topics=post['topics'];

                               print(topics);
                               if (topics!=null){

                                 //i assume that post tag with one topic
                                 topics.forEach((topic) {
                                    topicName.add(topic['title']);
                                    svcName.add(topic['svcsConnection']['edges'][0]['node']['title']);
                                 });
                                 return Column(
                                   children: [
                                     Post(
                                       username: username,
                                       postContent: content,
                                       topicName: topicName,
                                       svcName: svcName,
                                     ),
                                     SizedBox(height: 10,),
                                   ],
                                 );
                               }
                               else {
                                 return Column(
                                 children: [
                                   Post(
                                     username: username,
                                     postContent: content,
                                     ),
                                   SizedBox(height: 10,),
                                 ],
                               );
                               }
                             }
                         ),

                       ],
                     ),
                   );
                 }
             ),
             MyBottomNavigationBar(2,widget.id)
           ],
         ),
       ),
     );
   }
}