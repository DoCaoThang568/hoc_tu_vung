import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flashcard_screen.dart'; // Sẽ cần cho điều hướng
import 'quiz_screen.dart'; // Sẽ cần cho điều hướng
// import 'traditional_learning_screen.dart'; // Màn hình học kiểu truyền thống (sẽ tạo sau)

class LearningMethodsScreen extends StatelessWidget {
  final Map<String, dynamic> topicData;

  const LearningMethodsScreen({super.key, required this.topicData});

  static const routeName = '/learning-methods';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String topicName = topicData['name'] ?? 'Chủ đề không xác định';
    final Color topicColor = topicData['color'] as Color? ?? theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn cách học', style: GoogleFonts.poppins()),
        backgroundColor: topicColor.withOpacity(0.8),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: topicColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: topicColor.withOpacity(0.3))
                ),
                child: Column(
                  children: [
                    Icon(topicData['icon'] as IconData? ?? Icons.category, size: 40, color: topicColor),
                    const SizedBox(height: 12),
                    Text(
                      'Chủ đề đã chọn:',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      topicName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: topicColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Chọn phương pháp học bạn muốn:',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 20),
              _buildLearningMethodButton(
                context: context,
                title: 'Học bằng Flashcard',
                subtitle: 'Lật thẻ để ghi nhớ từ vựng',
                icon: Icons.style_outlined,
                color: Colors.orange,
                onTap: () {
                  // TODO: Truyền topicData vào FlashcardScreen nếu cần
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => FlashcardScreen(topicData: topicData), // Giả sử FlashcardScreen chấp nhận topicData
                    ),
                  );
                  print('Chuyển đến Flashcard với chủ đề: \$topicName');
                },
              ),
              const SizedBox(height: 16),
              _buildLearningMethodButton(
                context: context,
                title: 'Làm bài Quiz',
                subtitle: 'Kiểm tra kiến thức với câu hỏi trắc nghiệm',
                icon: Icons.quiz_outlined,
                color: Colors.purple,
                onTap: () {
                  // TODO: Truyền topicData vào QuizScreen nếu cần
                   Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => QuizScreen(topicData: topicData), // Giả sử QuizScreen chấp nhận topicData
                    ),
                  );
                  print('Chuyển đến Quiz với chủ đề: \$topicName');
                },
              ),
              const SizedBox(height: 16),
              _buildLearningMethodButton(
                context: context,
                title: 'Học kiểu truyền thống',
                subtitle: 'Luyện tập đa dạng như Duolingo',
                icon: Icons.school_outlined,
                color: Colors.green,
                onTap: () {
                  // TODO: Điều hướng đến TraditionalLearningScreen (sẽ tạo sau)
                  // Navigator.of(context).pushReplacementNamed(TraditionalLearningScreen.routeName, arguments: topicData);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tính năng "Học kiểu truyền thống" cho chủ đề \$topicName đang được phát triển.', style: GoogleFonts.poppins()),
                      backgroundColor: Colors.blueGrey,
                    ),
                  );
                  print('Chuyển đến Học truyền thống với chủ đề: \$topicName');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLearningMethodButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: color.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

// Cần cập nhật FlashcardScreen và QuizScreen để chấp nhận `topicData`
// Ví dụ cho FlashcardScreen:
// class FlashcardScreen extends StatelessWidget {
//   final Map<String, dynamic>? topicData; // Thêm tham số này
//   const FlashcardScreen({super.key, this.topicData});
//   ...
// }

// Ví dụ cho QuizScreen:
// class QuizScreen extends StatelessWidget {
//   final Map<String, dynamic>? topicData; // Thêm tham số này
//   const QuizScreen({super.key, this.topicData});
//   ...
// }
