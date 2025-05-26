import 'package:flutter/material.dart';
import '../models/pronunciation_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FlashcardScreen extends StatefulWidget {
  final String? selectedTopic;

  const FlashcardScreen({super.key, this.selectedTopic});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  final PronunciationService _pronunciationService = PronunciationService();
  
  bool _showMeaning = false;
  late String _selectedTopic;
  
  // Danh sách chủ đề
  final List<String> _topics = [
    'Tất cả',
    'Giao tiếp cơ bản',
    'Du lịch',
    'Công nghệ', 
    'Kinh doanh',
    'Thức ăn & Đồ uống',
  ];
  
  // Danh sách từ vựng mẫu
  final List<Map<String, dynamic>> _allFlashcards = [
    {
      'word': 'Congratulations',
      'phonetic': '/kənˌɡrætʃəˈleɪʃənz/',
      'meaning': 'Chúc mừng',
      'example': 'Congratulations on your new job!',
      'example_meaning': 'Chúc mừng công việc mới của bạn!',
      'image': 'https://img.freepik.com/free-vector/people-celebrating-concept-illustration_114360-1875.jpg',
      'topic': 'Giao tiếp cơ bản',
    },
    {
      'word': 'Appreciate',
      'phonetic': '/əˈpriːʃieɪt/',
      'meaning': 'Đánh giá cao',
      'example': 'I really appreciate your help.',
      'example_meaning': 'Tôi thực sự đánh giá cao sự giúp đỡ của bạn.',
      'image': 'https://img.freepik.com/free-vector/tiny-hr-manager-employer-hiring-rating-candidates-job-interview_74855-19924.jpg',
      'topic': 'Giao tiếp cơ bản',
    },
    {
      'word': 'Convenient',
      'phonetic': '/kənˈviːniənt/',
      'meaning': 'Thuận tiện',
      'example': 'Is this time convenient for you?',
      'example_meaning': 'Thời gian này có thuận tiện cho bạn không?',
      'image': 'https://img.freepik.com/free-vector/people-using-online-apps-set_52683-8076.jpg',
      'topic': 'Giao tiếp cơ bản',
    },
    {
      'word': 'Enthusiasm',
      'phonetic': '/ɪnˈθjuːziæzəm/',
      'meaning': 'Sự nhiệt tình',
      'example': 'She shows great enthusiasm for her work.',
      'example_meaning': 'Cô ấy thể hiện sự nhiệt tình cao đối với công việc của mình.',
      'image': 'https://img.freepik.com/free-vector/business-team-putting-together-jigsaw-puzzle-isolated-flat-vector-illustration-cartoon-partners-working-connection-teamwork-partnership-cooperation-concept_74855-9814.jpg',
      'topic': 'Kinh doanh',
    },
    {
      'word': 'Profound',
      'phonetic': '/prəˈfaʊnd/',
      'meaning': 'Sâu sắc',
      'example': 'The book had a profound effect on me.',
      'example_meaning': 'Cuốn sách đã có tác động sâu sắc đến tôi.',
      'image': 'https://img.freepik.com/free-vector/reading-concept-illustration_114360-1868.jpg',
      'topic': 'Kinh doanh',
    },
    {
      'word': 'Destination',
      'phonetic': '/ˌdestəˈneɪʃən/',
      'meaning': 'Điểm đến',
      'example': 'This island is a popular tourist destination.',
      'example_meaning': 'Hòn đảo này là một điểm đến du lịch phổ biến.',
      'image': 'https://img.freepik.com/free-vector/travel-landing-page-with-photo_52683-28452.jpg',
      'topic': 'Du lịch',
    },
    {
      'word': 'Accommodation',
      'phonetic': '/əˌkɒməˈdeɪʃən/',
      'meaning': 'Chỗ ở',
      'example': 'We need to book accommodation for our trip.',
      'example_meaning': 'Chúng ta cần đặt chỗ ở cho chuyến đi của mình.',
      'image': 'https://img.freepik.com/free-vector/booking-app-concept_52683-43102.jpg',
      'topic': 'Du lịch',
    },
  ];
  
  List<Map<String, dynamic>> _filteredFlashcards = [];
  int _currentIndex = 0;
  bool _isAddingNewWord = false;
  
  // Controllers cho form thêm từ mới
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _phoneticController = TextEditingController();
  final TextEditingController _meaningController = TextEditingController();
  final TextEditingController _exampleController = TextEditingController();
  final TextEditingController _exampleMeaningController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String _newWordTopic = 'Giao tiếp cơ bản';

  @override
  void initState() {
    super.initState();
    
    // Khởi tạo chủ đề từ tham số nếu có
    _selectedTopic = widget.selectedTopic ?? 'Tất cả';
    
    // Khởi tạo animation lật thẻ
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showMeaning = !_showMeaning;
        });
        _flipController.reverse();
      }
    });
    
    // Lọc từ vựng ban đầu
    _filterFlashcards();
    
    // Cấu hình TTS
    _initTts();
  }
  
  // Khởi tạo Text-to-Speech
  void _initTts() async {
    await _pronunciationService.setTtsLanguage("en-US");
    await _pronunciationService.setTtsSpeechRate(0.5); // Tốc độ đọc vừa phải
    await _pronunciationService.setTtsVolume(1.0);
    await _pronunciationService.setTtsPitch(1.0);
  }
  
  // Đọc từ vựng
  Future<void> _speakWord(String word) async {
    await _pronunciationService.pronounceWord(word);
  }
  
  // Hàm lọc từ vựng theo chủ đề
  void _filterFlashcards() {
    setState(() {
      if (_selectedTopic == 'Tất cả') {
        _filteredFlashcards = List.from(_allFlashcards);
      } else {
        _filteredFlashcards = _allFlashcards
          .where((card) => card['topic'] == _selectedTopic)
          .toList();
      }
      
      // Đặt lại index
      _currentIndex = _filteredFlashcards.isNotEmpty ? 0 : -1;
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    _pronunciationService.dispose();
    _wordController.dispose();
    _phoneticController.dispose();
    _meaningController.dispose();
    _exampleController.dispose();
    _exampleMeaningController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
  
  // Các hàm điều khiển flashcard
  void _flipCard() {
    if (_flipController.isAnimating) return;
    _flipController.forward();
  }

  void _nextCard() {
    if (_filteredFlashcards.isEmpty) return;
    
    setState(() {
      _showMeaning = false;
      _currentIndex = (_currentIndex + 1) % _filteredFlashcards.length;
    });
  }
  
  void _previousCard() {
    if (_filteredFlashcards.isEmpty) return;
    
    setState(() {
      _showMeaning = false;
      _currentIndex = (_currentIndex - 1 + _filteredFlashcards.length) % _filteredFlashcards.length;
    });
  }
  
  void _toggleAddNewWord() {
    setState(() {
      _isAddingNewWord = !_isAddingNewWord;
      
      // Clear form khi mở
      if (_isAddingNewWord) {
        _wordController.clear();
        _phoneticController.clear();
        _meaningController.clear();
        _exampleController.clear();
        _exampleMeaningController.clear();
        _imageUrlController.clear();
        _newWordTopic = 'Giao tiếp cơ bản';
      }
    });
  }
  
  void _addNewWord() {
    // Kiểm tra field bắt buộc
    if (_wordController.text.trim().isEmpty || 
        _meaningController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Từ vựng và nghĩa không được để trống')),
      );
      return;
    }
    
    // Tạo từ mới và thêm vào danh sách
    final newWord = {
      'word': _wordController.text.trim(),
      'phonetic': _phoneticController.text.trim(),
      'meaning': _meaningController.text.trim(),
      'example': _exampleController.text.trim(),
      'example_meaning': _exampleMeaningController.text.trim(),
      'image': _imageUrlController.text.trim(),
      'topic': _newWordTopic,
    };
    
    setState(() {
      // Thêm từ vào danh sách
      _allFlashcards.add(newWord);
      
      // Nếu chủ đề đang chọn phù hợp với từ mới, thêm vào danh sách đã lọc
      if (_selectedTopic == 'Tất cả' || _selectedTopic == _newWordTopic) {
        _filteredFlashcards.add(newWord);
      }
      
      // Đóng form
      _isAddingNewWord = false;
      
      // Hiển thị thông báo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã thêm từ vựng mới thành công')),
      );
    });
  }

  // Build màn hình chính
  @override
  Widget build(BuildContext context) {
    // Khi đang thêm từ mới
    if (_isAddingNewWord) {
      return _buildAddNewWordForm();
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Học thẻ từ vựng'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần chọn chủ đề
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chọn chủ đề:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Hiển thị danh sách chủ đề
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _topics.length,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedTopic == _topics[index];
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedTopic = _topics[index];
                              });
                              _filterFlashcards();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[200],
                              foregroundColor: isSelected ? Colors.white : Colors.black87,
                              elevation: isSelected ? 2 : 0,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              minimumSize: Size.zero,
                            ),
                            child: Text(
                              _topics[index],
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  Text(
                    'Số từ vựng trong chủ đề "$_selectedTopic": ${_filteredFlashcards.length}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  // Tiến độ
                  if (_filteredFlashcards.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tiến độ: ${_currentIndex + 1}/${_filteredFlashcards.length}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.refresh, size: 18),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () => _filterFlashcards(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: (_currentIndex + 1) / _filteredFlashcards.length,
                              minHeight: 5,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            
            // Hiển thị khi không có từ vựng
            if (_filteredFlashcards.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.book_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Không có từ vựng nào trong chủ đề này',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          'Hãy chọn chủ đề khác hoặc thêm từ vựng mới',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton.icon(
                          onPressed: _toggleAddNewWord,
                          icon: const Icon(Icons.add),
                          label: const Text('Thêm từ vựng mới'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Quay lại'),
                      ),
                    ],
                  ),
                ),
              ),
              
            // Hiển thị flashcard
            if (_filteredFlashcards.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Flashcard - sử dụng animation cơ bản
                      Expanded(
                        child: GestureDetector(
                          onTap: _flipCard,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: _showMeaning 
                                ? _buildCardBack() 
                                : _buildCardFront(),
                          ),
                        ),
                      ),
                      
                      // Điều khiển
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Nút trước
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: _previousCard,
                                    child: const Icon(Icons.arrow_back, size: 20),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              
                              // Lật thẻ
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _flipCard,
                                  icon: const Icon(Icons.flip, size: 18),
                                  label: const Text('Lật thẻ'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              
                              // Quiz
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/quiz');
                                  },
                                  icon: const Icon(Icons.quiz, size: 18),
                                  label: const Text('Quiz'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              
                              // Nút tiếp
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: _nextCard,
                                    child: const Icon(Icons.arrow_forward, size: 20),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleAddNewWord,
        tooltip: 'Thêm từ mới',
        child: const Icon(Icons.add),
      ),
    );
  }
  
  // Widget hiển thị mặt trước của thẻ flashcard
  Widget _buildCardFront() {
    if (_filteredFlashcards.isEmpty) return Container();
    
    final card = _filteredFlashcards[_currentIndex];
    
    return Card(
      elevation: 5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.blue.shade500, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Hình ảnh nền (nếu có)
              if (card['image'] != null && card['image'].toString().isNotEmpty)
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.25,
                    child: CachedNetworkImage(
                      imageUrl: card['image'],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.blue.shade500),
                      errorWidget: (context, url, error) => Container(color: Colors.blue.shade500),
                      memCacheHeight: 400,
                    ),
                  ),
                ),
                
              // Nội dung
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Icon biên dịch ở phía trên
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          "文\nA",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    
                    // Từ vựng và nút phát âm
                    Expanded(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                card['word'],
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // Nút phát âm
                            IconButton(
                              onPressed: () => _speakWord(card['word']),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              iconSize: 32,
                              icon: Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.volume_up,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Phiên âm
                    if (card['phonetic'] != null && card['phonetic'].toString().isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          card['phonetic'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    
                    // Hướng dẫn
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.6), Colors.black.withOpacity(0.4)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.touch_app,
                            size: 16,
                            color: Colors.yellow,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Chạm để xem nghĩa',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Widget hiển thị mặt sau của thẻ flashcard
  Widget _buildCardBack() {
    if (_filteredFlashcards.isEmpty) return Container();
    
    final card = _filteredFlashcards[_currentIndex];
    
    return Card(
      elevation: 5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.teal.shade500, Colors.teal.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Hình ảnh nền (nếu có)
              if (card['image'] != null && card['image'].toString().isNotEmpty)
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.25,
                    child: CachedNetworkImage(
                      imageUrl: card['image'],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.teal.shade500),
                      errorWidget: (context, url, error) => Container(color: Colors.teal.shade500),
                      memCacheHeight: 400,
                    ),
                  ),
                ),
                
              // Nội dung
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: [
                    // Nghĩa từ vựng
                    Expanded(
                      child: Center(
                        child: Text(
                          card['meaning'],
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    
                    // Ví dụ
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Text(
                              'Ví dụ:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Box ví dụ
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        card['example'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    // Nút phát âm cho ví dụ
                                    if (card['example'] != null && card['example'].toString().isNotEmpty)
                                      InkWell(
                                        onTap: () => _speakWord(card['example']),
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.volume_up,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const Divider(color: Colors.white24, height: 16),
                                Text(
                                  card['example_meaning'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Chạm để quay lại
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.7), Colors.black.withOpacity(0.5)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.touch_app,
                            size: 18,
                            color: Colors.yellow,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Chạm để quay lại',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Form thêm từ mới
  Widget _buildAddNewWordForm() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm từ vựng mới'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _toggleAddNewWord,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Từ vựng
            const Text(
              'Từ vựng *',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _wordController,
              decoration: const InputDecoration(
                hintText: 'Nhập từ vựng (Tiếng Anh)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Phiên âm
            const Text(
              'Phiên âm',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneticController,
              decoration: const InputDecoration(
                hintText: 'Nhập phiên âm (VD: /hello/)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Nghĩa
            const Text(
              'Nghĩa *',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _meaningController,
              decoration: const InputDecoration(
                hintText: 'Nhập nghĩa (Tiếng Việt)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Chủ đề
            const Text(
              'Chủ đề',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _newWordTopic,
              isExpanded: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: _topics.where((topic) => topic != 'Tất cả').map((topic) {
                return DropdownMenuItem<String>(
                  value: topic,
                  child: Text(topic),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _newWordTopic = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            
            // Ví dụ
            const Text(
              'Ví dụ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _exampleController,
              decoration: const InputDecoration(
                hintText: 'Nhập câu ví dụ (Tiếng Anh)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            
            // Nghĩa của ví dụ
            const Text(
              'Nghĩa của ví dụ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _exampleMeaningController,
              decoration: const InputDecoration(
                hintText: 'Nhập nghĩa của câu ví dụ (Tiếng Việt)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addNewWord,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Thêm từ vựng',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 