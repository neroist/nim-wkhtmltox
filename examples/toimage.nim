import nimwkhtmltox/image

initImage()

let settings = createGlobalSettings()
settings.setGlobalSettings({
  "in": "https://spdx.org/licenses/LGPL-3.0-or-later.html",
  "out": "latex.png",
  "fmt": "png"
})

let conv = createConverter(settings, "")

conv.convert()