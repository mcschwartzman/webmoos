let nodes;

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
  background(200);
  point(20,20);
}

function draw() {
  background(220);

  stroke('purple');
  strokeWeight(10);


  // getData().then(result=>{
  //   console.log(result);
  //   let nodes = result;
  //   for (const node in nodes){
  //     let node_dict = nodes[node];
  //     // console.log(node_dict);
  //     let x = parseInt(node_dict["X"]);
  //     let y = parseInt(node_dict["Y"]);
  //     console.log(x, y);
  //     point(x, y);
  //     // point(parseInt(node_dict["X"]), parseInt(node_dict["Y"]));
  //     // console.log(node_dict["X"], node_dict["Y"]);
  //   }
  // });

  // point(100,100);
  // point(50,100);
  
  response = fetch("http://localhost:3000/nodes").then(function(response) {
    return response.json();
  }).then(function(data) {
    // console.log(data);
    nodes = data;
  });

  console.log(nodes);

  for (const node in nodes){
    let node_dict = nodes[node];
    // console.log(node_dict);
    let x = parseInt(node_dict["X"]);
    let y = -1 * parseInt(node_dict["Y"]);
    console.log(x, y);
    point(x, y);
    // point(parseInt(node_dict["X"]), parseInt(node_dict["Y"]));
    // console.log(node_dict["X"], node_dict["Y"]);
  }
  
}

// function(response){
//   let nodes = response;
//   for (const node in nodes){
//     let node_dict = nodes[node];
//     // console.log(node_dict);
//     let x = parseInt(node_dict["X"]);
//     let y = parseInt(node_dict["Y"]);
//     console.log(x, y);
//     point = {"x": x, "y": y};
//     point(x, y);
//     // point(parseInt(node_dict["X"]), parseInt(node_dict["Y"]));
//     // console.log(node_dict["X"], node_dict["Y"]);
//   }
//   // console.log(response);
// }