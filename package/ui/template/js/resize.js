// Script um die Höhe der Box mit Logfileausgabe an Fenstergröße anzupassen

function setBoxHeight() {
  var h0=window.innerHeight;
  var h=document.body.scrollHeight;
  var o1=document.getElementById("file-content-box");
  if (!!o1) {
    var h1=o1.style.height;
    var t1=o1.getBoundingClientRect().top;
    let h2=h0-t1-22;
    if (h2>50) {
      o1.style.height = h2+"px";
      var o2=document.getElementById("file-content-txt");
      if (!!o2) {
        o2.style.height=h2+"px";
        if (h>h0+20) { // the list of available files causes scrollbar for whole dialog
          o2.style.resize="vertical"
        }
        else {
          o2.style.resize="none"
        }
      }
    }
  }
}


function myLoad() {
  setBoxHeight();
  var o2=document.getElementById("file-content-txt");
  if (!!o2) {
    var sy=o2.scrollHeight;
    o2.scrollTo(0, sy);
    }
  }

window.onload=myLoad;
window.onresize=setBoxHeight;
