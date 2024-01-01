import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:clinigram_app/core/constants/app_colors.dart';
import 'package:clinigram_app/features/translation/data/generated/l10n.dart';
import 'package:clinigram_app/features/profile/data/models/rating_model.dart';
import 'package:clinigram_app/features/profile/data/repositries/profile_repo.dart';
import 'package:clinigram_app/features/profile/providers/current_user_profile_provider.dart';

class AddRate extends ConsumerStatefulWidget {
  final String userId;

  AddRate({
    Key? key,
    required this.userId,
  });

  @override
  ConsumerState<AddRate> createState() => _AddRateState();
}

class _AddRateState extends ConsumerState<AddRate> {
  final TextEditingController _controller = TextEditingController();
  double userRate = 0.0;
  String comment = '';

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProfileProvider);
    final repo = ref.watch(profileRepoProvider);

    return Column(
      children: [
        const SizedBox(height: 20),
        RatingBar.builder(
          initialRating: 0,
          itemSize: 36,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, index) {
            if (index < userRate) {
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
            setState(() {
              userRate = rating;
            }); // Update userRate when the rating changes
          },
        ),
        const SizedBox(height: 20),
        Text(
          S.of(context).CommentsWidget_addCommentHint,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: separatorGray,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            maxLines: 5,
            controller: _controller,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            final userRating = RatingModel(
                userId: currentUser.id,
                rating: userRate,
                comment: _controller.text);
            repo.addRatingAndComment(userRating, widget.userId);

            _controller.clear();
            Navigator.pop(context);
          },
          child: Text(S.of(context).ClicnkInfoView_Add),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
