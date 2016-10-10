import sqlite3

#creates a databse neamed keyword_count
def create_db():
	conn = sqlite3.connect('db/keyword_count.db')
	c = conn.cursor()
	c.execute('CREATE TABLE keycount (keyword text, count integer)')
	conn.commit()
	c.close()

#updates a single entry into the database
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

#Gets a list of top 20 keywords
def get_top_keywords():
	conn = sqlite3.connect('db/keyword_count.db')
	c = conn.cursor()

	c.execute('SELECT * FROM keycount ORDER BY count DESC LIMIT 20')
	result = c.fetchall()
	
	conn.commit()
	c.close()

	return result

#Gets a list of top 3 keywords to use as a preview in the home page
def get_top_keywords_preview():
	conn = sqlite3.connect('db/keyword_count.db')
	c = conn.cursor()

	c.execute('SELECT * FROM keycount ORDER BY count DESC LIMIT 3')
	result = c.fetchall()
	
	conn.commit()
	c.close()

	return result

#Adds a list of items into the db (multi search querys)
def add_list_to_db(list):
	#TODO make the connection to the db only once and add the elements and close the db at the end of the function

	for item in list:
		update_entry(item, list[item])

#Prints the whole databse for debugging purposes 
def print_db():
	conn = sqlite3.connect('db/keyword_count.db')
	c = conn.cursor()

	for row in c.execute('SELECT * FROM keycount ORDER BY count DESC'):
		print row

	conn.commit()
	c.close()

#deletes the table and creates a new one - used when the session is restarted
def recreate_db():
	conn = sqlite3.connect('db/keyword_count.db')
	c = conn.cursor()
	c.execute('DROP TABLE keycount')
	c.execute('CREATE TABLE keycount (keyword text, count integer)')
	conn.commit()
	c.close()

def fetch_url_title(url):
    database = sqlite3.connect('database.db')
    c = database.cursor()
    c.execute('SELECT doc_url_title FROM DOC_INFO WHERE doc_url=?', (url,))
    title = c.fetchone()
    c.close()
    return title[0]