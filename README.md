# parallax

Just a small piece of R (https://www.r-project.org/) code to measure distance from Earth to an object in space based on the parralax method.
Two types of calculations are offered: (1) regular parallax (useful for computing distance to the Moon or a nearby asteroid) and (2) transit parallax (dedicated to measuring the distance to a satellite during a lunar/solar transit).

What's required:

1. The coordinates of the two locations on Earth from where the object was observed.

2. The angular distance in the position of the object from two locations on Earth (A and B).
This is typically obtained by taking a picutre at the exact same time, aligning the stars between the two images and calculating the distance between the two positions of the object of interest (angular distance is easily obtained by multiplying the distance in pixels by the sampling of the image).

3. The position in the sky (Altitude and Azimuth) of the object from point A

4. The coordinates of two points on the line of centrality of the transit (for transit calculations only).

See: example.R for an example of how to use the code.
