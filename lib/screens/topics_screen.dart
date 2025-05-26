import 'package:flutter/material.dart';
import 'flashcard_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  // Danh sách chủ đề mẫu
  final List<Map<String, dynamic>> _topics = [
    {
      'name': 'Giao tiếp cơ bản',
      'english_name': 'Basic Communication',
      'icon': Icons.chat_bubble_outline,
      'color': Colors.blue,
      'word_count': 50,
      'progress': 0.65,
    },
    {
      'name': 'Du lịch',
      'english_name': 'Travel',
      'icon': Icons.flight,
      'color': Colors.green,
      'word_count': 40,
      'progress': 0.3,
    },
    {
      'name': 'Công nghệ',
      'english_name': 'Technology',
      'icon': Icons.computer,
      'color': Colors.orange,
      'word_count': 35,
      'progress': 0.1,
    },
    {
      'name': 'Kinh doanh',
      'english_name': 'Business',
      'icon': Icons.business_center,
      'color': Colors.purple,
      'word_count': 45,
      'progress': 0.5,
    },
    {
      'name': 'Thức ăn & Đồ uống',
      'english_name': 'Food & Drinks',
      'icon': Icons.restaurant_menu,
      'color': Colors.red,
      'word_count': 30,
      'progress': 0.8,
    },
    {
      'name': 'Giáo dục',
      'english_name': 'Education',
      'icon': Icons.school,
      'color': Colors.indigo,
      'word_count': 25,
      'progress': 0.4,
    },
    {
      'name': 'Y tế & Sức khỏe',
      'english_name': 'Health & Medical',
      'icon': Icons.medical_services,
      'color': Colors.teal,
      'word_count': 35,
      'progress': 0.2,
    },
    {
      'name': 'Thể thao',
      'english_name': 'Sports',
      'icon': Icons.sports_basketball,
      'color': Colors.amber,
      'word_count': 30,
      'progress': 0.15,
    },
  ];

  // Danh sách chủ đề đã được lọc theo tìm kiếm
  List<Map<String, dynamic>> _filteredTopics = [];
  
  // Controller cho tìm kiếm
  final TextEditingController _searchController = TextEditingController();
  
  // Controller cho các trường nhập liệu
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _englishNameController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Khởi tạo danh sách lọc ban đầu là toàn bộ danh sách chủ đề
    _filteredTopics = List.from(_topics);
    
    // Lắng nghe sự thay đổi của ô tìm kiếm
    _searchController.addListener(_filterTopics);
  }
  
  // Hàm lọc chủ đề dựa trên từ khóa tìm kiếm
  void _filterTopics() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      if (query.isEmpty) {
        // Nếu không có từ khóa, hiển thị tất cả chủ đề
        _filteredTopics = List.from(_topics);
      } else {
        // Lọc chủ đề theo tên tiếng Việt hoặc tiếng Anh
        _filteredTopics = _topics.where((topic) {
          final name = topic['name'].toString().toLowerCase();
          final englishName = topic['english_name'].toString().toLowerCase();
          return name.contains(query) || englishName.contains(query);
        }).toList();
      }
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _englishNameController.dispose();
    super.dispose();
  }

  // Hiển thị dialog thêm chủ đề mới
  void _showAddTopicDialog() {
    // Reset các controller
    _nameController.text = '';
    _englishNameController.text = '';
    
    // Màu sắc và biểu tượng mặc định
    Color selectedColor = Colors.blue;
    IconData selectedIcon = Icons.chat_bubble_outline;
   
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Thêm chủ đề mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trường nhập tên tiếng Việt
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên chủ đề (Tiếng Việt)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Trường nhập tên tiếng Anh
                TextField(
                  controller: _englishNameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên chủ đề (Tiếng Anh)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                // Thêm chủ đề mới vào danh sách
                if (_nameController.text.isNotEmpty && _englishNameController.text.isNotEmpty) {
                  setState(() {
                    _topics.add({
                      'name': _nameController.text,
                      'english_name': _englishNameController.text,
                      'icon': selectedIcon,
                      'color': selectedColor,
                      'word_count': 0, // Bắt đầu với 0 từ
                      'progress': 0.0, // Tiến độ 0%
                    });
                  });
                  
                  // Hiển thị thông báo thành công
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã thêm chủ đề mới thành công')),
                  );
                  
                  Navigator.pop(dialogContext);
                } else {
                  // Hiển thị thông báo lỗi nếu chưa nhập đủ thông tin
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
                  );
                }
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Xử lý điều hướng quay lại
        Navigator.of(context).pop();
        return false; // Ngăn popScope mặc định và để Navigator.pop kiểm soát quay lại
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          title: Text(
            'Các chủ đề từ vựng',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
        floatingActionButton: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: _showAddTopicDialog,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            heroTag: 'addTopicBtn',
            tooltip: 'Thêm chủ đề từ vựng mới',
            child: const Icon(
              Icons.add,
              size: 28,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần hướng dẫn và tìm kiếm
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chọn một chủ đề để bắt đầu học từ vựng',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Ô tìm kiếm nâng cao
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: _searchController.text.isEmpty 
                            ? Colors.grey.withOpacity(0.15)
                            : Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm chủ đề...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.withOpacity(0.7),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: _searchController.text.isEmpty
                              ? Colors.grey
                              : Theme.of(context).colorScheme.primary,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? AnimatedOpacity(
                                opacity: 1.0,
                                duration: const Duration(milliseconds: 300),
                                child: IconButton(
                                  icon: const Icon(Icons.close_rounded, size: 18),
                                  color: Colors.grey,
                                  splashRadius: 20,
                                  onPressed: () {
                                    _searchController.clear();
                                    // Ẩn bàn phím sau khi xóa
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        filled: false,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                      onSubmitted: (_) => FocusScope.of(context).unfocus(),
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                ],
              ),
            ),
            
            // Danh sách chủ đề
            Expanded(
              child: _filteredTopics.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Không tìm thấy chủ đề nào',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Thử tìm kiếm với từ khóa khác',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: _filteredTopics.length,
                      itemBuilder: (context, index) {
                        final topic = _filteredTopics[index];
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              // Chuyển đến màn hình flashcard với chủ đề được chọn
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FlashcardScreen(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    spreadRadius: 0,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        // Icon chủ đề
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: topic['color'].withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            topic['icon'],
                                            color: topic['color'],
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                topic['name'],
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                topic['english_name'],
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Badge số từ vựng
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '${topic['word_count']} từ',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    // Thanh tiến độ
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Tiến độ: ${(topic['progress'] * 100).toInt()}%',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              '${(topic['progress'] * topic['word_count']).toInt()}/${topic['word_count']} từ',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        LinearProgressIndicator(
                                          value: topic['progress'],
                                          backgroundColor: Colors.grey[200],
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            topic['color'],
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                          minHeight: 8,
                                        ),
                                      ],
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
          ],
        ),
      ),
    );
  }
} 