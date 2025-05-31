import 'package:flutter/material.dart';
import '../services/categories_service.dart';
import 'flashcard_screen.dart';

class TopicsScreen extends StatefulWidget {
  const TopicsScreen({super.key});

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }
  Future<void> _loadCategories() async {
    try {
      final result = await CategoriesService.getCategories();
      if (result.isSuccess && result.data != null) {
        setState(() {
          _categories = result.data!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi tải danh mục: ${result.error ?? "Unknown error"}')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chủ đề học tập'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
              ? const Center(
                  child: Text(
                    'Không có chủ đề nào',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('ID: ${category.id} - Từ vựng: ${category.wordCount}'),
                        leading: Icon(category.iconData, color: category.color),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Navigate to flashcard screen for this category
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FlashcardScreen(
                                topicData: {
                                  'id': category.id,
                                  'name': category.name,
                                  'english_name': category.englishName,
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),    );
  }
}
