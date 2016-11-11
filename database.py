import sqlite3

def create_db(db_id):
	db = 'db/' + db_id + '.db'
	conn = sqlite3.connect(db)
	c = conn.cursor()
	c.execute('CREATE TABLE IF NOT EXISTS keycount (keyword text, count integer)')
	conn.commit()
	c.close()

def update_entry(keyword, count, db_id):
	db = 'db/' + db_id + '.db'
	conn = sqlite3.connect(db)
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

def update_entry_multi(keyword, count, c):
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

def get_all_keywords(db_id):
	db = 'db/' + db_id + '.db'
	conn = sqlite3.connect(db)
	c = conn.cursor()

	c.execute('SELECT * FROM keycount ORDER BY count')
	result = c.fetchall()
	
	conn.commit()
	c.close()

	return result

def get_top_keywords(db_id):
	db = 'db/' + db_id + '.db'
	conn = sqlite3.connect(db)
	c = conn.cursor()

	c.execute('SELECT * FROM keycount ORDER BY count DESC LIMIT 10')
	result = c.fetchall()
	
	conn.commit()
	c.close()

	return result

def add_list_to_db(list, db_id):
	db = 'db/' + db_id + '.db'
	conn = sqlite3.connect(db)
	c = conn.cursor()
	for item in list:
		update_entry_multi(item, list[item], c)

	conn.commit()
	c.close()

def print_db(db_id):
	db = 'db/' + db_id + '.db'
	conn = sqlite3.connect(db)
	c = conn.cursor()

	for row in c.execute('SELECT * FROM keycount ORDER BY count DESC'):
		print row

	conn.commit()
	c.close()

def recreate_db(db_id):
	db = 'db/' + db_id + '.db'
	conn = sqlite3.connect(db)
	c = conn.cursor()
	c.execute('DROP TABLE keycount')
	c.execute('CREATE TABLE keycount (keyword text, count integer)')
	conn.commit()
	c.close()

def fetch_web_links(word):
	conn = sqlite3.connect("database.db")
	c = conn.cursor()

	#Get word id from lexicon
	c.execute("SELECT * FROM lexicon WHERE word=?", (word,))
	res = c.fetchone()
	if (res is None):
		return None, None

	word_id = res[0]

	#Get All the pages containing the word
	c.execute("SELECT * FROM invertedindex WHERE word_id=?", (word_id,))
	res = c.fetchone()
	doc_ids = res[1]
	doc_ids = "(" + doc_ids + ")"

	#Get page rank of all the pages
	c.execute("SELECT * FROM pagerank WHERE doc_id IN" + doc_ids + " ORDER BY doc_rank ASC")
	res = c.fetchall()

	pagerank = []
	for r in res:
		pagerank.append(int(r[0]))

	#Get information about the page
	c.execute("SELECT * FROM DocIndex WHERE doc_id in" + doc_ids)
	res = c.fetchall()

	pages = {}
	for r in res:
		pages[int(r[0])] = r 

	c.close()
	return pages, pagerank