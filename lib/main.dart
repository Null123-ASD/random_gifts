import 'package:flutter/material.dart';
import 'dart:async'; // 导入 Timer 所需的库
// import 'AdminLoginScreen.dart'; // 引入 AdminLoginScreen
import 'RandomGiftScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GiftApp());
}

class GiftApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Timer? _timer; // 定义一个计时器变量

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 标题
          Column(
            children: [
              Text(
                "We will choose a\n gift for you",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Let's see what we have in store today",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          // 图片区域
          Image.asset(
            'assets/gift_ps.png',
            height: 250,
            fit: BoxFit.contain,
          ),
          // "Twist" 按钮
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GestureDetector(
              // onLongPressStart: (_) {
              //   // 开始长按时启动计时器
              //   _timer = Timer(Duration(seconds: 5), () {
              //     // 长按 5 秒后跳转到 AdminLoginScreen
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => AdminLoginScreen()),
              //     );
              //   });
              // },
              // onLongPressEnd: (_) {
              //   // 松开按钮时取消计时器
              //   if (_timer != null && _timer!.isActive) {
              //     _timer!.cancel();
              //   }
              // },
              child: ElevatedButton(
                onPressed: () {
                  // 正常点击跳转到 RandomGiftScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RandomGiftScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.card_giftcard, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Twist",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}