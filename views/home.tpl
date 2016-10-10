<!doctype html>

<html lang="en">
% include('head.tpl')
<body class="home-body" style="background: url({{bg_url}}); background-size: cover; background-repeat: no-repeat; background-position: center center;">
	<div class="header-container">
		<div class="header">
			<!--TODO Handle case of no picture available -->
			%if logged_in:
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

	<div class="home-container">
		<div class="main-logo">
				<img src="images/banora.png" />
		</div>
		<div class="devsite-search-wrapper devsite-home-page-search-wrapper">
			<form class="devsite-search-form" action="search" method="get">
			   	<div id="searchbox" class="devsite-searchbox">
			   		<input placeholder="Search" type="text" class="devsite-search-field devsite-search-query search-query" name="q" value="" autocomplete="off">
		        	<input type="submit" value="search" class="devsite-search-enter material-icons">
			    </div>
		    </form>
		</div>
	</div>

	<div class="img-credits">{{bg_copywright}}</div>

	% include('footer.tpl')
</body>
</html>
