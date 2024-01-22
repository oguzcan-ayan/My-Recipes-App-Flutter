import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'recipe_detail_screen.dart';

class RecipesScreen extends StatefulWidget {
  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yemek Tarifleri'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: firestore.collection('recipes').doc('recipes2').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Tarif bulunamadı'));
          }

          List<dynamic> recipes = snapshot.data!['recipes'] ?? [];

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> recipeData = recipes[index];
              String title = recipeData['title'] ?? 'Başlık Yok';
              String imageUrl = recipeData['imageUrl'] ?? 'https://via.placeholder.com/150';
              String description = recipeData['description'] ?? 'Açıklama Yok';
              String preparation = recipeData['preparationContent'] ?? 'No preparation';
              String videoUrl = recipeData['videoUrl'] ?? 'Video';
              List<dynamic> ingredients = recipeData['ingredients'] ?? [];

              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.orange.shade200, // Açık turuncu renk
                        Colors.pink.shade100, // Açık pembe renk
                      ],
                    ),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    leading: Image.network(imageUrl, width: 100, height: 100, fit: BoxFit.cover),
                    title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white70)),
                          SizedBox(height: 5),
                          Text(preparation, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailScreen(
                            documentId: "recipes2",
                            title: title,
                            imageUrl: imageUrl,
                            description: description,
                            preparation: preparation,
                            videoUrl: videoUrl,
                            ingredients: ingredients,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
