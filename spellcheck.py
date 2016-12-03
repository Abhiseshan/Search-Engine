from whoosh.spelling import *
import sqlite3

#loding into memory
conn = sqlite3.connect("database.db")
c = conn.cursor()
c.execute("SELECT word FROM lexicon")
res = c.fetchall()

words = [str(i[0]) for i in res]

print words
corrector = ListCorrector(words)

print corrector.suggest("gra")