part of events;

/**
 * Class for opening a generic right sided panel
 */
class OpenGenericPanel {

  /**
   * defines which content should be loaded into the panel
   */
  PanelView view;

  OpenGenericPanel(this.view);


}

enum PanelView {
  Settings, NewLink, None
}