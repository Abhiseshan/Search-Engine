<div class="header-container search-header-container">
	<div class="header mdl-grid">
		<div class="mdl-cell--1-col search_logo_desktop">
			<a href="/"><div class="search-logo" ></div></a>
		</div>
		<div class="mdl-cell--6-col search_logo_mobile center">
			<a href="/"><div class="search-logo-mobile" ></div></a>
		</div>
		<div class="mdl-cell--6-col">
			<form id= "mySearchResult" class="search-form" action="search" method="get">
			   	<div id="searchbox" class="searchbox">
			   		<input id= "myInputResult" placeholder="Search" value="{{query}}" type="text" class="search-field search-query search-query" name="q" value="" autocomplete="off">
					<button  type=button onclick="startDictationResult()" class="search-voice material-icons"></button>
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
