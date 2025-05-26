import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoc_tu_vung/models/word_model.dart';
import 'package:hoc_tu_vung/models/exercise_model.dart';
import 'dart:math';

class InteractiveLessonScreen extends StatefulWidget {
  static const routeName = '/interactive-lesson';
  final Map<String, dynamic> topicData;

  const InteractiveLessonScreen({super.key, required this.topicData});

  @override
  State<InteractiveLessonScreen> createState() => _InteractiveLessonScreenState();
}

class _InteractiveLessonScreenState extends State<InteractiveLessonScreen> {
  late List<Word> _allWords;
  late List<Exercise> _exercises;
  int _currentExerciseIndex = 0;
  Map<String, dynamic> _userAnswers = {}; // To store user's answer for each exercise
  bool _showResults = false;
  List<String> _currentUnscrambledWords = [];
  List<String> _selectedWords = [];

  // Sample sentences for unscrambling
  final Map<String, List<Map<String, dynamic>>> _sampleSentences = {
    'basic_communication': [
      {
        'sentence': 'Hello, how are you?',
        'words': ['you?', 'Hello,', 'are', 'how'],
        'hint': 'Xin chào, bạn có khỏe không?',
        'relatesToWordId': 'word1' // Relates to "Hello"
      },
      {
        'sentence': 'Thank you very much!',
        'words': ['much!', 'Thank', 'very', 'you'],
        'hint': 'Cảm ơn bạn rất nhiều!',
        'relatesToWordId': 'word2' // Relates to "Thank you"
      },
      {
        'sentence': 'Goodbye, see you later!',
        'words': ['later!', 'Goodbye,', 'you', 'see'],
        'hint': 'Tạm biệt, hẹn gặp lại!',
        'relatesToWordId': 'word3' // Relates to "Goodbye"
      },
    ],
    'travel': [
      {
        'sentence': 'We booked a room at this hotel.',
        'words': ['hotel.', 'this', 'at', 'room', 'a', 'booked', 'We'],
        'hint': 'Chúng tôi đã đặt một phòng ở khách sạn này.',
        'relatesToWordId': 'word4' // Relates to "Hotel"
      },
      {
        'sentence': 'I need to be at the airport by 7 AM.',
        'words': ['AM.', '7', 'by', 'airport', 'the', 'at', 'be', 'to', 'need', 'I'],
        'hint': 'Tôi cần đến sân bay lúc 7 giờ sáng.',
        'relatesToWordId': 'word5' // Relates to "Airport"
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    if (widget.topicData['id'] == null) {
      print("[InteractiveLessonScreen] ERROR: topicData['id'] is null!");
    } else {
      print("[InteractiveLessonScreen] Received topicId: ${widget.topicData['id']}");
    }
    // Sample words - replace with actual data fetching later
    _allWords = [
      Word(
        id: 'word1',
        topicId: 'basic_communication',
        vietnamese: 'Xin chào',
        english: 'Hello',
        pronunciation: '/həˈloʊ/',
        exampleSentenceVietnamese: 'Xin chào, bạn có khỏe không?',
        exampleSentenceEnglish: 'Hello, how are you?',
        audioUrl: 'https://example.com/audio/hello.mp3',
      ),
      Word(
        id: 'word2',
        topicId: 'basic_communication',
        vietnamese: 'Cảm ơn',
        english: 'Thank you',
        pronunciation: '/θæŋk juː/',
        exampleSentenceVietnamese: 'Cảm ơn bạn rất nhiều!',
        exampleSentenceEnglish: 'Thank you very much!',
        audioUrl: 'https://example.com/audio/thankyou.mp3',
      ),
      Word(
        id: 'word3',
        topicId: 'basic_communication',
        vietnamese: 'Tạm biệt',
        english: 'Goodbye',
        pronunciation: '/ɡʊdˈbaɪ/',
        exampleSentenceVietnamese: 'Tạm biệt, hẹn gặp lại!',
        exampleSentenceEnglish: 'Goodbye, see you later!',
        audioUrl: 'https://example.com/audio/goodbye.mp3',
      ),
      Word(
        id: 'word4',
        topicId: 'travel',
        vietnamese: 'Khách sạn',
        english: 'Hotel',
        pronunciation: '/hoʊˈtel/',
        exampleSentenceVietnamese: 'Chúng tôi đã đặt một phòng ở khách sạn này.',
        exampleSentenceEnglish: 'We booked a room at this hotel.',
        audioUrl: 'https://example.com/audio/hotel.mp3',
      ),
       Word(
        id: 'word5',
        topicId: 'travel',
        vietnamese: 'Sân bay',
        english: 'Airport',
        pronunciation: '/ˈerˌpôrt/',
        exampleSentenceVietnamese: 'Tôi cần đến sân bay lúc 7 giờ sáng.',
        exampleSentenceEnglish: 'I need to be at the airport by 7 AM.',
        audioUrl: 'https://example.com/audio/airport.mp3',
      ),
      // Add a word for a topic that might not have sentences to test fallback
      Word(
        id: 'word6',
        topicId: 'food',
        vietnamese: 'Phở',
        english: 'Pho',
        pronunciation: '/fɜː/',
        exampleSentenceVietnamese: 'Tôi muốn ăn phở.',
        exampleSentenceEnglish: 'I want to eat Pho.',
        audioUrl: 'https://example.com/audio/pho.mp3',
      ),
    ];

    _exercises = _generateExercisesForTopic(widget.topicData['id'], _allWords);
    if (_exercises.isEmpty) {
      print("[InteractiveLessonScreen] WARNING: No exercises were generated for topicId: ${widget.topicData['id']}.");
    }
    _exercises.shuffle(); // Randomize exercise order
    _resetSentenceUnscrambleState();
  }

  List<Exercise> _generateExercisesForTopic(String? topicId, List<Word> allWords) {
    if (topicId == null) {
      return [];
    }
    List<Word> topicWords = allWords.where((w) => w.topicId == topicId).toList();
    List<Exercise> exercises = [];
    int exerciseIdCounter = 0;
    final random = Random();

    for (var word in topicWords) {
      // Create a Multiple Choice (Vietnamese to English)
      List<String> mcOptionsEn = topicWords
          .where((w) => w.id != word.id)
          .map((w) => w.english)
          .toList();
      mcOptionsEn.shuffle(random);
      mcOptionsEn = mcOptionsEn.take(min(3, mcOptionsEn.length)).toList();
      mcOptionsEn.add(word.english);
      mcOptionsEn.shuffle(random);

      exercises.add(MultipleChoiceExercise(
        id: 'ex_mc_vt_en_${exerciseIdCounter++}',
        type: ExerciseType.multipleChoiceVietnameseToEnglish,
        word: word,
        questionText: 'Nghĩa của từ "${word.vietnamese}" là gì?',
        options: mcOptionsEn,
        correctAnswer: word.english,
      ));

      // Create a Multiple Choice (English to Vietnamese)
      List<String> mcOptionsVi = topicWords
          .where((w) => w.id != word.id)
          .map((w) => w.vietnamese)
          .toList();
      mcOptionsVi.shuffle(random);
      mcOptionsVi = mcOptionsVi.take(min(3, mcOptionsVi.length)).toList();
      mcOptionsVi.add(word.vietnamese);
      mcOptionsVi.shuffle(random);

      exercises.add(MultipleChoiceExercise(
        id: 'ex_mc_en_vt_${exerciseIdCounter++}',
        type: ExerciseType.multipleChoiceEnglishToVietnamese,
        word: word,
        questionText: 'What is the meaning of "${word.english}"?',
        options: mcOptionsVi,
        correctAnswer: word.vietnamese,
      ));

      if (word.exampleSentenceEnglish != null && word.exampleSentenceEnglish!.contains(word.english)) {
        exercises.add(FillInTheBlankExercise(
          id: 'ex_fib_en_${exerciseIdCounter++}',
          type: ExerciseType.fillInTheBlankEnglish,
          word: word,
          questionText: 'Điền từ còn thiếu vào chỗ trống (Tiếng Anh):',
          sentenceTemplate: word.exampleSentenceEnglish!.replaceFirst(word.english, '_________'),
          correctAnswer: word.english,
        ));
      }
    }
    // Add Sentence Unscramble exercises
    if (_sampleSentences.containsKey(topicId)) {
      for (var sentenceData in _sampleSentences[topicId]!) {
        Word relatedWord = topicWords.firstWhere(
          (w) => w.id == sentenceData['relatesToWordId'],
          orElse: () => topicWords.isNotEmpty 
                        ? topicWords.first 
                        : Word(id: 'temp_fallback_word', topicId: topicId, vietnamese: 'N/A', english: 'N/A') // Use topicId directly
        );
        exercises.add(SentenceUnscrambleExercise(
          id: 'ex_su_${exerciseIdCounter++}',
          word: relatedWord, // Associate with a word from the topic
          questionText: 'Sắp xếp các từ sau thành câu hoàn chỉnh:',
          scrambledWords: List<String>.from(sentenceData['words']),
          correctSentence: sentenceData['sentence'],
          hint: sentenceData['hint'],
        ));
      }
    } else {
      print("[InteractiveLessonScreen] _generateExercisesForTopic: No sentence unscramble data found for topicId '$topicId'.");
    }


    return exercises;
  }

  void _resetSentenceUnscrambleState() {
    if (_exercises.isNotEmpty && _currentExerciseIndex < _exercises.length && _exercises[_currentExerciseIndex] is SentenceUnscrambleExercise) {
      final exercise = _exercises[_currentExerciseIndex] as SentenceUnscrambleExercise;
      setState(() {
        _currentUnscrambledWords = List<String>.from(exercise.scrambledWords);
        _currentUnscrambledWords.shuffle();
        _selectedWords = [];
      });
    } else {
       setState(() {
        _currentUnscrambledWords = [];
        _selectedWords = [];
      });
    }
  }


  void _nextExercise(String? selectedAnswer) {
    if (_currentExerciseIndex < _exercises.length) {
       _userAnswers[_exercises[_currentExerciseIndex].id] = selectedAnswer;
    }
    setState(() {
      if (_currentExerciseIndex < _exercises.length - 1) {
        _currentExerciseIndex++;
        _resetSentenceUnscrambleState(); // Reset state for the new exercise
      } else {
        _showResults = true;
      }
    });
  }

  Widget _buildExerciseWidget(Exercise exercise) {
    if (exercise is MultipleChoiceExercise) {
      return _buildMultipleChoiceWidget(exercise);
    } else if (exercise is FillInTheBlankExercise) {
      return _buildFillInTheBlankWidget(exercise);
    } else if (exercise is SentenceUnscrambleExercise) {
      return _buildSentenceUnscrambleWidget(exercise);
    }
    return Text('Loại bài tập không được hỗ trợ: ${exercise.type}');
  }

  Widget _buildMultipleChoiceWidget(MultipleChoiceExercise exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exercise.questionText,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        ...exercise.options.map((option) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50), 
              ),
              onPressed: () => _nextExercise(option),
              child: Text(option, style: GoogleFonts.poppins(fontSize: 16)),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildFillInTheBlankWidget(FillInTheBlankExercise exercise) {
    TextEditingController controller = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exercise.questionText,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Text(
          exercise.sentenceTemplate,
          style: GoogleFonts.poppins(fontSize: 16, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Nhập câu trả lời của bạn',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () => _nextExercise(controller.text),
          child: Text('Kiểm tra', style: GoogleFonts.poppins(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildSentenceUnscrambleWidget(SentenceUnscrambleExercise exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exercise.questionText,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        if (exercise.hint != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Gợi ý: ${exercise.hint}',
              style: GoogleFonts.poppins(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey[700]),
            ),
          ),
        const SizedBox(height: 20),
        // Display selected words
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 15),
          constraints: const BoxConstraints(minHeight: 50), // Corrected: Use constraints for minHeight
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade100,
          ),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: _selectedWords.map((word) {
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedWords.remove(word);
                    _currentUnscrambledWords.add(word);
                  });
                },
                child: Chip(
                  label: Text(word, style: GoogleFonts.poppins(fontSize: 16)),
                  backgroundColor: Colors.blue[100],
                ),
              );
            }).toList(),
          ),
        ),
        // Display available words to select
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.center,
          children: _currentUnscrambledWords.map((word) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                setState(() {
                  _selectedWords.add(word);
                  _currentUnscrambledWords.remove(word);
                });
              },
              child: Text(word, style: GoogleFonts.poppins(fontSize: 16)),
            );
          }).toList(),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: (_selectedWords.isNotEmpty)
              ? () {
                  String userAnswer = _selectedWords.join(' ');
                  _nextExercise(userAnswer);
                }
              : null, // Disable button if no words are selected
          child: Text('Kiểm tra', style: GoogleFonts.poppins(fontSize: 16, /*color: Colors.white*/)),
        ),
      ],
    );
  }


  Widget _buildResultsScreen() {
    int correctAnswers = 0;
    _userAnswers.forEach((exerciseId, userAnswer) {
      final exercise = _exercises.firstWhere((ex) => ex.id == exerciseId);
      bool isCorrect = false;
      if (exercise is MultipleChoiceExercise) {
        isCorrect = exercise.correctAnswer == userAnswer;
      } else if (exercise is FillInTheBlankExercise) {
        isCorrect = exercise.correctAnswer.toLowerCase() == (userAnswer as String?)?.toLowerCase();
      } else if (exercise is SentenceUnscrambleExercise) {
        isCorrect = exercise.correctSentence == userAnswer;
      }
      if (isCorrect) {
        correctAnswers++;
      }
    });
    double score = (_exercises.isNotEmpty) ? (correctAnswers / _exercises.length) * 100 : 0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Kết quả bài học',
              style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Bạn đã hoàn thành ${_exercises.length} bài tập.',
              style: GoogleFonts.poppins(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Số câu đúng: $correctAnswers/${_exercises.length}',
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.green[700]),
            ),
            const SizedBox(height: 10),
            Text(
              'Điểm: ${score.toStringAsFixed(1)}%',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Go back to Learning Methods or Topics screen
              },
              child: Text('Hoàn thành', style: GoogleFonts.poppins(fontSize: 16, /*color: Colors.white*/)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color appBarColor = widget.topicData['color'] as Color? ?? Theme.of(context).primaryColor;
    final String topicName = widget.topicData['name'] as String? ?? 'Bài học tương tác';

    return Scaffold(
      appBar: AppBar(
        title: Text(topicName, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
        backgroundColor: appBarColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _exercises.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      'Đang tải bài học...',
                       style: GoogleFonts.poppins(fontSize: 16),
                    )
                  ],
                )
              )
            : _showResults
                ? _buildResultsScreen()
                : _buildExerciseWidget(_exercises[_currentExerciseIndex]),
      ),
    );
  }
}
