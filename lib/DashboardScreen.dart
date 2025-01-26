import 'package:flutter/material.dart';
import 'AddGiftScreen.dart';
import 'ModificationDeletionScreen.dart';
import 'ViewGiftsScreen.dart';
import 'RandomGiftScreen.dart';
import 'ChatScreen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => RandomGiftScreen()), // 修改这里
            );
          },
        ),
        title: Text(
          "Dashboard Screen",
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 功能选项网格布局
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // 每行两个选项
                crossAxisSpacing: 16.0, // 水平间距
                mainAxisSpacing: 16.0, // 垂直间距
                children: [
                  // Add a New Gift
                  _buildDashboardCard(
                    context,
                    icon: Icons.add,
                    title: "Add a New Gift",
                    subtitle: "Create a new gift",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddGiftScreen()),
                      );
                    },
                  ),
                  // Modification and Deletion
                  _buildDashboardCard(
                    context,
                    icon: Icons.edit,
                    title: "Modification and Deletion",
                    subtitle: "Modify or delete a gift",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ModificationDeletionScreen()),
                      );
                    },
                  ),
                  // View Gifts
                  _buildDashboardCard(
                    context,
                    icon: Icons.card_giftcard,
                    title: "View Gifts",
                    subtitle: "View all gifts",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewGiftsScreen()),
                      );
                    },
                  ),
                  //Chat Box
                  _buildDashboardCard(
                    context,
                    icon: Icons.chat,
                    title: "Chat Box",
                    subtitle: "Chat with GPT",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建单个功能卡片
  Widget _buildDashboardCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey.shade300, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.0, color: Colors.black),
            SizedBox(height: 16.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
