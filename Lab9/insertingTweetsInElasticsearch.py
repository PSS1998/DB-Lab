import requests
import json
import time
import os
import re
from elasticsearch import Elasticsearch 


def extract_hashtags(s):
    return re.findall(r'\#(.+?)\b', s)


url = 'https://www.sahamyab.com/guest/twiter/list'

es=Elasticsearch([{'host':'localhost','port':9200}])
index_name = "tweets"


fetched = 0
total = 1000
api_sleep = 2

while fetched < total:
    print(fetched)
    response = requests.request('GET', url, params={'v':'0.1'})
    if response.status_code == requests.codes.ok:
        data = response.json()['items']
        for tweet in data:
	        if 'content' in tweet:
	            if 'id' in tweet:
		            text = tweet['content']
		            hashtags = extract_hashtags(text)
		            tweet['hashtags'] = hashtags
		            res = es.index(index=index_name,id=tweet['id'],body=tweet)
        es.indices.refresh(index_name)
        fetched = es.count(index=index_name, params={"format": "json"})["count"]
    time.sleep(api_sleep) 