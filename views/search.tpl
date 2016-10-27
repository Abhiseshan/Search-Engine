<!doctype html>

<html lang="en">
% include('head.tpl')
<body>
	% include('search_header.tpl')

	<div class="search-results-container">
		<div class="mdl-grid">
			<div class="mdl-cell--6-col mdl-cell--1-offset">

			<!-- Calculator -->
<%
			import re
			import requests

			match = re.match( r'((\d*)\s*([\+\-\/\*^e%])\s*(\d*))|(log(.*))|sin(.*)|cos(.*)|tan(.*)|sec(.*)|cosec(.*)|cot(.*)|ln(.*)', query)

			if match:
				val = requests.get("http://api.mathjs.org/v1/", params={'expr': query})				
				params = {'ans': val.text, 'query':query + ' ='}
				include('calculator.tpl', **params)
			end	

%>
			
			<!-- implement python for loop to loop throuh the search results and display them using the search display template -->
<%
			from collections import namedtuple		 			
			ResultStruct = namedtuple("ResultStruct", "name link description")		
			searchResults = []		
			#for testing purposes only		
			searchResults.append(ResultStruct("Test1", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))		
			searchResults.append(ResultStruct("Test2", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))		
			searchResults.append(ResultStruct("Test3", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))		
			searchResults.append(ResultStruct("test4", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))		
			searchResults.append(ResultStruct("Test5", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))		
			searchResults.append(ResultStruct("Test6", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test7", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test8", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test9", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test10", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test11", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test12", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test13", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test14", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test15", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test16", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test17", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test18", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test19", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test20", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test21", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test22", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test23", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test24", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test25", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test26", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
			searchResults.append(ResultStruct("Test27", "test.com", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id enim orci. Quisque at risus sapien. Duis congue purus in lorem sagittis, quis fringilla tortor rhoncus. Duis malesuada pellentesque sapien, id elementum est tincidunt at. Mauris id placerat lectus. Nulla."))
	
			tot_results = len(searchResults)

			if start is None or str(start) is '':
				start = 0
			end

			start = int(start)

			max_pg = tot_results/10
			current = start/10

			url = '/search?q=' + query +  u"\u0026" + 'start='

			pageSearchResults = [searchResults[i:i+10] for i in range(0,len(searchResults),10)]


			for result in pageSearchResults[current]:
				params = {'link_name':result.name, 'link_url':result.link, 'link_description':result.description}
 				include('search_result.tpl', **params)
 			end

			#import database as db

			#if results is not None:
			#	description = ""

				#for result in results:
					#params = {'link_name':db.fetch_url_title(result), 'link_url':result, 'link_description':description}
					#include('search_result.tpl', **params)
				#end
			#end
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

		<nav class="mdl-grid">
		    <ul class="pagination mdl-cell--1-offset">
		        <!--Arrow left-->
		        <li class="page-item">
		            <a class="page-link" aria-label="Previous">
		                <span aria-hidden="true">&laquo;</span>
		            </a>
		        </li>

		        %for i in range(current-7, current+7):
		        	%if i <= max_pg and i >=0:
		        		%url_i = url + str(i) + "0"
		        		<li class="page-item"><a href="{{url_i}}">{{i+1}}</a></li>
		        	%end
		        %end

		        <!--Arrow right-->
		        <li class="page-item">
		            <a class="page-link" aria-label="Next">
		                <span aria-hidden="true">&raquo;</span>
		            </a>
		        </li>
		    </ul>
		</nav>
	</div>
	<div style="height: 50px"></div>

	% include('footer.tpl')
</body>
</html>
