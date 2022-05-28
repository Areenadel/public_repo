//need edit {this query doesnt accept or filtering } ,
// need to add claims that process as member
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:svc15/widgets/app_drawer.dart';
import 'package:svc15/widgets/claim.dart';

class ClaimsScreen extends StatefulWidget {
  final id;
  ClaimsScreen(this.id);

  // static const routeName = '/claimsScreen';

  // const ClaimsScreen({Key? key}) : super(key: key);

  @override
  _ClaimsScreenState createState() => _ClaimsScreenState(this.id);
}

class _ClaimsScreenState extends State<ClaimsScreen> {
  final id;
  _ClaimsScreenState(this.id);
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
          home: ClaimsScreenHomePage(this.id),
        ),
      ),
    );
  }
}

class ClaimsScreenHomePage extends StatefulWidget{
  final id;
  ClaimsScreenHomePage(this.id);
  @override
  State<ClaimsScreenHomePage> createState() => _ClaimsScreenHomePageState(this.id);
}

class _ClaimsScreenHomePageState extends State<ClaimsScreenHomePage> {
  final id;
  _ClaimsScreenHomePageState(this.id);
  final String claimsQuery="""
  query Claims(\$Uid:ID!){
  asFollower:claims(where: {
    userP_SINGLE:{
      id:\$Uid
    }
  }) {
    id
    userS{
      id
      username
    }
  }
  asMember:claims(where: {
     member_SINGLE:{
      user:{
        id:\$Uid
      }
    }
    
  })  {
    id
    userS {
      id
      username
    }
  }
}
  """;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Claims'),
        ),
        // drawer: AppDrawer(),
        body: Query(
            options: QueryOptions(
              document: gql(claimsQuery),
              variables: {
                "Uid": widget.id
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

              List? claimsF = result.data ? ['asFollower'];
              // List? claimsM = result.data ? ['asMember'];

              if (claimsF == null ) {
                return const Text('No claims');
              }
              List claims=claimsF;
              return Padding(
                  padding: EdgeInsets.all(10),
                  child: ListView.builder(
                      itemCount: claims.length,
                      itemBuilder: (context, index) {
                        final claim = claims[index];
                        final usernameS=claim['userS']['username'];
                        final idS=claim['userS']['id'];
                        return Column(
                          children: [
                            Claim(
                              username:usernameS,
                              id:idS,
                              myID:widget.id
                            ),
                            SizedBox(height: 10,),
                          ],
                        );

                      }
                  )
              );
            }
        ));
  }
}
