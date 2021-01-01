from pymongo import MongoClient

# Requires the PyMongo package.
# https://api.mongodb.com/python/current

client = MongoClient('mongodb://localhost:27017/?readPreference=primary&appname=MongoDB%20Compass&ssl=false')
result = client['sahamTweet']['tweet'].aggregate([
    {
        '$group': {
            '_id': '$senderUsername', 
            'count': {
                '$sum': 1
            }
        }
    }, {
        '$sort': {
            'count': -1
        }
    }, {
        '$limit': 10
    }
])
print(list(result))


result = client['sahamTweet']['tweet'].find({"senderUsername": "oldertraider"})
print(list(result))
