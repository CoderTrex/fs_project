import requests

url = 'http://localhost:5000/get_recommendations'
data = {'userid': 'eunseong'}
response = requests.get(url, json=data)

print(response.json())