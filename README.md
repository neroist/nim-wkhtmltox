# nim-wkhtmltox

Nim bindings to wkhtmltox.

## Examples

To PDF:

```nim
import nimwkhtmltox/pdf

initPdf()

# from w3schools
let content = """
<!DOCTYPE html>
<html>
<head>
  <style>
    h1 {
      color: blue;
      font-family: verdana;
      font-size: 300%;
    }

    p  {
      color: red;
      font-family: courier;
      font-size: 160%;
    }
  </style>
</head>
<body>

  <h1>This is a heading</h1>
  <p>This is a paragraph.</p>

</body>
</html>
"""

let settings = createGlobalSettings()
settings.setGlobalSetting("out", "./index.pdf")

let conv =  createConverter(settings)

let objSettings = createObjectSettings()

conv.addObject(objSettings, content)

conv.convert()

deinitPdf()
```

```nim
import nimwkhtmltox/pdf

initPDF()

toPDF(
  "https://wkhtmltopdf.org/libwkhtmltox/pagesettings.html",
  createGlobalSettings({
    "out": "pagesettings.pdf"
  })
)

deinitPDF()
```

To Image:

```nim
import nimwkhtmltox/image

initImage()

let settings = createGlobalSettings()
settings.setGlobalSettings({
  "in": "https://spdx.org/licenses/LGPL-3.0-or-later.html",
  "out": "license.png",
  "fmt": "png"
})

let conv = createConverter(settings, "")

conv.convert()
```

```nim
import nimwkhtmltox/image

initImage()

toImage(
  "https://github.com/neroist/nim-wkhtmltox",
  createGlobalSettings({
    "out": "nim-wkhtmltox.png",
    "fmt": "png"
  })
)

deinitImage()
```
