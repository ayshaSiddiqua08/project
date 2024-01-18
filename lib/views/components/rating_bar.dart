import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingBarWidget extends StatefulWidget {
  final double rating;

  RatingBarWidget({required this.rating});

  @override
  _RatingBarWidgetState createState() => _RatingBarWidgetState();
}
class _RatingBarWidgetState extends State<RatingBarWidget> {
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: widget.rating,
      minRating: 0,
      itemSize: 11.r,
      direction: Axis.horizontal,
      allowHalfRating: true,
      ignoreGestures: true, // This will make the rating bar non-editable
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        // Callback when the rating changes (since ignoreGestures is true, this won't be called)
      },
    );
  }
}

