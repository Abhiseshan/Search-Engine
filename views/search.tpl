<!doctype html>

<html lang="en">
% include('head.tpl')
<body>
	% include('search_header.tpl')

	<div class="search-results-container">
		<div class="mdl-grid">
			<div class="mdl-cell--6-col mdl-cell--1-offset-desktop mdl-cell--1-offset-tablet mobile-result">

			<!-- Spellcheck -->
			%if corrected != query.strip() and str(start) is '':
				<div class="spell_check">Did you mean <a href="search?q={{corrected}}">{{corrected}}</a></div>
			%end

<%
			if start is None or str(start) is '':
				start = 0
			end

			start = int(start)

	#Calculator 

			if start == 0:
				import re
				import requests

				match = re.match( r'((\d*)\s*([\+\-\/\*^e%])\s*(\d*))|(log(.*))|sin(.*)|cos(.*)|tan(.*)|sec(.*)|cosec(.*)|cot(.*)|ln(.*)', query)
				
				if match: 
					val = requests.get("http://api.mathjs.org/v1/", params={'expr': query})
					if not "Error: Undefined symbol" in val.text:
						params = {'ans': val.text, 'query':query + ' ='}
						include('calculator.tpl', **params)
					end
				elif query == "calculator":
					params = {'ans': "0", 'query':""}
					include('calculator.tpl', **params)
				end
			end


	#Weather

			if start == 0:
				if query == "weather":
					include('weather.tpl')
				end
			end
	#<----------------------------------------------------------------------------------------------		
	#problem is here?
	#Game
			if start == 0:
				if query == "nocowlevel":
					include('game.tpl')
				end
			end

	#Search Results

			import database as db
			import urllib
			from bottle import *
			from collections import namedtuple		 			
			ResultStruct = namedtuple("ResultStruct", "name link description")		
			searchResults = []

			try: 
				pages, pagerank = db.fetch_web_links_multi(querys)
			except NameError: 
				pages, pagerank = db.fetch_web_links(query)
			end

			if not pages is None:
		 		for page in pagerank:
					searchResults.append(ResultStruct(pages[page][2], pages[page][1], pages[page][3]))
				end

				tot_results = len(searchResults)-1

				max_pg = tot_results/10
				current = start/10

				url = '/search?' + urllib.urlencode({'q':query}) +  u"\u0026" + 'start='

				pageSearchResults = [searchResults[i:i+10] for i in range(0,len(searchResults),10)]


				for result in pageSearchResults[current]:
					params = {'link_name':result.name, 'link_url':result.link, 'link_description':result.description}
	 				include('search_result.tpl', **params)
	 			end
	 		elif query != "nocowlevel":
%>

			<p>Your search - <b>{{query}} </b>- did not match any documents.</p>
			<p>Suggestions</p>
			<ul>
				<li>Make sure that all words are spelled correctly</li>
				<li>Try different keywords.</li>
				<li>Try more general keywords.</li>
			</ul>

			%end
			
			<!-- implement python for loop to loop throuh the search results and display them using the search display template -->

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

		%if not pages is None: 
		<nav class="mdl-grid">
		    <ul class="pagination mdl-cell--1-offset-desktop mdl-cell--1-offset-tablet">
		        <!--Arrow left-->
		        <li class="page-item">
		       		%url_i = url + "0"
			        %if current != 0:
			        	%url_i  = url + str(current-1) + "0"
			        %end
		            <a href="{{url_i}}" class="page-link" aria-label="Previous">
		                <span aria-hidden="true">&laquo;</span>
		            </a>
		        </li>
			        %for i in range(current-7, current+7):
			        	%if i <= max_pg and i >=0:
			        		%url_i = url + str(i) + "0"
			        		%if i == current:
			        			%active="active"
			        		%else:
			        			%active=""
			        		%end
			        		<li class="page-item {{active}} pg-number"><a href="{{url_i}}">{{i+1}}</a></li>
			        	%end
			        %end
		        <!--Arrow right-->
		        <li class="page-item">
		        	%url_i = url + str(max_pg) + "0"
			        %if current != max_pg:
			        	%url_i = url + str(current+1) + "0"
			        %end
		            <a href="{{url_i}}" class="page-link" aria-label="Next">
		                <span aria-hidden="true">&raquo;</span>
		            </a>
		        </li>
		    </ul>
		</nav>
	    %end
	</div>
	<div style="height: 50px"></div>

	% include('footer.tpl')
</body>
</html>
