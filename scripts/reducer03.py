#!/usr/bin/env python
import sys

current_movie = None
current_rating_sum = 0
current_rating_count = 0

max_movie = ""
max_average = 0

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
      if rating_average > max_average:
        max_movie = current_movie
        max_average = rating_average
    current_movie = movie
    current_rating_sum = rating
    current_rating_count = 1

if current_movie == movie:
  rating_average = current_rating_sum / current_rating_count
  if rating_average > max_average:
    max_movie = current_movie
    max_average = rating_average

print ("%s\t%s" % (max_movie, max_average))