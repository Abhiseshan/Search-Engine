<div class="header-container search-header-container">
	<div class="header mdl-grid">
		<div class="mdl-cell--1-col">
			<div class="search-logo">
				<a href="/"><img src="images/banora_small.png" /></a>
			</div>
		</div>
		<div class="mdl-cell--6-col">
			<form class="search-form" action="search" method="get">
			   	<div id="searchbox" class="searchbox">
			   		<input placeholder="Search" value="{{query}}" type="text" class="search-field search-query search-query" name="q" value="" autocomplete="off">
					<button  type=button onclick="startDictation()" class="search-voice material-icons"></button>
		        	<input type="submit" value="search" class="search-enter material-icons">
			    </div>
		    </form>
	    </div>
	    %if defined('picture'):
			<img src="{{picture}}" class="profile-icon" id="profile-icon" onclick="toggle_visibility('account-box');toggle_visibility('account-box-arrow');"/>
			<div class="account-box" id="account-box">
				<a class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored logout-button" href="/logout">Logout</a>
				<div class="name">{{name}}</div>
				<div class="email">{{email}}</div>
			</div>
			<div class="account-box-arrow" id="account-box-arrow"></div>
		%else:
			<a class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored login-button" href="/login">Login</a>
		%end
	</div>
</div>