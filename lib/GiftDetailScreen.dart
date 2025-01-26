import 'dart:io'; // 用于加载本地图片
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GiftDetailScreen extends StatelessWidget {
  final Map<String, dynamic> gift;
  final Color backgroundColor;

  GiftDetailScreen({
    required this.gift,
    required this.backgroundColor,
  });

  /// 打开 URL 链接
  Future<void> _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  /// 构建礼物图片显示逻辑
  Widget _buildGiftImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      // 路径为空，显示占位图
      return Image.asset(
        "assets/placeholder.png",
        height: 200,
        fit: BoxFit.cover,
      );
    } else if (imagePath.startsWith('http')) {
      // 网络图片路径
      return Image.network(
        imagePath,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "assets/placeholder.png",
            height: 200,
            fit: BoxFit.cover,
          );
        },
      );
    } else if (File(imagePath).existsSync()) {
      // 本地文件路径（永久存储目录中的文件）
      return Image.file(
        File(imagePath),
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      try {
        // 如果路径指向的是 `assets/` 文件夹中的图片
        return Image.asset(
          imagePath,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              "assets/placeholder.png",
              height: 200,
              fit: BoxFit.cover,
            );
          },
        );
      } catch (e) {
        // 如果加载失败，返回占位图
        return Image.asset(
          "assets/placeholder.png",
          height: 200,
          fit: BoxFit.cover,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Text(
              "Random Gifts",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 20),
            // 显示礼物图片
            _buildGiftImage(gift["image"]),
            SizedBox(height: 20),
            Text(
              gift["name"] ?? "Unknown Gift",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              gift["type"] ?? "Unknown Type",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 20),
            // 显示价格
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_fire_department, color: Colors.redAccent),
                  SizedBox(width: 8),
                  Text(
                    gift["price"] ?? "N/A",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // 按钮：返回到随机礼物页面
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("One more time"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 12),
              ),
            ),
            SizedBox(height: 10),
            // 按钮：跳转到礼物链接
            ElevatedButton(
              onPressed: () async {
                final url = gift["link"] ?? "";
                if (url.isNotEmpty) {
                  await _launchURL(context, url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No URL available')),
                  );
                }
              },
              child: Text("Check on marketplace"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}