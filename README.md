# parallax

Just a small piece of R code to measure distance from Earth to an object in space based on the parralax method.

What's required:

1. The coordinates of the two locations on Earth from where the object was observed.

2. The angular distance in the position of the object from two locations on Earth (A and B).
This is typically obtained by taking a picutre at the exact same time, aligning the stars between the two images and calculating the distance between the two positions of the object of interest (angular distance is easily obtained by multiplying the distance in pixels by the sampling of the image).

3. The position in the sky (Altitude and Azimuth) of the object from point A

See: example.R for an example of how to use the code.
