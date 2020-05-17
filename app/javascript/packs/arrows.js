
$("#svg_bg").attr("height", $(document).height());

var drawConnector = function(divA, divB, edge) {
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
    edgeyB = yB + hB + 10;
    curvex = edgexB;
    curvey = edgeyA;
    }

  if(yB > yA){
    edgexB = xB + wB / 2;
    edgexB -= 0;
    edgexA = xA + wA / 2;
    edgeyA = yA + hA + 10;
    curvex = edgexA;
    curvey = edgeyB;
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
};

edges.forEach(function(edge, i) {
  drawConnector('#n_'+edge[0], '#n_'+edge[1], '#e_'+i);
});