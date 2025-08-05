import 'package:content_scripter/common_widget/cache_image.dart';
import 'package:flutter/material.dart';

class BuildImage extends StatelessWidget {
  final VoidCallback onClose;
  final String imagePath;
  final bool isUploaded;
  const BuildImage({
    required this.isUploaded,
    required this.imagePath,
    required this.onClose,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isUploaded ? 1.0 : 0.4,
            child: CacheImage(url: imagePath),
          ),
          if (!isUploaded)
            const CircularProgressIndicator()
          else
            Positioned(
              top: 2,
              right: 2,
              child: GestureDetector(
                onTap: onClose,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
