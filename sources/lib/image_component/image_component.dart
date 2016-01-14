library image_component;

import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';
import 'package:event_bus/event_bus.dart';
import 'package:speedpad/event_classes/events.dart';
import 'package:speedpad/services/storage_service.dart';
import 'package:speedpad/util/file_utils.dart';

@Component(
    selector: "image-component",
    templateUrl: "packages/speedpad/image_component/image_component.html",
    useShadowDom: false
)
class ImageComponent implements AttachAware, ShadowRootAware {

  @NgAttr('width')
  String widthArgument;
  int width = 300;

  @NgAttr('height')
  String heightArgument;
  int height = 200;

  @NgAttr('allowImport')
  String allowImportArgument;
  bool allowImport = false;

  @NgTwoWay('src')
  String dataSourceArgument;

  Element _thisElement;
  Element _dragHint;
  DivElement _imagePreviewContainer;
  bool showDragHint = false;

  bool _attributesLoaded = false;
  bool _templateLoaded = false;

  List<StreamSubscription> eventListeners = new List<StreamSubscription>();

  StorageService _storage;
  EventBus _eventBus;

  ImageComponent(this._thisElement, this._storage, this._eventBus) {

  }

  void attach() {

    if (_thisElement.attributes.containsKey('allowImport')) {
      allowImport = true;
    }

    if (widthArgument != null && widthArgument.isNotEmpty) {
      width = int.parse(widthArgument);
    }

    if (heightArgument != null && heightArgument.isNotEmpty) {
      height = int.parse(heightArgument);
    }

    _attributesLoaded = true;
    onLoadingComplete();
  }

  void onShadowRoot(ShadowRoot shadowRoot) {
    _imagePreviewContainer = _thisElement.querySelector(".ImagePreviewContainer");
    _dragHint = _thisElement.querySelector(".dragHint");

    _templateLoaded = true;
    onLoadingComplete();
  }


  /**
   * This function will be called when all component things are initialized
   */
  void onLoadingComplete() {
    if (!(_attributesLoaded && _templateLoaded)) {
      return;
    }

    _imagePreviewContainer.style.width = width.toString() + "px";
    _imagePreviewContainer.style.height = height.toString() + "px";


    if (allowImport) {

      //re-register event listeners
      _eventBus.on(OpenGenericPanel).listen((data) {
        onLoadingComplete();
      });

      _eventBus.on(CancelNewPagePanel).listen((data) {
        dataSourceArgument = "";
        eventListeners.forEach((StreamSubscription subscription) {
          subscription.cancel();
        });
        eventListeners.clear();
      });

      //document - on drag enter
      var sub = document.onDragEnter.listen((MouseEvent e) {
        e.preventDefault();
        showDragHint = true;
      });
      eventListeners.add(sub);

      //document - on drag over
      sub = document.onDragOver.listen((MouseEvent e) {
        e.preventDefault();
        showDragHint = true;
      });
      eventListeners.add(sub);

      //document - on drag leave
      sub = document.onDragLeave.listen((MouseEvent e) {
        e.preventDefault();
        Element target = e.target as Element;
        if (target != null && !_thisElement.contains(target)) {
          showDragHint = false;
        }
      });
      eventListeners.add(sub);

      //document - on drop
      sub = document.onDrop.listen((MouseEvent e) {
        e.preventDefault();
        showDragHint = false;
      });
      eventListeners.add(sub);

      //drag hint - on drag enter
      sub = _dragHint.onDragEnter.listen((MouseEvent e) {
        _dragHint.classes.add("dragHint-hover");
      });
      eventListeners.add(sub);

      //drag hint - on drag leave
      sub = _dragHint.onDragLeave.listen((MouseEvent e) {
        _dragHint.classes.remove("dragHint-hover");
      });
      eventListeners.add(sub);

      //drag hint - on drop
      sub = _dragHint.onDrop.listen((MouseEvent e) {
        //remove hover class
        _dragHint.classes.remove("dragHint-hover");

        List<File> files = e.dataTransfer.files;
        print("files.length: " + files.length.toString());

        if (files.length > 1) {
          print("Error - too many files!");
          //TODO: show Error - to many Files

        } else if (files.length < 1) {
          //TODO: show Error - no files available
          print("Error - no files droped");
          print("trying to read data transfer as URL");
          var imgUrl = e.dataTransfer.getData('URL');
          getImageFromUrlAsDataUrl(imgUrl).then((String dataUrl) {
            dataSourceArgument = dataUrl;
          });

        } else {
          getImageFromFileAsDataUrl(files[0]).then((String dataUrl) {
            dataSourceArgument = dataUrl;
          });
        }

      });
      eventListeners.add(sub);

    }
  }


  bool imgAvaliable() {
    if (dataSourceArgument != null && dataSourceArgument.isNotEmpty) {
      return true;
    }
    return false;
  }


}