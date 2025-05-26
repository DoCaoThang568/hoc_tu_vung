import 'package:flutter/material.dart';
import '../models/pronunciation_service.dart';
import 'enhanced_vocabulary_image.dart';

class VocabularyItem extends StatelessWidget {
  final String word;
  final String phonetic;
  final String meaning;
  final double progress;
  final String? imageUrl;
  final double nativeSimilarity;
  final String? topic;
  final PronunciationService _pronunciationService = PronunciationService();

  VocabularyItem({
    super.key,
    required this.word,
    required this.phonetic,
    required this.meaning,
    required this.progress,
    this.imageUrl,
    this.nativeSimilarity = 0,
    this.topic,
  });
  
  // Đọc từ vựng với cơ chế dự phòng
  Future<void> _speakWord(String text, BuildContext context) async {
    bool success = await _pronunciationService.pronounceWord(
      text, 
      preferredSource: PronunciationSource.localTts
    );
    
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Không thể phát âm từ '$text'. Vui lòng thử lại sau."),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Tải xuống',
            onPressed: () async {
              // Tải xuống phát âm để sử dụng offline
              bool downloaded = await _pronunciationService.downloadAndSaveAudio(text);
              if (downloaded) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Đã tải xuống phát âm để sử dụng offline."))
                  );
                }
              }
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Hiển thị chi tiết từ vựng
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình ảnh minh họa với widget nâng cao
              EnhancedVocabularyImage(
                imageUrl: imageUrl,
                word: word,
                size: 60,
                isZoomable: true,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            word,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (topic != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue[300]!),
                            ),
                            child: Text(
                              topic!,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: GestureDetector(
                        onTap: () => _speakWord(word, context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.volume_up_rounded,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              phonetic,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.speed,
                              size: 12,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            PopupMenuButton<double>(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                size: 12,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              initialValue: 0.5,
                              onSelected: (rate) {
                                _pronunciationService.setTtsSpeechRate(rate);
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 0.25,
                                  child: Text('Rất chậm', style: TextStyle(fontSize: 12)),
                                ),
                                const PopupMenuItem(
                                  value: 0.5,
                                  child: Text('Chậm', style: TextStyle(fontSize: 12)),
                                ),
                                const PopupMenuItem(
                                  value: 0.75,
                                  child: Text('Bình thường', style: TextStyle(fontSize: 12)),
                                ),
                                const PopupMenuItem(
                                  value: 1.0,
                                  child: Text('Nhanh', style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            meaning,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        _buildNativeSimilarityBadge(nativeSimilarity),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(progress),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(progress * 100).toInt()}% hoàn thành',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.favorite_border,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                // Đánh dấu yêu thích
                              },
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: Icon(
                                Icons.bookmark_border,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                // Đánh dấu để học sau
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNativeSimilarityBadge(double similarity) {
    Color color;
    String level;
    
    if (similarity >= 0.8) {
      color = Colors.green;
      level = 'Cao';
    } else if (similarity >= 0.5) {
      color = Colors.orange;
      level = 'Trung bình';
    } else {
      color = Colors.red;
      level = 'Thấp';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.compare_arrows,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 2),
          Text(
            '$level (${(similarity * 100).toInt()}%)',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.3) return Colors.red;
    if (progress < 0.7) return Colors.orange;
    return Colors.green;
  }
} 