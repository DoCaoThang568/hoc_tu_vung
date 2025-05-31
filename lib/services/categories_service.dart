import 'package:flutter/material.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class CategoriesService {
  // Get categories from API (GET /categories)
  static Future<CategoriesResult> getCategories() async {
    try {
      print('🏷️ Fetching categories from API...');
      
      final response = await ApiService.get(ApiConfig.categoriesEndpoint);
      
      if (response.isSuccess && response.data != null) {
        // Parse categories từ response
        List<Category> categories = [];
        
        // Kiểm tra format response từ backend
        dynamic categoriesData;
        if (response.data!.containsKey('data')) {
          // Format: {"data": [...], "status": "success"}
          categoriesData = response.data!['data'];
        } else {
          // Format: [...] trực tiếp hoặc response.data chính là array
          categoriesData = response.data;
        }
        
        if (categoriesData is List) {
          categories = categoriesData
              .map((json) => Category.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        
        print('✅ Loaded ${categories.length} categories from API');
        return CategoriesResult.success(categories);
      } else {
        print('❌ API Error: ${response.error}');
        return CategoriesResult.error(response.error ?? 'Không thể tải danh sách chủ đề');
      }
    } catch (e) {
      print('❌ Exception in getCategories: $e');
      return CategoriesResult.error('Đã có lỗi xảy ra khi tải danh sách chủ đề');
    }
  }

  // Get sample/fallback categories (backup khi API không hoạt động)
  static List<Category> getSampleCategories() {
    return [
      Category(
        id: '1',
        name: 'Giao tiếp cơ bản',
        englishName: 'Basic Communication',
        iconData: Icons.chat_bubble_outline,
        color: Colors.blue,
        wordCount: 50,
        progress: 0.65,
      ),
      Category(
        id: '2',
        name: 'Du lịch',
        englishName: 'Travel',
        iconData: Icons.flight,
        color: Colors.green,
        wordCount: 40,
        progress: 0.3,
      ),
      Category(
        id: '3',
        name: 'Thức ăn & Đồ uống',
        englishName: 'Food & Drinks',
        iconData: Icons.restaurant_menu,
        color: Colors.red,
        wordCount: 30,
        progress: 0.8,
      ),
      Category(
        id: '4',
        name: 'Công nghệ',
        englishName: 'Technology',
        iconData: Icons.computer,
        color: Colors.orange,
        wordCount: 35,
        progress: 0.1,
      ),
      Category(
        id: '5',
        name: 'Kinh doanh',
        englishName: 'Business',
        iconData: Icons.business,
        color: Colors.purple,
        wordCount: 45,
        progress: 0.4,
      ),
    ];
  }

  // Helper: Convert string to IconData
  static IconData _getIconFromName(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'basic communication':
        return Icons.chat_bubble_outline;
      case 'travel':
        return Icons.flight;
      case 'food & drinks':
      case 'food':
        return Icons.restaurant_menu;
      case 'technology':
        return Icons.computer;
      case 'business':
        return Icons.business;
      case 'animals':
        return Icons.pets;
      case 'sports':
        return Icons.sports_soccer;
      case 'education':
        return Icons.school;
      default:
        return Icons.folder;
    }
  }

  // Helper: Convert string to Color
  static Color _getColorFromName(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'basic communication':
        return Colors.blue;
      case 'travel':
        return Colors.green;
      case 'food & drinks':
      case 'food':
        return Colors.red;
      case 'technology':
        return Colors.orange;
      case 'business':
        return Colors.purple;
      case 'animals':
        return Colors.teal;
      case 'sports':
        return Colors.cyan;
      case 'education':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
}

// Category Model để map với response từ API
class Category {
  final String id;
  final String name; // Tên hiển thị (Vietnamese)
  final String englishName; // Tên tiếng Anh từ API field 'categories'
  final IconData iconData;
  final Color color;
  final int wordCount;
  final double progress;

  Category({
    required this.id,
    required this.name,
    required this.englishName,
    required this.iconData,
    required this.color,
    required this.wordCount,
    required this.progress,
  });

  // Parse từ JSON response của API
  factory Category.fromJson(Map<String, dynamic> json) {
    String categoriesName = json['categories'] as String;
    return Category(
      id: json['id'].toString(),
      name: json['vietnamese_name'] as String? ?? categoriesName, // Fallback to English name
      englishName: categoriesName,
      iconData: CategoriesService._getIconFromName(categoriesName),
      color: CategoriesService._getColorFromName(categoriesName),
      wordCount: json['word_count'] as int? ?? 20,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }
  // Convert sang Map để hiển thị trong UI (tương thích với code cũ)
  Map<String, dynamic> toDisplayMap() {
    return {
      'id': id,
      'name': name,
      'english_name': englishName,
      'icon': iconData,
      'color': color,
      'word_count': wordCount,
      'progress': progress,
    };
  }
}

// Result wrapper cho Categories API calls
class CategoriesResult {
  final bool isSuccess;
  final List<Category>? data;
  final String? error;

  CategoriesResult.success(this.data)
      : isSuccess = true,
        error = null;
  CategoriesResult.error(this.error)
      : isSuccess = false,
        data = null;
}

