import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

class EnhancedVocabularyImage extends StatelessWidget {
  final String? imageUrl;
  final String word;
  final double size;
  final bool isZoomable;

  const EnhancedVocabularyImage({
    super.key,
    this.imageUrl,
    required this.word,
    this.size = 60,
    this.isZoomable = false,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildFallbackImage();
    }

    return isZoomable
        ? GestureDetector(
            onTap: () => _showFullImage(context),
            child: Hero(
              tag: 'image_${imageUrl ?? word}',
              child: _buildImage(),
            ),
          )
        : _buildImage();
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildFallbackImage(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: size,
      height: size,
      color: _getColorForLetter(word[0]).withOpacity(0.2),
      child: Center(
        child: SizedBox(
          width: size / 3,
          height: size / 3,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getColorForLetter(word[0]),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          word.substring(0, 1).toUpperCase(),
          style: TextStyle(
            fontSize: size / 2.5,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Hero(
                  tag: 'image_${imageUrl ?? word}',
                  child: Container(
                    color: Colors.black,
                    child: PhotoView(
                      imageProvider: CachedNetworkImageProvider(imageUrl!),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              word,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForLetter(String letter) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
    ];
    
    // Sử dụng mã ASCII của chữ cái để chọn màu
    final index = letter.toLowerCase().codeUnitAt(0) % colors.length;
    return colors[index];
  }
} 