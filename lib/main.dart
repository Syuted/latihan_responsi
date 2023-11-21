import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latihan Responsi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> data = [];
  String selectedMenu = 'News';

  @override
  void initState() {
    super.initState();
    loadData(selectedMenu);
  }

  Future<void> loadData(String menu) async {
    String endpoint = getMenuEndpoint(menu);
    final response = await http.get(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  String getMenuEndpoint(String menu) {
    switch (menu) {
      case 'News':
        return 'https://api.spaceflightnewsapi.net/v4/articles/?format=json';
      case 'Blog':
        return 'https://api.spaceflightnewsapi.net/v4/blogs/?format=json';
      case 'Reports':
        return 'https://api.spaceflightnewsapi.net/v4/reports/?format=json';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Space News App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    selectMenu('News');
                  },
                  child: const Text('News'),
                ),
                ElevatedButton(
                  onPressed: () {
                    selectMenu('Blog');
                  },
                  child: const Text('Blog'),
                ),
                ElevatedButton(
                  onPressed: () {
                    selectMenu('Reports');
                  },
                  child: const Text('Reports'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index]['title']),
                    subtitle: Text(data[index]['summary']),
                    onTap: () {
                      // Tampilkan detail jika diperlukan
                      showDetailDialog(data[index]['title'], data[index]['url']);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void selectMenu(String menu) {
    setState(() {
      selectedMenu = menu;
    });
    loadData(menu);
  }

  void showDetailDialog(String title, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('URL: $url'),
                // Tambahkan informasi detail lainnya jika diperlukan
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
