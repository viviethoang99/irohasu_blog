import 'package:flutter/material.dart';
import 'package:irohasu_blog/shared/spacing.dart';
import 'box_widget.dart';
import 'text.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const BoxWidget(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 48.0,
            // backgroundImage: AssetImage('assets/images/avatar.jpeg'),
            backgroundColor: Colors.blue,
          ),
          VSpace(12),
          IrohaText.semibold(
            'Vi Hoàng',
            fontSize: 20,
          ),
          VSpace(16),
          IrohaText.regular(
            'Yuri Is Justice',
            fontSize: 15,
          ),
          VSpace(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfomationWidget(title: 'bài viết', count: 1),
              InfomationWidget(title: 'thể loại', count: 1),
              InfomationWidget(title: 'thẻ', count: 5),
              InfomationWidget(title: 'số từ'),
            ],
          )
        ],
      ),
    );
  }
}

class InfomationWidget extends StatelessWidget {
  const InfomationWidget({
    super.key,
    required this.title,
    this.count,
  });

  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IrohaText.regular(
          '${count ?? 0}',
          fontSize: 20,
        ),
        const SizedBox(height: 5),
        IrohaText.regular(
          title,
          fontSize: 16,
        ),
      ],
    );
  }
}
