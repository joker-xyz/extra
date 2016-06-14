import requests
import json
from requests.auth import HTTPBasicAuth
print("Welcome to free message service")
toN = input("enter receipint number (add country code e.g. +91 for india\n")
fromN = input("enter sender number\n")
message = input("enter message to sent\n")
response = requests.post('https://api.clicksend.com/rest/v2/send.json', data={"method": "rest","message": message,"senderid": "","to": toN}, auth=HTTPBasicAuth('joker123', 'BC9DA688-1B6D-F406-0D8A-94873FD86AFB'))
print(json.loads(response.text))
