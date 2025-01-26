import 'dart:io';
import 'package:flutter/material.dart';
import 'database_helper.dart';

class ViewGiftsScreen extends StatefulWidget {
  @override
  _ViewGiftsScreenState createState() => _ViewGiftsScreenState();
}

class _ViewGiftsScreenState extends State<ViewGiftsScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> gifts = [];

  @override
  void initState() {
    super.initState();
    _loadGifts();
  }

  Future<void> _loadGifts() async {
    final fetchedGifts = await _dbHelper.fetchAllGifts();
    setState(() {
      gifts = fetchedGifts;
    });
  }

  // 构建礼物图片，根据路径类型处理
  Widget _buildGiftImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      // 空路径，显示占位图
      return Image.asset(
        "assets/placeholder.png",
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } else if (imagePath.startsWith('http')) {
      // 网络图片
      return Image.network(
        imagePath,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "assets/placeholder.png",
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          );
        },
      );
    } else if (File(imagePath).existsSync()) {
      // 本地文件路径
      return Image.file(
        File(imagePath),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } else {
      try {
        // 如果是 `assets/` 中的图片路径
        return Image.asset(
          imagePath,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        );
      } catch (e) {
        // 无效路径，显示占位图
        return Image.asset(
          "assets/placeholder.png",
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Gifts"),
        backgroundColor: Colors.red,
      ),
      body: gifts.isEmpty
          ? Center(child: Text("No gifts available"))
          : ListView.builder(
        itemCount: gifts.length,
        itemBuilder: (context, index) {
          final gift = gifts[index];
          return ListTile(
            leading: _buildGiftImage(gift['image']), // 使用处理后的图片加载方法
            title: Text(gift['name']),
            subtitle: Text("${gift['type']} - ${gift['price']}"),
          );
        },
      ),
    );
  }
}