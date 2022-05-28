
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:svc15/models/user_model.dart';

import '../global_functions.dart';

class Post extends StatefulWidget {
  final username;
  final postContent;
  final svcName;
  final topicName;
  final postColor;

  const Post({this.username, this.postContent, this.svcName, this.topicName, this.postColor});


  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Color.fromRGBO(203, 200, 200, 0.5),
          color: widget.postColor,

          borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 15, 10),
                    child: CircleAvatar(radius: 23,),
                ),
                Text(widget.username),
              ],
            ),
            // SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.postContent),
                SizedBox(height: 8,),
                Text('#${widget.svcName}:${widget.topicName}'),
              ],
            ),

            SizedBox(height: 10,),
            Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("usefulness: "),
                    RatingBar.builder(
                      // initialRating: 3,
                      // minRating: 1,
                      itemSize: 30,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      // itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ],
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(10, 10),
                        padding: EdgeInsets.all(7),
                        textStyle: TextStyle(fontSize: 13),
                      ),
                      onPressed: () {
                        // rankCategorizedContent(postId, topicId)
                      },
                      child: Text("Approve"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(10, 10),
                        padding: EdgeInsets.all(7),
                        textStyle: TextStyle(fontSize: 13),
                      ),
                      onPressed: () {
                        // rankCategorizedContent(postId, topicId)
                        // call this function many times (as number of topics)

                      },
                      child: Text("Disapprove"),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  //for tagged posts
  void rankCategorizedContent(int postId, int topicId){ // post and topic
    double weightedApprovals = sumWeightedApprovals(postId, topicId); //call function (send postId and TopicId)
    double weightedDisapprovals = sumWeightedDisapprovals(postId, topicId);
    double score = weightedApprovals - weightedDisapprovals;
    double normalizedPositiveScore;
    if(score > 0){
      double minPositiveScore = getMinPositiveScore(topicId);
      double maxPositiveScore = getMaxPositiveScore(topicId);
      normalizedPositiveScore = (score-minPositiveScore) / (maxPositiveScore-minPositiveScore);
    }
    else
      normalizedPositiveScore = 0;
  }
}
