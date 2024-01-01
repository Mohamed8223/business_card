import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:clinigram_app/features/profile/utils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:clinigram_app/core/constants/app_colors.dart';
import 'package:clinigram_app/features/profile/providers/other_user_profile_provider.dart';

class RateCard extends ConsumerStatefulWidget {
  final String userId;
  final double? rate;
  final String? comment;
  const RateCard(this.userId, this.rate, this.comment, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RateCardState();
}

class _RateCardState extends ConsumerState<RateCard> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(otherUserProfileProvider(widget.userId));
    final user = userState.user;

    if (user == null || widget.rate == null) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundImage: getDefaultProfilePicForUser(user),
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            " ${widget.comment}",
            maxLines: 1,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xff113c67),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          RatingBar.builder(
            initialRating: widget.rate!,
            itemSize: 15,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, index) {
              if (index < widget.rate!) {
                return const Icon(
                  Icons.star,
                  color: Colors.amber,
                );
              } else {
                return const Icon(
                  Icons.star,
                  color:
                      separatorGray, // Change this to your desired color for empty stars
                );
              }
            },
            onRatingUpdate: (rating) {
              // The onRatingUpdate callback is not used when ignoreGestures is true.
            },
            ignoreGestures: true, // Disable user interaction
          ),
        ],
      ),
    );
  }
}
