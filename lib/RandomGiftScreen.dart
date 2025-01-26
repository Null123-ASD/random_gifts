import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'GiftDetailScreen.dart'; // 导入礼物详情页面
import 'database_helper.dart'; // 导入数据库助手
import 'DashboardScreen.dart'; // 导入 DashboardScreen

class RandomGiftScreen extends StatefulWidget {
  @override
  _RandomGiftScreenState createState() => _RandomGiftScreenState();
}

class _RandomGiftScreenState extends State<RandomGiftScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> gifts = [];
  final List<Color> cardColors = [
    Colors.purple[200]!,
    Colors.blue[400]!,
    Colors.orange[700]!,
    Colors.teal[600]!,
    Colors.yellow[800]!,
  ];

  late PageController _pageController;
  bool _isTwisting = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 5000, viewportFraction: 0.8);
    _loadGifts();
  }

  Future<void> _loadGifts() async {
    // 从数据库中获取礼物信息
    final fetchedGifts = await _dbHelper.fetchAllGifts();

    // 如果数据库为空，插入默认礼物数据
    if (fetchedGifts.isEmpty) {
      final defaultGifts = [
        {
          "image": "assets/watch.png",
          "name": "Apple Watch 5",
          "type": "Smart watch",
          "price": "\$299.00",
          "link": "https://www.apple.com/watch/",
          "isDefault": 1,
        },
        {
          "image": "assets/game.png",
          "name": "Gaming Console",
          "type": "Gaming",
          "price": "\$499.00",
          "link": "https://www.playstation.com/",
          "isDefault": 1,
        },
        {
          "image": "assets/phone.png",
          "name": "Smartphone",
          "type": "Mobile",
          "price": "\$799.00",
          "link": "https://www.samsung.com/",
          "isDefault": 1,
        },
        {
          "image": "assets/shoes.png",
          "name": "Sneakers",
          "type": "Fashion",
          "price": "\$89.00",
          "link": "https://www.nike.com/",
          "isDefault": 1,
        },
        {
          "image": "assets/speakers.png",
          "name": "Bluetooth Speaker",
          "type": "Audio",
          "price": "\$199.00",
          "link": "https://www.jbl.com/",
          "isDefault": 1,
        },
      ];

      // 插入默认数据到数据库
      for (var gift in defaultGifts) {
        await _dbHelper.insertGift(gift);
      }

      gifts = defaultGifts;
    } else {
      gifts = fetchedGifts;
    }

    setState(() {});
  }

  Widget _buildGiftImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Image.asset(
        "assets/placeholder.png",
        height: 200,
        fit: BoxFit.cover,
      );
    } else if (imagePath.startsWith('http')) {
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
      return Image.file(
        File(imagePath),
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      try {
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
        return Image.asset(
          "assets/placeholder.png",
          height: 200,
          fit: BoxFit.cover,
        );
      }
    }
  }

  Future<void> _startRandomTwisting() async {
    if (_isTwisting) return;
    _isTwisting = true;

    Random random = Random();
    int twistCount = 15 + random.nextInt(15);

    for (int i = 0; i < twistCount; i++) {
      await Future.delayed(Duration(milliseconds: 60));
      _pageController.nextPage(
        duration: Duration(milliseconds: 80),
        curve: Curves.easeInOut,
      );
    }

    setState(() {
      _isTwisting = false;
    });

    final selectedIndex = _pageController.page!.toInt() % gifts.length;
    final selectedGift = gifts[selectedIndex];
    final selectedColor = cardColors[selectedIndex % cardColors.length];

    _navigateToGiftDetail(selectedGift, selectedColor);
  }

  void _navigateToGiftDetail(Map<String, dynamic> gift, Color cardColor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GiftDetailScreen(
          gift: gift,
          backgroundColor: cardColor,
        ),
      ),
    );
  }

  Widget _buildGiftCard(Map<String, dynamic> gift, Color cardColor) {
    final imagePath = gift['image'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 60.0),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 190,
              height: 190,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildGiftImage(imagePath),
              ),
            ),
            SizedBox(height: 12),
            Text(
              gift["name"] ?? "Unknown Gift",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              gift["type"] ?? "Unknown Type",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[50],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.purple, // 背景色
              borderRadius: BorderRadius.circular(8), // 圆角
              border: Border.all(color: Colors.white, width: 2), // 边框
            ),
            child: IconButton(
              icon: Icon(Icons.add, color: Colors.white), // 加号图标
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: gifts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    "Loading gifts...",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: Text(
                    "Over 1200 Random Gifts\nfor Everyone",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      final gift = gifts[index % gifts.length];
                      final cardColor = cardColors[index % cardColors.length];
                      return GestureDetector(
                        onTap: () => _navigateToGiftDetail(gift, cardColor),
                        child: _buildGiftCard(gift, cardColor),
                      );
                    },
                  ),
                ),
                Icon(Icons.arrow_drop_up, size: 80, color: Colors.black),
                GestureDetector(
                  onTap: _startRandomTwisting,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                    child: Text(
                      _isTwisting ? "Twisting..." : "Twisting",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 80),
              ],
            ),
    );
  }
}
