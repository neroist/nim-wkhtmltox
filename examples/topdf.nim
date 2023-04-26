import nimwkhtmltox/pdf

initPdf(true)

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
settings.setGlobalSetting("out", "./latex.pdf")

let conv =  createConverter(settings)

let objSettings = createObjectSettings()

conv.addObject(objSettings, content)

#conv.convert()



toPdf("https://google.com")

deinitPdf()