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

function startDictation() {
	if (window.hasOwnProperty('webkitSpeechRecognition')) {

		var recognition = new webkitSpeechRecognition();

		recognition.continuous = false;
		recognition.interimResults = false;

		recognition.lang = "en-US";
		recognition.start();

		recognition.onresult = function(e) {
			document.getElementById('myInput').value = e.results[0][0].transcript;
			recognition.stop();
			document.getElementById('mySearch').submit();
		};

		recognition.onerror = function(e) {
			recognition.stop();
		}
	}
}

function startDictationResult() {
	if (window.hasOwnProperty('webkitSpeechRecognition')) {

		var recognition = new webkitSpeechRecognition();

		recognition.continuous = false;
		recognition.interimResults = false;

		recognition.lang = "en-US";
		recognition.start();

		recognition.onresult = function(e) {
			document.getElementById('myInputResult').value = e.results[0][0].transcript;
			recognition.stop();
			document.getElementById('mySearchResult').submit();
		};

		recognition.onerror = function(e) {
			recognition.stop();
		}
	}
}

function playAnim() {
	if (document.getElementById('logo').src.indexOf("images/banora.png") != -1 ){
		document.getElementById('logo').src = 'images/banora.gif'; 
	}

	else{
		document.getElementById('logo').src = 'images/banora.png'; 
	}
}
