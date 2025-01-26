import 'dart:io';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ModificationDeletionScreen extends StatefulWidget {
  @override
  _ModificationDeletionScreenState createState() =>
      _ModificationDeletionScreenState();
}

class _ModificationDeletionScreenState extends State<ModificationDeletionScreen> {
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

  Future<void> _deleteGift(int id, bool isDefault) async {
    if (isDefault) {
      _showError("This gift cannot be deleted.");
      return;
    }
    await _dbHelper.deleteGift(id);
    _loadGifts(); // 刷新列表
  }

  Future<void> _modifyGift(int id, Map<String, dynamic> updatedGift, bool isDefault) async {
    if (isDefault) {
      _showError("This gift cannot be modified.");
      return;
    }
    await _dbHelper.updateGift(id, updatedGift);
    _loadGifts(); // 刷新列表
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _openEditDialog(BuildContext context, Map<String, dynamic> gift) {
    final TextEditingController nameController =
    TextEditingController(text: gift['name']);
    final TextEditingController typeController =
    TextEditingController(text: gift['type']);
    final TextEditingController priceController =
    TextEditingController(text: gift['price']);
    final TextEditingController linkController =
    TextEditingController(text: gift['link']);
    File? selectedImageFile =
    gift['image'] != null && File(gift['image']).existsSync()
        ? File(gift['image'])
        : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Gift"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(labelText: "Type"),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: "Price"),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final pickedImage = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (pickedImage != null) {
                          final permanentImagePath =
                          await _saveImageToPermanentDirectory(
                              File(pickedImage.path));
                          setState(() {
                            selectedImageFile = File(permanentImagePath);
                          });
                        }
                      },
                      child: Text("Select Image"),
                    ),
                    SizedBox(width: 10),
                    selectedImageFile != null
                        ? Image.file(
                      selectedImageFile!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, color: Colors.grey),
                    ),
                  ],
                ),
                TextField(
                  controller: linkController,
                  decoration: InputDecoration(labelText: "Link"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                final updatedGift = {
                  'name': nameController.text,
                  'type': typeController.text,
                  'price': priceController.text,
                  'image': selectedImageFile?.path ?? gift['image'],
                  'link': linkController.text,
                };

                _modifyGift(gift['id'], updatedGift, gift['isDefault'] == 1);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<String> _saveImageToPermanentDirectory(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    final newFilePath =
        '$path/${DateTime.now().millisecondsSinceEpoch}_${imageFile.uri.pathSegments.last}';
    final newFile = await imageFile.copy(newFilePath);
    return newFile.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modify or Delete Gifts"),
        backgroundColor: Colors.red,
      ),
      body: gifts.isEmpty
          ? Center(child: Text("No gifts available"))
          : ListView.builder(
        itemCount: gifts.length,
        itemBuilder: (context, index) {
          final gift = gifts[index];
          final isDefault = gift['isDefault'] == 1; // 檢查是否是預設禮物
          return ListTile(
            title: Text(gift['name']),
            subtitle: Text(gift['type']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    if (isDefault) {
                      _showError("This gift cannot be modified.");
                    } else {
                      _openEditDialog(context, gift);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteGift(gift['id'], isDefault);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}