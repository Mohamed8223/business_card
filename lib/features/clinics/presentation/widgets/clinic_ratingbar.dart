import 'package:clinigram_app/features/clinics/data/models/clinic_model.dart';
import 'package:clinigram_app/features/profile/data/models/rating_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ClinicRatingBar extends StatefulWidget {
   const ClinicRatingBar({super.key});

  @override
  State<ClinicRatingBar> createState() => _ClinicRatingBarState();
}

class _ClinicRatingBarState extends State<ClinicRatingBar> {
 
   double rat=3;
  
  @override
  Widget build(BuildContext context) {
    return  RatingBar.builder(
   initialRating: rat,
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
    print(rat);
    initState(){
       rat=rating;
       
    }
    
      RatingModel(userId: '', rating: rat, comment: 'comment');
   },
);
  }
}