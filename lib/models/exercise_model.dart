import 'package:hoc_tu_vung/models/word_model.dart';

enum ExerciseType {
  multipleChoiceVietnameseToEnglish, // Vietnamese word, multiple English choices
  multipleChoiceEnglishToVietnamese, // English word, multiple Vietnamese choices
  fillInTheBlankEnglish, // Sentence with blank, fill in English word
  fillInTheBlankVietnamese, // Sentence with blank, fill in Vietnamese word
  listeningComprehension, // Listen to audio, choose correct word/meaning
  sentenceUnscramble, // Arrange words into a complete sentence
  // Add more types as needed: matching, etc.
}

abstract class Exercise {
  final String id;
  final ExerciseType type;
  final Word word; // The primary word this exercise is based on
  final String questionText;

  Exercise({
    required this.id,
    required this.type,
    required this.word,
    required this.questionText,
  });
}

class MultipleChoiceExercise extends Exercise {
  final List<String> options;
  final String correctAnswer; // Store the correct answer string directly

  MultipleChoiceExercise({
    required String id,
    required ExerciseType type,
    required Word word,
    required String questionText,
    required this.options,
    required this.correctAnswer,
  }) : super(id: id, type: type, word: word, questionText: questionText);
}

class FillInTheBlankExercise extends Exercise {
  final String sentenceTemplate; // e.g., "Tôi ___ học tiếng Anh." or "I ___ to learn English."
  final String correctAnswer; // The word that fills the blank

  FillInTheBlankExercise({
    required String id,
    required ExerciseType type,
    required Word word,
    required String questionText, // Could be "Điền từ còn thiếu vào chỗ trống."
    required this.sentenceTemplate,
    required this.correctAnswer,
  }) : super(id: id, type: type, word: word, questionText: questionText);
}

class ListeningComprehensionExercise extends Exercise {
  final List<String> options; // Options to choose from after listening
  final String correctAnswer; // The correct option string

  ListeningComprehensionExercise({
    required String id,
    required ExerciseType type,
    required Word word, // Word object contains the audioUrl
    required String questionText, // e.g., "Nghe và chọn từ/nghĩa đúng."
    required this.options,
    required this.correctAnswer,
  }) : super(id: id, type: type, word: word, questionText: questionText);
}

class SentenceUnscrambleExercise extends Exercise {
  final List<String> scrambledWords;
  final String correctSentence;
  final String? hint; // Optional hint, e.g., the Vietnamese translation

  SentenceUnscrambleExercise({
    required String id,
    required Word word, // Could be the main new word in the sentence
    required String questionText, // e.g., "Sắp xếp các từ sau thành câu hoàn chỉnh:"
    required this.scrambledWords,
    required this.correctSentence,
    this.hint,
  }) : super(id: id, type: ExerciseType.sentenceUnscramble, word: word, questionText: questionText);
}

// Example of how you might generate exercises:
// List<Exercise> generateExercisesForTopic(String topicId, List<Word> allWords) {
//   List<Word> topicWords = allWords.where((w) => w.topicId == topicId).toList();
//   List<Exercise> exercises = [];
//   int exerciseIdCounter = 0;

//   for (var word in topicWords) {
//     // Create a Multiple Choice (Vietnamese to English)
//     List<String> mcOptions = topicWords
//         .where((w) => w.id != word.id)
//         .map((w) => w.english)
//         .toList();
//     mcOptions.shuffle();
//     mcOptions = mcOptions.take(3).toList();
//     mcOptions.add(word.english);
//     mcOptions.shuffle();

//     exercises.add(MultipleChoiceExercise(
//       id: 'ex_mc_vt_en_${exerciseIdCounter++}',
//       type: ExerciseType.multipleChoiceVietnameseToEnglish,
//       word: word,
//       questionText: 'Nghĩa của từ "${word.vietnamese}" là gì?',
//       options: mcOptions,
//       correctAnswer: word.english,
//     ));

//     // Add more exercise types here based on the word
//     // e.g., FillInTheBlank, ListeningComprehension
//   }
//   return exercises;
// }
