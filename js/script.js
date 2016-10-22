window.onload = function() {
	var bt_login = document.querySelector('.login-button');
	bt_login.setAttribute("href", "/login?redirect=" + (location.pathname+location.search).substr(1));
}

function toggle_visibility(id) {
   var e = document.getElementById(id);
   if(e.style.display == 'block')
      e.style.display = 'none';
   else
      e.style.display = 'block';
}