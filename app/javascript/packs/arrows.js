
$("#svg_bg").attr("height", $(document).height());

var drawConnector = function(divA, divB, edge, stroke) {
  let elemA = $(divA)
  let elemB = $(divB)

  let pA = elemA.offset();
  let pB = elemB.offset();

  let wA = elemA.innerWidth();
  let hA = elemA.innerHeight();
  let wB = elemB.innerWidth();
  let hB = elemB.innerHeight();

  // console.log(wA);

  let xA = pA.left;
  let yA = pA.top;
  let xB = pB.left;
  let yB = pB.top;

  let edgexA = xA;
  let edgeyA = yA;
  let edgexB = xB;
  let edgeyB = yB;
  let curvex = edgexB;
  let curvey = edgeyA;

  if(yA > yB){
    edgexA = xA + wA / 2;
    edgeyA -= 0;
    edgexB = xB + wB / 2;
    edgeyB = yB + hB + 8;
    curvex = edgexB;
    curvey = edgeyA;
    }

  if(yB > yA){
    edgexB = xB + wB / 2;
    edgeyB -= 8;
    edgexA = xA + wA / 2;
    edgeyA = yA + hA;
    curvex = edgexB;
    curvey = edgeyA;
  }

  if(xA == xB){
    curvex += 120;
    if(yA > yB){
      curvey = edgeyA + ((edgeyB - edgeyA) / 2);
    }
    if(yB > yA){
      curvey = edgeyB + ((edgeyA - edgeyB) / 2);
    }
  }

  if(yA == yB){
    edgexA = xA + wA / 2;
    edgeyA -= 0;
    edgexB = xB + wB / 2;
    edgeyB -= 5;
    curvex = edgexA + ((edgexB - edgexA) / 2);
    curvey = edgeyA - 140;
  }

  $(edge).attr("d", "M"+edgexA+" "+edgeyA+" Q"+curvex+" "+curvey+" "+edgexB+" "+edgeyB);
  $(edge).attr("stroke", stroke);
  $(edge).attr("marker-end", "url(#arrowhead"+ stroke +")");
};

nodes.forEach(function(node){
  $('#n_'+node).mouseenter(function(){
    edges.forEach(function(edge, i) {
      if (edge[0] == node){
        drawConnector('#n_'+edge[0], '#n_'+edge[1], '#e_'+i, "fuchsia");
      }
      if (edge[1] == node){
        drawConnector('#n_'+edge[0], '#n_'+edge[1], '#e_'+i, "cyan");
      }
    });
  });
  $('#n_'+node).mouseleave(function(){
    edges.forEach(function(edge, i) {
      if (edge[0] == node){
        drawConnector('#n_'+edge[0], '#n_'+edge[1], '#e_'+i, "black");
      }
      if (edge[1] == node){
        drawConnector('#n_'+edge[0], '#n_'+edge[1], '#e_'+i, "black");
      }
    });
  });
});

edges.forEach(function(edge, i) {
  drawConnector('#n_'+edge[0], '#n_'+edge[1], '#e_'+i, "black");
});

$(window).resize(function(){
  edges.forEach(function(edge, i) {
    drawConnector('#n_'+edge[0], '#n_'+edge[1], '#e_'+i, "black");
  });
});

let prevcolor = "black";

$(".link_delete").each(function(){
  let nodes = $(this).attr("id").split('_');

  $(this).mouseenter(function(){
    edges.forEach(function(edge, i) {
      if (edge[0] == nodes[1] && edge[1] == nodes[2]){
        prevcolor = $('#e_'+i).attr('stroke');
        drawConnector('#n_'+edge[0], '#n_'+edge[1], '#e_'+i, "orange");
      }
    });
  });

  $(this).mouseleave(function(){
    edges.forEach(function(edge, i) {
      if (edge[0] == nodes[1] && edge[1] == nodes[2]){
        drawConnector('#n_'+edge[0], '#n_'+edge[1], '#e_'+i, prevcolor);
      }
    });
  });

});