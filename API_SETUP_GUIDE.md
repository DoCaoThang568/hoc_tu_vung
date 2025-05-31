# 🔧 API BACKEND SETUP GUIDE

## 📋 Cấu hình API Backend cho app Flutter

### 🎯 **Requirements**
App Flutter cần kết nối với backend API PostgreSQL với các endpoint sau:

#### **Categories API:**
```
GET /api/categories
```

#### **Lessons API:**
```
GET /api/categories/{categoryId}/lessons
GET /api/lessons/{lessonId}/vocabulary  
GET /api/lessons/{lessonId}/exercises
```

### 📝 **Expected API Response Formats**

#### **1. Categories Endpoint (GET /api/categories):**

**Successful Response:**
```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "categories": "Basic Communication",
      "vietnamese_name": "Giao tiếp cơ bản",
      "word_count": 25,
      "progress": 0.0
    },
    {
      "id": 2,
      "categories": "Travel",
      "vietnamese_name": "Du lịch",
      "word_count": 30,
      "progress": 0.0
    }
  ],
  "message": "Categories retrieved successfully"
}
```

**Alternative Simple Format:**
```json
[
  {
    "id": 1,
    "categories": "Basic Communication"
  },
  {
    "id": 2,
    "categories": "Travel"
  }
]
```

#### **2. Lessons by Category (GET /categories/{categoryId}/lessons):**

```json
{
  "status": "success",
  "lessons": [
    {
      "id": 1,
      "title": "Greetings and Introductions",
      "description": "Learn basic greetings and how to introduce yourself",
      "vocabulary_count": 10,
      "exercise_count": 5,
      "duration": "15 phút",
      "difficulty": "Cơ bản"
    },
    {
      "id": 2,
      "title": "Daily Conversations",
      "description": "Common phrases for everyday conversations",
      "vocabulary_count": 15,
      "exercise_count": 8,
      "duration": "20 phút", 
      "difficulty": "Trung bình"
    }
  ]
}
```

#### **3. Lesson Vocabulary (GET /lessons/{lessonId}/vocabulary):**

```json
{
  "status": "success",
  "vocabulary": [
    {
      "id": 1,
      "english": "Hello",
      "vietnamese": "Xin chào",
      "pronunciation": "həˈloʊ",
      "part_of_speech": "interjection",
      "example": "Hello, how are you?",
      "example_translation": "Xin chào, bạn khỏe không?",
      "audio_url": "/audio/hello.mp3"
    },
    {
      "id": 2,
      "english": "Goodbye",
      "vietnamese": "Tạm biệt",
      "pronunciation": "ɡʊdˈbaɪ",
      "part_of_speech": "interjection",
      "example": "Goodbye, see you tomorrow!",
      "example_translation": "Tạm biệt, hẹn gặp lại ngày mai!",
      "audio_url": "/audio/goodbye.mp3"
    }
  ]
}
```

#### **4. Lesson Exercises (GET /lessons/{lessonId}/exercises):**

```json
{
  "status": "success",
  "exercises": [
    {
      "id": 1,
      "question": "What is the Vietnamese translation of 'Hello'?",
      "options": ["Xin chào", "Tạm biệt", "Cảm ơn", "Xin lỗi"],
      "correct_answer": 0,
      "explanation": "'Hello' in Vietnamese is 'Xin chào', which is the most common greeting."
    },
    {
      "id": 2,
      "question": "How do you say 'Thank you' in English?",
      "options": ["Please", "Sorry", "Thank you", "Excuse me"],
      "correct_answer": 2,
      "explanation": "'Thank you' is the standard way to express gratitude in English."
    }
  ]
}
```

### ⚙️ **API Configuration trong Flutter**

File: `lib/config/api_config.dart`
```dart
class ApiConfig {
  // Thay đổi URL này thành địa chỉ backend thật
  static const String baseUrl = 'http://localhost:3000'; // Dev
  // static const String baseUrl = 'https://your-api.com'; // Production
  
  static const String categoriesEndpoint = '/api/categories';
  static const String lessonsByCategoryEndpoint = '/api/categories/{categoryId}/lessons';
  static const String lessonVocabularyEndpoint = '/api/lessons/{lessonId}/vocabulary';
  static const String lessonExercisesEndpoint = '/api/lessons/{lessonId}/exercises';
}
```

### 🚀 **Cách test API Integration**

1. **Chạy app Flutter:**
   ```bash
   flutter run --debug
   ```

2. **Vào Home Screen → Click "API Test"**

3. **Click "Test GET /categories"**

4. **Kiểm tra result:**
   - ✅ **Success:** API trả về đúng format
   - ❌ **Error:** Hiển thị lỗi và fallback sang sample data

### 🔍 **Debug Information**

App sẽ in debug logs trong console:
```
🌐 API GET: http://localhost:3000/api/categories
📥 Response Status: 200
📥 Response Body: {...}
✅ Loaded 3 categories from API
```

### 🛠️ **Backend Implementation Notes**

#### **Database Schema Example:**
```sql
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    categories VARCHAR(255) NOT NULL,
    vietnamese_name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO categories (id, categories, vietnamese_name) VALUES
(1, 'Basic Communication', 'Giao tiếp cơ bản'),
(2, 'Travel', 'Du lịch'),
(3, 'Food & Drinks', 'Thức ăn & Đồ uống'),
(4, 'Technology', 'Công nghệ'),
(5, 'Business', 'Kinh doanh');
```

#### **Express.js Endpoint Example:**
```javascript
// GET /api/categories
app.get('/api/categories', async (req, res) => {
  try {
    const result = await pool.query('SELECT id, categories FROM categories ORDER BY id');
    res.json({
      status: 'success',
      data: result.rows,
      message: 'Categories retrieved successfully'
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve categories',
      error: error.message
    });
  }
});

// GET /api/categories/:categoryId/lessons
app.get('/api/categories/:categoryId/lessons', async (req, res) => {
  const { categoryId } = req.params;
  try {
    const result = await pool.query('SELECT * FROM lessons WHERE category_id = $1', [categoryId]);
    res.json({
      status: 'success',
      lessons: result.rows
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve lessons',
      error: error.message
    });
  }
});

// GET /api/lessons/:lessonId/vocabulary
app.get('/api/lessons/:lessonId/vocabulary', async (req, res) => {
  const { lessonId } = req.params;
  try {
    const result = await pool.query('SELECT * FROM vocabulary WHERE lesson_id = $1', [lessonId]);
    res.json({
      status: 'success',
      vocabulary: result.rows
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve vocabulary',
      error: error.message
    });
  }
});

// GET /api/lessons/:lessonId/exercises
app.get('/api/lessons/:lessonId/exercises', async (req, res) => {
  const { lessonId } = req.params;
  try {
    const result = await pool.query('SELECT * FROM exercises WHERE lesson_id = $1', [lessonId]);
    res.json({
      status: 'success',
      exercises: result.rows
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve exercises',
      error: error.message
    });
  }
});
```

### 📱 **App Behavior**

- **API Available:** Load real data from backend
- **API Unavailable:** Show error message + use sample data
- **Network Error:** Show "Không có kết nối internet" + use sample data

### 🔄 **Next Steps**

1. ✅ **Test Categories API** (Current)
2. 🔄 **Authentication API** (POST /api/auth/login)
3. 🔄 **Lessons API** (GET /api/categories/{id}/lessons)
4. 🔄 **Vocabulary API** (GET /api/lessons/{id}/vocabulary)
5. 🔄 **Quiz API** (GET /api/lessons/{id}/quiz)

---

**📞 Contact:** Update khi API backend sẵn sàng để test integration!
