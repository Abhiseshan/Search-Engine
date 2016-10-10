# Copyright (C) 2011 by Peter Goodman
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

import urllib2
import urlparse
import os
from bs4 import*
from bs4 import Tag
import sqlite3
from collections import defaultdict
import re


def attr(elem, attr):
    """An html attribute from an html element. E.g. <a href="">, then
    attr(elem, "href") will get the href or an empty string."""
    try:
        return elem[attr]
    except:
        return ""

WORD_SEPARATORS = re.compile(r'\s|\n|\r|\t|[^a-zA-Z0-9\-_]')
_word_id_to_word = {} #Create a dictionary which maps word id to word
_inverted_index = {}  #Create a dictionary for mapping the word id to doc id
_resolved_inverted = {} #Create a dictionary for mapping the words to URL
_url_title = {}       #Create a dictionary to store the titles of URL
_doc_id_to_url = {}   #Create a dictionary for mapping the doc id to URL


#returns a single word id with the document ids given a word id
def get_single_inverted_index(selected_id):
    inverted_set = {}
    doc_id_set = set()
    doc_id_set = _inverted_index[selected_id]
    inverted_set[selected_id] = doc_id_set
    return inverted_set
    
#returns a word with urls given the word
def get_single_resolved_inverted_index(selected_word):
    resolved_inverted_set = {}
    url_set = set()
    url_set = _resolved_inverted[selected_word]
    resolved_inverted_set[selected_word] = url_set
    return resolved_inverted_set

class crawler(object):
    """Represents 'Googlebot'. Populates a database by crawling and indexing
    a subset of the Internet.

    This crawler keeps track of font sizes and makes it simpler to manage word
    ids and document ids."""

    def __init__(self, db_conn, url_file):
        """Initialize the crawler with a connection to the database to populate
        and with the file containing the list of seed URLs to begin indexing."""
        self._url_queue = [ ]
        self._doc_id_cache = { }
        self._word_id_cache = { }
        self._link_list = []

        # functions to call when entering and exiting specific tags
        self._enter = defaultdict(lambda *a, **ka: self._visit_ignore)
        self._exit = defaultdict(lambda *a, **ka: self._visit_ignore)

        # add a link to our graph, and indexing info to the related page
        self._enter['a'] = self._visit_a

        # record the currently indexed document's title an increase
        # the font size
        #def visit_title(*args, **kargs):
        #   self._visit_title(*args, **kargs)
        #   self._increase_font_factor(7)(*args, **kargs)

        # increase the font size when we enter these tags
        self._enter['b'] = self._increase_font_factor(2)
        self._enter['strong'] = self._increase_font_factor(2)
        self._enter['i'] = self._increase_font_factor(1)
        self._enter['em'] = self._increase_font_factor(1)
        self._enter['h1'] = self._increase_font_factor(7)
        self._enter['h2'] = self._increase_font_factor(6)
        self._enter['h3'] = self._increase_font_factor(5)
        self._enter['h4'] = self._increase_font_factor(4)
        self._enter['h5'] = self._increase_font_factor(3)
        #self._enter['title'] = visit_title

        # decrease the font size when we exit these tags
        self._exit['b'] = self._increase_font_factor(-2)
        self._exit['strong'] = self._increase_font_factor(-2)
        self._exit['i'] = self._increase_font_factor(-1)
        self._exit['em'] = self._increase_font_factor(-1)
        self._exit['h1'] = self._increase_font_factor(-7)
        self._exit['h2'] = self._increase_font_factor(-6)
        self._exit['h3'] = self._increase_font_factor(-5)
        self._exit['h4'] = self._increase_font_factor(-4)
        self._exit['h5'] = self._increase_font_factor(-3)
        #self._exit['title'] = self._increase_font_factor(-7)

        # never go in and parse these tags
        self._ignored_tags = set([
            'meta', 'script', 'link', 'meta', 'embed', 'iframe', 'frame', 
            'noscript', 'object', 'svg', 'canvas', 'applet', 'frameset', 
            'textarea', 'style', 'area', 'map', 'base', 'basefont', 'param',
        ])

        # set of words to ignore
        self._ignored_words = set([
            '', 'the', 'of', 'at', 'on', 'in', 'is', 'it',
            'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
            'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
            'u', 'v', 'w', 'x', 'y', 'z', 'and', 'or',
        ])

        self._mock_next_doc_id = 1
        self._mock_next_word_id = 1

        # keep track of some info about the page we are currently parsing
        self._curr_depth = 0
        self._curr_url = ""
        self._curr_doc_id = 0
        self._font_size = 0
        self._curr_words = None

        # get all urls into the queue
        try:
            with open(url_file, 'r') as f:
                for line in f:
                    self._url_queue.append((self._fix_url(line.strip(), ""), 0))
        except IOError:
            pass

        self.crawl(depth=1)


    def _mock_insert_document(self, url):
        """A function that pretends to insert a url into a document db table
        and then returns that newly inserted document's id."""
        ret_id = self._mock_next_doc_id
        self._mock_next_doc_id += 1
        _doc_id_to_url[ret_id] = url         #store the id and url in _doc_id_to_url dictionary
        return ret_id
    
    def _mock_insert_word(self, word):
        """A function that pretends to inster a word into the lexicon db table
        and then returns that newly inserted word's id."""
        ret_id = self._mock_next_word_id
        self._mock_next_word_id += 1
        _word_id_to_word[ret_id] = word     #store the id and word in _word_id_to_word dictionary
        return ret_id
    
    def word_id(self, word):
        """Get the word id of some specific word."""
        if word in self._word_id_cache:
            return self._word_id_cache[word]

        word_id = self._mock_insert_word(word)
        self._word_id_cache[word] = word_id
        return word_id
    
    def document_id(self, url):
        """Get the document id for some url."""
        if url in self._doc_id_cache:
            return self._doc_id_cache[url]
        
        doc_id = self._mock_insert_document(url)
        self._doc_id_cache[url] = doc_id
        return doc_id

    def _fix_url(self, curr_url, rel):
        """Given a url and either something relative to that url or another url,
        get a properly parsed url."""

        rel_l = rel.lower()
        if rel_l.startswith("http://") or rel_l.startswith("https://"):
            curr_url, rel = rel, ""
            
        # compute the new url based on import 
        curr_url = urlparse.urldefrag(curr_url)[0]
        parsed_url = urlparse.urlparse(curr_url)
        return urlparse.urljoin(parsed_url.geturl(), rel)

    #def add_link(self, from_doc_id, to_doc_id):
        """Add a link into the database, or increase the number of links between
        two pages in the database."""
        #self._link_list.append((from_doc_id, to_doc_id))
        # TODO

    def _visit_title(self, title):
        """Called when visiting the <title> tag."""
        #title_text = self._text_of(elem).strip()
        _url_title[self._curr_url] = title
    
    def _visit_a(self, elem):
        """Called when visiting <a> tags."""

        dest_url = self._fix_url(self._curr_url, attr(elem,"href"))
        #_url_title[dest_url] = self._text_of(elem).strip()
        #print "href="+repr(dest_url), \
        #      "title="+repr(attr(elem,"title")), \
        #      "alt="+repr(attr(elem,"alt")), \
        #      "text="+repr(self._text_of(elem))

        # add the just found URL to the url queue
        self._url_queue.append((dest_url, self._curr_depth))
        #self._url_queue2.append(dest_url)
        
        # add a link entry into the database from the current document to the
        # other document
        #self.add_link(self._curr_doc_id, self.document_id(dest_url)) uncomment later

        # TODO add title/alt/text to index for destination url
    
    def _add_words_to_document(self):
        # TODO: knowing self._curr_doc_id and the list of all words and their
        #       font sizes (in self._curr_words), add all the words into the
        #       database for this document
        #       print "num words="+ str(len(self._curr_words))
        for word in self._curr_words:
            word_id = word[0]  #curr_words is a list for all word ids with the doc id, we consider it as array and just require the word id
            if word_id in _inverted_index:  #if particular word id exisits add the corresponding doc id
                _inverted_index[word_id].add(self._curr_doc_id)
            else:
                _inverted_index[word_id]= set()  #if word id doesnt exist create a set and add the corresponding doc id to it
                _inverted_index[word_id].add(self._curr_doc_id)
    

    def _increase_font_factor(self, factor):
        """Increade/decrease the current font size."""
        def increase_it(elem):
            self._font_size += factor
        return increase_it
    
    def _visit_ignore(self, elem):
        """Ignore visiting this type of tag"""
        pass

    def _add_text(self, elem):
        """Add some text to the document. This records word ids and word font sizes
        into the self._curr_words list for later processing."""
        words = WORD_SEPARATORS.split(elem.string.lower())
        for word in words:
            word = word.strip()
            if word in self._ignored_words:
                continue
            self._curr_words.append((self.word_id(word), self._font_size))
        
    def _text_of(self, elem):
        """Get the text inside some element without any tags."""
        if isinstance(elem, Tag):
            text = [ ]
            for sub_elem in elem:
                text.append(self._text_of(sub_elem))
            
            return " ".join(text)
        else:
            return elem.string

    def _index_document(self, soup):
        """Traverse the document in depth-first order and call functions when entering
        and leaving tags. When we come accross some text, add it into the index. This
        handles ignoring tags that we have no business looking at."""
        class DummyTag(object):
            next = False
            name = ''
        
        class NextTag(object):
            def __init__(self, obj):
                self.next = obj
        
        tag = soup.html
        stack = [DummyTag(), soup.html]

        while tag and tag.next:
            tag = tag.next

            # html tag
            if isinstance(tag, Tag):

                if tag.parent != stack[-1]:
                    self._exit[stack[-1].name.lower()](stack[-1])
                    stack.pop()

                tag_name = tag.name.lower()

                # ignore this tag and everything in it
                if tag_name in self._ignored_tags:
                    if tag.nextSibling:
                        tag = NextTag(tag.nextSibling)
                    else:
                        self._exit[stack[-1].name.lower()](stack[-1])
                        stack.pop()
                        tag = NextTag(tag.parent.nextSibling)
                    
                    continue
                
                # enter the tag
                self._enter[tag_name](tag)
                stack.append(tag)

            # text (text, cdata, comments, etc.)
            else:
                self._add_text(tag)

    def crawl(self, depth = 0 , timeout=3):
        """Crawl the web!"""
        seen = set()

        while len(self._url_queue):

            url, depth_ = self._url_queue.pop()

            # skip this url; it's too deep
            if depth_ > depth:
                continue

            doc_id = self.document_id(url)

            # we've already seen this document
            if doc_id in seen:
                #print depth_ + 'continue'
                continue

            seen.add(doc_id) # mark this document as haven't been visited
            
            socket = None
            try:
                socket = urllib2.urlopen(url, timeout=timeout)
                soup = BeautifulSoup(socket.read(),"html.parser")
                self._curr_depth = depth_ + 1
                self._curr_url = url
                self._curr_doc_id = doc_id
                self._font_size = 0
                self._curr_words = [ ]
                self._index_document(soup)
                self._add_words_to_document()
                self._visit_title(soup.title.string)
                print "    url="+repr(self._curr_url)

            except Exception as e:
                print e
                pass
            finally:
                if socket:
                    socket.close()
        #Create a database named database.db
        database = sqlite3.connect('database.db')
        c = database.cursor()

        c.execute('CREATE TABLE IF NOT EXISTS INVERTEDINDEX (wordId INTEGER , DocId INTEGER)')
        c.execute('CREATE TABLE IF NOT EXISTS DOC (doc_id INTEGER, doc_url TEXT)')
        c.execute('CREATE TABLE IF NOT EXISTS WORD (word_id INTEGER, words TEXT)')
        c.execute('CREATE TABLE IF NOT EXISTS DOC_INFO (doc_id INTEGER, doc_url TEXT, doc_url_title TEXT)')

        # add doc_id to database with the corresonding url
        for url in self._doc_id_cache:
            c.execute('INSERT INTO DOC VALUES (?,?)', (self._doc_id_cache[url], url))

        # add word_id to database with the corresponding word id
        for word in self._word_id_cache:
            c.execute('INSERT INTO WORD VALUES (?, ?)', (self._word_id_cache[word], word))
        #add doc id, url associated with it and title of url into a database
        #for url in _url_queue:
        for url in _url_title:
            c.execute('INSERT INTO DOC_INFO (doc_url, doc_url_title) VALUES(?,?)', (url, _url_title[url]))

        database.commit()
        database.close() #close the database
            
    #Maps the word id with the associated doc id
    def get_inverted_index(self):
        return _inverted_index

    #Maps the word with the corresponding URL
    def get_resolved_inverted_index(self):
        for elem in _inverted_index:
            word = _word_id_to_word[elem]
            doc_ids = _inverted_index[elem]
            resolved_set = set()
            for doc_id in doc_ids:
                resolved_set.add(_doc_id_to_url[doc_id])
                _resolved_inverted[word] = resolved_set
        return _resolved_inverted
    
    def _title_of_url(self, url):
        #if url in _url_title:
        return _url_title[url]
    
    def fetch_url_title(self, url):
        database = sqlite3.connect('database.db')
        c = database.cursor()
        c.execute('SELECT doc_url_title FROM DOC_INFO WHERE doc_url=?', (url,))
        return c.fetchone()
    
    #Get title of Url
    def visit_title(*args, **kargs):
        print "in viist title"
        self._visit_title(*args, **kargs)
        self._increase_font_factor(7)(*args, **kargs)


if __name__ == "__main__":
    try:
        os.remove("database.db")
    except:
        pass
    bot = crawler(None, "urls.txt")
    bot.crawl(depth=0)
