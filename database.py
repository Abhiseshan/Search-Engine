import sqlite3

def create_db():
	conn = sqlite3.connect('db/keyword_count.db')
	c = conn.cursor()
	c.execute('CREATE TABLE keycount (keyword text, count integer)')
	conn.commit()
	c.close()

def update_entry(keyword, count):
	conn = sqlite3.connect('db/keyword_count.db')
	c = conn.cursor()

	c.execute('SELECT * FROM keycount WHERE keyword=?', (keyword,))

	result = c.fetchall()

	if not result:
		#insert into table
		c.execute('INSERT INTO keycount (keyword, count) VALUES (?,?)', (keyword, count))
	else:
		#update it
		if not len(result) == 1:
			print "oops an error has occured"
		else:
			count += int(result[0][1])
			c.execute('UPDATE keycount SET count=? WHERE keyword=?',(count, keyword))
	
	conn.commit()
	c.close()

def get_top_keywords():
	conn = sqlite3.connect('db/keyword_count.db')
	c = conn.cursor()

	c.execute('SELECT * FROM keycount ORDER BY count DESC LIMIT 20')
	result = c.fetchall()
	
	conn.commit()
	c.close()

	return result

def get_top_keywords_preview():
	conn = sqlite3.connect('db/keyword_count.db')
	c = conn.cursor()

	c.execute('SELECT * FROM keycount ORDER BY count DESC LIMIT 3')
	result = c.fetchall()
	
	conn.commit()
	c.close()

	return result

def add_list_to_db(list):
	#TODO make the connection to the db only once and add the elements and close the db at the end of the function

	for item in list:
		update_entry(item, list[item])

def print_db():
	conn = sqlite3.connect('db/keyword_count.db')
	c = conn.cursor()

	for row in c.execute('SELECT * FROM keycount ORDER BY count DESC'):
		print row

	conn.commit()
	c.close()

def recreate_db():
	conn = sqlite3.connect('db/keyword_count.db')
	c = conn.cursor()
	c.execute('DROP TABLE keycount')
	c.execute('CREATE TABLE keycount (keyword text, count integer)')
	conn.commit()
	c.close()