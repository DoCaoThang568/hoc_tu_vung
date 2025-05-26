import 'package:flutter/material.dart';
import 'pronunciation_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Các cài đặt
  bool _darkMode = false;
  bool _enableNotifications = true;
  String _selectedLanguage = 'Tiếng Việt';
  double _textSize = 16.0;
  bool _autoPlayPronunciation = true;
  int _reminderTime = 20; // phút
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Thông tin người dùng
        _buildUserInfoCard(),
        const SizedBox(height: 24),
        
        // Giao diện
        _buildSectionTitle('Giao diện'),
        _buildSettingItem(
          icon: Icons.dark_mode,
          title: 'Chế độ tối',
          subtitle: 'Thay đổi màu sắc giao diện',
          trailing: Switch(
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        _buildSettingItem(
          icon: Icons.text_fields,
          title: 'Cỡ chữ',
          subtitle: 'Điều chỉnh cỡ chữ trong ứng dụng',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _textSize > 12 ? () {
                  setState(() {
                    _textSize -= 2;
                  });
                } : null,
              ),
              Text(
                '${_textSize.toInt()}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _textSize < 24 ? () {
                  setState(() {
                    _textSize += 2;
                  });
                } : null,
              ),
            ],
          ),
        ),
        
        // Ngôn ngữ
        _buildSectionTitle('Ngôn ngữ'),
        _buildSettingItem(
          icon: Icons.language,
          title: 'Ngôn ngữ ứng dụng',
          subtitle: 'Thay đổi ngôn ngữ hiển thị',
          trailing: DropdownButton<String>(
            value: _selectedLanguage,
            items: const [
              DropdownMenuItem(
                value: 'Tiếng Việt',
                child: Text('Tiếng Việt'),
              ),
              DropdownMenuItem(
                value: 'English',
                child: Text('English'),
              ),
            ],
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  _selectedLanguage = value;
                });
              }
            },
            underline: Container(),
          ),
        ),
        
        // Phát âm
        _buildSectionTitle('Phát âm'),
        _buildSettingItem(
          icon: Icons.record_voice_over,
          title: 'Tự động phát âm',
          subtitle: 'Tự động phát âm khi xem từ vựng mới',
          trailing: Switch(
            value: _autoPlayPronunciation,
            onChanged: (value) {
              setState(() {
                _autoPlayPronunciation = value;
              });
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        _buildSettingItem(
          icon: Icons.tune,
          title: 'Cài đặt phát âm nâng cao',
          subtitle: 'Tùy chỉnh tốc độ, ngôn ngữ và nguồn phát âm',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PronunciationSettingsScreen(),
              ),
            );
          },
        ),
        
        // Thông báo
        _buildSectionTitle('Thông báo'),
        _buildSettingItem(
          icon: Icons.notifications,
          title: 'Bật thông báo',
          subtitle: 'Nhận thông báo nhắc nhở học tập',
          trailing: Switch(
            value: _enableNotifications,
            onChanged: (value) {
              setState(() {
                _enableNotifications = value;
              });
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        if (_enableNotifications)
          _buildSettingItem(
            icon: Icons.access_time,
            title: 'Thời gian nhắc nhở',
            subtitle: 'Nhận thông báo mỗi $_reminderTime phút',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _reminderTime > 10 ? () {
                    setState(() {
                      _reminderTime -= 10;
                    });
                  } : null,
                ),
                Text(
                  '$_reminderTime',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _reminderTime < 120 ? () {
                    setState(() {
                      _reminderTime += 10;
                    });
                  } : null,
                ),
              ],
            ),
          ),
        
        // Khác
        _buildSectionTitle('Khác'),
        _buildSettingItem(
          icon: Icons.help_outline,
          title: 'Trợ giúp & Hỗ trợ',
          subtitle: 'Xem hướng dẫn sử dụng ứng dụng',
          onTap: () {
            // Mở trang trợ giúp
          },
        ),
        _buildSettingItem(
          icon: Icons.info_outline,
          title: 'Giới thiệu',
          subtitle: 'Thông tin về ứng dụng',
          onTap: () {
            // Hiển thị thông tin ứng dụng
          },
        ),
        _buildSettingItem(
          icon: Icons.rate_review_outlined,
          title: 'Đánh giá ứng dụng',
          subtitle: 'Đánh giá và góp ý cho chúng tôi',
          onTap: () {
            // Mở trang đánh giá
          },
        ),
        _buildSettingItem(
          icon: Icons.logout,
          title: 'Đăng xuất',
          subtitle: 'Đăng xuất khỏi tài khoản hiện tại',
          textColor: Colors.red,
          onTap: () {
            // Xử lý đăng xuất
            _showLogoutDialog();
          },
        ),
      ],
    );
  }

  Widget _buildUserInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://ui-avatars.com/api/?name=Học+Viên&background=random',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Thông tin người dùng
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Học Viên',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'hocvien@example.com',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Mở trang hồ sơ
                    },
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Chỉnh sửa'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24,
        bottom: 16,
        left: 8,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: trailing,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Xử lý đăng xuất
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'Đăng xuất',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 