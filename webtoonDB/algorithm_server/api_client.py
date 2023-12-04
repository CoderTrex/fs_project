import requests

url = 'http://localhost:5000/get_recommendations'
data = {'userid': 'uid11234'}
response = requests.get(url, json=data)

print(response.json())