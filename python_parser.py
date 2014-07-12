import sys
import json
import difflib
 
# variables to save
tweets_text = [] # We will store the text of every tweet in this list
tweets_id=[] # User ID
tweets_createdat = [] # When the tweet was tweeted
# USER INFO
tweets_name=[] # Twitter username
tweets_description=[] # description of Twitter account
tweets_location = [] # Location of every tweet (free text field - not always accurate or given)
tweets_timezone = [] # Timezone name of every tweet
tweets_selflang = [] # self reported language
tweets_scount = [] # status count
# PLACE VARIABLE
tweets_place=[] # general array for place
tweets_language = [] # Language
tweets_coord1 = [] # Coordinates
tweets_coord2 = [] # Coordinates
tweets_country = [] # Country
# WITHHELD INFO
tweets_withheld=[] # country where the stuff is withheld 

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
                        tweets_createdat.append(tweet['created_at'])
                except KeyError:
                        tweets_createdat.append('')
                try:
                        tweets_language.append(tweet['lang'])
                except KeyError:
                        tweets_language.append('')
                try:
                        tweets_user.append(tweet['user'])
                except KeyError:
                        tweets_user.append('')
                try:
                        tweets_place.append(tweet['place'])
                except KeyError:
                        tweets_place.append('')
        except ValueError:
                pass                        

# extract the user stuff
for x in range(0,len(tweets_user)):
        try:
                tweets_id.append(tweets_user[x]['id'])
        except Exception, e:
                tweets_id.append('')

for x in range(0,len(tweets_user)):
        try:
                tweets_name.append(tweets_user[x]['name']).encode('utf-8')
        except Exception, e:
                tweets_name.append('')

for x in range(0,len(tweets_user)):
        try:
                tweets_description.append(tweets_user[x]['description']).encode('utf-8')
        except Exception, e:
                tweets_description.append('')

for x in range(0,len(tweets_user)):
        try:
                tweets_location.append(tweets_user[x]['location']).encode('utf-8')
        except Exception, e:
                tweets_location.append('')

for x in range(0,len(tweets_user)):
        try:
                tweets_selflang.append(tweets_user[x]['lang'])
        except Exception, e:
                tweets_selflang.append('')

for x in range(0,len(tweets_user)):
        try:
                tweets_timezone.append(tweets_user[x]['time_zone'])
        except Exception, e:                try:
                tweets_timezone.append('')

for x in range(0,len(tweets_user)):
        try:
                tweets_scount.append(tweets_user[x]['statuses_count'])
        except Exception, e:
                tweets_scount.append('')
                
# place stuff
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

