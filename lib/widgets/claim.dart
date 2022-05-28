import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:svc15/global_functions.dart';
import 'package:svc15/screens/main%20screens/profile_screen.dart';

class Claim extends StatefulWidget {
  final username;
  final id;
  final myID;
  const Claim({this.myID,this.username,this.id});

  @override
  _ClaimState createState() => _ClaimState(this.myID,this.username,this.id);
}

class _ClaimState extends State<Claim> {
  final myClient = GetIt.I<GraphQLClient>();
  final username;
  final id;
  final myID;
  _ClaimState(this.myID,this.username,this.id);
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
          home: ClaimHomePage( this.myID,this.username,this.id),
        ),
      ),
    );
  }

}

class ClaimHomePage extends StatefulWidget {
  final username;
  final id;
  final myID;
  ClaimHomePage(this.myID,this.username,this.id);
  @override
  State<ClaimHomePage> createState() => _ClaimHomePageState(this.myID,this.username,this.id);
}

class _ClaimHomePageState extends State<ClaimHomePage> {
  final username;
  final id;
  final myID;
  _ClaimHomePageState(this.myID,this.username,this.id);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(215, 215, 215, 0.5),

      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                      child: CircleAvatar(),
                    ),
                    Text(widget.username)
                  ],
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, new MaterialPageRoute(
                          builder: (context) =>
                          new ProfileScreen(widget.id))
                      );
                    },
                    child: Text('View Profile'))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                    },
                    child: Text('Approve')
                ),
                ElevatedButton(
                    onPressed: () {
                    },
                    child: Text('disapprove')
                ),
                ElevatedButton(
                    onPressed: () {
                    },
                    child: Text('ignore')
                )
              ],

            ),
          ],
        ),
      ),
    );
  }

  bool claimNotExpired(){//user and svc
    //
    return true;
  }

  //when to call?
  void claimSVCMembership(int userId, int svcId){//user and SVC
    if(claimNotExpired()){
      double weightedApprovals = sumWeightedApprovals(userId, svcId); //call function (send user and SVC)
      double weightedDisapprovals = sumWeightedDisapprovals(userId, svcId);
      double weightedIgnores = sumWeightedIgnores(userId, svcId);
      if((weightedApprovals+weightedDisapprovals) > weightedIgnores
          && weightedApprovals > weightedDisapprovals){
        acceptUserClaim(userId, svcId);
        //activate membership
      }
    }
  }

  void acceptUserClaim(int userId, int svcId){
    //in database, add this user to this svc(make the relation)
  }
}