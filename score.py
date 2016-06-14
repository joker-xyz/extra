import requests
import os
from time import sleep 

liveMatchUrl = 'https://cricscore-api.appspot.com/csa'


res = requests.get(liveMatchUrl)



liveMatches = res.json()

def getScore():
	pass
	matchId = ''
	for liveMatch in liveMatches:
		if 'india' in liveMatch['t1'].lower() or 'india' in liveMatch['t2'].lower():
			# print(liveMatch)
			matchId += str(liveMatch['id'])

	res = requests.get(liveMatchUrl + '?id=' + matchId)
	liveScore = res.json()
	print(liveScore)
	os.system('notify-send --urgency=low \''+liveScore[0]['de']+'\'')

while True:
	getScore()
	sleep(30)


