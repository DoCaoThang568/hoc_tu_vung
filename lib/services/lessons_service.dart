import '../services/api_service.dart';

class LessonsService {
  // Get lessons by category ID từ API hoặc fallback data
  static Future<List<Map<String, dynamic>>> getLessonsByCategory(int categoryId) async {
    try {
      print('🔄 Loading lessons for category $categoryId...');
      
      final response = await ApiService.get('/categories/$categoryId/lessons');
      
      if (response.isSuccess && response.data != null) {
        // Parse JSON response
        if (response.data!['lessons'] is List) {
          List<dynamic> jsonList = response.data!['lessons'];
          List<Map<String, dynamic>> lessons = List<Map<String, dynamic>>.from(jsonList);
          
          print('✅ Successfully loaded ${lessons.length} lessons for category $categoryId');
          return lessons;
        } else if (response.data is List) {
          // Direct array response
          List<dynamic> jsonList = response.data as List;
          List<Map<String, dynamic>> lessons = List<Map<String, dynamic>>.from(jsonList);
          
          print('✅ Successfully loaded ${lessons.length} lessons for category $categoryId');
          return lessons;
        } else {
          print('⚠️ Invalid data format for lessons');
          return getSampleLessons(categoryId);
        }
      } else {
        print('⚠️ API failed for lessons: ${response.error}');
        // Fallback to sample data
        return getSampleLessons(categoryId);
      }
    } catch (e) {
      print('❌ Exception loading lessons: $e');
      // Fallback to sample data
      return getSampleLessons(categoryId);
    }
  }

  // Get lesson vocabulary by lesson ID
  static Future<List<Map<String, dynamic>>> getLessonVocabulary(int lessonId) async {
    try {
      print('🔄 Loading vocabulary for lesson $lessonId...');
      
      final response = await ApiService.get('/lessons/$lessonId/vocabulary');
      
      if (response.isSuccess && response.data != null) {
        if (response.data!['vocabulary'] is List) {
          List<dynamic> jsonList = response.data!['vocabulary'];
          List<Map<String, dynamic>> vocabulary = List<Map<String, dynamic>>.from(jsonList);
          
          print('✅ Successfully loaded ${vocabulary.length} vocabulary words for lesson $lessonId');
          return vocabulary;
        } else if (response.data is List) {
          List<dynamic> jsonList = response.data as List;
          List<Map<String, dynamic>> vocabulary = List<Map<String, dynamic>>.from(jsonList);
          
          print('✅ Successfully loaded ${vocabulary.length} vocabulary words for lesson $lessonId');
          return vocabulary;
        } else {
          print('⚠️ Invalid data format for vocabulary');
          return getSampleVocabulary(lessonId);
        }
      } else {
        print('⚠️ API failed for vocabulary: ${response.error}');
        return getSampleVocabulary(lessonId);
      }
    } catch (e) {
      print('❌ Exception loading vocabulary: $e');
      return getSampleVocabulary(lessonId);
    }
  }

  // Get lesson exercises by lesson ID
  static Future<List<Map<String, dynamic>>> getLessonExercises(int lessonId) async {
    try {
      print('🔄 Loading exercises for lesson $lessonId...');
      
      final response = await ApiService.get('/lessons/$lessonId/exercises');
      
      if (response.isSuccess && response.data != null) {
        if (response.data!['exercises'] is List) {
          List<dynamic> jsonList = response.data!['exercises'];
          List<Map<String, dynamic>> exercises = List<Map<String, dynamic>>.from(jsonList);
          
          print('✅ Successfully loaded ${exercises.length} exercises for lesson $lessonId');
          return exercises;
        } else if (response.data is List) {
          List<dynamic> jsonList = response.data as List;
          List<Map<String, dynamic>> exercises = List<Map<String, dynamic>>.from(jsonList);
          
          print('✅ Successfully loaded ${exercises.length} exercises for lesson $lessonId');
          return exercises;
        } else {
          print('⚠️ Invalid data format for exercises');
          return getSampleExercises(lessonId);
        }
      } else {
        print('⚠️ API failed for exercises: ${response.error}');
        return getSampleExercises(lessonId);
      }
    } catch (e) {
      print('❌ Exception loading exercises: $e');
      return getSampleExercises(lessonId);
    }
  }

  // Sample data cho development/fallback
  static List<Map<String, dynamic>> getSampleLessons(int categoryId) {
    // Sample lessons data theo category
    Map<int, List<Map<String, dynamic>>> sampleLessonsByCategory = {
      1: [ // Animals
        {
          'id': 1,
          'title': 'Động vật hoang dã',
          'english_title': 'Wild Animals',
          'description': 'Học từ vựng về các loài động vật hoang dã',
          'image_url': 'assets/images/animals_wild.jpg',
          'word_count': 20,
          'duration': 15,
          'difficulty': 'Dễ',
          'category_id': 1,
        },
        {
          'id': 2,
          'title': 'Động vật nuôi',
          'english_title': 'Domestic Animals',
          'description': 'Học từ vựng về các loài động vật nuôi',
          'image_url': 'assets/images/animals_domestic.jpg',
          'word_count': 15,
          'duration': 12,
          'difficulty': 'Dễ',
          'category_id': 1,
        },
      ],
      2: [ // Nature
        {
          'id': 3,
          'title': 'Thiên nhiên',
          'english_title': 'Nature Elements',
          'description': 'Học từ vựng về các yếu tố thiên nhiên',
          'image_url': 'assets/images/nature.jpg',
          'word_count': 25,
          'duration': 20,
          'difficulty': 'Trung bình',
          'category_id': 2,
        },
      ],
      3: [ // Food
        {
          'id': 4,
          'title': 'Trái cây',
          'english_title': 'Fruits',
          'description': 'Học từ vựng về các loại trái cây',
          'image_url': 'assets/images/fruits.jpg',
          'word_count': 18,
          'duration': 15,
          'difficulty': 'Dễ',
          'category_id': 3,
        },
      ],
    };
    
    return sampleLessonsByCategory[categoryId] ?? [];
  }

  static List<Map<String, dynamic>> getSampleVocabulary(int lessonId) {
    Map<int, List<Map<String, dynamic>>> sampleVocabularyByLesson = {
      1: [ // Wild Animals lesson
        {
          'id': '1',
          'topicId': '1',
          'vietnamese': 'sư tử',
          'english': 'lion',
          'pronunciation': '/ˈlaɪən/',
          'exampleSentenceVietnamese': 'Sư tử là vua của rừng rậm.',
          'exampleSentenceEnglish': 'The lion is the king of the jungle.',
          'audioUrl': 'assets/audio/lion.mp3',
        },
        {
          'id': '2',
          'topicId': '1',
          'vietnamese': 'hổ',
          'english': 'tiger',
          'pronunciation': '/ˈtaɪɡər/',
          'exampleSentenceVietnamese': 'Hổ có những sọc đen và cam.',
          'exampleSentenceEnglish': 'The tiger has black and orange stripes.',
          'audioUrl': 'assets/audio/tiger.mp3',
        },
        {
          'id': '3',
          'topicId': '1',
          'vietnamese': 'voi',
          'english': 'elephant',
          'pronunciation': '/ˈelɪfənt/',
          'exampleSentenceVietnamese': 'Voi là động vật có vòi dài.',
          'exampleSentenceEnglish': 'An elephant is an animal with a long trunk.',
          'audioUrl': 'assets/audio/elephant.mp3',
        },
      ],
      2: [ // Domestic Animals lesson
        {
          'id': '4',
          'topicId': '2',
          'vietnamese': 'chó',
          'english': 'dog',
          'pronunciation': '/dɔːɡ/',
          'exampleSentenceVietnamese': 'Chó là bạn thân của con người.',
          'exampleSentenceEnglish': 'Dogs are man\'s best friend.',
          'audioUrl': 'assets/audio/dog.mp3',
        },
        {
          'id': '5',
          'topicId': '2',
          'vietnamese': 'mèo',
          'english': 'cat',
          'pronunciation': '/kæt/',
          'exampleSentenceVietnamese': 'Mèo thích ngủ trên ghế sofa.',
          'exampleSentenceEnglish': 'Cats like to sleep on the sofa.',
          'audioUrl': 'assets/audio/cat.mp3',
        },
      ],
    };
    
    return sampleVocabularyByLesson[lessonId] ?? [];
  }

  static List<Map<String, dynamic>> getSampleExercises(int lessonId) {
    Map<int, List<Map<String, dynamic>>> sampleExercisesByLesson = {
      1: [ // Wild Animals lesson exercises
        {
          'id': '1',
          'type': 'multiple_choice',
          'question': 'Nghĩa của từ "lion" là gì?',
          'word': 'lion',
          'options': ['sư tử', 'hổ', 'báo', 'chó sói'],
          'correct_answer': 'sư tử',
          'explanation': 'Lion có nghĩa là sư tử.',
        },
        {
          'id': '2',
          'type': 'multiple_choice',
          'question': 'Từ tiếng Anh của "hổ" là gì?',
          'word': 'hổ',
          'options': ['lion', 'tiger', 'leopard', 'wolf'],
          'correct_answer': 'tiger',
          'explanation': 'Hổ trong tiếng Anh là tiger.',
        },
      ],
      2: [ // Domestic Animals lesson exercises
        {
          'id': '3',
          'type': 'multiple_choice',
          'question': 'Nghĩa của từ "dog" là gì?',
          'word': 'dog',
          'options': ['chó', 'mèo', 'gà', 'vịt'],
          'correct_answer': 'chó',
          'explanation': 'Dog có nghĩa là chó.',
        },
      ],
    };
      return sampleExercisesByLesson[lessonId] ?? [];
  }
}
