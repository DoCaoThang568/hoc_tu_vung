import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/lessons_service.dart';

class LessonExercisesScreen extends StatefulWidget {
  final int lessonId;
  final String lessonTitle;
  final Map<String, dynamic> topicData;

  const LessonExercisesScreen({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
    required this.topicData,
  });

  @override
  State<LessonExercisesScreen> createState() => _LessonExercisesScreenState();
}

class _LessonExercisesScreenState extends State<LessonExercisesScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _exercises = [];
  int _currentExerciseIndex = 0;
  int? _selectedAnswer;
  bool _showResult = false;
  int _score = 0;
  List<bool> _exerciseResults = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final exercises = await LessonsService.getLessonExercises(widget.lessonId);
      
      setState(() {
        _exercises = exercises;
        _exerciseResults = List<bool>.filled(exercises.length, false);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Có lỗi xảy ra khi tải bài tập: $e';
        _isLoading = false;
      });
    }
  }

  void _selectAnswer(int answerIndex) {
    if (_showResult) return;
    
    setState(() {
      _selectedAnswer = answerIndex;
    });
  }

  void _submitAnswer() {
    if (_selectedAnswer == null) return;

    final exercise = _exercises[_currentExerciseIndex];
    final correctAnswer = exercise['correct_answer'] as int;
    final isCorrect = _selectedAnswer == correctAnswer;

    setState(() {
      _showResult = true;
      _exerciseResults[_currentExerciseIndex] = isCorrect;
      if (isCorrect) _score++;
    });
  }

  void _nextExercise() {
    if (_currentExerciseIndex < _exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
    } else {
      _showFinalResult();
    }
  }

  void _showFinalResult() {
    final percentage = (_score / _exercises.length * 100).round();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Hoàn thành bài tập!',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              percentage >= 80 ? Icons.emoji_events : 
              percentage >= 60 ? Icons.thumb_up : Icons.school,
              size: 64,
              color: percentage >= 80 ? Colors.amber : 
                     percentage >= 60 ? Colors.green : Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              'Điểm số: $_score/${_exercises.length}',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$percentage%',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _getEncouragementMessage(percentage),
              style: GoogleFonts.poppins(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to lessons
            },
            child: const Text('Quay lại'),
          ),
          ElevatedButton(
            onPressed: _restartExercises,
            child: const Text('Làm lại'),
          ),
        ],
      ),
    );
  }

  String _getEncouragementMessage(int percentage) {
    if (percentage >= 90) return 'Xuất sắc! Bạn đã làm rất tốt!';
    if (percentage >= 80) return 'Tốt lắm! Tiếp tục phát huy!';
    if (percentage >= 60) return 'Khá tốt! Hãy cố gắng thêm!';
    return 'Cần cố gắng thêm. Hãy ôn lại từ vựng!';
  }

  void _restartExercises() {
    Navigator.pop(context); // Close dialog
    setState(() {
      _currentExerciseIndex = 0;
      _selectedAnswer = null;
      _showResult = false;
      _score = 0;
      _exerciseResults = List<bool>.filled(_exercises.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color topicColor = widget.topicData['color'] as Color? ?? theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bài tập',
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            Text(
              widget.lessonTitle,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
        backgroundColor: topicColor.withOpacity(0.8),
        elevation: 0,
        actions: [
          if (_exercises.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentExerciseIndex + 1}/${_exercises.length}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: _buildContent(),
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
            Text('Đang tải bài tập...'),
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
              onPressed: _loadExercises,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_exercises.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có bài tập nào',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Progress bar
        _buildProgressBar(),
        
        // Exercise content
        Expanded(
          child: _buildExercise(),
        ),
        
        // Action buttons
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildProgressBar() {
    final theme = Theme.of(context);
    final Color topicColor = widget.topicData['color'] as Color? ?? theme.colorScheme.primary;
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tiến độ',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Điểm: $_score/${_exercises.length}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: topicColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentExerciseIndex + 1) / _exercises.length,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(topicColor),
          ),
        ],
      ),
    );
  }

  Widget _buildExercise() {
    final exercise = _exercises[_currentExerciseIndex];
    final question = exercise['question'] ?? 'Câu hỏi';
    final options = exercise['options'] as List<dynamic>? ?? [];
    final correctAnswer = exercise['correct_answer'] as int;
    final explanation = exercise['explanation'] ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child: Text(
              question,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Options
          Text(
            'Chọn đáp án:',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          
          ...options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value.toString();
            
            return _buildOptionCard(index, option, correctAnswer);
          }).toList(),
          
          // Explanation (show after answer)
          if (_showResult && explanation.isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.blue.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Giải thích:',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    explanation,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionCard(int index, String option, int correctAnswer) {
    final theme = Theme.of(context);
    final Color topicColor = widget.topicData['color'] as Color? ?? theme.colorScheme.primary;
    
    bool isSelected = _selectedAnswer == index;
    bool isCorrect = index == correctAnswer;
    bool showCorrectness = _showResult;

    Color cardColor;
    Color textColor;
    Color borderColor;

    if (showCorrectness) {
      if (isCorrect) {
        cardColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        borderColor = Colors.green.shade300;
      } else if (isSelected && !isCorrect) {
        cardColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        borderColor = Colors.red.shade300;
      } else {
        cardColor = theme.cardColor;
        textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
        borderColor = Colors.grey.shade300;
      }
    } else {
      if (isSelected) {
        cardColor = topicColor.withOpacity(0.1);
        textColor = topicColor;
        borderColor = topicColor;
      } else {
        cardColor = theme.cardColor;
        textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
        borderColor = Colors.grey.shade300;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _selectAnswer(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected || (showCorrectness && isCorrect) 
                      ? (showCorrectness && isCorrect 
                          ? Colors.green 
                          : (showCorrectness && isSelected && !isCorrect 
                              ? Colors.red 
                              : topicColor))
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected || (showCorrectness && isCorrect)
                        ? Colors.transparent
                        : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: showCorrectness
                    ? Icon(
                        isCorrect ? Icons.check : (isSelected ? Icons.close : null),
                        color: Colors.white,
                        size: 16,
                      )
                    : (isSelected 
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                        : null),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: isSelected || (showCorrectness && isCorrect)
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final theme = Theme.of(context);
    final Color topicColor = widget.topicData['color'] as Color? ?? theme.colorScheme.primary;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (!_showResult) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: _selectedAnswer != null ? _submitAnswer : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: topicColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Xác nhận',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: ElevatedButton(
                onPressed: _nextExercise,
                style: ElevatedButton.styleFrom(
                  backgroundColor: topicColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _currentExerciseIndex < _exercises.length - 1 
                      ? 'Câu tiếp theo' 
                      : 'Hoàn thành',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
