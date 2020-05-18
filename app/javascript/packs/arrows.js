
$("#svg_bg").attr("height", $(document).height());

var drawConnector = function(divA, divB, edge, stroke) {
  let elemA = $(divA)
  let elemB = $(divB)

  let pA = elemA.position();
  let pB = elemB.position();

  let wA = elemA.outerWidth();
  let hA = elemA.outerHeight();
  let wB = elemB.outerWidth();
  let hB = elemB.outerHeight();

  console.log(wA);

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
  $('#n_'+node).mouseover(function(){
    edges.forEach(function(edge, i) {
      if (edge[0] == node){
        drawConnector('#n_'+edge[0], '#n_'+edge[1], '#e_'+i, "fuchsia");
      }
      if (edge[1] == node){
        drawConnector('#n_'+edge[0], '#n_'+edge[1], '#e_'+i, "cyan");
      }
    });
  });
  $('#n_'+node).mouseout(function(){
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