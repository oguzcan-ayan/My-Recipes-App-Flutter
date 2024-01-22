// RecipeDetailScreen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String documentId;
  final String title;
  final String imageUrl;
  final String description;
  final String preparation;
  final String videoUrl;
  final List<dynamic> ingredients;

  const RecipeDetailScreen({
    Key? key,
    required this.documentId,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.preparation,
    required this.videoUrl,
    required this.ingredients,
  }) : super(key: key);

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late String currentPreparation;
  final TextEditingController _preparationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentPreparation = widget.preparation;
    _preparationController.text = currentPreparation;
  }

  @override
  void dispose() {
    _preparationController.dispose();
    super.dispose();
  }

  Future<void> _updatePreparation() async {
    await FirebaseFirestore.instance
        .collection('recipes')
        .doc(widget.documentId)
        .update({'preparation': _preparationController.text});
    setState(() {
      currentPreparation = _preparationController.text;
    });
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hazırlık Düzenle'),
          content: TextField(
            controller: _preparationController,
            maxLines: null,
            decoration: InputDecoration(hintText: 'Hazırlık kısmını giriniz'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('İptal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Kaydet'),
              onPressed: () async {
                await _updatePreparation();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _showEditDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(widget.imageUrl, fit: BoxFit.cover, height: 200),
            SizedBox(height: 8),
            if (widget.videoUrl.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(widget.videoUrl, style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
              ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.ingredients.map((item) => Text('• $item', style: TextStyle(fontSize: 16))).toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(widget.description, style: TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(currentPreparation, style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
