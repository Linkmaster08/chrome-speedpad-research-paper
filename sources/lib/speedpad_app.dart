library speedpad_app;

import 'package:angular/angular.dart' as Angular;
import 'package:event_bus/event_bus.dart';

//add-button
import 'package:speedpad/add_button/add_button.dart';

//settings-button
import 'package:speedpad/settings_button/settings_button.dart';

//generic-panel
import 'package:speedpad/generic_panel/generic_panel.dart';

//new-link-panel
import 'package:speedpad/new_link_panel/new_link_panel.dart';

//settings-panel
import 'package:speedpad/settings_panel/settings_panel.dart';

//image-component
import 'package:speedpad/image_component/image_component.dart';

//link-component
import 'package:speedpad/link_component/link_component.dart';

//launchpad-canvas
import 'package:speedpad/launchpad_canvas/launchpad_canvas_component.dart';

//services
import 'package:speedpad/services/storage_service.dart';
import 'package:speedpad/util/service_connection_manager.dart';


class SpeedpadApp extends Angular.Module {

  SpeedpadApp() {
    //add event bus to dependency injection
    bind(EventBus, toValue: new EventBus());

    //add storage service to dependency injection
    bind(StorageService);
//    bind(StorageService, toValue: new StorageService());
//    bind(StorageService, toFactory: (Angular.Injector inj) => new StorageService(inj.get(EventBus)));

    //add ServiceConnectionManager to di
    bind(ServiceConnectionManager);

    bind(AddButton);
    bind(SettingsButton);

    bind(GenericPanel);
    bind(NewLinkPanel);
    bind(SettingsPanel);

    bind(ImageComponent);
    bind(LinkComponent);
    bind(LaunchpadCanvas);
  }

}