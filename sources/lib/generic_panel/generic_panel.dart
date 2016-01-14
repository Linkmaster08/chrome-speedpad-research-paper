library generic_panel;

import 'dart:html';
import 'dart:async';

import 'package:angular/angular.dart';
import 'package:event_bus/event_bus.dart';
import 'package:animation/animation.dart';

import 'package:speedpad/event_classes/events.dart';

@Component(
    selector: "generic-panel",
    templateUrl: "packages/speedpad/generic_panel/generic_panel.html",
    useShadowDom: false
)
class GenericPanel implements ShadowRootAware {

  //injected
  EventBus _eventBus;
  Element _elementRoot;

  Element _boxElement;
  ElementAnimation _boxInAnimation;
  ElementAnimation _boxOutAnimation;
  NodeValidatorBuilder validator;
  PanelView currentPanel = PanelView.None;
  StreamSubscription<MouseEvent> _clickEvents;

  PanelView get isSettingsPanel {
    return PanelView.Settings;
  }

  PanelView get isNewLinkPanel {
    return PanelView.NewLink;
  }

  closeGenericPanel() {
    if (currentPanel == PanelView.NewLink) {
      _eventBus.fire(new CancelNewPagePanel());
    }

    window.animationFrame.then((num) {
      _boxOutAnimation.run();
      createBoxOutAnimation();
    });
    _clickEvents.cancel();
  }

  GenericPanel(this._eventBus, this._elementRoot) {

    //react on open events on the event bus
    _eventBus.on(OpenGenericPanel).listen((OpenGenericPanel e) {

      if (e.view != currentPanel) {

        switch (e.view) {
          case PanelView.Settings:
            currentPanel = PanelView.Settings;
            break;
          case PanelView.NewLink:
            currentPanel = PanelView.NewLink;
            break;
          case PanelView.None:
            currentPanel = PanelView.None;
            break;
        }
      }

      //run box in animation
      window.animationFrame.then((num) {
        _boxInAnimation.run();
        createBoxInAnimation();
      });


      //run box out animation when clicking outside
      _clickEvents = window.document.onClick.listen((MouseEvent e) {
        Element target = e.target as Element;
        if (target != null && !_elementRoot.contains(target)) {
          closeGenericPanel();
        }
      });
    });


    _eventBus.on(CloseGenericPanel).listen( (CloseGenericPanel e){
      closeGenericPanel();
    });


  }

  void onShadowRoot(ShadowRoot shadowRoot) {
    _boxElement = _elementRoot.querySelector('.GenericPanel');

    if (_boxElement == null) {
      print("Box Element not found!");
    }

    createBoxInAnimation();
    createBoxOutAnimation();
  }

  /**
   * helper function
   */
  void createBoxInAnimation() {
    _boxInAnimation = new ElementAnimation(_boxElement)
      ..duration = 500
      ..properties = {
      "width": 400
    };
  }

  /**
   * helper function
   */
  void createBoxOutAnimation() {
    _boxOutAnimation = new ElementAnimation(_boxElement)
      ..duration = 500
      ..properties = {
      "width": 0
    };
  }


}