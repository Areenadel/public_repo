import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:svc15/widgets/app_drawer.dart';
import 'package:svc15/widgets/list_item.dart';
import 'package:svc15/widgets/search_item.dart';

class MySVCsScreen extends StatefulWidget {
  // static const routeName = '/MySVCsScreen';

  // const MySVCsScreen({Key? key}) : super(key: key);

  final id;
  MySVCsScreen(this.id);
  @override
  _MySVCsScreenState createState() => _MySVCsScreenState(this.id);
}

class _MySVCsScreenState extends State<MySVCsScreen> {
  final id;
  _MySVCsScreenState(this.id);
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
          home: MySVCsScreenHomePage(this.id),
        ),
      ),
    );
  }
}

class MySVCsScreenHomePage extends StatefulWidget{
  final id;
  MySVCsScreenHomePage(this.id);
  @override
  State<MySVCsScreenHomePage> createState() => _MySVCsScreenHomePageState(this.id);
}

class _MySVCsScreenHomePageState extends State<MySVCsScreenHomePage> {
  final id;
  final String svcsQuery="""
  
  query Svcs(\$Uid:ID!) {
  svcs(where: {
    userF_SINGLE:{
      id:\$Uid
    }
  }) {
    id
    title
  }
}
  """;
  _MySVCsScreenHomePageState(this.id);
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
              Text('All SVCs i follow:', style: TextStyle(fontSize: 20),),
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