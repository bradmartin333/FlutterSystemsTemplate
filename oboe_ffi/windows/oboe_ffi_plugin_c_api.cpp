#include "include/oboe_ffi/oboe_ffi_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "oboe_ffi_plugin.h"

void OboeFfiPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  oboe_ffi::OboeFfiPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
