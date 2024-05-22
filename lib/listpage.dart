import 'package:flutter/material.dart';
import 'API/API.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'detailpage.dart';

class HalamanUtama extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<HalamanUtama> {
  late Future<List<dynamic>> _remote_jobs;

  @override
  void initState() {
    super.initState();
    _remote_jobs = _fetchSets();
  }

  Future<List<dynamic>> _fetchSets() async {
    final response = await http.get(Uri.parse('$API_LINK/remote_jobs'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal Memuat API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Page'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _remote_jobs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final set = snapshot.data![index];
                  final logoUrl = set['logo'] ?? '';
                  final symbolUrl = set['symbol'] ?? '';
                  return GestureDetector(
                    onTap: () {
                      // Navigate to DetailSetsPage when a card is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(setId: set['id']),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
