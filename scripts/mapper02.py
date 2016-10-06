#!/usr/bin/env python          
import sys            
import csv                                                       
movieFile = "movies.csv"
movieList = {}
with open(movieFile, mode = 'r') as infile:
  reader = csv.reader(infile)
  for row in reader:  
    movieList[row[0]] = {}  
    movieList[row[0]]["title"] = row[1].strip()  
    movieList[row[0]]["genre"] = row[2].strip()                       
for oneMovie in sys.stdin:                                     
  oneMovie = oneMovie.strip()      
  ratingInfo = oneMovie.split(",")               
  try:
    movieTitle = movieList[ratingInfo[1]]["title"]   
    rating = float(ratingInfo[2])                     
    print ("%s\t%s" % (movieTitle, rating))    
  except ValueError:                           
    continue  