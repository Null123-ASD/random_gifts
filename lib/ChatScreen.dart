import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // 在這裡替換為你的 OpenAI API Key
  final String apiKey = "sk-iy7aTLE5TvdRWt6Z9sqGqR7Kk8x3jK0zbVdJypVyemKe0AFJ";

  Future<void> _sendMessage(String message) async {
    setState(() {
      _isLoading = true;
      _messages.add({"user": message});
    });

    try {
      final response = await http.post(
        Uri.parse("https://api.chatanywhere.tech/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": message},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data["choices"][0]["message"]["content"];
        setState(() {
          _messages.add({"bot": reply});
        });
      } else {
        setState(() {
          _messages.add({"bot": "Sorry, something went wrong."});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"bot": "Error: $e"});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Easy ChatGPT"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  Widget messageWidget;

                  if (message.containsKey("user")) {
                    messageWidget = ListTile(
                      title: Text(
                        message["user"]!,
                        style: TextStyle(color: Colors.white),
                      ),
                      tileColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    );
                  } else if (message.containsKey("bot")) {
                    messageWidget = ListTile(
                      title: Text(
                        message["bot"]!,
                        style: TextStyle(color: Colors.black),
                      ),
                      tileColor: Colors.green[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    );
                  } else {
                    return SizedBox.shrink();
                  }

                  return Column(
                    children: [
                      messageWidget,
                      SizedBox(height: 8),
                    ],
                  );
                },
              ),
            ),
            if (_isLoading) CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Write here...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      final message = _controller.text.trim();
                      if (message.isNotEmpty) {
                        _controller.clear();
                        _sendMessage(message);
                      }
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
}
