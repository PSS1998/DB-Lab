import requests
import json
import time
from pymongo import MongoClient

client = MongoClient()
db = client['sahamTweet']
url = "https://www.sahamyab.com/guest/twiter/list"
fetched = 0
total = 1000
api_sleep = 2
while fetched < total:
    print(fetched)
    response = requests.request('GET', url, params={'v':'0.1'})
    if response.status_code == requests.codes.ok:
        data = response.json()['items']
        for tweet in data:
            db.tweet.replace_one({"id" : tweet['id']}, tweet, upsert=True)
        fetched = db.tweet.estimated_document_count()
    time.sleep(api_sleep) 
