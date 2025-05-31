import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/lessons_service.dart';

class VocabularyScreen extends StatefulWidget {
  final int lessonId;
  final String lessonTitle;
  final Map<String, dynamic> topicData;

  const VocabularyScreen({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
    required this.topicData,
  });

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _vocabulary = [];
  int _currentIndex = 0;
  bool _showTranslation = false;

  @override
  void initState() {
    super.initState();
    _loadVocabulary();
  }

  Future<void> _loadVocabulary() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final vocabulary = await LessonsService.getLessonVocabulary(widget.lessonId);
      
      setState(() {
        _vocabulary = vocabulary;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Có lỗi xảy ra khi tải từ vựng: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color topicColor = widget.topicData['color'] as Color? ?? theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Từ vựng',
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            Text(
              widget.lessonTitle,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
        backgroundColor: topicColor.withOpacity(0.8),
        elevation: 0,
        actions: [
          if (_vocabulary.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentIndex + 1}/${_vocabulary.length}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: _buildContent(),
      bottomNavigationBar: _vocabulary.isNotEmpty ? _buildNavigationBar() : null,
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải từ vựng...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadVocabulary,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_vocabulary.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có từ vựng nào',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return PageView.builder(
      itemCount: _vocabulary.length,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
          _showTranslation = false;
        });
      },
      itemBuilder: (context, index) {
        return _buildVocabularyCard(_vocabulary[index]);
      },
    );
  }

  Widget _buildVocabularyCard(Map<String, dynamic> word) {
    final theme = Theme.of(context);
    final Color topicColor = widget.topicData['color'] as Color? ?? theme.colorScheme.primary;

    final english = word['english'] ?? word['word'] ?? 'Word';
    final vietnamese = word['vietnamese'] ?? word['translation'] ?? 'Từ';
    final pronunciation = word['pronunciation'] ?? '';
    final example = word['example'] ?? '';
    final exampleTranslation = word['example_translation'] ?? '';
    final partOfSpeech = word['part_of_speech'] ?? word['type'] ?? '';

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Main vocabulary card
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showTranslation = !_showTranslation;
                });
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      topicColor.withOpacity(0.8),
                      topicColor.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: topicColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // English word
                          Text(
                            english,
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          // Pronunciation
                          if (pronunciation.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              '/$pronunciation/',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                          
                          // Part of speech
                          if (partOfSpeech.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                partOfSpeech,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                          
                          const SizedBox(height: 20),
                          
                          // Translation (conditional)
                          AnimatedOpacity(
                            opacity: _showTranslation ? 1.0 : 0.3,
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              _showTranslation ? vietnamese : 'Nhấn để xem nghĩa',
                              style: GoogleFonts.poppins(
                                fontSize: _showTranslation ? 24 : 16,
                                fontWeight: _showTranslation 
                                    ? FontWeight.w600 
                                    : FontWeight.normal,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Audio button (if available)
                    if (word['audio_url'] != null || word['pronunciation'] != null)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.volume_up,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // TODO: Implement audio playback
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Chức năng phát âm đang được phát triển'),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          // Example section
          if (example.isNotEmpty) ...[
            const SizedBox(height: 16),
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: topicColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.format_quote,
                          color: topicColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ví dụ:',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: topicColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      example,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    if (exampleTranslation.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        exampleTranslation,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
          
          // Instruction text
          const SizedBox(height: 16),
          Text(
            'Vuốt sang trái/phải để xem từ tiếp theo',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    final theme = Theme.of(context);
    final Color topicColor = widget.topicData['color'] as Color? ?? theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Previous button
          ElevatedButton.icon(
            onPressed: _currentIndex > 0
                ? () {
                    setState(() {
                      _currentIndex--;
                      _showTranslation = false;
                    });
                  }
                : null,
            icon: const Icon(Icons.navigate_before),
            label: const Text('Trước'),
            style: ElevatedButton.styleFrom(
              backgroundColor: topicColor.withOpacity(0.1),
              foregroundColor: topicColor,
            ),
          ),
          
          // Show translation button
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _showTranslation = !_showTranslation;
              });
            },
            icon: Icon(_showTranslation ? Icons.visibility_off : Icons.visibility),
            label: Text(_showTranslation ? 'Ẩn nghĩa' : 'Hiện nghĩa'),
            style: ElevatedButton.styleFrom(
              backgroundColor: topicColor,
              foregroundColor: Colors.white,
            ),
          ),
          
          // Next button
          ElevatedButton.icon(
            onPressed: _currentIndex < _vocabulary.length - 1
                ? () {
                    setState(() {
                      _currentIndex++;
                      _showTranslation = false;
                    });
                  }
                : null,
            icon: const Icon(Icons.navigate_next),
            label: const Text('Tiếp'),
            style: ElevatedButton.styleFrom(
              backgroundColor: topicColor.withOpacity(0.1),
              foregroundColor: topicColor,
            ),
          ),
        ],
      ),
    );
  }
}
