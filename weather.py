import urllib2
import json

#Gets json data from OpenWeatherAPI and parses it and returs a dictionary of needed elements
def getWeatherInfo():
	contents = urllib2.urlopen("http://api.openweathermap.org/data/2.5/weather?q=Toronto,on&appid=4805980c3c170bc0dcb39db79bf940eb").read()
	data = json.loads(contents)
	temp = float(data['main']['temp'])
	temp_min = float(data['main']['temp_min'])
	temp_max = float(data['main']['temp_max'])
	temp = temp - 273.15
	temp_min = temp_min - 273.15
	temp_max = temp_max - 273.15
	temp = str(int(temp)) + u"\u00b0"
	temp_min = str(int(temp_min)) + u"\u00b0"
	temp_max = str(int(temp_max)) + u"\u00b0"
	weather = {'temp': temp, 'temp_min': temp_min, 'temp_max': temp_max, 'desc': data['weather'][0]['main'], 'icon': data['weather'][0]['icon']}
	return weather