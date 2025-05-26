class Word {
  final String id;
  final String topicId; // To associate with a topic
  final String vietnamese;
  final String english;
  final String? pronunciation; // Phonetic spelling
  final String? exampleSentenceVietnamese;
  final String? exampleSentenceEnglish;
  final String? audioUrl; // For pronunciation sound

  Word({
    required this.id,
    required this.topicId,
    required this.vietnamese,
    required this.english,
    this.pronunciation,
    this.exampleSentenceVietnamese,
    this.exampleSentenceEnglish,
    this.audioUrl,
  });
}
