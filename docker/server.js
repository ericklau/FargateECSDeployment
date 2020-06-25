const express = require('express')
const bodyParser= require('body-parser')
const app = express()
const multer = require('multer');
const serveIndex = require('serve-index');

app.use(bodyParser.urlencoded({extended: true}))

//app.use(express.static('uploads'));
app.use('/uploads', express.static('uploads'), serveIndex('uploads', { 'icons': true }))

var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads')
  },
  filename: function (req, file, cb) {
    cb(null, file.originalname)
  }
})

var upload = multer({ storage: storage })


app.get('/',function(req,res){
  res.sendFile(__dirname + '/index.html');

});

app.listen(8080);

// upload single file

app.post('/uploadfile', upload.single('myFile'), (req, res, next) => {
  const file = req.file
  if (!file) {
    const error = new Error('Please upload a file')
    error.httpStatusCode = 400
    return next(error)

  }
    res.redirect('/uploads');
 
})


//Uploading multiple files
app.post('/uploadmultiple', upload.array('myFiles', 12), (req, res, next) => {
  const files = req.files
  if (!files) {
    const error = new Error('Please choose files')
    error.httpStatusCode = 400
    return next(error)
  }

     res.redirect('/uploads');
 
})



