open util/boolean 


sig Car{ id: Int,position: one Position, reserved: one Bool, running: one Bool, parked: Bool }
{
	id > 0
	parked = True
	running= False
}

sig User{ id: Int, position: one Position}
{
	id > 0
}

fact carIdsAreUnique{
	all c1,c2: Car | (c1!=c2) => (c1.id != c2.id)
}

fact userIdsAreUnique{
	all u1,u2: User | (u1!=u2) => (u1.id != u2.id)
}

sig Position{ latitude: Int, longitude: Int}

sig Time{year: Int, month: Int, day: Int, hour: Int,  minute: Int}
{
	year>0
	month>0 && month <=12
	day>0 && day<=31
	hour >0 && hour<=24
	minute>=0 && minute <60
}

/*fun isPassedOneHour[t1,t2: Time]: Bool {
	(t1.year = t2.year && t1.month=t2.month && t1.day= t2.day && (((t2.hour = t1.hour +1) && (t2.minute > t1.minute)) || (t2.hour > t1.hour+1) ))
}*/


sig Reservation{ user: one User, car: one Car, resvTime: one Time, expired: one Bool}
{
}


/*fact carAvailableWhenResvExpires{
	all r: Reservation | isPassedOneHour(r.resvTime,TIME_NOW) implies r.car.reserved = false
}*/

fact carCanBeReservedOnce{
	all c: Car | lone r: Reservation | r.car = c && r.car.running = True && r.expired = False
}


sig Ride{ resv: one Reservation, startLoc: one Position, stopLoc: one Position, startTime: one Time}
{
	resv.car.running=True
}

fact parkingIffNotRiding{
	all c: Car |(c.parked = True) <=> c.running= False
}

fact rideImpliesResv{
all r:Ride | one reserv: Reservation | r.resv.car.running = True implies reserv.car = r.resv.car && reserv.expired = False
}

/*fact resvNotExpired{
		all r: Ride | not isPassedOneHour(r.resv.resvTime, r.startTime)
}*/



/*pred reservesACar[u: User, c:Car, r:Reservation]
{
	c.reserved = True
	r.car=c
	r.user = u
}

pred ridesACar[u: User, c:Car, r:Reservation, ride:Ride]
{
	ride.resv = r
	c.running = True
}

pred parksACar[u: User, c:Car, r:Reservation]
{
	c.running=False
	c.reserved = False
}*/

pred show(){
#Car=4
}

assert runningImpliesReserved{
no c: Car | c.running = True && c.reserved = False
}

//run show for 5
check runningImpliesReserved

