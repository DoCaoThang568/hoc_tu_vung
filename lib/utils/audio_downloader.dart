import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AudioDownloader {
  static const String googleTtsUrl = 'https://translate.google.com/translate_tts';
  static const String googleDictionaryUrl = 'https://ssl.gstatic.com/dictionary/static/sounds/oxford/';
  
  /// Tải tệp âm thanh từ Google Translate TTS
  static Future<bool> downloadFromGoogleTts(String word, {String lang = 'en'}) async {
    try {
      final String normalizedWord = word.toLowerCase().replaceAll(' ', '_');
      final Uri uri = Uri.parse('$googleTtsUrl?ie=UTF-8&q=$word&tl=$lang&client=tw-ob');
      
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        // Lưu tệp
        return await _saveAudioFile(normalizedWord, response.bodyBytes);
      }
      
      return false;
    } catch (e) {
      debugPrint('Error downloading from Google TTS: $e');
      return false;
    }
  }
  
  /// Tải tệp âm thanh từ Google Dictionary
  static Future<bool> downloadFromGoogleDictionary(String word) async {
    try {
      final String normalizedWord = word.toLowerCase().replaceAll(' ', '_');
      final String formattedWord = word.toLowerCase().replaceAll(' ', '-');
      final Uri uri = Uri.parse('$googleDictionaryUrl$formattedWord--_us_1.mp3');
      
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        // Lưu tệp
        return await _saveAudioFile(normalizedWord, response.bodyBytes);
      }
      
      return false;
    } catch (e) {
      debugPrint('Error downloading from Google Dictionary: $e');
      return false;
    }
  }
  
  /// Lưu tệp âm thanh vào thư mục assets/audio
  static Future<bool> _saveAudioFile(String filename, Uint8List bytes) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final String appDir = dir.path;
      final String audioDir = '$appDir/assets/audio';
      
      // Tạo thư mục nếu chưa tồn tại
      final audioDirectory = Directory(audioDir);
      if (!(await audioDirectory.exists())) {
        await audioDirectory.create(recursive: true);
      }
      
      // Lưu tệp
      final File file = File('$audioDir/$filename.mp3');
      await file.writeAsBytes(bytes);
      
      debugPrint('Saved audio file to: ${file.path}');
      return true;
    } catch (e) {
      debugPrint('Error saving audio file: $e');
      return false;
    }
  }
  
  /// Tải xuống nhiều từ vựng cùng lúc
  static Future<Map<String, bool>> batchDownload(List<String> words) async {
    final Map<String, bool> results = {};
    
    for (final word in words) {
      // Thử tải từ Google Dictionary trước
      bool success = await downloadFromGoogleDictionary(word);
      
      // Nếu không thành công, thử tải từ Google TTS
      if (!success) {
        success = await downloadFromGoogleTts(word);
      }
      
      results[word] = success;
    }
    
    return results;
  }
} 