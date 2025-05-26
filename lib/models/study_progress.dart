class StudyProgress {
  final int totalWords;      // Tổng số từ vựng
  final int learnedWords;    // Số từ vựng đã học
  final int totalTopics;     // Tổng số chủ đề
  final int activeTopics;    // Số chủ đề đang học tích cực
  final int streakDays;      // Số ngày học liên tiếp
  final int wordsToday;      // Số từ vựng đã học hôm nay
  final Map<String, int>? topicProgress; // Tiến độ theo từng chủ đề

  const StudyProgress({
    required this.totalWords,
    required this.learnedWords,
    required this.totalTopics,
    required this.activeTopics,
    required this.streakDays,
    required this.wordsToday,
    this.topicProgress,
  });

  // Tỉ lệ hoàn thành tổng thể
  double get completionRate => learnedWords / totalWords;

  // Số từ vựng còn lại cần học
  int get remainingWords => totalWords - learnedWords;

  // Tỉ lệ chủ đề đang học
  double get topicCoverageRate => activeTopics / totalTopics;

  // Phương thức thêm từ vựng đã học
  StudyProgress addLearnedWord() {
    return StudyProgress(
      totalWords: totalWords,
      learnedWords: learnedWords + 1,
      totalTopics: totalTopics,
      activeTopics: activeTopics,
      streakDays: streakDays,
      wordsToday: wordsToday + 1,
      topicProgress: topicProgress,
    );
  }

  // Phương thức thêm chủ đề mới
  StudyProgress addTopic() {
    return StudyProgress(
      totalWords: totalWords,
      learnedWords: learnedWords,
      totalTopics: totalTopics + 1,
      activeTopics: activeTopics + 1,
      streakDays: streakDays,
      wordsToday: wordsToday,
      topicProgress: topicProgress,
    );
  }

  // Tạo bản sao với cập nhật
  StudyProgress copyWith({
    int? totalWords,
    int? learnedWords,
    int? totalTopics,
    int? activeTopics,
    int? streakDays,
    int? wordsToday,
    Map<String, int>? topicProgress,
  }) {
    return StudyProgress(
      totalWords: totalWords ?? this.totalWords,
      learnedWords: learnedWords ?? this.learnedWords,
      totalTopics: totalTopics ?? this.totalTopics,
      activeTopics: activeTopics ?? this.activeTopics,
      streakDays: streakDays ?? this.streakDays,
      wordsToday: wordsToday ?? this.wordsToday,
      topicProgress: topicProgress ?? this.topicProgress,
    );
  }
} 