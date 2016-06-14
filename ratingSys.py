import requests
import json
import os
import sys
import re

oldDir = input("enter Directory");

movieList=[]

apiUrl = 'http://www.omdbapi.com/?tomatoes=true&t='

try:
	movieList = os.listdir(oldDir)
except Exception as e:
	print('No such Directory found !')
	sys.exit(0)

def getExactMovieName(movie):
	# delete everything starting with (
	n_movie = re.sub(r'\(.*$', '', movie)
	n_movie = re.sub(r'\d.*$', '', n_movie)
	n_movie = re.sub(r'\.', ' ', n_movie)
	return n_movie;

for movie in movieList:
	try:
		n_movie = getExactMovieName(movie)
		print('requesting for '+n_movie)
		result = requests.get(apiUrl+n_movie)
		j_result = json.loads(result.text)
		if oldDir[-1] != '/':
			oldDir+='/'
		imdbRating = j_result['imdbRating']
		tomatoRating = j_result['tomatoRating']
		newDir = oldDir+'IMDB('+imdbRating+') TOMATO('+tomatoRating+') '+n_movie+'/'
		os.mkdir(newDir)
		os.rename(oldDir+movie , newDir+movie)
		with open(newDir+'info.txt', 'w+') as fp:
			fp.write(result.text)
		print('request completed for '+n_movie)
	except Exception as e:
		print("IMDB rating not found")

