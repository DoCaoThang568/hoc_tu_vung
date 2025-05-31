import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/lessons_service.dart';
import 'vocabulary_screen.dart';
import 'lesson_exercises_screen.dart';

class LessonsScreen extends StatefulWidget {
  final Map<String, dynamic> topicData;

  const LessonsScreen({super.key, required this.topicData});

  static const routeName = '/lessons';

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _lessons = [];

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final categoryId = int.tryParse(widget.topicData['id'] ?? '1') ?? 1;
      final lessons = await LessonsService.getLessonsByCategory(categoryId);
      
      setState(() {
        _lessons = lessons;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Có lỗi xảy ra khi tải bài học: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String topicName = widget.topicData['name'] ?? 'Chủ đề không xác định';
    final Color topicColor = widget.topicData['color'] as Color? ?? theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bài học', style: GoogleFonts.poppins()),
        backgroundColor: topicColor.withOpacity(0.8),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLessons,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Topic Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    topicColor.withOpacity(0.8),
                    topicColor.withOpacity(0.1),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    widget.topicData['icon'] as IconData? ?? Icons.book,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    topicName,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${_lessons.length} bài học có sẵn',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải bài học...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadLessons,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_lessons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có bài học nào',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hãy quay lại sau để xem các bài học mới',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _lessons.length,
      itemBuilder: (context, index) {
        final lesson = _lessons[index];
        return _buildLessonCard(lesson, index);
      },
    );
  }
  Widget _buildLessonCard(Map<String, dynamic> lesson, int index) {
    final theme = Theme.of(context);
    final title = lesson['title'] ?? 'Bài học ${index + 1}';
    final description = lesson['description'] ?? 'Mô tả bài học';
    final vocabularyCount = lesson['vocabulary_count'] ?? 0;
    final exerciseCount = lesson['exercise_count'] ?? 0;
    final duration = lesson['duration'] ?? '15 phút';
    final difficulty = lesson['difficulty'] ?? 'Cơ bản';
    
    // Difficulty color
    Color difficultyColor;
    switch (difficulty.toLowerCase()) {
      case 'nâng cao':
      case 'advanced':
        difficultyColor = Colors.red;
        break;
      case 'trung bình':
      case 'intermediate':
        difficultyColor = Colors.orange;
        break;
      default:
        difficultyColor = Colors.green;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showLessonOptions(context, lesson),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.menu_book,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.titleLarge?.color,
                          ),
                        ),
                        Text(
                          description,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: difficultyColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: difficultyColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      difficulty,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: difficultyColor,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Stats
              Row(
                children: [
                  _buildStatChip(
                    icon: Icons.schedule,
                    label: duration,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  _buildStatChip(
                    icon: Icons.translate,
                    label: '$vocabularyCount từ',
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  _buildStatChip(
                    icon: Icons.quiz,
                    label: '$exerciseCount bài tập',
                    color: Colors.purple,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showLessonOptions(BuildContext context, Map<String, dynamic> lesson) {
    final lessonId = lesson['id'] ?? 1;
    final title = lesson['title'] ?? 'Bài học';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Vocabulary option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.translate, color: Colors.blue),
              ),
              title: Text(
                'Học từ vựng',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                'Xem và học các từ vựng trong bài học',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VocabularyScreen(
                      lessonId: lessonId,
                      lessonTitle: title,
                      topicData: widget.topicData,
                    ),
                  ),
                );
              },
            ),
            
            // Exercises option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.quiz, color: Colors.purple),
              ),
              title: Text(
                'Làm bài tập',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                'Thực hành với các bài tập và câu hỏi',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonExercisesScreen(
                      lessonId: lessonId,
                      lessonTitle: title,
                      topicData: widget.topicData,
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
