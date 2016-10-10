from crawler import crawler
import crawler as t

crawler = crawler(None, "urls.txt")

# Testing some cases of the dictonary
print "\n"
print 'Depth of crawler is 0, using URls: \nhttp://google.com, http://google.ca, http://bing.com'
print 'Fetching document ids associated with word id = 1, 2, 3.....'
print 'Comparing data: \n'

fetchedData = str(t.get_single_inverted_index(1))  
setData = '{1: set([1])}'

print 'Does document id = 1 contain doc id 1? '
print 'Data fetched = ' + fetchedData 
print "Data to be compared = " + setData
print setData == fetchedData

print "\n"

fetchedData = str(t.get_single_inverted_index(2))  
setData = '{2: set([1, 2, 3])}'
print 'Does document id = 2 contain doc ids 1, 2, 3?'
print 'Data fetched = ' + fetchedData 
print "Data to be compared = " + setData
print setData == fetchedData

print "\n"

fetchedData = str(t.get_single_inverted_index(3))  
setData = '{3: set([1, 2, 3])}'
print 'Does document id = 3 contain doc ids 1, 2, 3? '
print 'Data fetched = ' + fetchedData 
print "Data to be compared = " + setData
print setData == fetchedData

print "\n"
print 'Depth of crawler is 0, using URls: \nhttp://google.com, http://google.ca, http://bing.com'
print 'Fetching Urls associated with words: ....'
print 'Comparing data: \n'

crawler.get_resolved_inverted_index()

fetchedData = str(t.get_single_resolved_inverted_index('outlook'))  
setData = "{'outlook': set(['http://bing.com'])}"
print 'Does word outlook contain http://bing.com? '
print 'Data fetched = ' + fetchedData 
print "Data to be compared = " + setData
print setData == fetchedData

print "\n"

fetchedData = str(t.get_single_resolved_inverted_index('google'))  
setData = "{'google': set(['http://google.ca', 'http://google.com'])}"
print 'Does word google contain http://google.ca, http://google.com? '
print 'Data fetched = ' + fetchedData 
print "Data to be compared = " + setData
print setData == fetchedData

print "\n"

fetchedData = str(t.get_single_resolved_inverted_index('help'))  
setData = "{'help': set(['http://bing.com'])}"
print 'Does word help contain http://bing.com?'
print 'Data fetched = ' + fetchedData 
print "Data to be compared = " + setData
print setData == fetchedData
