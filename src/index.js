require('./index.html');
import { Main } from './Main.elm';
var mountNode = document.getElementById('main');

var app = Main.embed(mountNode);

document.body.onkeypress = function(e) {
    app.ports.bodyKeyPress.send(e.keyCode);
};