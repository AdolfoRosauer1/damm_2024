import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:damm_2024/models/news.dart';
import 'package:damm_2024/services/analytics_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';


class NewsService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AnalyticsService _analyticsService = AnalyticsService();

void shareNews(News news) async {
  try {
    final http.Response response = await http.get(Uri.parse(news.imageUrl));
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/${news.id}.png');
    await file.writeAsBytes(response.bodyBytes);
    final XFile xfile = XFile(file.path);

    await Share.shareXFiles(
      [xfile],
      text: news.description,
    );
    _analyticsService.logShareNews(news.id, FirebaseAuth.instance.currentUser!.uid);
  } catch (e) {
    print('Error sharing news: $e');
  }
}

  Future<News?> getNewsById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('news').doc(id).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        var imageUrl = await _storage.ref().child(data['imagePath']).getDownloadURL();
        data['id'] = id;
        data['imageUrl'] = imageUrl;
        return News.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting news by id: $e");
      return null;
    }
  }

  Future<List<News>> getNews() async{

    List<News> news = [];
    QuerySnapshot snapshot = await _firestore.collection('news').get();

    for (var element in snapshot.docs) {
      var data = element.data() as Map<String,dynamic>;
      var imageUrl = await _storage.ref().child(data['imagePath']).getDownloadURL();
      data['id'] = element.id;
      data['imageUrl'] = imageUrl;
      news.add(News.fromJson(data));
    }

    return news;
  }
}