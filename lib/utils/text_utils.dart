import 'package:flutter/material.dart';

/// Các hàm tiện ích để giúp hiển thị text chất lượng cao trên các thiết bị có mật độ pixel cao
class TextUtils {
  /// Tính toán kích thước font phù hợp với mật độ pixel của thiết bị
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    double scaleFactor = MediaQuery.of(context).textScaleFactor;
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    
    // Điều chỉnh kích thước phù hợp với mật độ pixel
    // Giảm kích thước một chút khi mật độ pixel cao để tránh text quá lớn
    if (devicePixelRatio > 2.5) {
      scaleFactor = scaleFactor * 0.95;
    }
    
    return baseFontSize * scaleFactor;
  }
  
  /// Tạo TextStyle với kích thước font được điều chỉnh
  static TextStyle getResponsiveTextStyle(
    BuildContext context,
    TextStyle baseStyle,
  ) {
    final fontSize = baseStyle.fontSize;
    if (fontSize == null) return baseStyle;
    
    return baseStyle.copyWith(
      fontSize: getResponsiveFontSize(context, fontSize),
      height: baseStyle.height != null
          ? baseStyle.height! * 1.05  // Tăng line height để cải thiện khả năng đọc
          : 1.2,
    );
  }
  
  /// Tạo văn bản sắc nét hơn bằng cách tối ưu hóa rendering
  static Text createOptimizedText(
    String text, {
    Key? key,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    BuildContext? context,
  }) {
    TextStyle? adjustedStyle = style;
    
    if (context != null && style != null) {
      adjustedStyle = getResponsiveTextStyle(context, style);
    }
    
    return Text(
      text,
      key: key,
      style: adjustedStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      textScaleFactor: 1.0, // Ngăn chặn tự động scale của hệ thống
      softWrap: true,
      textWidthBasis: TextWidthBasis.longestLine, // Cải thiện hiển thị khi wrap text
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: true,
        applyHeightToLastDescent: true,
      ),
    );
  }
} 