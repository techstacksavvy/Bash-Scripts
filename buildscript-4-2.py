#!/bin/bash/env python3

#title          :buildscript-4
#description    :gather data from an API and organize that data into CSV format
#author         :Sasheeny Hubbard
#date           :10-17-2022
#version        :2      
#usage          :./buildscript-4.sh
#notes          :       
#bash_version   :5.1.16(1)-release
#============================================================================


import os
import requests
import json
import csv

def jprint(obj):
    # create a formatted string of the Python JSON object
    text = json.dumps(obj, sort_keys=True, indent=4)
    print(text)

# create a CSV file to store collected data
os.system('touch movie_facts.csv')

# prompt user for input
movie = input("Enter the name of a movie: ")

# create a while loop with a nested if statement

# get request code begins
url = "https://movie-database-alternative.p.rapidapi.com/"

querystring = {"s":movie,"r":"json","page":"1"}

headers = {
	"X-RapidAPI-Key": "3b88330fa3mshb917aae8d1b6002p189804jsnd1b3c0fe5581",
	"X-RapidAPI-Host": "movie-database-alternative.p.rapidapi.com"
}

response = requests.request("GET", url, headers=headers, params=querystring)

data = jprint(response.json())

#field_names= response.json()[0]
field_names = ['Poster', 'Title', 'Type', 'Year', 'imdbID']
movie_data = response.json()

with open('movie_facts.csv', 'a', newline='') as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=field_names)
    writer.writeheader()
    #print(type(movie_data))
    writer.writerows(movie_data)