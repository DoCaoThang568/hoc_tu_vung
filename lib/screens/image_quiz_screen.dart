import 'package:flutter/material.dart';
import '../models/pronunciation_service.dart';

class ImageQuizScreen extends StatefulWidget {
  const ImageQuizScreen({super.key});

  @override
  State<ImageQuizScreen> createState() => _ImageQuizScreenState();
}

class _ImageQuizScreenState extends State<ImageQuizScreen> {
  final PronunciationService _pronunciationService = PronunciationService();
  
  // Số mạng sống
  int _lives = 5;
  
  // Số câu trả lời đúng liên tiếp
  int _streak = 0;
  
  // Trạng thái đã trả lời câu hỏi
  bool _hasAnswered = false;
  
  // Chỉ mục câu hỏi hiện tại và đáp án đúng
  int _currentQuestionIndex = 0;
  int _correctAnswerIndex = 0;
  
  // Chỉ mục đáp án đã chọn
  int? _selectedAnswerIndex;
  
  // Đánh dấu khi hoàn thành bài học
  bool _isCompleted = false;
  
  // Danh sách câu hỏi
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Đâu là "cái ly"?',
      'options': [
        {'image': 'https://cdn-icons-png.flaticon.com/512/924/924514.png', 'text': 'mug'},
        {'image': 'https://cdn-icons-png.flaticon.com/512/1046/1046857.png', 'text': 'glass'},
        {'image': 'https://cdn-icons-png.flaticon.com/512/3100/3100553.png', 'text': 'milk'},
        {'image': 'https://cdn-icons-png.flaticon.com/512/7420/7420915.png', 'text': 'coffee'}
      ],
      'correctIndex': 1, // glass
    },
    {
      'question': 'Đâu là "quả táo"?',
      'options': [
        {'image': 'https://cdn-icons-png.flaticon.com/512/415/415682.png', 'text': 'apple'},
        {'image': 'https://cdn-icons-png.flaticon.com/512/415/415733.png', 'text': 'orange'},
        {'image': 'https://cdn-icons-png.flaticon.com/512/2909/2909761.png', 'text': 'banana'},
        {'image': 'https://cdn-icons-png.flaticon.com/512/590/590774.png', 'text': 'grape'}
      ],
      'correctIndex': 0, // apple
    },
    {
      'question': 'Đâu là "con mèo"?',
      'options': [
        {'image': 'https://cdn-icons-png.flaticon.com/512/616/616408.png', 'text': 'dog'},
        {'image': 'https://cdn-icons-png.flaticon.com/512/3523/3523125.png', 'text': 'bird'},
        {'image': 'https://cdn-icons-png.flaticon.com/512/616/616430.png', 'text': 'cat'},
        {'image': 'https://cdn-icons-png.flaticon.com/512/1998/1998627.png', 'text': 'fish'}
      ],
      'correctIndex': 2, // cat
    },
    {
      'question': 'Đâu là "cái bàn"?',
      'options': [
        {'image': 'https://cdn-icons-png.flaticon.com/512/2647/2647911.png', 'text': 'chair'},
        {'image': 'https://cdn-icons-png.flaticon.com/512/2769/2769264.png', 'text': 'table'},
        {'image': 'https://cdn-icons-png.flaticon.com/512/864/864725.png', 'text': 'bed'},
        {'image': 'https://cdn-icons-png.flaticon.com/512/2291/2291120.png', 'text': 'sofa'}
      ],
      'correctIndex': 1, // table
    },
    {
      'question': 'Đâu là "quyển sách"?',
      'options': [
        {'image': 'https://cdn-icons-png.flaticon.com/512/863/863823.png', 'text': 'book'},
        {'image': 'https://cdn-icons-png.flaticon.com/512/2665/2665632.png', 'text': 'notebook'},
        {'image': 'https://cdn-icons-png.flaticon.com/512/3079/3079165.png', 'text': 'newspaper'},
        {'image': 'https://cdn-icons-png.flaticon.com/512/1420/1420074.png', 'text': 'magazine'}
      ],
      'correctIndex': 0, // book
    },
  ];

  @override
  void initState() {
    super.initState();
    _prepareQuestion();
  }
  
  // Chuẩn bị câu hỏi
  void _prepareQuestion() {
    setState(() {
      // Nếu đã hoàn thành tất cả câu hỏi, đánh dấu hoàn thành
      if (_currentQuestionIndex >= _questions.length) {
        _isCompleted = true;
        return;
      }
      
      _hasAnswered = false;
      _selectedAnswerIndex = null;
      _correctAnswerIndex = _questions[_currentQuestionIndex]['correctIndex'];
    });
  }
  
  // Xử lý khi chọn đáp án
  void _selectAnswer(int index) {
    if (_hasAnswered) return;
    
    setState(() {
      _hasAnswered = true;
      _selectedAnswerIndex = index;
      
      if (index == _correctAnswerIndex) {
        // Đáp án đúng
        _streak++;
      } else {
        // Đáp án sai
        _streak = 0;
        _lives--;
        
        // Nếu hết mạng, quay về màn hình chính
        if (_lives <= 0) {
          _showGameOver();
          return;
        }
      }
    });
  }
  
  // Chuyển câu hỏi tiếp theo
  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _prepareQuestion();
    });
  }
  
  // Hiển thị thông báo kết thúc game
  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Bạn đã hết mạng!'),
        content: const Text('Hãy thử lại nhé.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('QUAY VỀ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Khởi tạo lại game
              setState(() {
                _lives = 5;
                _streak = 0;
                _currentQuestionIndex = 0;
                _prepareQuestion();
              });
            },
            child: const Text('THỬ LẠI'),
          ),
        ],
      ),
    );
  }
  
  // Đọc từ vựng
  void _speakWord(String text) {
    _pronunciationService.pronounceWord(text);
  }

  @override
  Widget build(BuildContext context) {
    // Hiển thị màn hình hoàn thành khi đã trả lời tất cả câu hỏi
    if (_isCompleted) {
      return _buildCompletionScreen();
    }
    
    // Lấy thông tin câu hỏi hiện tại
    final currentQuestion = _questions[_currentQuestionIndex];
    final options = currentQuestion['options'];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Hình Ảnh'),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[400]!, Colors.blue[600]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Phần tiêu đề
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'cách nhanh nhất để\nhọc ngoại ngữ mới',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Thanh tiến trình
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                        child: Row(
                          children: [
                            // Thanh tiến trình
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_streak >= 3)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.yellow[100],
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '$_streak LẦN LIÊN TỤC',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.yellow[800],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  LinearProgressIndicator(
                                    value: (_currentQuestionIndex + 1) / _questions.length,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow[600]!),
                                    borderRadius: BorderRadius.circular(10),
                                    minHeight: 8,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            
                            // Số mạng còn lại
                            Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red[400],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$_lives',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Câu hỏi
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                        child: Text(
                          currentQuestion['question'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      // Các đáp án
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(
                              options.length,
                              (index) => GestureDetector(
                                onTap: () => _selectAnswer(index),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _getOptionBorderColor(index),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    color: _getOptionColor(index),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Hình ảnh
                                        Expanded(
                                          child: Container(
                                            color: Colors.white,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Image.network(
                                                  options[index]['image'],
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        
                                        // Từ vựng
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                          color: Colors.white,
                                          child: Text(
                                            options[index]['text'],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Phần dưới
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                          color: _hasAnswered ? Colors.green[100] : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Thông báo khi trả lời
                            if (_hasAnswered)
                              Row(
                                children: [
                                  Text(
                                    _selectedAnswerIndex == _correctAnswerIndex
                                        ? 'Làm tốt lắm!'
                                        : 'Đáp án đúng là: ${options[_correctAnswerIndex]['text']}',
                                    style: TextStyle(
                                      color: _selectedAnswerIndex == _correctAnswerIndex
                                          ? Colors.green[800]
                                          : Colors.red[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  ElevatedButton.icon(
                                    onPressed: () => _speakWord(options[_correctAnswerIndex]['text']),
                                    icon: const Icon(Icons.volume_up, size: 18),
                                    label: const Text(''),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue[100],
                                      foregroundColor: Colors.blue[700],
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(12),
                                      elevation: 0,
                                    ),
                                  ),
                                ],
                              ),
                              
                            // Nút tiếp tục
                            if (_hasAnswered)
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 12),
                                child: ElevatedButton(
                                  onPressed: _nextQuestion,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF58CC02),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Text(
                                    'TIẾP TỤC',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Màn hình hoàn thành
  Widget _buildCompletionScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[400]!, Colors.blue[600]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 120,
                  color: Colors.yellow[300],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Hoàn thành!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Số mạng còn lại: $_lives',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'QUAY VỀ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[600],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _lives = 5;
                      _streak = 0;
                      _currentQuestionIndex = 0;
                      _isCompleted = false;
                      _prepareQuestion();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'THỬ LẠI',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Màu viền của ô lựa chọn
  Color _getOptionBorderColor(int index) {
    if (!_hasAnswered) {
      return Colors.grey[200]!;
    }
    
    if (index == _correctAnswerIndex) {
      return const Color(0xFF58CC02);
    }
    
    if (index == _selectedAnswerIndex && index != _correctAnswerIndex) {
      return Colors.red[400]!;
    }
    
    return Colors.grey[200]!;
  }
  
  // Màu nền của ô lựa chọn
  Color _getOptionColor(int index) {
    if (!_hasAnswered) {
      return Colors.white;
    }
    
    if (index == _correctAnswerIndex) {
      return Colors.green[50]!;
    }
    
    if (index == _selectedAnswerIndex && index != _correctAnswerIndex) {
      return Colors.red[50]!;
    }
    
    return Colors.white;
  }
} 