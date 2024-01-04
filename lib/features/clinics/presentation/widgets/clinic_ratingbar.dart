import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ClinicRatingBar extends StatelessWidget {
  const ClinicRatingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return  RatingBar.builder(
   initialRating: 3,
   minRating: 1,
   direction: Axis.horizontal,
   allowHalfRating: true,
   itemCount: 5,
   itemPadding:const EdgeInsets.symmetric(horizontal: 4.0),
   itemBuilder: (context, _) =>const  Icon(
     Icons.star,
     color: Colors.amber,
   ),
   onRatingUpdate: (rating) {
      print(rating);
   },
);
  }
}