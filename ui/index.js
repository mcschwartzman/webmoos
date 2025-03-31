const express = require('express');
const mqtt = require("mqtt");
const client = mqtt.connect("mqtt://10.1.0.4");

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
  console.log(message.toString());
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