library new_link_panel;

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:event_bus/event_bus.dart';
import 'package:shared_classes/shared_classes.dart';
import 'package:speedpad/event_classes/events.dart';
import 'package:speedpad/services/storage_service.dart';


@Component(
    selector: "new-link-panel",
    templateUrl: "packages/speedpad/new_link_panel/new_link_panel.html",
    useShadowDom: false
)
class NewLinkPanel {

  LinkElement link;
  String nameBuffer = "";
  String urlBuffer = "";
  String imgBuffer = "";
  //TODO: add editable ComboBox for parentTab
  TabEntry parentTab = new TabEntry("Home");

  bool missingName = false;
  bool missingUrl = false;

  StorageService _storage;
  EventBus _eventBus;

  NewLinkPanel(this._storage, this._eventBus) {
    _eventBus.on(CancelNewPagePanel).listen( (e) {
      urlBuffer = "";
      nameBuffer = "";
    });
  }

  void save() {
    if (nameBuffer.isEmpty) {
      missingName = true;
      return;
    } else {
      missingName = false;
    }

    if (urlBuffer.isEmpty) {
      missingUrl = true;
      return;
    } else {
      missingUrl = false;
    }

    if (imgBuffer.isEmpty) {
      //TODO: add empty image placeholder image
      //TODO: add possibility for website screenshot later
    }

    //Pack all Buffer vars to a LinkEntry and give it to _storage.save
    var linkEntry = new LinkEntry(nameBuffer, parentTab, urlBuffer, imgBuffer);
    _eventBus.fire(new SaveLink(linkEntry));
    _eventBus.fire(new CloseGenericPanel(PanelView.NewLink));
  }

  void cancel() {
    _eventBus.fire(new CloseGenericPanel(PanelView.NewLink));
  }



}