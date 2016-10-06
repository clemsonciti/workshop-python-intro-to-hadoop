#!/usr/bin/env python
import sys

current_movie = None
current_rating_sum = 0
current_rating_count = 0

for line in sys.stdin:
  line = line.strip()
  movie, rating = line.split("\t", 1)
  try:
    rating = float(rating)
  except ValueError:
    continue

  if current_movie == movie:
    current_rating_sum += rating
    current_rating_count += 1
  else:
    if current_movie:
      rating_average = current_rating_sum / current_rating_count
      print ("%s\t%s" % (current_movie, rating_average))    
    current_movie = movie
    current_rating_sum = rating
    current_rating_count = 1

if current_movie == movie:
  rating_average = current_rating_sum / current_rating_count
  print ("%s\t%s" % (current_movie, rating_average))
