type
  GlobalSettings* = object

type
  Converter* = object
  StrCallback* = proc (`converter`: ptr Converter; str: cstring) {.cdecl.}
  IntCallback* = proc (`converter`: ptr Converter; val: cint) {.cdecl.}
  VoidCallback* = proc (`converter`: ptr Converter) {.cdecl.}

{.push dynlib: "wkhtmltox.dll".}
{.push discardable.}
proc initImage*(useGraphics: cint): cint {.cdecl, importc: "wkhtmltoimage_init".}
proc deinitImage*(): cint {.cdecl, importc: "wkhtmltoimage_deinit".}
proc extendedQt*(): cint {.cdecl, importc: "wkhtmltoimage_extended_qt".}
proc version*(): cstring {.cdecl, importc: "wkhtmltoimage_version".}
proc createGlobalSettings*(): ptr GlobalSettings {.cdecl,
    importc: "wkhtmltoimage_create_global_settings".}
proc setGlobalSetting*(settings: ptr GlobalSettings; name: cstring; value: cstring): cint {.
    cdecl, importc: "wkhtmltoimage_set_global_setting".}
proc getGlobalSetting*(settings: ptr GlobalSettings; name: cstring; value: cstring;
                      vs: cint): cint {.cdecl, importc: "wkhtmltoimage_get_global_setting".}
proc createConverter*(settings: ptr GlobalSettings; data: cstring): ptr Converter {.
    cdecl, importc: "wkhtmltoimage_create_converter".}
proc destroyConverter*(`converter`: ptr Converter) {.cdecl,
    importc: "wkhtmltoimage_destroy_converter".}
proc setDebugCallback*(`converter`: ptr Converter; cb: StrCallback) {.cdecl,
    importc: "wkhtmltoimage_set_debug_callback".}
proc setInfoCallback*(`converter`: ptr Converter; cb: StrCallback) {.cdecl,
    importc: "wkhtmltoimage_set_info_callback".}
proc setWarningCallback*(`converter`: ptr Converter; cb: StrCallback) {.cdecl,
    importc: "wkhtmltoimage_set_warning_callback".}
proc setErrorCallback*(`converter`: ptr Converter; cb: StrCallback) {.cdecl,
    importc: "wkhtmltoimage_set_error_callback".}
proc setPhaseChangedCallback*(`converter`: ptr Converter; cb: VoidCallback) {.cdecl,
    importc: "wkhtmltoimage_set_phase_changed_callback".}
proc setProgressChangedCallback*(`converter`: ptr Converter; cb: IntCallback) {.cdecl,
    importc: "wkhtmltoimage_set_progress_changed_callback".}
proc setFinishedCallback*(`converter`: ptr Converter; cb: IntCallback) {.cdecl,
    importc: "wkhtmltoimage_set_finished_callback".}
proc convert*(`converter`: ptr Converter): cint {.cdecl,
    importc: "wkhtmltoimage_convert".}
##  CAPI(void) wkhtmltoimage_begin_conversion(wkhtmltoimage_converter * converter);
##  CAPI(void) wkhtmltoimage_cancel(wkhtmltoimage_converter * converter);

proc currentPhase*(`converter`: ptr Converter): cint {.cdecl,
    importc: "wkhtmltoimage_current_phase".}
proc phaseCount*(`converter`: ptr Converter): cint {.cdecl,
    importc: "wkhtmltoimage_phase_count".}
proc phaseDescription*(`converter`: ptr Converter; phase: cint): cstring {.cdecl,
    importc: "wkhtmltoimage_phase_description".}
proc progressString*(`converter`: ptr Converter): cstring {.cdecl,
    importc: "wkhtmltoimage_progress_string".}
proc httpErrorCode*(`converter`: ptr Converter): cint {.cdecl,
    importc: "wkhtmltoimage_http_error_code".}
proc getOutput*(`converter`: ptr Converter; a2: ptr ptr uint8): clong {.cdecl,
    importc: "wkhtmltoimage_get_output".}
{.pop.}
{.pop.}

# convenience procs -----

proc setGlobalSettings*(settings: ptr GlobalSettings; nvs: openArray[tuple[name: string, value: int | string | bool | float]]) = 
  for nv in nvs:
    settings.setGlobalSetting(cstring nv[0], cstring $nv[1])

proc toImage*(path: string, settings: ptr GlobalSettings = createGlobalSettings()): bool {.discardable.} = 
  settings.setGlobalSetting("in", path)
  let htmlConverter = createConverter(settings, "")

  bool htmlConverter.convert()

proc initImage*(useGraphics: bool = false): bool {.discardable.} = 
  bool initImage(cint useGraphics)

proc createGlobalSettings*(nvs: openArray[tuple[name: string, value: int | string | bool | float]]): ptr GlobalSettings = 
  result = createGlobalSettings()
  result.setGlobalSettings(nvs)
  