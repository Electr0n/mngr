u1 = User.create(email: 'electron@gmail.com', name: 'Eugene', surname: 'Skorodumov', password: '123qwe',
		gender: 'Male', bday: "29 Dec 1992", country: 'BY', city: 'HM', phone: "291363912", role: 'admin')
u2 = User.create(email: 'skulleton@gmail.com', name: 'Eugene', surname: 'Prischep', password: '123qwe',
		gender: 'Male', bday: "9 Jan 1992", country: 'BY', city: 'HM', phone: "293407694", role: 'admin')
u3 = User.create(email: 'ivanov@yandex.ru', name: 'Albert', surname: 'Einstein', password: '123qwe',
		gender: 'Male', bday: "14 Mar 1879", country: 'BY', city: 'HM', phone: '0', role: 'user')
u4 = User.create(email: 'facebook@tut.by', name: 'Mark', surname: 'Zuckerberg', password: '123qwe',
		gender: 'Male', bday: "14 May 1984", country: 'BY', city: 'HM', phone: "291234567", role: 'user')
u5 = User.create(email: 'boobs@xxx.com', name: 'Pomela', surname: 'Anderson', password: '123qwe',
		gender: 'Female', bday: "1 Jul 1967", country: 'BY', city: 'HM', phone: "0", role: 'user')


e1 = Event.create(name: 'birthday', date: '29 dec 2016', time: '17:00', description: "It will be fun!!!",
		etype: "party", gender: "Female", number: '15', agemin: '18', agemax: '30')
e2 = Event.create(name: 'roller skating', date: '30 may 2016', time: '22:00', description: "Skating all nigth, take ur friends",
		etype: "sport", gender: 'NA', number: '0', agemin: '16', agemax: '90')
e3 = Event.create(name: 'concert', date: '30 sep 2017', time: '21:00', description: "Imagine Dragons",
		etype: "music", gender: 'NA', number: '10000', agemin: '18', agemax: '0')
e4 = Event.create(name: 'speed dating', date: '20 mar 2016', time: '15:00', description: "Find your love",
		etype: "NA", gender: "NA", number: '30', agemin: '18', agemax: '0')
e5 = Event.create(name: 'office party', date: '25 jul 2016', time: '20:00', description: "Beer, Vodka and Meet",
		etype: "party", gender: "NA", number: '50', agemin: '18', agemax: '0')

u1.events << [e1, e3, e5]
u2.events << [e2, e1, e5]
u3.events << [e1, e5, e4]
u4.events << [e1, e2, e3, e4, e5]