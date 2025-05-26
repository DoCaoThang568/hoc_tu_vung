import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

enum PronunciationSource {
  localTts,
  onlineTts,
  preRecorded
}

class PronunciationService {
  static final PronunciationService _instance = PronunciationService._internal();
  factory PronunciationService() => _instance;
  
  PronunciationService._internal() {
    _initTts();
  }
  
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // Theo dõi trạng thái phát âm hiện tại
  bool _isSpeaking = false;
  
  // Khởi tạo Text-to-Speech
  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    
    _flutterTts.setStartHandler(() {
      _isSpeaking = true;
    });
    
    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
    });
    
    _flutterTts.setErrorHandler((error) {
      _isSpeaking = false;
      debugPrint("TTS Error: $error");
    });
  }
  
  // Phát âm từ vựng với cơ chế dự phòng thông minh
  Future<bool> pronounceWord(String word, {PronunciationSource preferredSource = PronunciationSource.localTts}) async {
    if (_isSpeaking) {
      await stopPronunciation();
    }
    
    bool success = false;
    
    switch (preferredSource) {
      case PronunciationSource.localTts:
        success = await _speakWithLocalTts(word);
        if (!success) {
          // Thử với tùy chọn trực tuyến nếu TTS cục bộ thất bại
          success = await _speakWithOnlineTts(word);
        }
        break;
        
      case PronunciationSource.onlineTts:
        success = await _speakWithOnlineTts(word);
        if (!success) {
          // Thử với tùy chọn cục bộ nếu TTS trực tuyến thất bại
          success = await _speakWithLocalTts(word);
        }
        break;
        
      case PronunciationSource.preRecorded:
        success = await _playPreRecordedAudio(word);
        if (!success) {
          // Thử với TTS cục bộ nếu không có bản ghi âm sẵn
          success = await _speakWithLocalTts(word);
        }
        break;
    }
    
    return success;
  }
  
  // Phát âm với TTS cục bộ
  Future<bool> _speakWithLocalTts(String word) async {
    try {
      await _flutterTts.speak(word);
      return true;
    } catch (e) {
      debugPrint("Local TTS Error: $e");
      return false;
    }
  }
  
  // Phát âm với TTS trực tuyến
  Future<bool> _speakWithOnlineTts(String word) async {
    try {
      // URL API demo - trong thực tế bạn sẽ cần một API phát âm thực tế
      final Uri uri = Uri.parse('https://api.voicerss.org/');
      final audioUrl = 'https://ssl.gstatic.com/dictionary/static/sounds/oxford/${word.toLowerCase()}--_us_1.mp3';
      
      final response = await http.get(Uri.parse(audioUrl));
      
      if (response.statusCode == 200) {
        // Lưu tệp âm thanh tạm thời
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/${word.toLowerCase()}.mp3');
        await file.writeAsBytes(response.bodyBytes);
        
        // Phát tệp âm thanh
        await _audioPlayer.play(DeviceFileSource(file.path));
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Online TTS Error: $e");
      return false;
    }
  }
  
  // Phát tệp âm thanh đã ghi sẵn
  Future<bool> _playPreRecordedAudio(String word) async {
    try {
      final String normalizedWord = word.toLowerCase().replaceAll(' ', '_');
      final String audioPath = 'assets/audio/$normalizedWord.mp3';
      
      // Kiểm tra xem tệp có tồn tại không
      await _audioPlayer.play(AssetSource(audioPath));
      return true;
    } catch (e) {
      debugPrint("Pre-recorded Audio Error: $e");
      return false;
    }
  }
  
  // Dừng phát âm
  Future<void> stopPronunciation() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      await _audioPlayer.stop();
      _isSpeaking = false;
    }
  }
  
  // Tải xuống và lưu tệp âm thanh cho từ vựng
  Future<bool> downloadAndSaveAudio(String word) async {
    try {
      final String normalizedWord = word.toLowerCase().replaceAll(' ', '_');
      final audioUrl = 'https://ssl.gstatic.com/dictionary/static/sounds/oxford/$normalizedWord--_us_1.mp3';
      
      final response = await http.get(Uri.parse(audioUrl));
      
      if (response.statusCode == 200) {
        // Lấy đường dẫn đến thư mục ứng dụng
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/assets/audio/$normalizedWord.mp3');
        
        // Tạo thư mục nếu chưa tồn tại
        if (!(await file.parent.exists())) {
          await file.parent.create(recursive: true);
        }
        
        // Lưu tệp
        await file.writeAsBytes(response.bodyBytes);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Download and Save Audio Error: $e");
      return false;
    }
  }
  
  // Hàm setter cho các thuộc tính TTS
  Future<void> setTtsLanguage(String language) async {
    await _flutterTts.setLanguage(language);
  }
  
  Future<void> setTtsSpeechRate(double rate) async {
    await _flutterTts.setSpeechRate(rate);
  }
  
  Future<void> setTtsVolume(double volume) async {
    await _flutterTts.setVolume(volume);
  }
  
  Future<void> setTtsPitch(double pitch) async {
    await _flutterTts.setPitch(pitch);
  }
  
  // Dọn dẹp tài nguyên khi không cần nữa
  void dispose() {
    _flutterTts.stop();
    _audioPlayer.dispose();
  }
} 