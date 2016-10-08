from bottle import route, run, static_file, request, template, error
import bottle
import collections
import database as db
import weather as w
from beaker.middleware import SessionMiddleware
from oauth2client.client import flow_from_clientsecrets
import urlparse
import httplib2
from apiclient.discovery import build

temp_redirect_url = None

session_opts = {
    'session.type': 'file',
    'session.data_dir': './data',
    'session.cookie_expires': False,
    'session.auto': True
}

app = SessionMiddleware(bottle.app(), session_opts)

@route('/usertest')
def user_params_test():
	user = get_user_details()
	return user

@route('/home')
@route('/')
def go_to_home():
	weather = w.getWeatherInfo()
	user = get_user_details()
	params = weather.copy()
	params.update(user)
	return template('home.tpl', **params)

@route('/search')
def search():
	params = get_user_details()
	query = request.query.q
	query = query.strip()
	if (query == ''):
		params.update(w.getWeatherInfo())
		return template('home.tpl', **params)
	elif " " not in query:
		if params['logged_in']:
			db.update_entry(query, 1, params['id'])
		params['query'] = query
		return template('search.tpl', **params)
	elif "top keywords" == query.lower():
		if params['logged_in']:
			db.update_entry("Top", 1, params['id'])
			db.update_entry("Keywords", 1, params['id'])
		params['query'] = query
		return template('top_keywords.tpl', **params)
	else:
		querys = query.split(' ')
		for q in querys:
			q = q.strip()
		queryCount = collections.Counter(querys)
		if params['logged_in']:
			db.add_list_to_db(queryCount, params['id'])
		params['querys']=queryCount
		params['query']=query
		return template('multisearch.tpl', **params)

@route('/login')
def login():
	flow = flow_from_clientsecrets('client_secrets.json', 
		scope='https://www.googleapis.com/auth/plus.me https://www.googleapis.com/auth/userinfo.email', 
		redirect_uri='http://localhost:8080/auth_return')

	auth_uri = flow.step1_get_authorize_url()
	bottle.redirect(str(auth_uri))

@route('/logout')
def logout():
	s = bottle.request.environ.get('beaker.session')
	s.invalidate()
	bottle.redirect("/")

@route('/auth_return')
def auth_return():
	code = request.query.code
	if code is None:
		return '500 - internal server error'

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


@route('/top_keywords')
def top_keywords():
	params = get_user_details()
	if params['logged_in']:
		db.update_entry("Top", 1, params['id'])
		db.update_entry("Keywords", 1, params['id'])
	params['query'] = "Top Keywords"
	return template('top_keywords.tpl', **params)

#Static def for files in folders
@route('/<folder:path>/<filename:path>')
def static_css(folder, filename):
    return static_file(filename, root='./' + folder)

#static def for files in root
@route('/<filename:path>')
def static_css(filename):
    return static_file(filename, root='./')

@error(404)
def error404(error):
   	return template('404.tpl')

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