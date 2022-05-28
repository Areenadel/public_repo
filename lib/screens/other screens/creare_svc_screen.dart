//need edit
//*****1- user can create one svc\topic only !?
//2- add topic des with controller
// 3- pass user id

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:svc15/widgets/app_drawer.dart';


class CreateSVCScreen extends StatefulWidget {
  final id;
  CreateSVCScreen(this.id);

  // static const routeName = '/createSVCScreen';

  // const CreateSVCScreen({Key? key}) : super(key: key);

  @override
  _CreateSVCScreenState createState() => _CreateSVCScreenState(this.id);
}

class _CreateSVCScreenState extends State<CreateSVCScreen> {
  final myClient = GetIt.I<GraphQLClient>();
  final id;
  _CreateSVCScreenState(this.id);
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
          home: CreateSVCScreenHomePage(this.id),
        ),
      ),
    );
  }
}

class CreateSVCScreenHomePage extends StatefulWidget{
  final id;
  CreateSVCScreenHomePage(this.id);
  @override
  State<CreateSVCScreenHomePage> createState() => _CreateSVCScreenHomePageState(this.id);
}

class _CreateSVCScreenHomePageState extends State<CreateSVCScreenHomePage> {
  final id;
  _CreateSVCScreenHomePageState(this.id);
  final svcTitleController = TextEditingController();
  final svcDesController = TextEditingController();
  final topicTitleController = TextEditingController();

  final _globalKey = GlobalKey<FormState>();

  final String createSVCMutation="""
  mutation CreateSvcs(
  \$title:String!,
  \$description:String!,
  \$Uid:ID,
  \$topicTitle:String!,
  ) {
  createSvcs(input:{
    title:\$title,
    description:\$description,
    userC:{
      connect:{
        where:{
          node:{
            id:\$Uid}}}},
    topics:{
      create:{
        node:{
          title:\$topicTitle,
          member:{
            connect:{
              where:{
                node:{
                  user:{
                    id:\$Uid
                    }
                    svcs_SINGLE:{
                      title:\$title
                    }
                    }
                    
                    }}}}}},
    members:{
      create:{
        node:{
          user:{
            connect:{
              where:{
                node:{
                  id:\$Uid
                  }}}}}}}} 
    ) {
    info {
      nodesCreated
      relationshipsCreated
    }
  }
}
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Create SVC'),),
        // drawer: AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Form(
                  key: _globalKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'SVC name',
                          // icon: Icon(Icons.alternate_email)
                        ),
                        controller: svcTitleController,
                        validator: (value) {
                          if(value == null || value.isEmpty){
                            return 'SVC name can\'t be empty';
                          }
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'SVC description ',
                        ),
                        controller: svcDesController,
                        validator: (value) {
                          if(value == null || value.isEmpty){
                            return 'SVC description can\'t be empty';
                          }
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'topic name',
                          // icon: Icon(Icons.alternate_email)
                        ),
                        controller: topicTitleController,
                        // validator: (value) {
                        //   if(value == null || value.isEmpty){
                        //     return 'topic name can\'t be empty';
                        //   }
                        // },
                      ),

                    ],
                  )
              ),
              Mutation(
                options: MutationOptions(
                  document: gql(createSVCMutation),
                  onCompleted: (dynamic resultData) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('SVC created')),
                    );
                    print(resultData);

                  },
                ),
                  builder: (
                      RunMutation runMutation,
                      QueryResult? result,
                  ) {
                    if(result!= null){
                      if(result.isLoading){
                        return Text("load");
                        // return const LoadingSpinner();
                      }
                      if(result.hasException){
                        // return Text("exp");
                        return Text(result.exception.toString());
                        // context.showError
                      }
                    }
                    return ElevatedButton(
                      onPressed: () {
                        if (_globalKey.currentState!.validate()) {
                          print('created');
                          runMutation({
                            'title':svcTitleController.text,
                            'description':svcDesController.text,
                            'Uid':widget.id,
                            'topicTitle':topicTitleController.text,

                          });
                          print('created2');
                          // Fluttertoast.showToast(msg: 'SVC created');


                          // Navigator.pushReplacementNamed(context, HomepageScreen.routeName);
                        }

                        // print('email:' + emailController.text);
                      },
                      child: Text('Create'),
                    );

                  }
              )
            ],
          ),
        )
    );
  }
}