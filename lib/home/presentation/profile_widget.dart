import 'package:flutter/material.dart';

import '../../shared/spacing.dart';
import '../../shared/text.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: SelectionArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage('assets/images/avatar.jpg'),
              backgroundColor: Colors.blue,
            ),
            VSpace(12),
            IrohaText.semibold(
              'Vi Hoang',
              fontSize: 25,
            ),
            VSpace(4),
            Opacity(
              opacity: .5,
              child: IrohaText.regular(
                'Yuri Is Justice',
                fontSize: 15,
                height: 1.5,
              ),
            ),
            VSpace(12),
            IrohaText.regular(
              'Hi, mình là Hoàng.',
              fontSize: 15,
              maxLines: null,
              height: 1.5,
            ),
            VSpace(8),
            IrohaText.regular(
              'Mình chủ yếu tập trung vào các lĩnh vực liên quan đến Flutter, Golang và Devops. Ngoài ra, mình cũng rất quan tâm đến thiết kế và nghệ thuật tuy nhiên chưa có cơ hội nghiên cứu chuyên sâu.',
              fontSize: 15,
              maxLines: null,
              height: 1.5,
            ),
            VSpace(8),
            IrohaText.regular(
              'Mình thích cộng đồng mã nguồn mở, nhưng trong quá khứ thường chỉ tập trung vào các dự án cá nhân ít được quan tâm. Ngoài lập trình, sở thích của minh còn bao gồm chụp ảnh, đọc truyện tranh và chơi game.',
              fontSize: 15,
              maxLines: null,
              height: 1.5,
            ),
            VSpace(8),
            IrohaText.regular(
              'Blog này được tạo ra để làm một cuốn nhật ký ghi ra những gì đã học trong tuần. Hi vọng sẽ duy trì thói quen này được vài tuần....',
              fontSize: 15,
              maxLines: null,
              height: 1.5,
            ),
          ],
        ),
      ),
    );
  }
}
