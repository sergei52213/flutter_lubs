import 'package:flutter/material.dart';
import '../extensions/extensions.dart';
import '../features/home/content_item.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({super.key, required this.content});

  final ContentItem content;

  @override
  Widget build(BuildContext context) {
    final imageSize = 100.0;

    return InkWell(
      // onTap: () => context.push('/content/${content.id}'),
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: imageSize,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                content.image,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: imageSize,
                  height: imageSize,
                  color: Colors.grey[300],
                ),
              ),
            ),
            16.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    content.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  8.ph,
                  Text(
                    content.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}