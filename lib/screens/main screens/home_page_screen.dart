//this page need edit
// 1- pass user id to query (not use specific id )
// 2- calculate rank by (memberR + userR) and get color based on
// 3- edit query (now it return duplicated posts)

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:svc15/widgets/app_drawer.dart';
import 'package:svc15/widgets/bottom_navigation_Bar.dart';
import 'package:svc15/widgets/post.dart';

import '../../widgets/search.dart';

class HomepageScreen extends StatefulWidget {
  // static const routeName = '/homepageScreen';
  final id;
  const HomepageScreen(this.id);
  // const HomepageScreen({Key? key}) : super(key: key);

  @override
  _HomepageScreenState createState() => _HomepageScreenState(this.id);
}

class _HomepageScreenState extends State<HomepageScreen> {
  final id;
   _HomepageScreenState(this.id);
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
          home: HomesPage(this.id),
        ),
      ),
    );
  }
}

class HomesPage extends StatefulWidget {
  final id;
  const HomesPage(this.id);
  @override
  State<HomesPage> createState() => _HomesPageState(this.id);
}

class _HomesPageState extends State<HomesPage> {
  final id;
   _HomesPageState(this.id);
  final String postsQuery="""
query Posts(\$id:ID!) {
  posts(where: {
    topics_SOME:{
      svcs:{
        userF_SINGLE:{
          id:\$id
        }
      }
    }
  }) {
    content
    userW {
      username
      
    }
    memberRAggregate {
      edge {
        value {
          sum
        }
      }
    }
    
    topics {
      title
      svcs{
      title
      }
    }
    
    userRAggregate {
      edge {
        value {
          
          sum
        }
      }
    }
    
    }
}






"""; //homepage screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Homepage'),
          actions: [SearchScreen(widget.id)],),

        drawer: AppDrawer(widget.id),
        body: Container(
          padding: EdgeInsets.all(5),
          color: Color.fromRGBO(20, 20, 20, 0.2),
          child: Column(
            children: [
              Expanded(
                child: Query(
                  options: QueryOptions(
                    document: gql(postsQuery),
                    variables: {
                      'id':widget.id
                    }
                  ),
                  builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore}) {
                    // refetchQuery = refetch;
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }

                    if (result.isLoading) {
                      return const Text('Loading');
                    }

                    List? repositories = result.data?['posts'];

                    if (repositories == null) {
                      return const Text('No repositories');
                    }

                    return ListView.builder(
                        itemCount: repositories.length,
                        itemBuilder: (context, index) {
                          final repository = repositories[index];
                          return Post(
                            username: repository['userW']['username'],
                            postContent: repository['content'],
                            svcName: repository['topics'][0]['svcs']['title'],
                            topicName: repository['topics'][0]['title'],
                            postColor: Color.fromRGBO(222, 165, 118, 1.0),
                          );
                        }
                    );
                  },


                ),
              ),
              MyBottomNavigationBar(0,widget.id)
            ],
          ),
        )
    );
  }
}