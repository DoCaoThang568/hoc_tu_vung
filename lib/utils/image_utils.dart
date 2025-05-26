import 'package:flutter/material.dart';

/// Các hàm tiện ích để cải thiện hiển thị hình ảnh trên các thiết bị có mật độ pixel cao
class ImageUtils {
  /// Tải hình ảnh với chất lượng phù hợp với mật độ pixel của thiết bị
  static Image getOptimizedImage({
    required String assetPath,
    double? width,
    double? height,
    BoxFit? fit,
    BuildContext? context,
    Color? color,
  }) {
    double dpr = context != null ? MediaQuery.of(context).devicePixelRatio : 1.0;
    
    // Sử dụng cacheWidth để tránh tải hình ảnh quá lớn vào bộ nhớ
    int? cacheWidth, cacheHeight;
    
    if (width != null) {
      cacheWidth = (width * dpr).round();
    }
    
    if (height != null) {
      cacheHeight = (height * dpr).round();
    }
    
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
      filterQuality: FilterQuality.high,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      color: color,
      isAntiAlias: true, // Áp dụng anti-aliasing để làm mịn hình ảnh
    );
  }
  
  /// Tạo container với hình ảnh nền được tối ưu
  static Widget buildOptimizedBackgroundImage({
    required String assetPath,
    required BuildContext context,
    required Widget child,
    BoxFit fit = BoxFit.cover,
  }) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(assetPath),
          fit: fit,
          filterQuality: FilterQuality.high,
        ),
      ),
      child: child,
    );
  }
  
  /// Tải hình ảnh từ mạng với chất lượng cao
  static Image getOptimizedNetworkImage({
    required String url,
    double? width,
    double? height,
    BoxFit? fit,
    BuildContext? context,
  }) {
    double dpr = context != null ? MediaQuery.of(context).devicePixelRatio : 1.0;
    
    int? cacheWidth, cacheHeight;
    
    if (width != null) {
      cacheWidth = (width * dpr).round();
    }
    
    if (height != null) {
      cacheHeight = (height * dpr).round();
    }
    
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
      filterQuality: FilterQuality.high,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      isAntiAlias: true,
    );
  }
} 