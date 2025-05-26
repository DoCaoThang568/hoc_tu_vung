                    // Hiển thị danh sách chủ đề - đã sửa để không dùng AnimationLimiter
                    SizedBox(
                      height = 50,
                      child = ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _topics.length,
                        itemBuilder: (context, index) {
                          return _buildTopicButton(index);
                        },
                      ),
                    ), 