# Dialogs
var Radio = gui.Dialog.new("/sim/gui/dialogs/radios/dialog",
        "Aircraft/767-300/Systems/tranceivers.xml");
var ap_settings = gui.Dialog.new("/sim/gui/dialogs/autopilot/dialog",
        "Aircraft/767-300/Systems/autopilot-dlg.xml");

gui.menuBind("radio", "dialogs.Radio.open()");
gui.menuBind("autopilot-settings", "dialogs.ap_settings.open()");
