library add_button;

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:event_bus/event_bus.dart';
import 'package:speedpad/event_classes/events.dart';

@Component(
    selector: "add-button",
    templateUrl: "packages/speedpad/add_button/add_button.html",
    useShadowDom: false
)
class AddButton {

  EventBus _eventBus;

  AddButton(this._eventBus) {

  }

  void addLink (MouseEvent e) {
    e.stopImmediatePropagation();
    _eventBus.fire(new OpenGenericPanel(PanelView.NewLink));
    }
}