import sys
import json
import difflib
 
# Input argument is the filename of the JSON ascii file from the Twitter API
filename = '/home/ubuntu/Run66.json' # one can change the file name
tweets_text = [] # We will store the text of every tweet in this list
tweets_location = [] # Location of every tweet (free text field - not always accurate or given)
tweets_timezone = [] # Timezone name of every tweet
tweets_place=[]
tweets_language = [] # Language
tweets_coord1 = [] # Coordinates
tweets_coord2 = [] # Coordinates
tweets_country = []
# Loop over all line
f = open(filename, "r")
lines = f.readlines()

for line in lines:
        try:
                tweet = json.loads(line)
                # Ignore retweets!
                if tweet.has_key("retweeted_status") or not tweet.has_key("text"):
                                continue
                # Fetch text from tweet
                text = tweet["text"].lower()
                # Ignore 'manual' retweets, i.e. messages starting with RT             
                if text.find("rt ") > -1:
                        continue
                tweets_text.append( text )
                try:
                        tweets_location.append(tweet['user']['location'].encode('utf-8'))
                except KeyError:
                        tweets_location.append('')
                try:
                        tweets_timezone.append(tweet['user']['time_zone'])
                except KeyError:
                        tweets_timezone.append('')       
                try:
                        tweets_language.append(tweet['user']['lang'])
                except KeyError:
                        tweets_language.append('')
                try:
                        tweets_place.append(tweet['place'])
                except KeyError:
                        tweets_place.append('')
        except ValueError:
                pass
# extract place stuff
for x in range(0,len(tweets_place)):
        try:
                tweets_country.append(tweets_place[x]['country_code'])
        except Exception, e:
                tweets_country.append('')
for x in range(0,len(tweets_place)):
        try:
                tweets_coord1.append(tweets_place[x]['bounding_box']['coordinates'][0][0][0])
        except Exception, e:
                tweets_coord1.append('')
for x in range(0,len(tweets_place)):
        try:
                tweets_coord2.append(tweets_place[x]['bounding_box']['coordinates'][0][0][1])
        except Exception, e:
                tweets_coord2.append('')                


with open('/Users/baobaozhang/Downloads/test2.csv', 'wb') as f:
    writer = csv.writer(f)
    writer.writerows(izip(tweets_text, tweets_location, tweets_timezone))

