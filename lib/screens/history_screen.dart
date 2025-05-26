import 'package:flutter/material.dart';
// import 'package:fl_chart/flutter_charts.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử học tập'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Tab bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Theme.of(context).colorScheme.primary,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[700],
              tabs: const [
                Tab(text: 'Hoạt động'),
                Tab(text: 'Thống kê'),
                Tab(text: 'Thành tích'),
              ],
            ),
          ),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActivityTab(),
                _buildStatisticsTab(),
                _buildAchievementsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab() {
    final activities = [
      {
        'date': '18/05/2025',
        'time': '09:30',
        'title': 'Đã hoàn thành Quiz',
        'subtitle': 'Chủ đề: Giao tiếp cơ bản',
        'score': '4/5',
        'icon': Icons.quiz,
        'color': Colors.blue,
      },
      {
        'date': '18/05/2025',
        'time': '08:45',
        'title': 'Đã học Flashcard',
        'subtitle': 'Chủ đề: Giao tiếp cơ bản',
        'count': '10 từ vựng',
        'icon': Icons.style,
        'color': Colors.green,
      },
      {
        'date': '17/05/2025',
        'time': '19:15',
        'title': 'Đã hoàn thành Quiz',
        'subtitle': 'Chủ đề: Du lịch',
        'score': '3/5',
        'icon': Icons.quiz,
        'color': Colors.blue,
      },
      {
        'date': '17/05/2025',
        'time': '15:30',
        'title': 'Đã thêm chủ đề mới',
        'subtitle': 'Chủ đề: Công nghệ',
        'icon': Icons.add_circle,
        'color': Colors.purple,
      },
      {
        'date': '16/05/2025',
        'time': '20:00',
        'title': 'Đã học Flashcard',
        'subtitle': 'Chủ đề: Du lịch',
        'count': '15 từ vựng',
        'icon': Icons.style,
        'color': Colors.green,
      },
    ];
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        
        // Group by date
        final bool showDateHeader = index == 0 || 
            activity['date'] != activities[index - 1]['date'];
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDateHeader) ...[
              if (index > 0) const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      activity['date'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      indent: 8,
                      endIndent: 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            
            // Activity card
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Activity icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: (activity['color'] as Color).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        activity['icon'] as IconData,
                        color: activity['color'] as Color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Activity details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                activity['title'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                activity['time'] as String,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity['subtitle'] as String,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Additional info
                          if (activity.containsKey('score'))
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber[700],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Điểm: ${activity['score']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          if (activity.containsKey('count'))
                            Row(
                              children: [
                                Icon(
                                  Icons.book,
                                  size: 16,
                                  color: Colors.green[700],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  activity['count'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatisticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Weekly Progress
          _buildStatCard(
            title: 'Tiến độ học tập trong tuần',
            child: Column(
              children: [
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(7, (index) {
                      final heights = [0.3, 0.5, 0.7, 0.4, 0.8, 0.6, 0.2];
                      final days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
                      final isToday = index == 5; // Giả sử hôm nay là thứ 7
                      
                      return Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: 30,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                gradient: LinearGradient(
                                  colors: isToday
                                      ? [Colors.blue, Colors.blue.shade700]
                                      : [Colors.blue.shade200, Colors.blue.shade400],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              height: 150 * heights[index],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            days[index],
                            style: TextStyle(
                              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                              color: isToday ? Colors.blue : Colors.grey[700],
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        icon: Icons.calendar_today,
                        value: '7',
                        label: 'Ngày liên tiếp',
                      ),
                      _buildStatItem(
                        icon: Icons.timer,
                        value: '5.2',
                        label: 'Giờ trong tuần',
                      ),
                      _buildStatItem(
                        icon: Icons.trending_up,
                        value: '+15%',
                        label: 'So với tuần trước',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Vocabulary Progress
          _buildStatCard(
            title: 'Từ vựng đã học',
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildProgressCircle(
                          value: 0.6,
                          centerText: '124/220',
                          label: 'Từ vựng',
                          color: Colors.blue,
                        ),
                      ),
                      Expanded(
                        child: _buildProgressCircle(
                          value: 0.3,
                          centerText: '3/10',
                          label: 'Chủ đề',
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLegendItem('Đã học', Colors.green),
                      _buildLegendItem('Đang học', Colors.orange),
                      _buildLegendItem('Chưa học', Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Quiz Performance
          _buildStatCard(
            title: 'Hiệu suất Quiz',
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        icon: Icons.check_circle,
                        value: '86%',
                        label: 'Tỉ lệ đúng',
                        color: Colors.green,
                      ),
                      _buildStatItem(
                        icon: Icons.quiz,
                        value: '23',
                        label: 'Quiz đã làm',
                        color: Colors.blue,
                      ),
                      _buildStatItem(
                        icon: Icons.speed,
                        value: '45s',
                        label: 'Thời gian TB',
                        color: Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Chủ đề Quiz tốt nhất',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildQuizPerformanceItem(
                        topic: 'Giao tiếp cơ bản',
                        score: '92%',
                        color: Colors.green,
                      ),
                      _buildQuizPerformanceItem(
                        topic: 'Du lịch',
                        score: '78%',
                        color: Colors.blue,
                      ),
                      _buildQuizPerformanceItem(
                        topic: 'Công nghệ',
                        score: '65%',
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCircle({
    required double value,
    required String centerText,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 120,
          width: 120,
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              Center(
                child: Text(
                  centerText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildQuizPerformanceItem({
    required String topic,
    required String score,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            topic,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            score,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsTab() {
    final achievements = [
      {
        'title': 'Ngày đầu tiên',
        'description': 'Hoàn thành bài học đầu tiên',
        'icon': Icons.star,
        'color': Colors.blue,
        'completed': true,
        'date': '11/05/2025',
      },
      {
        'title': 'Học liên tục 7 ngày',
        'description': 'Học tập 7 ngày liên tục không gián đoạn',
        'icon': Icons.calendar_today,
        'color': Colors.green,
        'completed': true,
        'date': '17/05/2025',
      },
      {
        'title': 'Người học chăm chỉ',
        'description': 'Hoàn thành 10 bài Quiz',
        'icon': Icons.quiz,
        'color': Colors.orange,
        'completed': true,
        'date': '17/05/2025',
      },
      {
        'title': 'Bậc thầy từ vựng',
        'description': 'Học 100 từ vựng mới',
        'icon': Icons.book,
        'color': Colors.purple,
        'completed': true,
        'date': '18/05/2025',
      },
      {
        'title': 'Học liên tục 30 ngày',
        'description': 'Học tập 30 ngày liên tục không gián đoạn',
        'icon': Icons.calendar_today,
        'color': Colors.amber,
        'completed': false,
        'progress': 0.23,
      },
      {
        'title': 'Thông thạo 5 chủ đề',
        'description': 'Hoàn thành 100% từ vựng trong 5 chủ đề',
        'icon': Icons.category,
        'color': Colors.teal,
        'completed': false,
        'progress': 0.6,
      },
      {
        'title': 'Điểm số hoàn hảo',
        'description': 'Đạt điểm tuyệt đối trong 3 bài Quiz liên tiếp',
        'icon': Icons.emoji_events,
        'color': Colors.red,
        'completed': false,
        'progress': 0.33,
      },
    ];
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        final bool isCompleted = achievement['completed'] as bool;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: isCompleted
                  ? Border.all(color: achievement['color'] as Color, width: 2)
                  : null,
            ),
            child: Row(
              children: [
                // Achievement icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: (achievement['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: achievement['color'] as Color,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    achievement['icon'] as IconData,
                    color: achievement['color'] as Color,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Achievement details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              achievement['title'] as String,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isCompleted)
                            Icon(
                              Icons.verified,
                              color: Colors.green[700],
                              size: 20,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        achievement['description'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Progress or completion date
                      if (isCompleted)
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: Colors.grey[600],
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Đạt được vào: ${achievement['date']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LinearProgressIndicator(
                              value: achievement['progress'] as double,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                achievement['color'] as Color,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tiến độ: ${((achievement['progress'] as double) * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),
          child,
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    Color? color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color ?? Colors.grey[700],
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
} 