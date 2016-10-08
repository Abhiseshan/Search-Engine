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
				from collections import namedtuple
				ResultStruct = namedtuple("ResultStruct", "name link description")
				searchResults = []
				#for testing purposes only
				searchResults.append(ResultStruct("Test", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
				searchResults.append(ResultStruct("Test", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
				searchResults.append(ResultStruct("Test", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
				searchResults.append(ResultStruct("test", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
				searchResults.append(ResultStruct("Test", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
				searchResults.append(ResultStruct("Test", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))

				for result in searchResults:
					params = {'link_name':result.name, 'link_url':result.link, 'link_description':result.description}
					include('search_result.tpl', **params)
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
