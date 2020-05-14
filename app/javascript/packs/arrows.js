var divA       = document.querySelector("#a");
var divB       = document.querySelector("#b");
var arrowLeft  = document.querySelector("#arrowLeft");
var arrowRight = document.querySelector("#arrowRight");

var drawConnector = function() {
  var posnALeft = {
    x: divA.offsetLeft - 8,
    y: divA.offsetTop  + divA.offsetHeight / 2
  };
  var posnARight = {
    x: divA.offsetLeft + divA.offsetWidth + 8,
    y: divA.offsetTop  + divA.offsetHeight / 2    
  };
  var posnBLeft = {
    x: divB.offsetLeft - 8,
    y: divB.offsetTop  + divB.offsetHeight / 2
  };
  var posnBRight = {
    x: divB.offsetLeft + divB.offsetWidth + 8,
    y: divB.offsetTop  + divB.offsetHeight / 2
  };
  var dStrLeft =
      "M" +
      (posnALeft.x      ) + "," + (posnALeft.y) + " " +
      "C" +
      (posnALeft.x - 100) + "," + (posnALeft.y) + " " +
      (posnBLeft.x - 100) + "," + (posnBLeft.y) + " " +
      (posnBLeft.x      ) + "," + (posnBLeft.y);
  arrowLeft.setAttribute("d", dStrLeft);
  var dStrRight =
      "M" +
      (posnBRight.x      ) + "," + (posnBRight.y) + " " +
      "C" +
      (posnBRight.x + 100) + "," + (posnBRight.y) + " " +
      (posnARight.x + 100) + "," + (posnARight.y) + " " +
      (posnARight.x      ) + "," + (posnARight.y);
  arrowRight.setAttribute("d", dStrRight);
};

// $("#x0_0_4_d, #x0_0_4_d").draggable({
//   drag: function(event, ui) {
//     drawConnector();
//   }
// });

drawConnector();

// setTimeout(drawConnector, 250);
/* The setTimeout delay here is only required to prevent
 * the initial appearance of the arrows from being
 * incorrect due to the animated expansion of the
 * Stack Overflow code snippet results after clicking
 * "Run Code Snippet." If this was a simpler website,
 * a simple command, i.e. `drawConnector();` would suffice.
 */