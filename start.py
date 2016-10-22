from bottle import route, run, static_file, request, template, error
import bottle
import collections
import database as db
import weather as w
import background as bg
from beaker.middleware import SessionMiddleware
from oauth2client.client import flow_from_clientsecrets
import urlparse
import httplib2
import re
from apiclient.discovery import build

temp_redirect_url = None

session_opts = {
    'session.type': 'file',
    'session.data_dir': './data',
    'session.cookie_expires': False,
    'session.auto': True
}

app = SessionMiddleware(bottle.app(), session_opts)

#Load the home page with weather and user data
@route('/home')
@route('/')
def go_to_home():
	#weather = w.getWeatherInfo()
	#params = weather.copy()
	params = get_user_details()
	#params.update(user)
	background = bg.getBackground()
	params.update(background)
	return template('home.tpl', **params)

#Handles all search querys
@route('/search')
def search():
	params = get_user_details()
	query = request.query.q
	query = query.strip()

	#empty query, return back to the home
	if (query == ''):
		#params.update(w.getWeatherInfo())
		params.update(bg.getBackground())
		return template('home.tpl', **params)
	#if we detect that it is a single query
	elif " " not in query:
		if params['logged_in']:
			db.update_entry(query.strip(), 1, params['id'])
		params['query'] = query

		#if query in resolved_inverted_index.keys():
		#	params['results'] = resolved_inverted_index[query]
		#else:
		params['results'] = None

		return template('search.tpl', **params)
	else:
		querys = re.findall(r'\S+', query)
		for q in querys:
			q = q.strip()
		queryCount = collections.Counter(querys)
		if params['logged_in']:
			db.add_list_to_db(queryCount, params['id'])
		params['querys']=queryCount
		params['query']=query
		return template('multisearch.tpl', **params)

#Handles the login
@route('/login')
def login():
	flow = flow_from_clientsecrets('client_secrets.json', 
		scope='https://www.googleapis.com/auth/plus.me https://www.googleapis.com/auth/userinfo.email', 
		redirect_uri='http://localhost:8080/auth_return')

	auth_uri = flow.step1_get_authorize_url()
	bottle.redirect(str(auth_uri))

#handles the logout 
@route('/logout')
def logout():
	s = bottle.request.environ.get('beaker.session')
	s.invalidate()
	bottle.redirect("/")

#handles the return token after login auth
@route('/auth_return')
def auth_return():
	code = request.query.code
	if code is None:
		bottle.redirect(500)

	flow = flow_from_clientsecrets('client_secrets.json', 
		scope='https://www.googleapis.com/auth/plus.me https://www.googleapis.com/auth/userinfo.email', 
		redirect_uri='http://localhost:8080/auth_return')

	credentials = flow.step2_exchange(code)
	token = credentials.id_token['sub']

	http = httplib2.Http()
	http = credentials.authorize(http)
	users_service = build('oauth2', 'v2', http=http)
	user_document = users_service.userinfo().get().execute() 

	s = bottle.request.environ.get('beaker.session')
  	s['user'] = user_document
  	s.save()

  	#create a new db (if it does not exist) file for the user
  	db.create_db(user_document['id'])

  	if temp_redirect_url is None:
		bottle.redirect("/")

	bottle.redirect(temp_redirect_url)

@route('/history')
def history():
	params = get_user_details()
	params['query'] = "History"
	return template('histroy.tpl', **params)

#Static def for files in folders
@route('/<folder:path>/<filename:path>')
def static_css(folder, filename):
    return static_file(filename, root='./' + folder)

#static def for files in root
@route('/<filename:path>')
def static_css(filename):
    return static_file(filename, root='./')

#When a 404 error occurs 
@error(404)
def error404(error):
   	return template('404.tpl')

#When a 500 error occurs
@error(500)
def error500(error):
   	return template('500.tpl')


#helper functions that do not do any type of routing 

def get_user_details():
	s = bottle.request.environ.get('beaker.session')
	user = s.get('user',{})	

	if not user:
		user.update({'logged_in': False})
	else:
		user.update({'logged_in': True})

	return user


run(host='localhost', port=8080, debug=True, app=app)
