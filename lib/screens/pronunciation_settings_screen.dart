import 'package:flutter/material.dart';
import '../models/pronunciation_service.dart';
import '../utils/audio_downloader.dart';

class PronunciationSettingsScreen extends StatefulWidget {
  const PronunciationSettingsScreen({super.key});

  @override
  State<PronunciationSettingsScreen> createState() => _PronunciationSettingsScreenState();
}

class _PronunciationSettingsScreenState extends State<PronunciationSettingsScreen> {
  final PronunciationService _pronunciationService = PronunciationService();
  
  // Các giá trị mặc định
  double _speechRate = 0.5;
  double _volume = 1.0;
  double _pitch = 1.0;
  String _selectedLanguage = 'en-US';
  PronunciationSource _preferredSource = PronunciationSource.localTts;
  
  // Từ vựng mẫu để thử nghiệm phát âm
  final TextEditingController _testWordController = TextEditingController(text: 'Hello');
  
  // Danh sách từ vựng để tải xuống
  final List<String> _popularWords = [
    'Congratulations',
    'Appreciate',
    'Convenient',
    'Enthusiasm',
    'Profound',
    'Destination',
    'Accommodation',
    'Consideration',
    'Development',
    'Experience',
  ];
  
  final List<String> _languages = [
    'en-US',
    'en-GB',
    'en-AU',
    'fr-FR',
    'de-DE',
    'it-IT',
    'es-ES',
    'ja-JP',
    'ko-KR',
    'zh-CN',
  ];
  
  bool _isDownloading = false;
  Map<String, bool?> _downloadStatus = {};

  @override
  void initState() {
    super.initState();
    _initSettings();
  }
  
  Future<void> _initSettings() async {
    // Trong thực tế, bạn có thể tải các cài đặt từ bộ nhớ cục bộ
    await _pronunciationService.setTtsSpeechRate(_speechRate);
    await _pronunciationService.setTtsVolume(_volume);
    await _pronunciationService.setTtsPitch(_pitch);
    await _pronunciationService.setTtsLanguage(_selectedLanguage);
  }

  @override
  void dispose() {
    _testWordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt phát âm'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Phần cài đặt phát âm
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cài đặt phát âm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Chọn nguồn phát âm ưu tiên
                const Text(
                  'Nguồn phát âm:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                SegmentedButton<PronunciationSource>(
                  segments: const [
                    ButtonSegment(
                      value: PronunciationSource.localTts,
                      label: Text('TTS cục bộ'),
                      icon: Icon(Icons.phonelink),
                    ),
                    ButtonSegment(
                      value: PronunciationSource.onlineTts,
                      label: Text('TTS trực tuyến'),
                      icon: Icon(Icons.cloud),
                    ),
                    ButtonSegment(
                      value: PronunciationSource.preRecorded,
                      label: Text('Bản ghi sẵn'),
                      icon: Icon(Icons.music_note),
                    ),
                  ],
                  selected: {_preferredSource},
                  onSelectionChanged: (Set<PronunciationSource> selected) {
                    setState(() {
                      _preferredSource = selected.first;
                    });
                  },
                ),
                const SizedBox(height: 24),
                
                // Chọn ngôn ngữ
                const Text(
                  'Ngôn ngữ:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedLanguage,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  items: _languages.map((language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
                  onChanged: (newValue) async {
                    if (newValue != null) {
                      setState(() {
                        _selectedLanguage = newValue;
                      });
                      await _pronunciationService.setTtsLanguage(newValue);
                    }
                  },
                ),
                const SizedBox(height: 24),
                
                // Tốc độ phát âm
                Row(
                  children: [
                    const Text(
                      'Tốc độ:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getSpeechRateLabel(_speechRate),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _speechRate,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: _getSpeechRateLabel(_speechRate),
                  onChanged: (newValue) {
                    setState(() {
                      _speechRate = newValue;
                    });
                  },
                  onChangeEnd: (newValue) async {
                    await _pronunciationService.setTtsSpeechRate(newValue);
                  },
                ),
                const SizedBox(height: 16),
                
                // Âm lượng
                Row(
                  children: [
                    const Text(
                      'Âm lượng:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(_volume * 100).toInt()}%',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _volume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: '${(_volume * 100).toInt()}%',
                  onChanged: (newValue) {
                    setState(() {
                      _volume = newValue;
                    });
                  },
                  onChangeEnd: (newValue) async {
                    await _pronunciationService.setTtsVolume(newValue);
                  },
                ),
                const SizedBox(height: 16),
                
                // Cao độ
                Row(
                  children: [
                    const Text(
                      'Cao độ:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getPitchLabel(_pitch),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _pitch,
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                  label: _getPitchLabel(_pitch),
                  onChanged: (newValue) {
                    setState(() {
                      _pitch = newValue;
                    });
                  },
                  onChangeEnd: (newValue) async {
                    await _pronunciationService.setTtsPitch(newValue);
                  },
                ),
                const SizedBox(height: 24),
                
                // Thử nghiệm phát âm
                const Text(
                  'Thử nghiệm:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _testWordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Nhập từ để thử',
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.volume_up),
                      label: const Text('Phát âm'),
                      onPressed: () async {
                        if (_testWordController.text.trim().isNotEmpty) {
                          final success = await _pronunciationService.pronounceWord(
                            _testWordController.text.trim(),
                            preferredSource: _preferredSource,
                          );
                          
                          if (!success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Không thể phát âm từ này. Vui lòng thử lại sau.'),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          // Phần tải xuống phát âm
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tải xuống phát âm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tải xuống phát âm của các từ vựng phổ biến để sử dụng ngoại tuyến.',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Danh sách từ vựng phổ biến
                ...List.generate(_popularWords.length, (index) {
                  final word = _popularWords[index];
                  final bool? status = _downloadStatus[word];
                  
                  return ListTile(
                    title: Text(word),
                    trailing: status == null
                        ? IconButton(
                            icon: const Icon(Icons.download),
                            onPressed: _isDownloading
                                ? null
                                : () => _downloadSingleWord(word),
                          )
                        : status
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: _isDownloading
                                    ? null
                                    : () => _downloadSingleWord(word),
                              ),
                  );
                }),
                
                const SizedBox(height: 16),
                
                // Nút tải xuống tất cả
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.download),
                    label: Text(_isDownloading ? 'Đang tải xuống...' : 'Tải xuống tất cả'),
                    onPressed: _isDownloading ? null : _downloadAllWords,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _getSpeechRateLabel(double rate) {
    if (rate < 0.25) return 'Rất chậm';
    if (rate < 0.5) return 'Chậm';
    if (rate < 0.75) return 'Bình thường';
    return 'Nhanh';
  }
  
  String _getPitchLabel(double pitch) {
    if (pitch < 0.8) return 'Thấp';
    if (pitch < 1.2) return 'Bình thường';
    if (pitch < 1.6) return 'Cao';
    return 'Rất cao';
  }
  
  Future<void> _downloadSingleWord(String word) async {
    setState(() {
      _isDownloading = true;
      _downloadStatus[word] = null;
    });
    
    try {
      final bool success = await AudioDownloader.downloadFromGoogleDictionary(word);
      
      setState(() {
        _downloadStatus[word] = success;
      });
      
      if (!success) {
        final bool ttsBkp = await AudioDownloader.downloadFromGoogleTts(word);
        setState(() {
          _downloadStatus[word] = ttsBkp;
        });
      }
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }
  
  Future<void> _downloadAllWords() async {
    setState(() {
      _isDownloading = true;
      for (final word in _popularWords) {
        _downloadStatus[word] = null;
      }
    });
    
    try {
      final results = await AudioDownloader.batchDownload(_popularWords);
      
      setState(() {
        _downloadStatus = results;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đã tải xuống ${results.values.where((v) => v).length}/${_popularWords.length} tệp phát âm.'
            ),
          ),
        );
      }
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }
} 