type
  GlobalSettings* = object

type
  ObjectSettings* = object

type
  Converter* = object
  StrCallback* = proc (`converter`: ptr Converter; str: cstring) {.cdecl.}
  IntCallback* = proc (`converter`: ptr Converter; val: cint) {.cdecl.}
  VoidCallback* = proc (`converter`: ptr Converter) {.cdecl.}

when defined(windows):
  {.push dynlib: "wkhtmltox.dll".}
elif defined(macosx):
  {.push dynlib: "libwkhtmltox.dynlib".}
else:
  {.push dynlib: "libwkhtmltox.so".}

{.push discardable.}
proc initPdf*(useGraphics: cint): cint {.cdecl, importc: "wkhtmltopdf_init".}
proc deinitPdf*(): cint {.cdecl, importc: "wkhtmltopdf_deinit".}
proc extendedQt*(): cint {.cdecl, importc: "wkhtmltopdf_extended_qt".}
proc version*(): cstring {.cdecl, importc: "wkhtmltopdf_version".}
proc createGlobalSettings*(): ptr GlobalSettings {.cdecl,
    importc: "wkhtmltopdf_create_global_settings".}
proc destroyGlobalSettings*(a1: ptr GlobalSettings) {.cdecl,
    importc: "wkhtmltopdf_destroy_global_settings".}
proc createObjectSettings*(): ptr ObjectSettings {.cdecl,
    importc: "wkhtmltopdf_create_object_settings".}
proc destroyObjectSettings*(a1: ptr ObjectSettings) {.cdecl,
    importc: "wkhtmltopdf_destroy_object_settings".}
proc setGlobalSetting*(settings: ptr GlobalSettings; name: cstring; value: cstring): cint {.
    cdecl, importc: "wkhtmltopdf_set_global_setting".}
proc getGlobalSetting*(settings: ptr GlobalSettings; name: cstring; value: cstring;
                      vs: cint): cint {.cdecl,
                                     importc: "wkhtmltopdf_get_global_setting".}
proc setObjectSetting*(settings: ptr ObjectSettings; name: cstring; value: cstring): cint {.
    cdecl, importc: "wkhtmltopdf_set_object_setting".}
proc getObjectSetting*(settings: ptr ObjectSettings; name: cstring; value: cstring;
                      vs: cint): cint {.cdecl,
                                     importc: "wkhtmltopdf_get_object_setting".}
proc createConverter*(settings: ptr GlobalSettings): ptr Converter {.cdecl,
    importc: "wkhtmltopdf_create_converter".}
proc destroyConverter*(`converter`: ptr Converter) {.cdecl,
    importc: "wkhtmltopdf_destroy_converter".}
proc setDebugCallback*(`converter`: ptr Converter; cb: StrCallback) {.cdecl,
    importc: "wkhtmltopdf_set_debug_callback".}
proc setInfoCallback*(`converter`: ptr Converter; cb: StrCallback) {.cdecl,
    importc: "wkhtmltopdf_set_info_callback".}
proc setWarningCallback*(`converter`: ptr Converter; cb: StrCallback) {.cdecl,
    importc: "wkhtmltopdf_set_warning_callback".}
proc setErrorCallback*(`converter`: ptr Converter; cb: StrCallback) {.cdecl,
    importc: "wkhtmltopdf_set_error_callback".}
proc setPhaseChangedCallback*(`converter`: ptr Converter; cb: VoidCallback) {.cdecl,
    importc: "wkhtmltopdf_set_phase_changed_callback".}
proc setProgressChangedCallback*(`converter`: ptr Converter; cb: IntCallback) {.cdecl,
    importc: "wkhtmltopdf_set_progress_changed_callback".}
proc setFinishedCallback*(`converter`: ptr Converter; cb: IntCallback) {.cdecl,
    importc: "wkhtmltopdf_set_finished_callback".}
#  CAPI(void) wkhtmltopdf_begin_conversion(wkhtmltopdf_converter * converter);
#  CAPI(void) wkhtmltopdf_cancel(wkhtmltopdf_converter * converter);

proc convert*(`converter`: ptr Converter): cint {.cdecl,
    importc: "wkhtmltopdf_convert".}
proc addObject*(`converter`: ptr Converter; setting: ptr ObjectSettings; data: cstring) {.
    cdecl, importc: "wkhtmltopdf_add_object".}
proc currentPhase*(`converter`: ptr Converter): cint {.cdecl,
    importc: "wkhtmltopdf_current_phase".}
proc phaseCount*(`converter`: ptr Converter): cint {.cdecl,
    importc: "wkhtmltopdf_phase_count".}
proc phaseDescription*(`converter`: ptr Converter; phase: cint): cstring {.cdecl,
    importc: "wkhtmltopdf_phase_description".}
proc progressString*(`converter`: ptr Converter): cstring {.cdecl,
    importc: "wkhtmltopdf_progress_string".}
proc httpErrorCode*(`converter`: ptr Converter): cint {.cdecl,
    importc: "wkhtmltopdf_http_error_code".}
proc getOutput*(`converter`: ptr Converter; a2: ptr ptr uint8): clong {.cdecl,
    importc: "wkhtmltopdf_get_output".}
{.pop.}
{.pop.}

# convenience procs -----

proc setGlobalSettings*(settings: ptr GlobalSettings; nvs: openArray[tuple[name: string, value: int | string | bool | float]]) = 
  for nv in nvs:
    settings.setGlobalSetting(cstring nv[0], cstring $nv[1])

proc setObjectSettings*(settings: ptr ObjectSettings; nvs: openArray[tuple[name: string, value: int | string | bool | float]]) = 
  for nv in nvs:
    settings.setObjectSetting(cstring nv[0], cstring $nv[1])

proc initPdf*(useGraphics: bool = false): bool {.discardable.} = 
  bool initPdf(cint useGraphics)

proc addObject*(`converter`: ptr Converter; setting: ptr ObjectSettings; data: string) = 
  addObject(`converter`, setting, cstring data)

proc toPdf*(path: string, globalSettings = createGlobalSettings(), objectSettings = createObjectSettings()): bool {.discardable.} =
  objectSettings.setObjectSetting("page", path)
  
  let conv = createConverter(globalSettings)
  conv.addObject(objectSettings, "")
  
  bool conv.convert()

proc createGlobalSettings*(nvs: openArray[tuple[name: string, value: int | string | bool | float]]): ptr GlobalSettings = 
  result = createGlobalSettings()
  result.setGlobalSettings(nvs)

proc createObjectSettings*(nvs: openArray[tuple[name: string, value: int | string | bool | float]]): ptr ObjectSettings = 
  result = createObjectSettings()
  result.setObjectSettings(nvs)
  
