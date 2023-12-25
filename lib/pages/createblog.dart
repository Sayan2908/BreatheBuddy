import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CreateBlogPage extends StatelessWidget {

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> addBlogDetails(String title, String description) async {

    String id = Uuid().v1();
    DateTime time = DateTime.now();

    await FirebaseFirestore.instance.collection('blogs').add({
      'id' : id,
      'title' : title,
      'description' : description,
      'time' : time,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Blog'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter blog title...',
              ),
              controller: _titleController,
            ),
            SizedBox(height: 16),
            Text(
              'Content:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter blog content...',
                ),
                controller: _descriptionController,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle saving blog logic here
          // For simplicity, we'll just navigate back for now
          addBlogDetails(_titleController.text.trim() , _descriptionController.text.trim());
          Navigator.pop(context);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
