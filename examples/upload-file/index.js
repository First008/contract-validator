var express = require('express')
var multer  = require('multer')
var path = require('path');
var upload = multer({ dest: 'uploads/' })

const port = 3000
const app = express()

app.post('/file', upload.single('avatar'), function (req, res, next) {
  // req.file is the `avatar` file
  // req.body will hold the text fields, if there were any
  console.log(req.file);
  res.send(200)
})


app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '/index.html'))
})


app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})
