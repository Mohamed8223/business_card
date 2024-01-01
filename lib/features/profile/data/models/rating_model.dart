class RatingModel {
  String userId;
  double rating;
  String comment;

  RatingModel({
    required this.userId,
    required this.rating,
    required this.comment,
  });

  Map<String, dynamic> toDocument() {
    return {
      'userId': userId,
      'rating': rating,
      'comment': comment,
    };
  }

  factory RatingModel.fromDocument(Map<String, dynamic> document) {
    return RatingModel(
      userId: document['userId'] as String,
      rating: document['rating'] as double,
      comment: document['comment'] as String,
    );
  }

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      userId: json['userId'] as String,
      rating: json['rating'] as double,
      comment: json['comment'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'rating': rating,
      'comment': comment,
    };
  }
}
