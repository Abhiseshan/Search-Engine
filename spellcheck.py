"""from whoosh.spelling import *
import sqlite3

#loding into memory
conn = sqlite3.connect("database.db")
c = conn.cursor()
c.execute("SELECT word FROM lexicon")
res = c.fetchall()

words = [str(i[0]) for i in res]

print words
corrector = ListCorrector(words)

print corrector.suggest("gra")"""

import re, collections

def words(text):
    return re.findall('[a-z]+', text.lower())

def train(features):
    model = collections.defaultdict(lambda: 1)
    for f in features:
        model[f] += 1
    return model

NWORDS = train(words(file('words.txt').read()))
alphabet = 'abcdefghijklmnopqrstuvwxyz_'

def edits1(word):
    s = [(word[:i], word[i:]) for i in range(len(word) + 1)]
    deletes    = [a + b[1:] for a, b in s if b]
    transposes = [a + b[1] + b[0] + b[2:] for a, b in s if len(b)>1]
    replaces   = [a + c + b[1:] for a, b in s for c in alphabet if b]
    inserts    = [a + c + b     for a, b in s for c in alphabet]
    return set(deletes + transposes + replaces + inserts)

def known_edits2(word):
    return set(e2 for e1 in edits1(word) for e2 in edits1(e1) if e2 in NWORDS)

def known(words):
    return set(w for w in words if w in NWORDS)

def correct(word):
    candidates = known([word]) or known(edits1(word)) or    known_edits2(word) or [word]
    return max(candidates, key=NWORDS.get)

def correct_query(query):
	corrected = ""
	for words in query.split():
		corrected += (correct(words.strip()) + " ")

	return corrected.strip()

print "this art" == correct_query("this art")
print correct_query("this art")