// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:io';
import 'package:flutter_application_2/classifier.dart';
import 'package:flutter_application_2/classifier_quant.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Classification',
      home: SplashScreen(
        seconds: 8,
        navigateAfterSeconds: const MyHomePage(title: 'Image Classifier'),
        title: const Text(
          'Fruit Classifier',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
          ),
        ),
        backgroundColor: Colors.orange[200],
        image: Image.asset("assets/splash.png"),
        photoSize: 100,
        loaderColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Classifier _classifier;

  var logger = Logger();

  File? _image;
  final picker = ImagePicker();

  Image? _imageWidget;

  img.Image? fox;

  Category? category;

  @override
  void initState() {
    super.initState();
    _classifier = ClassifierQuant();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
      _imageWidget = Image.file(_image!);

      _predict();
    });
  }

  void _predict() async {
    img.Image imageInput = img.decodeImage(_image!.readAsBytesSync())!;
    var pred = _classifier.predict(imageInput);

    setState(() {
      category = pred;
    });
  }

  void mycustom() {
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Fruit Classifier',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: Colors.deepOrangeAccent[100],
      ),
      body: Container(
        color: const Color(0xFFE6EE9C),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(
                top: 10,
              ),
            ),
            Center(
              child: _image == null
                  ? const Text('No image selected.')
                  : Container(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height / 2),
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: _imageWidget,
                    ),
            ),
            const SizedBox(
              height: 36,
            ),
            Text(
              category != null &&
                      (category!.label == "orange" ||
                          category!.label == "banana" ||
                          category!.label == "lemon" ||
                          category!.label == "strawberry" ||
                          category!.label == "fig" ||
                          category!.label == "pineapple" ||
                          category!.label == "custard apple")
                  ? "The above fruit is a ${category!.label}"
                  : 'UNIDENTIFIABLE',
                  
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              category != null &&
                      (category!.label == "orange" ||
                          category!.label == "banana" ||
                          category!.label == "lemon" ||
                          category!.label == "strawberry" ||
                          category!.label == "fig" ||
                          category!.label == "pineapple" ||
                          category!.label == "custard apple")
                  ? 'Guess: ${category!.score.toStringAsFixed(3)}%'
                  : '',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(60),
            shadowColor: Colors.deepOrangeAccent,
            primary: Colors.deepOrangeAccent[100],
          ),
          onPressed: getImage,
          child: const Text(
            'UPLOAD IMAGE',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        borderOnForeground: false,
        color: Colors.deepOrangeAccent[100],
      ),
    );
  }
}
