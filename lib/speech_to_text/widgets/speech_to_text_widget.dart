import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/speech_to_text/speech_to_text_result.dart';
import 'package:flutter_sixvalley_ecommerce/speech_to_text/widgets/empty_data_widget.dart';
import 'package:provider/provider.dart';
import '../../provider/speechtotext_provider.dart';

class SpeechToTextWidget extends StatefulWidget {
  SpeechToTextWidget({Key key}) : super(key: key);

  @override
  _SpeechToTextWidgetState createState() => _SpeechToTextWidgetState();
}

class _SpeechToTextWidgetState extends State<SpeechToTextWidget> {
  late SpeechToTextProvider sttProvider;

  @override
  initState() {
    super.initState();
    sttProvider = Provider.of<SpeechToTextProvider>(context, listen: false);
    sttProvider.init();
    navigation();
  }

  navigation() {
    sttProvider.setupNavigationCallback(
      (result) {
        if (result.isNotEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SpeechToTextResult(searchQuery: result),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EmptyDataWidget(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_backspace_rounded),
        ),
        title: Text("Voice Search"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<SpeechToTextProvider>(
              builder: (context, value, child) {
                return Text(
                  value.spokenWords.isEmpty
                      ? "I am listening..."
                      : value.spokenWords,
                  // _lastWords,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                );
              },
            ),
            SizedBox(height: 30),
            Consumer<SpeechToTextProvider>(
              builder: (context, value, child) => InkWell(
                onTap: () {
                  value.init();
                },
                child: value.speechToText.isListening
                    ? Image(
                        image: AssetImage('assets/gif/listening.gif'),
                      )
                    : Icon(
                        Icons.mic_off,
                        size: 50,
                        color: Colors.blue,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
