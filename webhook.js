  var express = require('express');
  var app = express();
  var bodyParser = require('body-parser');
  var https = require('https');
  var fs = require("fs");
  var request = require('request');

  var token = "EAADwDlamdyUBAMjAedx1TS7g9dCSdyzCfzhyRysENMBK6b5IKtBqvlKIlqdmUsLqfzOnL8GeqkdPZCjQJuP8V22LLZCZC4nTvAmitfHMbKKUMsWHfwRZBZAAHReAF77dlPetoFZCbJIdUOwNSuflH5aEZACx4FP5eKw3vgY6MT9qZCjBpQZDZD";
  app.use(bodyParser.json())
  app.use(bodyParser.urlencoded({ extended: true }));
  var user_details = {};

  function setUserDetailsAndPostback(user_id, payload){
  	 var options = {
      uri: "https://graph.facebook.com/v2.6/"+user_id+"?fields=first_name&access_token="+token,
      method: 'GET'
    };
    function callback(error, response, body) {
      if (!error && response.statusCode == 200) {
        console.log(body) // Print the shortened url.
        var user = JSON.parse(body);
        user_details[user_id] = user.first_name;
        postback(user_id, payload);
      }
    }
    request(options, callback).end();
  }


  function getStructuredMessageData(title){
    messageData = {
      "attachment": {
        "type": "template",
        "payload": {
          "template_type": "generic",
          "elements": [{
            "title": "First "+text,
            "subtitle": "Element #1 of an hscroll",
            "image_url": "http://www.headhonchos.com/employers/img/employers-home-page-bg.jpg",
            "buttons": [{
              "type": "web_url",
              "url": "https://www.messenger.com/",
              "title": "Web url"
            }, {
              "type": "postback",
              "title": "Postback",
              "payload": "Payload for first element in a generic bubble",
            }],
          },{
            "title": "Second "+text,
            "subtitle": "Element #2 of an hscroll",
            "image_url": "http://www.headhonchos.com/employers/img/employers-home-page-bg.jpg",
            "buttons": [{
              "type": "postback",
              "title": "Postback",
              "payload": "Payload for second element in a generic bubble",
            }],
          }]
        }
      }
    };
  }


  function sendTextMessage(sender, text) {
    console.log("sending"+sender+text);
  
    messageData = {
      text:text
    }
    
    var options = {
      uri: 'https://graph.facebook.com/v2.6/me/messages?access_token='+token,
      method: 'POST',
      json: {
        "recipient": {"id":sender},
        "message": messageData
      }
    };

   request(options, function (error, response, body) {
    if (!error && response.statusCode == 200) {
      console.log("success " + body.id) // Print the shortened url.
    }else{
      console.log("error");
    }
  });
}

app.get('/ping', function (req, res) {
   res.end("running");
})

app.get('/webhook', function (req, res) {
  if (req.query['hub.verify_token'] === 'chaos@joker') {
    res.send(req.query['hub.challenge']);
  } else {
    res.send('Error, wrong validation token');    
  }
});

app.post('/webhook/', function (req, res) {
 console.log("received");
  messaging_events = req.body.entry[0].messaging;
  for (i = 0; i < messaging_events.length; i++) {
    event = req.body.entry[0].messaging[i];
    user_id = event.sender.id;
    console.log("sender:"+user_id);
    if (event.message && event.message.text) {
	     text = event.message.text;
	     console.log("msg received"+text);
      sendTextMessage(user_id, ""+ text.substring(0, 200), 0);
    }
    if (event.postback) {
      if(!(user_id in user_details)){
        setUserDetailsAndPostback(user_id, event.postback.payload);
      }else{
  	    postback(user_id, event.postback.payload);
      }
    	continue;
    }
  }
  res.sendStatus(200);
});

var server = app.listen(8080, function () {

  var host = server.address().address
  var port = server.address().port

  console.log("Example app listening at http://%s:%s", host, port)

})

function postback(user_id, payload){
  var username = user_details[user_id];
  switch(payload){
    case "job":
        msg = "Thank you "+username + " for choosing us, we need just couple of info.  How much experience do you have?";
        break;
    case "course":
      msg = "Thank you "+username + " for choosing us, please choose your area of interest";
      break;
    case "carrer":
      msg = "Thank you "+username + " for choosing us, how can we help you?";
      break;
    default:
      msg = "default";
  }
  sendTextMessage(user_id, msg);
}
