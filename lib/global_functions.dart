double sumWeightedApprovals(int id1, int id2) {//(userId, svcId) or (postId, topicId)
  //from dataBase
  return 7;
}

double sumWeightedDisapprovals(int id1, int id2) {//(userId, svcId) or (postId, topicId)
  //from dataBase
  return 4;
}

double sumWeightedIgnores(int userId, int svcId) {
  //from dataBase
  return 2;
}

double getMinPositiveScore(int topicId) {//topic
  //from dataBase
  return 2.3;
}

double getMaxPositiveScore(int topicId) {//topic
  //from dataBase
  return 6.3;
}

double getMinUserScore(int svcId) {//svc
  //from dataBase
  return 5.1;
}

double getMaxUserScore(int svcId) {//svc
  //from dataBase
  return 8.1;
}

void calculateUserRank(int userId, int svcId){
  //if membership is active
  double weightedApprovals = sumWeightedApprovals(userId, svcId); //call function (send userId and svcId)
  double weightedDisapprovals = sumWeightedDisapprovals(userId, svcId);
  double score = weightedApprovals - weightedDisapprovals;
  double normalizedUserScore;
  double minUserScore = getMinUserScore(svcId);
  double maxUserScore = getMaxUserScore(svcId);
  normalizedUserScore = (score-minUserScore) / (maxUserScore-minUserScore);

}