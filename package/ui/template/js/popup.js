// Script für Popupfenster http://www.stichpunkt.de/html/popup.html
var pop = null;

function popdown() {
if (pop && !pop.closed) pop.close();
}

function popup(obj,w,h) {
	var url = (obj.getAttribute) ? obj.getAttribute("href") : obj.href;
	if (!url) return true;
	w = (w) ? w += 20 : 150;  // 150px*150px is the default size
	h = (h) ? h += 25 : 150;
	var args = "width="+w+",height="+h+",resizable";
	popdown();
	pop = window.open(url,"",args);
	return (pop) ? false : true;
}

// window.onunload = popdown;
// window.onfocus = popdown;