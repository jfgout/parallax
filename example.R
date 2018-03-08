# Example 1: Regular parallax measurement.
# Calculating the distance from Earth to asteroid (3200) Phaethon from two images taken from Scottsdale (Arizona, USA) and Antibes (France) at the same time.

source("parallax.R")

# Geographical coordinates for the two observing sites:
A = c(33.469543, -111.934369) #Scottsdale
B = c(43.599915, 7.058496) #Antibes

# Position of (3200) Phaethon in the sky form Scottsdale at 1.20am UTC Dec 16 2017
ALT = getDecimalCoords(67, 14, 50)
AZ = getDecimalCoords(77, 43, 11)

# Angle measured on the images: 153"
parallax = 153/(60*60)

# Call to the main function:
getDistanceToTarget(A, B, parallax, ALT, AZ)

# Resut: 10.63 million kilometers (true value was 10.58 million km according to Stellarium... not bad!)

#--------------------------

# Example 2: Distance to Tiangong-1 during a lunar transit.

source("parallax.R")

alpha = 252 # Angular distance between the two parallel lines corresponding to the satellite passing in front of the Moon/Sun from 2 nearby positions

A = c( getDecimalCoords(33,30,03.07), 0-getDecimalCoords(111,37,04.75) )	# Coordinates for observer #1
B = c( getDecimalCoords(33,30,16.60), 0-getDecimalCoords(111,37,02.45) )	# Coordinates for observer #2

L1 = c( getDecimalCoords(33,30,19.68), 0-getDecimalCoords(111,37,48.64) ) # Coordinates of a random point on the line of centrality (choose a point within a few miles of observing site)
L2 = c( getDecimalCoords(33,29,29.74), 0-getDecimalCoords(111,36,10.43) ) # Coordinates of a second random point on the line of centrality (choose a point within a few miles of observing site and a few miles from point L1)

# Position of the Moon/Sun at the time of transit
ALT = 55.0
AZ = 146.6

parallax = alpha/(60*60)

getDistanceToTarget(A, B, parallax, ALT, AZ, L1, L2)
