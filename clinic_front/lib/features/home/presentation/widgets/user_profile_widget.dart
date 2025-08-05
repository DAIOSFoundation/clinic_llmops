import 'package:banya_llmops/shared/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class UserProfileWidget extends StatelessWidget {
  final String imageUrl;
  final String userName;
  const UserProfileWidget({
    super.key,
    required this.imageUrl,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(imageUrl),
          backgroundColor: Colors.black,
        ),
        SizedBox(width: 8),
        Text(userName, style: AppTextStyles.title(context)),
      ],
    );
  }
}
