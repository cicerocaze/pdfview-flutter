import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_pdf_viewer/api/pdf_api.dart';
import 'package:test_pdf_viewer/page/pdf_viewer_page.dart';
import 'package:test_pdf_viewer/widget/button_widget.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'PDF Viewer';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonWidget(
                  text: 'Asset PDF',
                  onClicked: () async {
                    final path = 'assets/sample.pdf';
                    final file = await PDFApi.loadAsset(path);
                    openPDF(context, file);
                  },
                ),
                const SizedBox(height: 16),
                ButtonWidget(
                  text: 'File PDF',
                  onClicked: () async {
                    final file = await PDFApi.pickFile();

                    if (file == null) return;
                    openPDF(context, file);
                  },
                ),
                const SizedBox(height: 16),
                ButtonWidget(
                  text: 'Network PDF',
                  onClicked: () async {
                    //It needs to be https
                    final url =
                        "https://www.accesstage.com.br/boleto/link-boleto?l=N&b=341&t=32340008&h=0&c=1779201919";
                    final url2 =
                        "http://www.africau.edu/images/default/sample.pdf";
                    print("url: $url");
                    final file = await PDFApi.loadNetwork(url2);
                    openPDF(context, file);
                  },
                ),
              ],
            ),
          ),
        ),
      );

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
      );
}
