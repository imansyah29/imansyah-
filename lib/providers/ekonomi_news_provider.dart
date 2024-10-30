import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_news/models/ekonomi_news_model.dart';

class EkonomiNewsProvider with ChangeNotifier {
  List<EkonomiNewsModel> _ekonomiList = [];
  bool _isLoading = false;

  List<EkonomiNewsModel> get ekonomiList => _ekonomiList;
  bool get isLoading => _isLoading;

  Future<void> fetchEkonomiNews() async {
    _isLoading = true;
    notifyListeners();

    final url =
        Uri.parse('https://api-berita-indonesia.vercel.app/cnn/ekonomi/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        _ekonomiList = [EkonomiNewsModel.fromJson(data)];
      }
    } catch (error) {
      rethrow;
    }

    _isLoading = false;
    notifyListeners();
  }
}