<!doctype html>

<html lang="en">
% include('head.tpl')
<body>
	<div class="header-container">
		<div class="header">
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
		<div class="main-logo">
				<img src="images/banora.png" />
		</div>
		<div class="devsite-search-wrapper devsite-home-page-search-wrapper">
			<form class="devsite-search-form" action="search" method="get">
			   	<div id="searchbox" class="devsite-searchbox">
			   		<input placeholder="Search" type="text" class="devsite-search-field devsite-search-query" name="q" value="" autocomplete="off">
		        	<div class="devsite-search-image material-icons"></div>
		        	<input type="submit" value="send" class="devsite-search-enter material-icons">
			    </div>
		    </form>
		</div>
	</div>

	<div class="container">
		<div class="mdl-grid">
			<div class="mdl-card-wide mdl-card mdl-shadow--2dp mdl-cell mdl-cell--6-col">
				<div class="mdl-card__media">
					<table class=" mdl-data-table mdl-js-data-table" style="width: 100%" id="results">
						<thead>
							<tr>
								<th class="mdl-data-table__cell--non-numeric">Top Keywords</th>
		      					<th class="mdl-data-table__cell--non-numeric">Count</th>
							</tr>
						</thead>
						<tbody>
							%import database as db
							%keywords = db.get_top_keywords_preview()
							%for word in keywords:
							<tr>
								<td class="mdl-data-table__cell--non-numeric">{{word[0]}}</td>
								<td class="mdl-data-table__cell--non-numeric">{{word[1]}}</td>
							</tr>
							%end
						</tbody>
					</table>
				</div>
				<div class="mdl-card__actions mdl-card--border">
				    <a class="mdl-button mdl-button--colored mdl-js-button mdl-js-ripple-effect" href="/top_keywords">
				      View all
				    </a>
				</div>
			</div>
			<div class="mdl-card mdl-shadow--2dp mdl-cell mdl-cell--3-col">
				<div class="mdl-card__media card-weather">
					<div class="current">
						<div class="city">Toronto</div>
						<div class="icon"><img src="/images/ic_weather/{{icon}}.png"></div>
						<div class="devider"></div>
						<div class="desc">{{desc}}</div>
						<div class="temp">{{temp}}</div>
					</div>
					<div class="high-low">
						<div class="icon"><img src="/images/ic_weather/temp_high.png"></div>
						<div class="temp">{{temp_max}}</div>
						<div class="icon"><img src="/images/ic_weather/temp_low.png"></div>		
						<div class="temp">{{temp_min}}</div>				
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
