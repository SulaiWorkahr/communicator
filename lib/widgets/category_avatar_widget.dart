import 'package:flutter/material.dart';
import 'sub_heading_widget.dart';

import '../constants/constants.dart';
import 'heading_widget.dart';

class CategoryAvatarWidget extends StatelessWidget {
  String title;
  String? image;
  final Function()? onTap;
  CategoryAvatarWidget(
      {super.key, required this.title, this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              // backgroundImage: NetworkImage(
              //             AppConstants.imgBaseUrl + (image ?? ''),
              //                                    ),
              //         ),
                   child:   Image.network(
                          AppConstants.imgBaseUrl + (image ?? ''),
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset(
                              AppAssets.logo,
                              height: 60,
                              width: 200,
                            );
                          },
                        ),
                        ),
              // backgroundImage: AssetImage(image!),
            // ),
            SubHeadingWidget(
              title: title,
              color: AppColors.dark,
            )
          ],
        ),
      ),
    );
  }
}
