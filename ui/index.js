const express = require('express');
const mqtt = require("mqtt");
const client = mqtt.connect("mqtt://10.1.0.4");

const server_host = "10.1.0.3";
const rest_port = 8000
const post_uri = "http://" + server_host + ":" + rest_port + "/post-moosvar"

node_data = {
};

client.on("connect", () => {
  client.subscribe("node-report", (err) => {
    if (err) {
      console.log("error!");
      console.log(err);
    }
  });
});

client.on("message", (topic, message) => {
  dict = JSON.parse(message.toString());
  node_data[dict["NAME"]] = dict;
});

const app = express();

const port = 3000;

const server = app.listen(port);

app.use(express.static('public'));
app.get('/nodes', (req, res) => {
  res.send(node_data);
});
app.post('/deploy', (req, res) => {

  let deploy_object = {
    "name":"DEPLOY_ALL",
    "value":"true"
  }
  let override_object = {
    "name":"MOOS_MANUAL_OVERRIDE_ALL",
    "value":"false"
  }
  let return_object = {
    "name":"RETURN_ALL",
    "value":"false"
  }

  fetch(post_uri, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(deploy_object)
  });
  fetch(post_uri, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(override_object)
  });
  fetch(post_uri, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(return_object)
  });

  res.send({"success":"true"});
});

app.post('/return', (req, res) => {

  let return_object = {
    "name":"RETURN_ALL",
    "value":"true"
  }

  fetch(post_uri, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(return_object)
  });

  res.send({"success":"true"});
});