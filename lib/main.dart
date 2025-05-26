import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/topics_screen.dart';
import 'screens/flashcard_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/image_quiz_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/learning_methods_screen.dart'; // Thêm import này

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Tối ưu hóa hiệu suất
  if (!kDebugMode) {
    // Không hiển thị lỗi không cần thiết trong mode release
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };
  }
  
  // Thiết lập định hướng màn hình
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Thiết lập style cho status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Tối ưu hiệu suất hình ảnh
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 100; // 100 MB
  
  // Tối ưu hóa hiển thị text
  if (kIsWeb || defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS) {
    // TextPainter.enableFontFallback = true; // Không được hỗ trợ trong phiên bản Flutter hiện tại
  }
  
  runApp(const UngDungHocTuVung());
}

class UngDungHocTuVung extends StatelessWidget {
  const UngDungHocTuVung({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Học Từ vựng Tiếng Anh',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4E6AF3),
          primary: const Color(0xFF4E6AF3),
          secondary: const Color(0xFF26C6DA),
          tertiary: const Color(0xFFFF7043),
          error: const Color(0xFFE53935),
          onPrimary: Colors.white,
          background: Colors.white,
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF4E6AF3),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          shadowColor: Colors.black38,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4E6AF3),
            letterSpacing: -0.5,
          ),
          displayMedium: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4E6AF3),
            letterSpacing: -0.3,
          ),
          displaySmall: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4E6AF3),
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4E6AF3),
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.black87,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.black87,
          ),
          labelLarge: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.grey.shade300;
                }
                return const Color(0xFF4E6AF3);
              },
            ),
            foregroundColor: WidgetStateProperty.all(Colors.white),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            elevation: WidgetStateProperty.all(0),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            overlayColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.white.withOpacity(0.2);
                }
                return Colors.transparent;
              },
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(const Color(0xFF4E6AF3)),
            textStyle: WidgetStateProperty.all(
              GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            overlayColor: WidgetStateProperty.all(
              const Color(0xFF4E6AF3).withOpacity(0.1),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(const Color(0xFF4E6AF3)),
            side: WidgetStateProperty.all(
              const BorderSide(color: Color(0xFF4E6AF3), width: 1.5),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4E6AF3), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
          ),
          hintStyle: GoogleFonts.inter(
            color: Colors.grey.shade500,
            fontSize: 14,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: Colors.black12,
          clipBehavior: Clip.antiAlias,
        ),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: const Color(0xFF4E6AF3).withOpacity(0.15),
          labelTextStyle: WidgetStateProperty.all(
            GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          iconTheme: WidgetStateProperty.all(
            const IconThemeData(size: 22),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.grey.shade100,
          labelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: const Color(0xFF4E6AF3),
          thumbColor: Colors.white,
          overlayColor: const Color(0xFF4E6AF3).withOpacity(0.2),
          valueIndicatorColor: const Color(0xFF4E6AF3),
          valueIndicatorTextStyle: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          ),
        dividerTheme: const DividerThemeData(
          thickness: 1,
          color: Color(0xFFEEEEEE),
        ),
        // Hiệu ứng splash và highlight
        splashColor: const Color(0xFF4E6AF3).withOpacity(0.15),
        highlightColor: const Color(0xFF4E6AF3).withOpacity(0.1),
        scaffoldBackgroundColor: const Color(0xFFF8F9FD),
      ),
      initialRoute: AuthScreen.routeName, // Đặt AuthScreen làm màn hình đầu tiên
      routes: {
        AuthScreen.routeName: (context) => const AuthScreen(),
        LearningMethodsScreen.routeName: (context) => LearningMethodsScreen(topicData: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>), // Thêm route này
        '/flashcard': (context) => const FlashcardScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/image_quiz': (context) => const ImageQuizScreen(),
        '/history': (context) => const HistoryScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/statistics': (context) => const HistoryScreen(),
        '/vocabulary_list': (context) => const FlashcardScreen(),
        '/learning_modes': (context) => const TopicsScreen(),
        '/topics': (context) => const TopicsScreen(),
      },
    );
  }
}

class ManHinhChinh extends StatefulWidget {
  const ManHinhChinh({super.key});

  static const String routeName = '/home'; // Thêm routeName cho ManHinhChinh

  @override
  State<ManHinhChinh> createState() => _ManHinhChinhState();
}

class _ManHinhChinhState extends State<ManHinhChinh> with SingleTickerProviderStateMixin {
  int _chiSoManHinh = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Widget> _cacManHinh = [
    const HomeScreen(),
    const TopicsScreen(),
    const FlashcardScreen(),
    const QuizScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  final List<String> _tieuDe = [
    'Trang chủ',
    'Chủ đề',
    'Flashcard',
    'Quiz',
    'Lịch sử',
    'Cài đặt',
  ];

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController, 
        curve: Curves.easeInOut,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Hiển thị dialog thêm chủ đề mới
  void _showAddTopicDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController englishNameController = TextEditingController();
    
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
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên chủ đề (Tiếng Việt)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Trường nhập tên tiếng Anh
                TextField(
                  controller: englishNameController,
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
                if (nameController.text.isNotEmpty && englishNameController.text.isNotEmpty) {
                  // Để thêm chủ đề mới, cần cập nhật TopicsScreen và các dữ liệu trong ứng dụng
                  // Trong thực tế, cần có một provider hoặc state management
                  
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
        // Xử lý nút back của hệ thống
        if (_chiSoManHinh != 0) {
          setState(() {
            _chiSoManHinh = 0; // Quay về trang chủ khi nhấn back
          });
          return false; // Ngăn không cho thoát app
        }
        return true; // Cho phép thoát app nếu đang ở trang chủ
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_tieuDe[_chiSoManHinh]),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                // Hiển thị thông báo
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Không có thông báo mới'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: _cacManHinh[_chiSoManHinh],
        ),
        // Hiển thị FAB khi đang ở tab Chủ đề
        floatingActionButton: _chiSoManHinh == 1 
          ? FloatingActionButton(
              onPressed: _showAddTopicDialog,
              tooltip: 'Thêm chủ đề mới',
              child: const Icon(Icons.add),
            )
          : null,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
            color: Colors.white,
          ),
          child: NavigationBar(
            selectedIndex: _chiSoManHinh,
            onDestinationSelected: (index) {
              if (index != _chiSoManHinh) {
                // Xử lý các trường hợp đặc biệt cần mở màn hình mới
                if (index == 1) { // Chủ đề (Topics)
                  // Sử dụng MaterialPageRoute thay vì pushNamed để đảm bảo hoạt động tốt hơn
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TopicsScreen()),
                  ).then((_) {
                    setState(() {
                      _chiSoManHinh = 0; // Quay lại Home sau khi đóng
                    });
                  });
                  return;
                } else if (index == 2) { // Flashcard
                  Navigator.pushNamed(context, '/flashcard').then((_) {
                    setState(() {
                      _chiSoManHinh = 0; // Quay lại Home sau khi đóng
                    });
                  });
                  return;
                } else if (index == 3) { // Quiz
                  Navigator.pushNamed(context, '/quiz').then((_) {
                    setState(() {
                      _chiSoManHinh = 0; // Quay lại Home sau khi đóng
                    });
                  });
                  return;
                } else if (index == 4) { // Lịch sử
                  Navigator.pushNamed(context, '/history').then((_) {
                    setState(() {
                      _chiSoManHinh = 0; // Quay lại Home sau khi đóng
                    });
                  });
                  return;
                } else if (index == 5) { // Cài đặt
                  Navigator.pushNamed(context, '/settings').then((_) {
                    setState(() {
                      _chiSoManHinh = 0; // Quay lại Home sau khi đóng
                    });
                  });
                  return;
                }
                
                // Xử lý các tab thông thường
                _animationController.reset();
                setState(() {
                  _chiSoManHinh = index;
                });
                _animationController.forward();
              }
            },
            height: 55,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            animationDuration: const Duration(milliseconds: 300),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, size: 20),
                selectedIcon: Icon(Icons.home, size: 20),
                label: 'Trang chủ',
              ),
              NavigationDestination(
                icon: Icon(Icons.category_outlined, size: 20),
                selectedIcon: Icon(Icons.category, size: 20),
                label: 'Chủ đề',
              ),
              NavigationDestination(
                icon: Icon(Icons.style_outlined, size: 20),
                selectedIcon: Icon(Icons.style, size: 20),
                label: 'Flashcard',
              ),
              NavigationDestination(
                icon: Icon(Icons.quiz_outlined, size: 20),
                selectedIcon: Icon(Icons.quiz, size: 20),
                label: 'Quiz',
              ),
              NavigationDestination(
                icon: Icon(Icons.history_outlined, size: 20),
                selectedIcon: Icon(Icons.history, size: 20),
                label: 'Lịch sử',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined, size: 20),
                selectedIcon: Icon(Icons.settings, size: 20),
                label: 'Cài đặt',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
