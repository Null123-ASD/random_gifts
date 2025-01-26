import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'; // 用于本地文件处理
import 'database_helper.dart';

class AddGiftScreen extends StatefulWidget {
  const AddGiftScreen({Key? key}) : super(key: key);

  @override
  _AddGiftScreenState createState() => _AddGiftScreenState();
}

class _AddGiftScreenState extends State<AddGiftScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ImagePicker _picker = ImagePicker();
  String? _selectedImagePath;

  bool _showGuide = false;

  @override
  void initState() {
    super.initState();
    _checkFirstUse();
  }

  Future<void> _checkFirstUse() async {
    final prefs = await SharedPreferences.getInstance();
    // 測試期間重置數據
    await prefs.remove('addGiftFirstUse'); // 測試時清理數據
    final isFirstUse = prefs.getBool('addGiftFirstUse') ?? true;
    print('Is first use: $isFirstUse'); // 調試輸出

    if (isFirstUse) {
      setState(() {
        _showGuide = true;
      });
      await prefs.setBool('addGiftFirstUse', false);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

  Future<void> _addGift() async {
    if (nameController.text.isEmpty ||
        typeController.text.isEmpty ||
        priceController.text.isEmpty ||
        _selectedImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields and pick an image")),
      );
      return;
    }

    final gift = {
      'name': nameController.text,
      'type': typeController.text,
      'price': priceController.text,
      'image': _selectedImagePath,
      'link': linkController.text,
    };

    await _dbHelper.insertGift(gift);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gift added successfully!')),
    );

    nameController.clear();
    typeController.clear();
    priceController.clear();
    linkController.clear();
    setState(() {
      _selectedImagePath = null;
    });
  }

  void _hideGuide() {
    setState(() {
      _showGuide = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload a New Gifts"),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          // 限制 SingleChildScrollView 的高度
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: _selectedImagePath == null
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_a_photo, size: 40.0),
                            Text("Pick Gifts Image"),
                          ],
                        )
                            : Image.file(File(_selectedImagePath!), fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Name"),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: typeController,
                    decoration: const InputDecoration(labelText: "Type"),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: "Price"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: linkController,
                    decoration: const InputDecoration(labelText: "link(e.g): https://www.jbl.com/"),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: _addGift,
                          child: const Text("Upload Gifts"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Clear"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 引導提示覆蓋層
          if (_showGuide)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7), // 背景半透明黑色
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.touch_app, size: 100, color: Colors.white),
                    const SizedBox(height: 20),
                    const Text(
                      "Long press the image area to select a gift image\n"
                      "Please fill in according to the\n example below to avoid mistakes\n\n"
                      "Name: Apple Watch 5\n"
                      "Type: Smart watch\n"
                      "Price: \$299.00\n"
                      "Link: https://www.apple.com/watch/",
                      style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold,),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _hideGuide, // 隱藏引導層
                      child: const Text("Finish"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}