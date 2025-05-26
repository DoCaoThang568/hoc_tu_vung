import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestion = 0;
  int _correctAnswers = 0;
  bool _isQuizCompleted = false;
  String? _selectedAnswer;
  bool _isAnswerChecked = false;
  
  // Danh sách câu hỏi mẫu
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the meaning of "Congratulations"?',
      'options': ['Chúc mừng', 'Xin lỗi', 'Cảm ơn', 'Tạm biệt'],
      'correct_answer': 'Chúc mừng',
      'topic': 'Giao tiếp cơ bản',
    },
    {
      'question': 'Which word means "Đánh giá cao"?',
      'options': ['Congratulate', 'Appreciate', 'Consider', 'Understand'],
      'correct_answer': 'Appreciate',
      'topic': 'Giao tiếp cơ bản',
    },
    {
      'question': 'Choose the correct translation for "Convenient"',
      'options': ['Thích hợp', 'Thuận tiện', 'Tốt đẹp', 'Phức tạp'],
      'correct_answer': 'Thuận tiện',
      'topic': 'Đời sống hàng ngày',
    },
    {
      'question': 'What is the meaning of "Enthusiasm"?',
      'options': ['Sự quan tâm', 'Sự tự tin', 'Sự hăng hái', 'Sự đam mê'],
      'correct_answer': 'Sự hăng hái',
      'topic': 'Công việc',
    },
    {
      'question': 'Choose the correct meaning of "Profound"',
      'options': ['Dễ dàng', 'Thường xuyên', 'Sâu sắc', 'Chính xác'],
      'correct_answer': 'Sâu sắc',
      'topic': 'Học thuật',
    },
    {
      'question': 'What is the meaning of "Delicious"?',
      'options': ['Ngon', 'Tươi', 'Mặn', 'Cay'],
      'correct_answer': 'Ngon',
      'topic': 'Ẩm thực',
    },
    {
      'question': 'Which word means "Kỳ nghỉ"?',
      'options': ['Holiday', 'Weekend', 'Birthday', 'Party'],
      'correct_answer': 'Holiday',
      'topic': 'Du lịch',
    },
    {
      'question': 'What does "Innovative" mean in Vietnamese?',
      'options': ['Đổi mới', 'Hiện đại', 'Cải tiến', 'Sáng tạo'],
      'correct_answer': 'Sáng tạo',
      'topic': 'Công nghệ',
    },
    {
      'question': 'Choose the correct translation for "Patient"',
      'options': ['Kiên nhẫn', 'Thông minh', 'Mạnh mẽ', 'Tự tin'],
      'correct_answer': 'Kiên nhẫn',
      'topic': 'Tính cách',
    },
    {
      'question': 'What is the Vietnamese word for "Computer"?',
      'options': ['Máy tính', 'Điện thoại', 'Máy ảnh', 'Máy in'],
      'correct_answer': 'Máy tính',
      'topic': 'Công nghệ',
    },
    {
      'question': 'Which word means "Bầu trời"?',
      'options': ['Sky', 'Cloud', 'Sun', 'Star'],
      'correct_answer': 'Sky',
      'topic': 'Thiên nhiên',
    },
    {
      'question': 'Choose the correct meaning of "Adventure"',
      'options': ['Phiêu lưu', 'Thử thách', 'Khám phá', 'Khó khăn'],
      'correct_answer': 'Phiêu lưu',
      'topic': 'Du lịch',
    },
    {
      'question': 'What is the meaning of "Beautiful"?',
      'options': ['Xinh đẹp', 'Dễ thương', 'Lịch sự', 'Thông minh'],
      'correct_answer': 'Xinh đẹp',
      'topic': 'Tính cách',
    },
    {
      'question': 'Which word means "Giúp đỡ"?',
      'options': ['Help', 'Support', 'Assist', 'Aid'],
      'correct_answer': 'Help',
      'topic': 'Giao tiếp cơ bản',
    },
    {
      'question': 'What does "Confident" mean in Vietnamese?',
      'options': ['Tự tin', 'Mạnh mẽ', 'Thông minh', 'Can đảm'],
      'correct_answer': 'Tự tin',
      'topic': 'Tính cách',
    },
  ];

  // Theo dõi câu trả lời sai
  final List<Map<String, dynamic>> _wrongAnswers = [];

  void _checkAnswer() {
    if (_selectedAnswer == null) return;
    
    setState(() {
      _isAnswerChecked = true;
      if (_selectedAnswer == _questions[_currentQuestion]['correct_answer']) {
        _correctAnswers++;
      } else {
        // Thêm câu hỏi sai vào danh sách
        _wrongAnswers.add({
          'question': _questions[_currentQuestion]['question'],
          'user_answer': _selectedAnswer,
          'correct_answer': _questions[_currentQuestion]['correct_answer'],
        });
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedAnswer = null;
        _isAnswerChecked = false;
      });
    } else {
      setState(() {
        _isQuizCompleted = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestion = 0;
      _correctAnswers = 0;
      _isQuizCompleted = false;
      _selectedAnswer = null;
      _isAnswerChecked = false;
      _wrongAnswers.clear(); // Xóa danh sách câu trả lời sai
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiểm tra từ vựng'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: _isQuizCompleted
            ? _buildResultScreen()
            : _buildQuizScreen(),
      ),
    );
  }

  Widget _buildQuizScreen() {
    final currentQ = _questions[_currentQuestion];
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiến độ
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: (_currentQuestion + 1) / _questions.length,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
                borderRadius: BorderRadius.circular(4),
                minHeight: 6,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Câu hỏi ${_currentQuestion + 1}/${_questions.length}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Đúng: $_correctAnswers',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Câu hỏi
          Card(
            elevation: 2,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentQ['question'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      currentQ['topic'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Danh sách đáp án
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: (currentQ['options'] as List).length,
              itemBuilder: (context, index) {
                final option = (currentQ['options'] as List)[index];
                final bool isSelected = _selectedAnswer == option;
                final bool isCorrect = option == currentQ['correct_answer'];
                
                // Xác định màu sắc cho đáp án
                Color? cardColor;
                if (_isAnswerChecked) {
                  if (isCorrect) {
                    cardColor = Colors.green[100];
                  } else if (isSelected && !isCorrect) {
                    cardColor = Colors.red[100];
                  }
                } else if (isSelected) {
                  cardColor = Theme.of(context).colorScheme.primary.withOpacity(0.1);
                }
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    margin: EdgeInsets.zero,
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: InkWell(
                      onTap: _isAnswerChecked ? null : () {
                        setState(() {
                          _selectedAnswer = option;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Số thứ tự đáp án
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index), // A, B, C, D
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            
                            // Nội dung đáp án
                            Expanded(
                              child: Text(
                                option,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            
                            // Icon kiểm tra đáp án
                            if (_isAnswerChecked && (isCorrect || isSelected))
                              Icon(
                                isCorrect ? Icons.check_circle : Icons.cancel,
                                color: isCorrect ? Colors.green : Colors.red,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Nút kiểm tra và tiếp theo
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: SizedBox(
              width: double.infinity,
              child: !_isAnswerChecked
                ? ElevatedButton(
                    onPressed: _selectedAnswer == null ? null : _checkAnswer,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.blue,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Kiểm tra',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _currentQuestion < _questions.length - 1
                          ? 'Câu tiếp theo'
                          : 'Xem kết quả',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    final score = (_correctAnswers / _questions.length * 100).toInt();
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Kết quả Quiz',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: CircularProgressIndicator(
                            value: score / 100,
                            strokeWidth: 12,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getScoreColor(score),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '$score%',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$_correctAnswers/${_questions.length} đúng',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    Text(
                      _getScoreMessage(score),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Hiển thị câu trả lời sai
            if (_wrongAnswers.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Các câu trả lời sai (${_wrongAnswers.length}):',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  ListView.builder(
                    itemCount: _wrongAnswers.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final wrongAnswer = _wrongAnswers[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Hiển thị câu hỏi - đảm bảo không bị tràn
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  wrongAnswer['question'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              // Phần nội dung câu trả lời
                              Column(
                                children: [
                                  // Đáp án của người dùng
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 8, top: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Đáp án của bạn:',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                wrongAnswer['user_answer'],
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Đáp án đúng
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(top: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Đáp án đúng:',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                wrongAnswer['correct_answer'],
                                                style: const TextStyle(
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            
            // Hiển thị thống kê theo chủ đề
            const SizedBox(height: 24),
            _buildTopicStats(),
            
            const SizedBox(height: 24),
            
            // Nút làm lại quiz
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _restartQuiz,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text(
                  'Làm lại Quiz',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getScoreMessage(int score) {
    if (score >= 80) return 'Xuất sắc! Bạn đã nắm vững từ vựng.';
    if (score >= 60) return 'Tốt! Tiếp tục cố gắng nhé.';
    if (score >= 40) return 'Cần cố gắng hơn nữa!';
    return 'Hãy ôn tập lại từ vựng nhé!';
  }

  // Tính thống kê theo chủ đề
  Map<String, Map<String, int>> _getTopicStats() {
    Map<String, Map<String, int>> stats = {};
    
    // Khởi tạo thống kê cho mỗi chủ đề
    for (var question in _questions) {
      final topic = question['topic'];
      if (!stats.containsKey(topic)) {
        stats[topic] = {'total': 0, 'correct': 0};
      }
      stats[topic]!['total'] = (stats[topic]!['total'] ?? 0) + 1;
    }
    
    // Tính số câu đúng cho mỗi chủ đề
    for (int i = 0; i < _questions.length; i++) {
      final question = _questions[i];
      final topic = question['topic'];
      
      if (_wrongAnswers.any((wrong) => wrong['question'] == question['question'])) {
        // Câu hỏi nằm trong danh sách sai
        continue;
      } else {
        // Nếu không nằm trong danh sách sai, tức là đúng
        stats[topic]!['correct'] = (stats[topic]!['correct'] ?? 0) + 1;
      }
    }
    
    return stats;
  }

  Widget _buildTopicStats() {
    final stats = _getTopicStats();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            'Hiệu suất theo chủ đề',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...stats.entries.map((entry) {
          final topic = entry.key;
          final correct = entry.value['correct'] ?? 0;
          final total = entry.value['total'] ?? 0;
          final percentage = (correct / total * 100).round();
          
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _getTopicColor(percentage).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    topic,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getTopicColor(percentage),
                    ),
                  ),
                ),
                Text(
                  '$correct/$total ($percentage%)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getTopicColor(percentage),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
  
  Color _getTopicColor(int percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }
} 