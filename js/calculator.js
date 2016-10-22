var ans = 0;

window.onload = function() {
	var input = document.querySelector('.calc-input');
	ans = input.value;
}

var HttpClient = function() {
    this.get = function(aUrl, aCallback) {
        var anHttpRequest = new XMLHttpRequest();
        anHttpRequest.onreadystatechange = function() { 
            if (anHttpRequest.readyState == 4 && anHttpRequest.status == 200)
                aCallback(anHttpRequest.responseText);
        }

        anHttpRequest.open( "GET", aUrl, true );            
        anHttpRequest.send( null );
    }
}

function appendNum(ele) {
	var input = document.querySelector('.calc-input');
	var inner = ele.innerHTML;
	var val = inner.substr(0, inner.indexOf('<')); 
	if (val == 'x'){
		val = '^';
	}
	input.value += val;
}

function resultNum() {
	var input = document.querySelector('.calc-input');
	var equation = input.value;
	var lastChar = equation[equation.length - 1];

	console.log(ans);

	var orig = equation;
	equation = equation.replace(/×/g, '*').replace(/÷/g, '/').replace(/\+/g, '%2B').replace(/Ans/g, ans).replace(/π/g, 'pi');

	if(equation) {
		//http://api.mathjs.org/v1/?expr=2*(7-3)
		equation.replace(/ /g,'');
		var query = "http://api.mathjs.org/v1/?expr=" + equation;
		aClient = new HttpClient();
		aClient.get(query, function(response) {
		   	input.value = response;
		   	ans = response;
		});
		var eqn = document.querySelector('#calculator .query');
		eqn.innerHTML = orig + '=';
		//input.value = eval(equation);
	}
	decimalAdded = false;
}

function clearNum() {
	var input = document.querySelector('.calc-input');
	input.value = '';
	decimalAdded = false;
}
