const jsreport = require('@jsreport/jsreport-core')({ loadConfig: true })

jsreport.init().then(() => {

  jsreport.render({
    template: {
      content: 'test body',
      helpers: '',
      engine: 'none',
      recipe: 'chrome-pdf',
      pdfAccessibility: {
        enabled: true
      },
      pdfOperations: [{
        enabled: true,
        type: 'merge',   
        mergeWholeDocument: true,
        template: {
          content: `<html>
<html>
  <head>
  </head>
  <body>
        test
  </body>
</html>
</html>`,
          recipe: 'chrome-pdf',
          engine: 'jsrender'
        }
      }]
    }
  })

}).catch((e) => {
  console.error(e.stack)
  process.exit(1)
})