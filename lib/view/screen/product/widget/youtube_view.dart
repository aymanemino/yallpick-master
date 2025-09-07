import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubeView extends StatefulWidget {
  final String videoUrl;
  YoutubeView({@required this.videoUrl});

  @override
  State<YoutubeView> createState() => _YoutubeViewState();
}

class _YoutubeViewState extends State<YoutubeView> {
  String videoId = '';

  @override
  void initState() {
    videoId = convertUrlToId(widget.videoUrl) ?? '';
    super.initState();
  }
  
  static String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:music\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    return Column(
      children: [
        TitleRow(
          title: getTranslated('overview', context),
          isDetailsPage: true,
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

        AspectRatio(
          aspectRatio: 16 / 9,
          child: videoId.isNotEmpty
              ? WebView(
                  initialUrl: 'https://www.youtube.com/embed/$videoId',
                  javascriptMode: JavascriptMode.unrestricted,
                )
              : Container(
                  color: Colors.grey[300]!!,
                  child: Center(
                    child: Text('Video not available'),
                  ),
                ),
        ),
      ],
    );
  }
}
