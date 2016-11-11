import urllib2
import json
from datetime import *

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
	weather = {	
		'temp': temp, 
		'temp_min': temp_min, 
		'temp_max': temp_max, 
		'desc': data['weather'][0]['main'], 
		'icon': data['weather'][0]['icon'],
		'location': data['name'] + ", " + data['sys']['country']
	}
	return weather

def getExtendedWeatherInfo():
	contents = urllib2.urlopen("http://api.openweathermap.org/data/2.5/forecast/daily?q=Toronto,on&units=metric&cnt=5&appid=4805980c3c170bc0dcb39db79bf940eb").read()
	data = json.loads(contents)	
	wlist = data['list']
	weatherList = {}
	dateList = []
	for item in wlist:
		dt = datetime.fromtimestamp(int(item['dt'])).strftime('%a')
		#datetime.fromtimestamp(int(item['dt'])).strftime('%Y-%m-%d')
		dateList.append(dt)
		temp_min = int(float(item['temp']['min']))
		temp_max = int(float(item['temp']['max']))
		weatherList[dt] = {"temp_min":temp_min, "temp_max":temp_max, "icon":item['weather'][0]['icon']}
	
	return weatherList,dateList

def getWeatherJSON():
	contents = urllib2.urlopen("http://api.openweathermap.org/data/2.5/forecast?q=Toronto,on&units=metric&appid=4805980c3c170bc0dcb39db79bf940eb").read()
	data = json.loads(contents)
	wlist = data['list']
	weatherList = {}
	current_date = ""
	for item in wlist:
		dt = item['dt_txt']
		dt = dt.split(" ")
		tm = datetime.strptime(dt[1],'%H:%M:%S')
		tm = str(int(tm.strftime('%I'))) + tm.strftime(' %p')

		if (dt[0] != current_date):
			current_date = dt[0]
			weatherList[current_date] = []

		temp = int(float(item['main']['temp']))
		desc = item['weather'][0]['main']
		weatherList[current_date].append({'c':[{'v': tm},{'v': temp},{'v': temp}]})
	
	weather_json = {
		'cols': [        
			{"label":"Hour","type":"string"},
        	{"label":"Temp","type":"number"},
        	{"label":"Annotation","type":"number","p":{"role":"annotation"}}
		],
		'rows': weatherList[current_date]
	}

	json_data = json.dumps(weather_json)

	return json_data