open util/boolean 


sig Car{position: one Position, reserved: one Bool, running: one Bool, user: one User, battery: Int}
{
	battery > 0
	battery < 100
}

sig User{resvCar: lone Car, drivingCar: lone Car, position: one Position}
{
}

sig Position{ latitude: Int, longitude: Int}

sig PowerStation{ carParked: set Car, capacity: Int, position: Position, }
{
}

sig Parking{car: lone Car}{}

fact capacityConstraint{
	 all pw: PowerStation | #pw.carParked < pw.capacity
}

fact carLocationConstraint{
	all c: Car, ps:PowerStation, p: Parking | (c in ps.carParked => c != p.car) and ( c = p.car => not c in ps.carParked) 
}

fact coordinatesConstraint{
	all u: User | #u.drivingCar=1 implies u.position = u.drivingCar.position
	all c:Car, pw: PowerStation | (c in pw.carParked) implies c.position = pw.position
	all pw1, pw2 : PowerStation | pw1 != pw2 implies pw1.position != pw2.position
}

fact carConstraints{
	all c: Car | c.running = True and #c.user = 1 implies c.user.drivingCar = c
	all c: Car | c.reserved = True and #c.user = 1 implies c.user.resvCar = c
	all c: Car | (c.running = True implies c.reserved = False) and (c.reserved = True implies c.running = False) 
	all c: Car, ps:PowerStation, p: Parking | ((c in ps.carParked) or (c = p.car)) implies c.running = False 
	all c: Car | (c.running=True <=> #c.user.drivingCar=1) and (c.reserved = True <=> #c.user.resvCar = 1) and (#c.user = 1 implies (c.running = True or c.reserved = True))
}

fact userConstraints{
	all u: User | #u.drivingCar = 1 implies u.drivingCar.user = u
	all u: User | #u.resvCar=1 implies u.resvCar.user = u
	all u: User | (#u.resvCar=1 implies #u.drivingCar=0) and (#u.drivingCar=1 implies #u.resvCar=0)
}


pred powerStationUpdate (c,c':Car) {
all p:PowerStation | (c in p.carParked => (one p':PowerStation | (
p'.carParked = p.carParked - c + c' and
p.capacity=p'.capacity and
p.position=p'.position and
#p.carParked=#p'.carParked )
))
}


pred UserReservesACar (c,c':Car, u,u':User) {
#u.resvCar=0
#u.drivingCar=0
c.running = False
c.reserved = False
#c.user=0
c'.running = False
c'.reserved = True
c'.user=u'
c.position=c'.position
c.battery=c'.battery
u'.resvCar=c'
#u.drivingCar=0
powerStationUpdate[c,c']
powerStationUpdate[c',c]
}

pred UserAbortsReservation (c,c':Car, u,u':User) {
UserReservesACar[c',c,u',u]
}







pred show(){
#Car=3
}

run show

