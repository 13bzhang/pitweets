##############################################
# USE PYTHON 2 WITH IPYTHON

# download IPython here: http://ipython.org/install.html
# change file working directories

import sys
import json
import difflib
import csv
import pandas

# variables to save
tweets_text = [] # We will store the text of every tweet in this list
tweets_id=[] # User ID
tweets_createdat = [] # When the tweet was tweeted
# USER INFO
tweets_user=[]
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
tweets_ccode = [] # Country code
tweets_country = [] # Country name
tweets_city=[] # city name
# WITHHELD INFO
tweets_withheldc=[] # country where the stuff is withheld 
tweets_withhelds=[] # scope of content withheld
# Loop over all line
f = open("/Users/baobaozhang/Box Sync/Run1.json")
lines = f.readlines()

for line in lines:
        try:
                tweet = json.loads(line)
                # Ignore retweets!
                #if tweet.has_key("retweeted_status") or not tweet.has_key("text"):
                #                continue
                # Fetch text from tweet
                #text = tweet["text"].encode('utf-8')
                # Ignore 'manual' retweets, i.e. messages starting with RT             
                #if text.find("rt ") > -1:
                #        continue
                try:
                        tweets_text.append(tweet['text'])
                except KeyError:
                        tweets_text.append('')                        
                try:
                        tweets_createdat.append(tweet['created_at'])
                except KeyError:
                        tweets_createdat.append('')
                try:
                        tweets_language.append(tweet['lang'])
                except KeyError:
                        tweets_language.append('')
                try:
                        tweets_withheldc.append(tweet['withheld_in_countries'])
                except KeyError:
                        tweets_withheldc.append('')
                try:
                        tweets_withhelds.append(tweet['withheld_scope'])
                except KeyError:
                        tweets_withhelds.append('')                        
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
                tweets_name.append(tweets_user[x]['name'])
        except Exception, e:
                tweets_name.append('')

for x in range(0,len(tweets_user)):
        try:
                tweets_description.append(tweets_user[x]['description'])
        except Exception, e:
                tweets_description.append('')

for x in range(0,len(tweets_user)):
        try:
                tweets_location.append(tweets_user[x]['location'])
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
        except Exception, e:
                tweets_timezone.append('')

for x in range(0,len(tweets_user)):
        try:
                tweets_scount.append(tweets_user[x]['statuses_count'])
        except Exception, e:
                tweets_scount.append('')
# place stuff
for x in range(0,len(tweets_place)):
        try:
                tweets_country.append(tweets_place[x]['country'])
        except Exception, e:
                tweets_country.append('')

for x in range(0,len(tweets_place)):
        try:
                tweets_ccode.append(tweets_place[x]['country_code'])
        except Exception, e:
                tweets_ccode.append('')

for x in range(0,len(tweets_place)):
        try:
                tweets_city.append(tweets_place[x]['full_name'])
        except Exception, e:
                tweets_city.append('')

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

# Export to CSV
data = {'id':tweets_id, 'text':tweets_text, 'time':tweets_createdat, 'name':tweets_name, 'descript':tweets_description, 'location':tweets_location, 'timezone':tweets_timezone, 'selflang':tweets_selflang, 'scount':tweets_scount,'language':tweets_language,'c1':tweets_coord1, 'c2':tweets_coord2, 'ccode':tweets_ccode, 'country':tweets_country,'city':tweets_city,'withc':tweets_withheldc,'withs':tweets_withhelds}
# make data frame
frame=pandas.DataFrame(data)
# export the file
frame.to_csv('/Users/baobaozhang/Box Sync/Run1.csv', sep=',', encoding='utf-8')

