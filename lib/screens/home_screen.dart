import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../widgets/stats_card.dart';
import '../widgets/vocabulary_item.dart';
import '../models/study_progress.dart';
import '../widgets/animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'topics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Dữ liệu báo cáo tiến trình học tập
  final StudyProgress _studyProgress = StudyProgress(
    totalWords: 220,
    learnedWords: 124,
    totalTopics: 10,
    activeTopics: 3,
    streakDays: 7,
    wordsToday: 15
  );
  
  final FlutterTts _flutterTts = FlutterTts();
  
  @override
  void initState() {
    super.initState();
    _initTts();
  }
  
  // Khởi tạo Text-to-Speech
  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }
  
  // Đọc từ vựng
  Future<void> _speakWord(String text) async {
    await _flutterTts.speak(text);
  }
  
  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Xử lý khi nhấn nút back vật lý
        return true; // Cho phép thoát khỏi app
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chào mừng người dùng
              SlideAnimation(
                beginOffset: const Offset(-50, 0),
                child: _buildWelcomeSection(context),
              ),
              
              const SizedBox(height: 24),
              
              // Thống kê học tập
              SlideAnimation(
                delay: const Duration(milliseconds: 150),
                child: _buildStatsSection(context),
              ),
              
              const SizedBox(height: 24),
              
              // Từ vựng đang học
              SlideAnimation(
                delay: const Duration(milliseconds: 300),
                child: _buildLearningSection(context),
              ),
              
              const SizedBox(height: 24),
              
              // Gợi ý chủ đề
              SlideAnimation(
                delay: const Duration(milliseconds: 450),
                child: _buildSuggestedTopics(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Color.lerp(
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
              0.6,
            )!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Top section with greeting and streak
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side - greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.emoji_events,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_studyProgress.streakDays} ngày liên tiếp',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                Text(
                  'Xin chào, Học viên!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                        fontSize: 22,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                      'Tiếp tục hành trình ngôn ngữ của bạn',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                  ],
                ),
              ),
              // Right side - animation
              Hero(
                tag: 'welcome_image',
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: Lottie.network(
                    'https://assets9.lottiefiles.com/packages/lf20_m2aybuxx.json',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 18),
          
          // Progress container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // Today's progress
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 14,
                            color: Colors.amber[200],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Hôm nay',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_studyProgress.wordsToday} từ mới',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 6,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _studyProgress.wordsToday / 20, // Assuming 20 is the daily goal
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Vertical divider
                Container(
                  height: 45,
                  width: 1,
                  color: Colors.white.withOpacity(0.2),
                ),
                
                // Total words learned
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 14,
                              color: Colors.green[200],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Tổng cộng',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_studyProgress.learnedWords} từ',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'đã học',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // "Start Learning" button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/flashcard');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.play_arrow_rounded, size: 20),
              label: Text(
                'Học ngay hôm nay',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Thống kê của bạn',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                // Chuyển đến trang thống kê chi tiết
                Navigator.pushNamed(context, '/statistics');
              },
              icon: const Icon(Icons.dashboard, size: 14),
              label: const Text('Dashboard', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                icon: Icons.calendar_today,
                value: '${_studyProgress.streakDays}',
                label: 'Ngày học liên tiếp',
                color: Colors.orange,
                iconSize: 18,
                valueSize: 20,
                labelSize: 12,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                icon: Icons.auto_stories,
                value: '${_studyProgress.learnedWords}',
                label: 'Từ vựng đã học',
                color: Colors.green,
                iconSize: 18,
                valueSize: 20,
                labelSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatsCard(
                icon: Icons.emoji_events,
                value: '85%',
                label: 'Tỉ lệ chính xác',
                color: Colors.blue,
                iconSize: 18,
                valueSize: 20,
                labelSize: 12,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatsCard(
                icon: Icons.category,
                value: '${_studyProgress.activeTopics}/${_studyProgress.totalTopics}',
                label: 'Chủ đề đang học',
                color: Colors.purple,
                iconSize: 18,
                valueSize: 20,
                labelSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLearningSection(BuildContext context) {
    // Format hiển thị số từ vựng đang học
    final wordProgressText = '${_studyProgress.learnedWords}/${_studyProgress.totalWords} từ vựng';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Đang học',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Row(
              children: [
                Text(
                  wordProgressText,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/vocabulary_list');
                  },
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('Xem tất cả'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Hiển thị thanh tiến trình tổng
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _studyProgress.learnedWords / _studyProgress.totalWords,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tiến độ học tập: ${(_studyProgress.learnedWords / _studyProgress.totalWords * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        // Danh sách từ vựng với phát âm
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () => _speakWord('Congratulations'),
                child: VocabularyItem(
                  word: 'Congratulations',
                  phonetic: '/kənˌɡrætʃəˈleɪʃənz/',
                  meaning: 'Chúc mừng',
                  progress: 0.8,
                  imageUrl: 'https://img.freepik.com/free-vector/people-celebrating-concept-illustration_114360-1875.jpg',
                  nativeSimilarity: 0.85,
                  topic: 'Giao tiếp',
                ),
              ),
              const Divider(height: 1),
              InkWell(
                onTap: () => _speakWord('Appreciate'),
                child: VocabularyItem(
                  word: 'Appreciate',
                  phonetic: '/əˈpriːʃieɪt/',
                  meaning: 'Đánh giá cao',
                  progress: 0.6,
                  imageUrl: 'https://img.freepik.com/free-vector/tiny-hr-manager-employer-hiring-rating-candidates-job-interview_74855-19924.jpg',
                  nativeSimilarity: 0.63,
                  topic: 'Công việc',
                ),
              ),
              const Divider(height: 1),
              InkWell(
                onTap: () => _speakWord('Convenient'),
                child: VocabularyItem(
                  word: 'Convenient',
                  phonetic: '/kənˈviːniənt/',
                  meaning: 'Thuận tiện',
                  progress: 0.4,
                  imageUrl: 'https://img.freepik.com/free-vector/people-using-online-apps-set_52683-8076.jpg',
                  nativeSimilarity: 0.45,
                  topic: 'Đời sống',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestedTopics(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Các chế độ học',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => _navigateToTopics(context),
                  child: const Text('Xem tất cả', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.2,
            padding: EdgeInsets.zero,
            children: [
              _buildTopicCard(
                context,
                'Flashcard',
                Icons.style,
                Colors.orange,
                () {
                  Navigator.pushNamed(context, '/flashcard');
                },
                'Học từ bằng thẻ ghi nhớ',
                '24 thẻ',
              ),
              _buildTopicCard(
                context,
                'Quiz',
                Icons.quiz,
                Colors.purple,
                () {
                  Navigator.pushNamed(context, '/quiz');
                },
                'Kiểm tra kiến thức',
                '15 câu hỏi',
              ),
              _buildTopicCard(
                context,
                'Quiz Ảnh',
                Icons.image,
                Colors.blue,
                () {
                  Navigator.pushNamed(context, '/image_quiz');
                },
                'Học qua hình ảnh',
                '5 câu hỏi',
              ),
              _buildTopicCard(
                context,
                'Lịch sử',
                Icons.history,
                Colors.green,
                () {
                  Navigator.pushNamed(context, '/history');
                },
                'Xem tiến trình học tập',
                'Theo dõi',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap, String description, String count) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.12), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          splashColor: color.withOpacity(0.2),
          highlightColor: color.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                // Left side - Icon with background
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: color,
                  ),
                ),
                const SizedBox(width: 8),
                
                // Center - Title and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: color.withOpacity(0.9),
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                // Right side - Count badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    count,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: color.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
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

  // Hàm điều hướng đến màn hình chủ đề
  void _navigateToTopics(BuildContext context) {
    // Dùng MaterialPageRoute để đảm bảo có animation chuyển màn hình đúng
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TopicsScreen(),
      ),
    );
  }
}
