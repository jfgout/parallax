r = 6371 # Earth radius

rad2deg<- function(rad) {(rad * 180) / (pi)}
deg2rad <- function(deg) {(deg * pi) / (180)}


getArcSec <- function(hour, minute, second){
  as = 60*60*hour + 60*minute + second
  as
}

getDecimalCoords <- function(hour, minute, second){
  as = getArcSec(hour, minute, second)
  dc = as/(60*60)
  dc
}


getCartesianCoords <- function(vr){
  vrc = c( r * cos(vr[2]) * cos(vr[1]) , r * cos(vr[2]) * sin(vr[1]) , r * sin(vr[2]) )
  vrc
}

myTransform_1 <- function(vv, phi){
  vvt = c( (-vv[3])*sin(phi) + vv[1]*cos(phi) , vv[2] , vv[3]*cos(phi) + vv[1]*sin(phi) )
  vvt
}


getTargetVector <- function(ALT, AZ, heigh){

  alpha = AZ - 90

  h = heigh / tan(deg2rad(ALT))
  a = h*cos(deg2rad(alpha))
  b = h*sin(deg2rad(alpha))
  
  vtarget = c(b, a, heigh)
  #print(vtarget)
  vtarget
}

getDot <- function(v1, v2){
  dd = 0
  for(i in (1:length(v1))){
    dd = dd + v1[i]*v2[i]
  }
  dd
}

getExp <- function(v){
  tot = 0
  for(i in (1:length(v))){
    tot = tot + v[i]^2
  }
  ret = sqrt(tot)
  ret
}

getDist <- function(v1, v2){
  tot = 0
  for(i in (1:length(v1))){
    tot = tot + (v2[i]-v1[i])^2
  }
  dist = sqrt(tot)
  dist
}


getBearing <- function(Ar, Br){
	
	lat1 = Ar[1]
	lon1 = Ar[2]
	
	lat2 = Br[1]
	lon2 = Br[2]
	
	y = sin(lon2 - lon1) * cos(lat2)
	x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lat2 - lat1)
	
	bearing = rad2deg(atan2(y,x))
	bearing = 360 - ((bearing + 360) %% 360)
	
	bearing
}

getDistanceBetween2Coords <- function(A, B){

	lat1Rads = deg2rad(A[1])
	lat2Rads = deg2rad(B[1])
	
	dLon = deg2rad(B[2]-A[2])
	
	d = acos(sin(lat1Rads) * sin(lat2Rads)+cos(lat1Rads)*cos(lat2Rads)*cos(dLon)) * r
	d
}

crossTrackDistance <- function(d1, bearingToPoint, bearingLine){
	distance = asin(sin(d1/r) * sin(bearingToPoint - bearingLine)) * r
}

distanceToLine <- function(P, L1, L2){

	bearingLP = getBearing(deg2rad(L1), deg2rad(P))
	bearingL = getBearing(deg2rad(L1), deg2rad(L2))

	d1 = getDistanceBetween2Coords(L1, P)
	d = crossTrackDistance(d1, deg2rad(bearingLP), deg2rad(bearingL))
	d
}

getDistanceToTarget <- function(A, B, parallax, ALT, AZ, L1=NA, L2=NA){

  # First, I invert latitude and longitude
  At = c(0 , A[1])
  Bt = c( B[2]-A[2] , B[1] )

  # Latitude and longitude expressed in radians
  Atr = deg2rad(At)
  Btr = deg2rad(Bt)
  
  
  # Calculating the cartesian coordinates
  VA = getCartesianCoords(Atr)
  VB = getCartesianCoords(Btr)
  
	if( is.na(L1)==F && is.na(L2)==F ){
		# Only if the calculation is for a transit
		# Computing the distance between the two observers on the axis perpendicular to the line of centrality
		d1 = distanceToLine(A, L1, L2)
		d2 = distanceToLine(B, L1, L2)
		dobs = abs(d1-d2)
	} else {
		#dobs = getDistanceBetween2Coords(A, B)
		dobs = getDist(VA, VB)

	}
  

  # phi is equal to 90 - latitude of point A
  phi = deg2rad(90 - A[1])
 
  # Let's make A the origin of the coordinates system (target exactly overhead from point A)  
  VAn = myTransform_1(VA, phi)
  VBn = myTransform_1(VB, phi)

  VAf = c(VAn[1], VAn[2], 0)
  VBf = c(VBn[1], VBn[2], VBn[3]-VAn[3])
  
  Vtarget = getTargetVector(ALT, AZ, 10000)

  dd = getDot(VBf, Vtarget) / (getExp(VBf) * getExp(Vtarget))
  phi = acos(dd)
  dp = dobs * sin(phi)
  
  dtarget = dp/deg2rad(parallax)
  dtarget
}
