//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <oboe_ffi/oboe_ffi_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) oboe_ffi_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "OboeFfiPlugin");
  oboe_ffi_plugin_register_with_registrar(oboe_ffi_registrar);
}
