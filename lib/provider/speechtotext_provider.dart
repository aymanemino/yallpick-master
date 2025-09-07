import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextProvider extends ChangeNotifier {
  SpeechToText speechToText = SpeechToText();
  final commonWords = [
    'for',
    'I',
    'want',
    'to',
    'buy',
    'and',
    'please',
    'search',
    'how',
    'get',
    'it',
    'this',
    'is',
    'are',
    'best',
    'me'
  ];
  String spokenWords = '';
  bool isListening = false;
  Function(String) _onNavigation;

  // setUpSpeechToText() async {
  //   bool available = await speechToText.initialize(
  //       // onStatus: (val) => print('STATUS ====> $val'),
  //       // onError: (val) => print('ERROR ====> $val'),
  //       );
  //   print('IS INITIALIZED SPEECH TO TEXT ====> $available');
  //   if (available) {
  //     onListen();
  //   } else {
  //     onStopListen();
  //   }
  //   notifyListeners();
  // }

  init() async {
    bool available = await speechToText.initialize();
    print('IS INITIALIZED SPEECH TO TEXT ====> $available');
    if (available) {
      onListen();
      Future.delayed(
        Duration(seconds: 5),
        () {
          onStopListen();
          _onNavigation(cleanRecognizedWords());
          print('NAVIGATION ::::: ');
        },
      );
    }
    notifyListeners();
  }

  onListen() {
    isListening = true;
    speechToText.listen(
      onResult: onSpeechResult,
    );
    notifyListeners();
  }

  onSpeechResult(SpeechRecognitionResult result) {
    spokenWords = result.recognizedWords;
    print('SPOKEN WORDS =====>> $spokenWords');
    notifyListeners();
  }

  onStopListen() {
    isListening = false;
    speechToText.stop();
    print('STOP LISTENING');
    notifyListeners();
  }

  void setupNavigationCallback(Function(String) onNavigation) {
    _onNavigation = onNavigation;
  }

  cleanRecognizedWords() {
    String product = spokenWords;
    for (String value in commonWords) {
      product = product.replaceAll(value, "");
      notifyListeners();
      print('===========>  ::::::::: $product');
    }
    return product.trim();
  }
}
