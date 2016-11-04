import urllib2
import json

def getBackground():
	contents = urllib2.urlopen("https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US").read()
	data = json.loads(contents)
	url = "https://www.bing.com" + data['images'][0]['url']
	copywright = data['images'][0]['copyright']
	return {'bg_url': url, 'bg_copywright': copywright}