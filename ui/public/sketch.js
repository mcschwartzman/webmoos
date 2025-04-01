let nodes;
let img;

function preload() {
  img = loadImage('/assets/forrest19.jpg');
}

async function getData(){
  const response = await fetch("http://localhost:3000/nodes");
  try {
    if (!response.ok) {
      throw new Error(`Response status: ${response.status}`
      );
    }
  
    const json = await response.json();
    // console.log(json);
    return json;
  } catch (error) {
    console.error(error.message);
  }
}

function setup() {

  createCanvas(1000, 750);

  let button = createButton('Deploy');
  button.position(600,0);
  button.mousePressed(sendDeploy);

  let returnButton = createButton('Return');
  returnButton.position(600,25);
  returnButton.mousePressed(sendReturn);
}

function draw() {

  background(200);
  image(img, 0, 0, 600, 600);

  strokeWeight(10);


  response = fetch("http://localhost:3000/nodes").then(function(response) {
    return response.json();
  }).then(function(data) {
    nodes = data;
  });

  const x_offset = 250;
  const y_offset = 120;

  for (const node in nodes){
    let node_dict = nodes[node];
    let x = parseInt(node_dict["X"]);
    let y = -1 * parseInt(node_dict["Y"]);
    stroke(node_dict["COLOR"]);
    point(x + x_offset, y + y_offset);

  }
  
}

function sendDeploy() {

  fetch('http://localhost:3000/deploy', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({"deploy":"true"})
  });
  
}

function sendReturn() {

  fetch('http://localhost:3000/return', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({"return":"true"})
  });
  
}