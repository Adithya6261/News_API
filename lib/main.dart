import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_code_1/Api_key.dart';
import 'package:device_preview/device_preview.dart';

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const MyApp(), // Wrap your app
  ),
);

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var newslist = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getNews();
  }

  void getNews() async {
    setState(() {
      loading = true;
    });
    try {
      Dio dio = Dio();
      Response response = await dio.get(
          'https://newsapi.org/v2/top-headlines?country=in&category=health&language=en&apiKey=$News_Api_key');
      setState(() {
        newslist = response.data['articles'];
        loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text(
            'News',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: newslist.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.network(
                              newslist[index]['urlToImage'] ?? '',
                              height: 100,
                              width: 100,
                              errorBuilder: (context, error, stackTrace) =>
                                 Image.asset('assets/avatar.jpg')
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  newslist[index]['title'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  newslist[index]['description'] ?? '',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
