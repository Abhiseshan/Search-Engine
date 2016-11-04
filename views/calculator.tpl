  <script src="js/calculator.js"></script>

			<div class="calculator mdl-card mdl-shadow--2dp" id="calculator">
				<div class="query">{{query}}</div>
				<input type="text" name="calc-input" value="{{ans}}" class="calc-input">
				<div class="buttons">
					<div class="row">
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect">Rad</button>
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect">Deg</button>
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect">x!</button>
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">(</button>
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">)</button>
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">%</button>
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="clearNum()">CE</button>
				    </div>
				    <div class="row">
				    	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect">Inv</button>
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">sin</button>
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">ln</button>
				      	<button class="calc-button num-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">7</button>
				      	<button class="calc-button num-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">8</button>
				      	<button class="calc-button num-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">9</button>
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">÷</button>
				    </div>
				    <div class="row">
				    	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">π</button>
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">cos</button>
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">log</button>
				      	<button class="calc-button num-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">4</button>
				      	<button class="calc-button num-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">5</button>
				      	<button class="calc-button num-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">6</button>
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">×</button>
				    </div>
				    <div class="row">
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">e</button>
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">tan</button>
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">v</button>
				      	<button class="calc-button num-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">1</button>
				      	<button class="calc-button num-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">2</button>
				      	<button class="calc-button num-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">3</button>
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">-</button>
				    </div>
				    <div class="row">
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">Ans</button>
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">EXP</button>
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">x<sup>y</sup></button>
				      	<button class="calc-button num-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">0</button>
				      	<button class="calc-button num-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">.</button>
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect button-color-blue" onclick="resultNum()">=</button>
				      	<button class="calc-button op-button mdl-button mdl-js-button mdl-js-ripple-effect" onclick="appendNum(this)">+</button>
				    </div>
				</div>
			</div>