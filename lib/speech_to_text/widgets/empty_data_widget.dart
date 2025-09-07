import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/speech_to_text/widgets/speech_to_text_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';

class EmptyDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_backspace_rounded),
        ),
        title: Text("Voice Search"),
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.ICON_SIZE_DEFAULT),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('We could not found result please try again.'),
              SizedBox(height: 16),
              CustomButton(
                buttonText: 'Try again',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SpeechToTextWidget(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
