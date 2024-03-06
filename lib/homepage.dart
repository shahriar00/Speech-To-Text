import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  stt.SpeechToText speechToText = stt.SpeechToText();
  String recoznizedText = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  void initSpeechState() async {
    bool available = await speechToText.initialize();
    if (!mounted) return;

    setState(() {
      isLoading = available;
    });
  }

  void isListening() {
    speechToText.listen(onResult: (result) {
      setState(() {
        recoznizedText = result.recognizedWords;
      });
    });
    setState(() {
      isLoading = true;
    });
  }

  void copyText() {
    Clipboard.setData(ClipboardData(text: recoznizedText));
  }

  void clearText() {
    setState(() {
      recoznizedText = "";
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Text Copied")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        backgroundColor: Colors.blue,
        centerTitle: true,
        title:const  Text("Speech To Text Converter",style: TextStyle(fontSize: 20, color: Colors.black),),
      ),
      body: Center(
        child: Column(
          children: [
           const Padding(
              padding:  EdgeInsets.only(top: 90),
              child:  Text(
                "Speech Recognition",
                style: TextStyle(fontSize: 20, color: Colors.blue),
              ),
            ),
           const  SizedBox(
              height: 20,
            ),
            IconButton(
              onPressed: () {
                isListening();
              },
              icon: Icon(isLoading ? Icons.mic : Icons.mic_none),
              iconSize: 100,
              color: isLoading ? Colors.red : Colors.grey,
            ),
           const SizedBox(
              height: 20,
            ),
            Container(
                height: 400,
                width: 400,
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  recoznizedText.isNotEmpty? recoznizedText : "Result Here.......",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )),
           const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: recoznizedText.isNotEmpty ? copyText : null,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Copy",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              const  SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: recoznizedText.isNotEmpty ? clearText : null,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 229, 7, 7),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Clear",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
