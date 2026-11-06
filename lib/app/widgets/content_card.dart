import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/domain.dart';
import '../extensions/extensions.dart';
import '../utils/image_url.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({
    super.key,
    required this.content,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  final Content content;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final imageSize = 100.0;

    return InkWell(
      onTap: () => context.push('/detail/${content.id}'),
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: imageSize,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                resolveImageUrl(content.image),
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: imageSize,
                  height: imageSize,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;

                  return Container(
                    width: imageSize,
                    height: imageSize,
                    color: Colors.grey[200],
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                },
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
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onFavoriteTap != null)
              IconButton(
                tooltip: isFavorite
                    ? 'Удалить из избранного'
                    : 'Добавить в избранное',
                onPressed: onFavoriteTap,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.redAccent : Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
