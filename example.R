# Calculating the distance from Earth to asteroid (3200) Phaethon from two images taken from Scottsdale (Arizona, USA) and Antibes (France) at the same time.

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
