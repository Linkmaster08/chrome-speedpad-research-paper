library speedpad_extension.file_utils;

import 'dart:async';
import 'dart:html';

/**
 * handles URL import from drag n drop
 * @returns Future with data url string
 */
Future<String> getImageFromUrlAsDataUrl(String url) {
  var completer = new Completer<String>();

  //test, if image is not data url
  if (!url.startsWith("data:")) {
    //download image and convert to data url

    //TODO: implement Scaling for Images for better performance

    HttpRequest.request(url, method: "GET", responseType: "blob").then((request) {
      var result = request.response;
      FileReader reader = new FileReader();
      reader.onLoadEnd.listen((ProgressEvent e) {
        completer.complete(reader.result as String);
      });
      reader.readAsDataUrl(result);
    }).catchError((error) {
      print("Error while downloading the image from " + url);
      print(error);
    });
  } else {
    completer.complete(url);
  }

  return completer.future;
}

Future<String> getImageFromFileAsDataUrl(File file) {
  var completer = new Completer<String>();
  var reader = new FileReader();

  reader.onLoadEnd.listen((ProgressEvent e) {
    completer.complete(reader.result as String);
  });

  reader.readAsDataUrl(file);
  return completer.future;
}
