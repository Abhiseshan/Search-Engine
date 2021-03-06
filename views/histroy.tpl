<!doctype html>

<html lang="en">
% include('head.tpl')
<body>
	% include('search_header.tpl')

	<div class="search-results-container">
		<div class="mdl-grid">
			%if logged_in:
			<div class="mdl-cell--5-col mdl-cell--1-offset query-count-table">
				<table class="mdl-data-table mdl-js-data-table" style="width: 100%" id="results">
					<thead>
						<tr>
							<th class="mdl-data-table__cell--non-numeric">Top Keywords</th>
	      					<th class="mdl-data-table__cell--non-numeric">Count</th>
						</tr>
					</thead>
					<tbody>
						%import database as db
						%keywords = db.get_all_keywords(id)
						%for word in keywords:
						<tr>
							<td class="mdl-data-table__cell--non-numeric">{{word[0]}}</td>
							<td class="mdl-data-table__cell--non-numeric">{{word[1]}}</td>
						</tr>
						%end
					</tbody>
				</table>
				<a href="/clear_history" class="clear-history-button mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect">Clear History</a>
			</div>
			%else:
				<p>Please login to view this page. Thank you.</p>
			%end
		</div>
	</div>
	<div style="height: 50px"></div>
	% include('footer.tpl')
</body>
</html>
