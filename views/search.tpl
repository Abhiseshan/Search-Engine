<!doctype html>

<html lang="en">
% include('head.tpl')
<body>
	% include('search_header.tpl')

	<div class="search-results-container">
		<div class="mdl-grid">
			<div class="mdl-cell--6-col mdl-cell--1-offset">
			<!-- implement python for loop to loop throuh the search results and display them using the search display template -->
<%
			import database as db

			if results is not None:
				description = ""

				for result in results:
					params = {'link_name':db.fetch_url_title(result), 'link_url':result, 'link_description':description}
					include('search_result.tpl', **params)
				end
			end
%>
			</div>
			%if logged_in:
			<div class="query-count-table mdl-cell--4-col" style="margin: 0 auto">
				<table class="mdl-data-table mdl-js-data-table" style="width: 100%" id="results">
					<thead>
						<tr>
							<th class="mdl-data-table__cell--non-numeric">Top Keywords</th>
	      					<th class="mdl-data-table__cell--non-numeric">Count</th>
						</tr>
					</thead>
					<tbody>
						%import database as db
						%keywords = db.get_top_keywords(id)
						%for word in keywords:
						<tr>
							<td class="mdl-data-table__cell--non-numeric">{{word[0]}}</td>
							<td class="mdl-data-table__cell--non-numeric">{{word[1]}}</td>
						</tr>
						%end
					</tbody>
				</table>
			</div>
			%end
		</div>
	</div>
	% include('footer.tpl')
</body>
</html>
