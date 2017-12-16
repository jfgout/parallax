r = 6370 # Earth radius

deg2rad <- function(deg){
  rr = (deg * pi) / (180)
  rr
}

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


getDistanceToTarget <- function(A, B, parallax, ALT, AZ){

  # First, I invert latitude and longitude
  At = c(0 , A[1])
  Bt = c( B[2]-A[2] , B[1] )

  # Latitude and longitude expressed in radians
  Atr = deg2rad(At)
  Btr = deg2rad(Bt)
  
  
  # Calculating the cartesian coordinates
  VA = getCartesianCoords(Atr)
  VB = getCartesianCoords(Btr)

  dobs = getDist(VA, VB)
  
  # phi is equal to 90 - latitude of point A
  phi = deg2rad(90 - A[1])
 
  # LEt's make A the origin of the coordinates system (target exactly overhead from point A)
  
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
