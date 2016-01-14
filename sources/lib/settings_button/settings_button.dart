library settings_button;

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:event_bus/event_bus.dart';
import 'package:speedpad/event_classes/events.dart';

@Component(
    selector: "settings-button",
    templateUrl: "packages/speedpad/settings_button/settings_button.html",
    useShadowDom: false
)
class SettingsButton {

  EventBus _eventBus;

  SettingsButton(this._eventBus) {

  }

  void openSettings (MouseEvent e) {
    e.stopImmediatePropagation();
    _eventBus.fire(new OpenGenericPanel(PanelView.Settings));
  }



}