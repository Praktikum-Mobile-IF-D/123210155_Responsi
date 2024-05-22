import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'API/API.dart';

class DetailPage extends StatefulWidget {
  final String setId;

  DetailPage({required this.setId});

  @override
  _DetailSetsPageState createState() => _DetailSetsPageState();
}

class _DetailSetsPageState extends State<DetailPage> {
  late Future<Map<String, dynamic>> _setDetails;

  @override
  void initState() {
    super.initState();
    _setDetails = _fetchSetDetails();
  }

  Future<Map<String, dynamic>> _fetchSetDetails() async {
    final response =
    await http.get(Uri.parse('$API_LINK/sets/${widget.setId}'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal Memuat Detail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Detail'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _setDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final setDetails = snapshot.data!;
            var logos = setDetails['logo'] ?? '';
            if (logos.isNotEmpty) {
              if (!logos.endsWith('.png')) {
                logos += '.png';
              }
            } else {
              logos = 'https://via.placeholder.com/100';
            }
            String symbols = setDetails['symbol'] ?? '';
            if (symbols.isNotEmpty) {
              if (!symbols.endsWith('.png')) {
                symbols += '.png';
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Image.network(
                  logos,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10),
                Text(
                  setDetails['name'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Release Date: ${setDetails['releaseDate']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 20),
                    if (symbols.isNotEmpty)
                      Image.network(
                        symbols,
                        width: 30,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: setDetails['cards'].length,
                      itemBuilder: (context, index) {
                        final card = setDetails['cards'][index];
                        String cardImage = card['image'] ?? '';
                        if (cardImage.isNotEmpty) {
                          if (!cardImage.endsWith('.png')) {
                            cardImage += '/high.png';
                          }
                        } else {
                          cardImage = 'https://via.placeholder.com/100';
                        }
                        return AspectRatio(
                          aspectRatio: 2 / 3, // Set aspect ratio to 2:3
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    cardImage,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  card['name'],
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
