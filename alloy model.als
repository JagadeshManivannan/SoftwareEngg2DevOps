open util/boolean 


sig Car{ id: Int,position: one Position, reserved: one Bool, running: one Bool }
{
	id > 0
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


sig Reservation{ user: one User, car: one Car, resvTime: one Time}
{
	car.reserved=True
}

/*fact carAvailableWhenResvExpires{
	all r: Reservation | isPassedOneHour(r.resvTime,TIME_NOW) implies r.car.reserved = false
}*/

fact carCanBeReservedOnce{
	all c: Car | lone r: Reservation | r.car = c
}


sig Ride{ resv: one Reservation, startLoc: one Position, stopLoc: one Position, startTime: one Time}
{
	resv.car.running=True
}

/*fact resvNotExpired{
		all r: Ride | not isPassedOneHour(r.resv.resvTime, r.startTime)
}*/


sig Parking{ loc: one Position, legit: one Bool}
{

}

pred show(){
#Car=4
}

run show for 5
