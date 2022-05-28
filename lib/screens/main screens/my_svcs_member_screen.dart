import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:svc15/widgets/app_drawer.dart';
import 'package:svc15/widgets/list_item.dart';
import 'package:svc15/widgets/search_item.dart';
class MySVCsMemberScreen extends StatefulWidget {
  // static const routeName = '/MySVCsScreen';

  // const MySVCsScreen({Key? key}) : super(key: key);

  final id;
  MySVCsMemberScreen(this.id);
  @override
  _MySVCsMemberScreenState createState() => _MySVCsMemberScreenState(this.id);
}

class _MySVCsMemberScreenState extends State<MySVCsMemberScreen> {
  final id;
  _MySVCsMemberScreenState(this.id);
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
          home: MySVCsMemberScreenHomePage(this.id),
        ),
      ),
    );
  }
}

class MySVCsMemberScreenHomePage extends StatefulWidget{
  final id;
  MySVCsMemberScreenHomePage(this.id);
  @override
  State<MySVCsMemberScreenHomePage> createState() => _MySVCsMemberScreenHomePageState(this.id);
}

class _MySVCsMemberScreenHomePageState extends State<MySVCsMemberScreenHomePage> {
  final id;
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
  _MySVCsMemberScreenHomePageState(this.id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('My SVCs'),),
        drawer: AppDrawer(widget.id),
        body: Container(
          padding: EdgeInsets.only(top: 10, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('All SVCs i am member in:', style: TextStyle(fontSize: 20),),
              Divider(height: 5,),
              Query(
                  options: QueryOptions(
                      document: gql(svcsQuery),
                      variables: {
                        'Uid':widget.id
                      }
                  ),
                  builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore}) {
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }

                    if (result.isLoading) {
                      return const Text('Loading');
                    }

                    List svcs = result.data ? ['svcs'];
                    print(svcs);
                    if (svcs == null) {
                      return const Text('No svc');
                    }

                    return
                      Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: svcs.length,

                              itemBuilder:(context, index) {
                                return ListItem(
                                    name: svcs[index]['title'],
                                id: svcs[index]['id'],
                                Uid:widget.id);
                              }
                          )
                      );
                  }
              )
            ],
          ),
        )

    );

  }
}


