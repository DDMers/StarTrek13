/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// UI templates created Adge Cutler and are available on their site "http://www.lcars.org.uk/lcars_TNG_panels.htm" //
// 					        They've been converted to GIF format and are used with their permission.			   //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/structure/weapons_console
	name = "Weapons console"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "weapons"
	var/active = FALSE
	var/damage
	var/heat //Inherited from the subsystem
	var/charge
	var/datum/shipsystem/weapons/subsystem
	var/list/ships = list()
	var/obj/structure/overmap/ship/our_ship
	var/list/theicons = list()
	var/target_window
	density = 1
	anchored = 1
	var/obj/structure/overmap/target

/obj/structure/weapons_console/defiant
	icon = 'StarTrek13/icons/trek/defianttactical.dmi'
	name = "Weapons console"
	icon_state = "weapons"

/obj/structure/helm/desk/functional/defiant
	icon = 'StarTrek13/icons/trek/defianttactical.dmi'
	icon_state = "shields"
	name = "shields station"

/obj/structure/weapons_console/romulan
	name = "Weapons console"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	icon_state = "rom-weapons"

/obj/structure/weapons_console/alt
	icon_state = "weapons_alt"
	icon = 'StarTrek13/icons/trek/star_trek.dmi'
	pixel_x = -16
	pixel_y = -16
	density = 0
	anchored = 1

/obj/structure/weapons_console/Initialize(timeofday)
	. = ..()
	START_PROCESSING(SSobj,src)
	if(our_ship)
		subsystem = our_ship.SC.weapons
	if(subsystem)
		damage = subsystem.damage
		heat = subsystem.heat
		charge = subsystem.charge


/obj/structure/weapons_console/proc/get_ship_icon(atom/item,mob/user)
	return icon2html(item, user, EAST)

/obj/structure/weapons_console/Topic(href, href_list) //For some reason, S is null
	..()
	var/mob/living/carbon/human/user = locate(href_list["clicker"])
	if(user in orange(1, src))
		var/mob/living/carbon/human/L = locate(href_list["clicker"])
		var/datum/shipsystem/SS = locate(href_list["system"])
		if(href_list["system"])
			to_chat(L, "<span class='notice'>Now targeting: [SS] subsystem.</span>")
			our_ship.target_subsystem = SS
			src.updateUsrDialog()
			attack_hand(L)
		if(href_list["flush"])
			to_chat(L, "Target reset.")
			target = null
			our_ship.target_subsystem = null
			src.updateUsrDialog()
			attack_hand(L)
	else
		target = null
		to_chat(user, "Move closer to [src]")


/obj/structure/weapons_console/attack_hand(mob/user)
	var/datum/asset/assets = get_asset_datum(/datum/asset/simple/weaponsconsole)
	assets.send(user)
	if(!target)
		var/list/L = list()
		for(var/obj/structure/overmap/OM in get_area(our_ship))
			if(istype(OM, /obj/structure/overmap))
				L += OM
		var/obj/structure/overmap/V = input("What ship shall we analyze?", "Weapons console)", null) in L
		target = V
		if(!V)
			return
	if(user in orange(1, src))
		var/s = ""
		s += "<!-- Image Map Generated by http://www.image-map.net/ -->"
		s+= "<style>body{background-color:#000000}</style>"
		if(!our_ship.target_subsystem)
			s+="<img src='weaponsbackground.png' usemap='#image-map'>"
		s+="<map name='image-map'>"
		s+="<area target='' alt='engines' title='engines' href='?src=\ref[src];system=\ref[target.SC.engines];clicker=\ref[user]' coords='84,410,81,449,90,458,101,460,122,463,141,468,139,512,261,490,276,468,409,461,449,420,211,413,149,414,122,412,178,412,338,414,401,421' shape='poly'>"
		s+="<area target='' alt='shields' title='shields' href='?src=\ref[src];system=\ref[target.SC.shields];clicker=\ref[user]' coords='473,481,560,527' shape='rect'>"
		s+="<area target='' alt='weapons' title='weapons' href='?src=\ref[src];system=\ref[target.SC.weapons];clicker=\ref[user]' coords='559,364,628,407,704,417,771,422,1073,391,1070,360,732,329,717,338,759,334,631,346' shape='poly'>"
		s+="<area target='' alt='close' title='close' href='?src=\ref[src];flush=1;clicker=\ref[user]' coords='1067,878,986,842' shape='rect'>"
		s+="</map>"
		var/thing = "Inactive"
		if(our_ship.target_subsystem)
			if(!istype(our_ship.target_subsystem, /datum/shipsystem))
				our_ship.target_subsystem = null
			if(!our_ship.target_subsystem.failed)
				thing = "Active"
			if(our_ship.target_subsystem.name == "engines")
				s+="<img src='weaponsbackground-engines.png' usemap='#image-map'>"
			if(our_ship.target_subsystem.name == "shields")
				s+="<img src='weaponsbackground-shields.png' usemap='#image-map'>" //Highlight the target in red.
			if(our_ship.target_subsystem.name == "weapons")
				s+="<img src='weaponsbackground-weapons.png' usemap='#image-map'>"
 			s += "<div align='right'>Target subsystem health: [our_ship.target_subsystem.integrity] / [our_ship.target_subsystem.max_integrity] | Status: [thing]<BR>"
		var/datum/browser/popup = new(user, "Weapons control", name, 1187, 980)
		popup.set_content(s)
		popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
		popup.open()
	else
		user = null
		return

/datum/asset/simple/weaponsconsole
	assets = list(
		"weaponsbackground.png"	= 'StarTrek13/icons/trek/enterpriseUI.png',
		"weaponsbackground-shields.png"	= 'StarTrek13/icons/trek/enterpriseUI-shields.png',
		"weaponsbackground-engines.png"	= 'StarTrek13/icons/trek/enterpriseUI-engines.png',
		"weaponsbackground-weapons.png"	= 'StarTrek13/icons/trek/enterpriseUI-weapons.png',
		"navcomp.gif"='StarTrek13/icons/trek/navcomp.gif',
		"odnrelay.gif"='StarTrek13/icons/trek/odnrelay.gif',
		"relayui.gif"='StarTrek13/icons/trek/relayui.gif'
	)
/datum/asset/simple/engiconsole
	assets = list(
		"warp.gif"='StarTrek13/icons/trek/warp.gif',
		"engiconsole.gif"='StarTrek13/icons/trek/engiconsole.gif',
		"subsystemconsole.gif"='StarTrek13/icons/trek/subsystemconsole.gif',
		"warpcoils.gif"='StarTrek13/icons/trek/warpcoils.gif',
		"warpfieldscreen.gif"='StarTrek13/icons/trek/warpfieldscreen.gif',
	)

/obj/structure/weapons_console/attack_hand(mob/user)
	var/datum/asset/assets = get_asset_datum(/datum/asset/simple/weaponsconsole)
	assets.send(user)
	if(!target)
		var/list/L = list()
		for(var/obj/structure/overmap/OM in get_area(our_ship))
			if(istype(OM, /obj/structure/overmap))
				L += OM
		var/obj/structure/overmap/V = input("What ship shall we analyze?", "Weapons console)", null) in L
		target = V
		if(!V)
			return
	if(user in orange(1, src))
		var/s = ""
		s += "<!-- Image Map Generated by http://www.image-map.net/ -->"
		s+= "<style>body{background-color:#000000}</style>"
		if(!our_ship.target_subsystem)
			s+="<img src='weaponsbackground.png' usemap='#image-map'>"
		s+="<map name='image-map'>"
		s+="<area target='' alt='engines' title='engines' href='?src=\ref[src];system=\ref[target.SC.engines];clicker=\ref[user]' coords='84,410,81,449,90,458,101,460,122,463,141,468,139,512,261,490,276,468,409,461,449,420,211,413,149,414,122,412,178,412,338,414,401,421' shape='poly'>"
		s+="<area target='' alt='shields' title='shields' href='?src=\ref[src];system=\ref[target.SC.shields];clicker=\ref[user]' coords='473,481,560,527' shape='rect'>"
		s+="<area target='' alt='weapons' title='weapons' href='?src=\ref[src];system=\ref[target.SC.weapons];clicker=\ref[user]' coords='559,364,628,407,704,417,771,422,1073,391,1070,360,732,329,717,338,759,334,631,346' shape='poly'>"
		s+="<area target='' alt='close' title='close' href='?src=\ref[src];flush=1;clicker=\ref[user]' coords='1067,878,986,842' shape='rect'>"
		s+="</map>"
		var/thing = "Inactive"
		if(our_ship.target_subsystem)
			if(!istype(our_ship.target_subsystem, /datum/shipsystem))
				our_ship.target_subsystem = null
			if(!our_ship.target_subsystem.failed)
				thing = "Active"
			if(our_ship.target_subsystem.name == "engines")
				s+="<img src='weaponsbackground-engines.png' usemap='#image-map'>"
			if(our_ship.target_subsystem.name == "shields")
				s+="<img src='weaponsbackground-shields.png' usemap='#image-map'>" //Highlight the target in red.
			if(our_ship.target_subsystem.name == "weapons")
				s+="<img src='weaponsbackground-weapons.png' usemap='#image-map'>"

			s += "<div align='right'>Target subsystem health: [our_ship.target_subsystem.integrity] / [our_ship.target_subsystem.max_integrity] | Status: [thing]<BR>"
		var/datum/browser/popup = new(user, "Weapons control", name, 1187, 980)
		popup.set_content(s)
		popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
		popup.open()
	else
		user = null
		return

/obj/structure/fluff/helm/desk/functional/navcomp
	name = "Helm"
	desc = "Used to warp the ship"
	icon_state = "galaxycom"
	var/stopspam = FALSE

/obj/structure/fluff/helm/desk/functional/navcomp/proc/allowsound()
	stopspam = FALSE

/obj/structure/fluff/helm/desk/functional/navcomp/Topic(href, href_list) //For some reason, S is null
	..()
	var/mob/living/carbon/human/user = locate(href_list["clicker"])
	var/datum/asset/assets = get_asset_datum(/datum/asset/simple/engiconsole)
	assets.send(user)
	if(user in orange(1, src))
		var/mob/living/carbon/human/L = locate(href_list["clicker"])
		if(href_list["stop"])
			our_ship.vel = 0
			user.say("All stop")
		if(href_list["warp"])
			var/obj/machinery/power/warpcore/W = locate(/obj/machinery/power/warpcore) in get_area(src)
			W.get_warp_factor()
			var/cochranes
			var/list/warplist = list()
			var/maxwarp
			if(W)
				W.get_warp_factor()
				cochranes = W.cochranes
				if(cochranes < WARP_1)
					warplist += 0
				if(cochranes >WARP_1)
					warplist += 1
				if(cochranes >WARP_2)
					warplist += 2
				if(cochranes >WARP_3)
					warplist += 3
				if(cochranes >WARP_4)
					warplist += 4
				if(cochranes >WARP_5)
					warplist += 5
				if(cochranes >WARP_6)
					warplist += 6
				if(cochranes >WARP_7)
					warplist += 7
				if(cochranes >WARP_8)
					warplist += 8
				if(cochranes >WARP_9)
					warplist += 9
				if(cochranes >WARP_10)
					warplist += 9.99999996
			else
				to_chat(L, "No warp core is present! Warping is not possible")
			if(!warplist.len)
				to_chat(L, "Insufficient warp power, ensure the warp coils are functional")
			var/speed = input(L,"Set warp factor", "Helm", null) in warplist
			switch(speed)
				if(0)
					return
				if(1)
					maxwarp = 1
				if(2)
					maxwarp = 3
				if(3)
					maxwarp = 5
				if(4)
					maxwarp = 7
				if(5)
					maxwarp = 9
				if(6)
					maxwarp = 11
				if(7)
					maxwarp = 13
				if(8)
					maxwarp = 20
				if(9)
					maxwarp = 30
				if(9.99999996)
					maxwarp = 35
			say(maxwarp)
			if(our_ship.SC.engines.try_warp())
				L.say("Ahead, warp [speed]")
				if(our_ship.pilot)
					to_chat(our_ship.pilot, "Helm has engaged warp factor [speed]")
				our_ship.vel = maxwarp
				if(!stopspam)
					for(var/mob/LT in our_ship.linked_ship)
						SEND_SOUND(LT, 'StarTrek13/sound/trek/ship_effects/warp.ogg')
					stopspam = TRUE
					addtimer(CALLBACK(src, .proc/allowsound), 100)
			else
				to_chat(L, "Warping failed! Engines may not be recharged.")
			src.updateUsrDialog()
	else
		to_chat(user, "Move closer to [src]")

/obj/structure/fluff/helm/desk/functional/navcomp/attack_hand(mob/user)
	var/datum/asset/assets = get_asset_datum(/datum/asset/simple/weaponsconsole)
	assets.send(user)
	if(user in orange(1, src))
		var/s = ""
		s+= "<!-- Image Map Generated by http://www.image-map.net/ -->"
		s+= "<img src='navcomp.gif' usemap='#image-map'>"
		s+= "<style>body{background-color:#000000}</style>"
		s+= "<map name='image-map'>"
		s+="<area target='' alt='Warp' title='Warp' href='?src=\ref[src];warp=1;clicker=\ref[user]' coords='76,210,0,301' shape='rect'>"
		s+="<area target='' alt='Stop' title='Stop' href='?src=\ref[src];stop=1;clicker=\ref[user]' coords='75,335,2,455' shape='rect'>"
		s+="</map>"
		var/datum/browser/popup = new(user, "Helm control", name, 661, 500)
		popup.set_content(s)
		popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
		popup.open()
	else
		user = null
		return

/obj/structure/fluff/helm/desk/functional/engineering
	name = "engineering console"
	icon = 'StarTrek13/icons/trek/flaksim_structures.dmi'
	icon_state = "engi"

/obj/structure/fluff/helm/desk/functional/engineering/attack_hand(mob/user)
	if(!our_ship)
		to_chat(user, "Console not linked to a ship, you should probably ask an admin or use the other console")
	var/datum/asset/assets = get_asset_datum(/datum/asset/simple/engiconsole)
	assets.send(user)
	if(user in orange(1, src))
		var/s = ""
		s+="<!-- Image Map Generated by http://www.image-map.net/ -->"
		s+= "<style>body{background-color:#000000}</style>"
		s+="<img src='engiconsole.gif' usemap='#image-map'>"
		s+="<map name='image-map'>"
		s+="<area target='' alt='Weapons access' title='Weapons access' href='?src=\ref[src];weapons=1;clicker=\ref[user]' coords='153,433,67,410' shape='rect'>"
		s+="<area target='' alt='Shields access' title='Shields access' href='?src=\ref[src];shields=1;clicker=\ref[user]' coords='253,408,315,442' shape='rect'>"
		s+="<area target='' alt='Engines access' title='Engines access' href='?src=\ref[src];engines=1;clicker=\ref[user]' coords='429,409,529,435' shape='rect'>"
		s+="<area target='' alt='Engine controls' title='Engine controls' href='?src=\ref[src];warpfield=1;clicker=\ref[user]' coords='120,452,153,477' shape='rect'>"
		s+="</map>"
		var/datum/browser/popup = new(user, "Engineering Console", name, 650, 530)
		popup.set_content(s)
		popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
		popup.open()
	else
		user = null
		return

/obj/structure/fluff/helm/desk/functional/engineering/Topic(href, href_list) //For some reason, S is null
	..()
	var/mob/living/carbon/human/user = locate(href_list["clicker"])
	if(user in orange(1, src))
		var/mob/living/carbon/human/L = locate(href_list["clicker"])
		if(href_list["weapons"])
			var/s = ""
			s+= "<img src='subsystemconsole.gif'>"
			s+= "<p>"
			s+="<style>body{background-color:#000000}</style>"
			s += "<B>STATISTICS</B><BR>"
			s += "[our_ship] weapons subsystem:<BR>"
			s += "Heat: [our_ship.SC.weapons.heat] |"
			s += " Weapon power (Gigawatts): [our_ship.SC.weapons.damage] |"
			s += " Weapon charge: [our_ship.SC.weapons.charge] / [our_ship.SC.weapons.max_charge]<BR>"
			var/datum/browser/popup = new(user, "Subsystem monitoring", name, 650, 500)
			popup.set_content(s)
			popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
			popup.open()
		if(href_list["shields"])
			var/s = ""
			s+= "<img src='subsystemconsole.gif'>"
			s+= "<p>"
			s+="<style>body{background-color:#000000}</style>"
			s += "<B>STATISTICS</B><BR>"
			s += "[our_ship] shields subsystem:<BR>"
			s += "Subsystem integrity: [our_ship.SC.shields.integrity]/[our_ship.SC.shields.max_integrity] |"
			s += " Shield strength: [our_ship.SC.shields.health] / [our_ship.SC.shields.max_health] |"
			s += " Recharge rate: [our_ship.SC.shields.chargeRate] HP/S<BR>"
			var/datum/browser/popup = new(user, "Subsystem monitoring", name, 650, 500)
			popup.set_content(s)
			popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
			popup.open()
		if(href_list["engines"])
			var/s = ""
			s+= "<img src='subsystemconsole.gif'>"
			s+= "<p>"
			s+="<style>body{background-color:#000000}</style>"
			s += "<B>STATISTICS</B><BR>"
			s += "[our_ship] engines subsystem:<BR>"
			s += "Subsystem integrity: [our_ship.SC.engines.integrity]/[our_ship.SC.engines.max_integrity] |"
			s += " Recharge rate: [our_ship.SC.engines.chargeRate] HP/S<BR>"
			var/datum/browser/popup = new(user, "Subsystem monitoring", name, 650, 500)
			popup.set_content(s)
			popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
			popup.open()
		if(href_list["warpfield"])
			var/s = ""
			s+="<!-- Image Map Generated by http://www.image-map.net/ -->"
			s+= "<style>body{background-color:#000000}</style>"
			s+="<img src='warp.gif' usemap='#image-map'>"
			s+="<map name='image-map'>"
			s+="<area target='' alt='Modify antimatter stream' title='Modify antimatter stream' href='?src=\ref[src];antideut=1;clicker=\ref[user]' coords='175,268,234,363' shape='rect'>"
			s+="<area target='' alt='Modify matter stream' title='Modify matter stream' href='?src=\ref[src];deut=1;clicker=\ref[user]' coords='177,47,235,140' shape='rect'>"
			s+="<area target='' alt='Access dilithium chamber' title='Access dilithium chamber' href='?src=\ref[src];dilithium=1;clicker=\ref[user]' coords='176,141,233,265' shape='rect'>"
			s+="<area target='' alt='Warp field statistics' title='Warp field statistics' href='?src=\ref[src];warpfield2=1;clicker=\ref[user]' coords='20,42,134,367' shape='rect'>"
			s+="</map>"
			var/datum/browser/popup = new(user, "Warp core access", name, 650, 500)
			popup.set_content(s)
			popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
			popup.open()
		if(href_list["antideut"])
			var/num = input(L,"Input antimatter stream flow rate", "Engineering console", null) as num
			if(num < 0)
				num = 0
			if(num > 10)
				num = 10
			for(var/obj/structure/antimatter_storage/S in get_area(src))
				S.flow_rate = num
			to_chat(L, "Modified flow rate to [num] L/S")
		if(href_list["deut"])
			var/num = input(L,"Input matter stream flow rate", "Engineering console", null) as num
			if(num < 0)
				num = 0
			if(num > 10)
				num = 10
			for(var/obj/structure/warp_storage/S in get_area(src))
				S.flow_rate = num
			to_chat(L, "Modified flow rate to [num] L/S")
		if(href_list["dilithium"])
			to_chat(L, "This currently does nothing, but will be used to replace crystals.")
		if(href_list["warpfield2"])
			var/s = ""
			s+="<!-- Image Map Generated by http://www.image-map.net/ -->"
			s+= "<style>body{background-color:#000000}</style>"
			s+="<img src='warpfieldscreen.gif' usemap='#image-map'>"
			s+="<map name='image-map'>"
			s+="<area target='' alt='Warp coil access' title='Coils' href='?src=\ref[src];coils=1;clicker=\ref[user]' coords='0,329,82,440' shape='rect'>"
			s+="</map>"
			var/datum/browser/popup = new(user, "Warp core access", name, 650, 500)
			popup.set_content(s)
			popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
			popup.open()
		if(href_list["coils"])
			var/s = ""
			s+="<!-- Image Map Generated by http://www.image-map.net/ -->"
			s+= "<style>body{background-color:#000000}</style>"
			s+="<img src='warpcoils.gif' usemap='#image-map'>"
			s+="<map name='image-map'>"
			s+="<area target='' alt='Modify' title='Modify' href='?src=\ref[src];modifycoils=1;clicker=\ref[user]' coords='77,162,0,471' shape='rect'>"
			s+="</map>"
			var/datum/browser/popup = new(user, "Warp core access", name, 661, 500)
			popup.set_content(s)
			popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
			popup.open()
		if(href_list["modifycoils"])
			var/num = input(L,"Enter limitation parameters (Max 300 cochranes)", "Engineering console", null) as num
			if(num < 0)
				num = 0
			if(num > 300)
				num = 300
			for(var/obj/machinery/power/warp_coil/WC in get_area(src))
				WC.max_cochranes = num
			to_chat(L, "Warp coils now limited to [num] cochranes. This will limit your warping capabilities by saving power.")
	else
		to_chat(user, "Move closer to [src]")


//Steps to repair:
/*
Open access to permit operation
Shunt subsystem power to avoid subsystem power loss
Disable power to depower the relay
Decouple arrays
Repair arrays
Reconnect arrays
*/

//TODO! Add shunting of subsystems through relays. This'd be done at an engineering console.

/obj/structure/ship_component/subsystem_relay
	name = "ODN plasma interface relay"
	desc = "An interface circuit which shunts power from the ship's powergrid to its subsystems, loss of these can lead to severe malfunction."
	var/access = FALSE //Access panel open? Below are repair steps. Shunt means !chosen subsystem. To shunt, you use the engineering console that I haven't made yet :b1:
	var/powered = TRUE
	var/decoupled = FALSE
	var/descrambled = FALSE
	var/reconnected = FALSE
	var/power_rating = 1 //Subsystems will always use 1 power as standard, but giving them more power makes them much stronger, you get 4 relays to start so you can overpower one system (or have one as a backup)
	icon_state = "relay"

/obj/structure/ship_component/subsystem_relay/Initialize()
	. = ..()

/obj/structure/ship_component/subsystem_relay/proc/depower()
	if(chosen)
		chosen.relays -= src
		chosen.power -= power_rating //Power is the sum total of the power of all relays, so we're removing this unit from that
		chosen = null
	powered = FALSE
	return

/obj/structure/ship_component/subsystem_relay/proc/shunt(mob/user)
	if(chosen)
		chosen.relays -= src
		chosen.power -= power_rating
		chosen = null
	var/datum/shipsystem/V = input("Where should we shunt power to?", "Weapons console)", null) in our_ship.SC.systems
	if(V)
		chosen = V
		to_chat(user,"[src] is now connected to the [chosen] subsystem")
		chosen.relays += src
		chosen.power += power_rating

/obj/structure/ship_component/subsystem_relay/process()
	if(!chosen || !our_ship)
		var/obj/structure/fluff/helm/desk/tactical/W = locate(/obj/structure/fluff/helm/desk/tactical) in(get_area(src))
		our_ship = W.theship
		if(our_ship)
			for(var/datum/shipsystem/S in our_ship.SC.systems)
				if(!S.relays.len)
					S.relays += src
					S.power += power_rating
					chosen = S
					break
	if(health <= 10)
		if(powered)
			fail()
			depower()
	if(powered)
		health -= 0.5 //Relays can and will fail on you if you keep them running. So it may be wise to keep your bonus relay there as a backup so you can instantly shunt power to it
		if(health > initial(health))
			health = initial(health)

/obj/structure/ship_component/subsystem_relay/attack_hand(mob/user)
	var/datum/asset/assets = get_asset_datum(/datum/asset/simple/weaponsconsole)
	assets.send(user)
	if(user in orange(1, src))
		var/s = ""
		s+="<!-- Image Map Generated by http://www.image-map.net/ -->"
		s+= "<style>body{background-color:#000000}</style>"
		s+="<img src='relayui.gif' usemap='#image-map'>"
		s+="<map name='image-map'>"
		s+="<area target='' alt='Open access' title='Open access' href='?src=\ref[src];open=1;clicker=\ref[user]' coords='400,186,455,237' shape='rect'>"
		s+="<area target='' alt='Toggle Power' title='Toggle power' href='?src=\ref[src];depower=1;clicker=\ref[user]' coords='401,319,456,241' shape='rect'>"
		s+="<area target='' alt='Decouple' title='Decouple plasma relays' href='?src=\ref[src];decouple=1;clicker=\ref[user]' coords='366,41,97,70' shape='rect'>"
		s+="<area target='' alt='Descramble' title='Repair plasma relays' href='?src=\ref[src];descramble=1;clicker=\ref[user]' coords='191,345,304,215' shape='rect'>"
		s+="<area target='' alt='Connect' title='Reconnect plasma relays' href='?src=\ref[src];reconnect=1;clicker=\ref[user]' coords='113,265,185,349' shape='rect'>"
		s+="<area target='' alt='Shunt' title='Shunt power' href='?src=\ref[src];shunt=1;clicker=\ref[user]' coords='416,474,484,596' shape='rect'>"
		s+="</map>"
		var/datum/browser/popup = new(user, "[src]", name, 500, 650)
		popup.set_content(s)
		popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
		popup.open()
	else
		user = null
		return

/obj/structure/ship_component/subsystem_relay/proc/reset_state()
	access = FALSE
	decoupled = FALSE
	descrambled = FALSE
	reconnected = FALSE

/obj/structure/ship_component/subsystem_relay/Topic(href, href_list) //For some reason, S is null
	..()
	var/mob/living/carbon/human/user = locate(href_list["clicker"])
	if(user in orange(1, src))
		var/mob/living/carbon/human/L = locate(href_list["clicker"])
		if(href_list["open"])
			if(!access)
				to_chat(L, "You begin to open [src]'s access panel")
				playsound(L.loc,'StarTrek13/sound/trek/tools/screwdriver.ogg',100,1)
				if(do_after(user, 50, target = src))
					to_chat(L, "<span class='notice'>Access hatch opened.</span>")
					access = TRUE
			else
				to_chat(L, "You begin to close [src]'s access panel")
				playsound(L.loc,'StarTrek13/sound/trek/tools/screwdriver.ogg',100,1)
				if(do_after(user, 50, target = src))
					to_chat(L, "<span class='notice'>Access hatch closed.</span>")
					access = FALSE
		if(href_list["shunt"])
			shunt(user)
		if(access && !decoupled && !descrambled)
			if(href_list["depower"])
				if(powered)
					to_chat(L, "You begin to disable [src]'s main power")
					playsound(L.loc,'StarTrek13/sound/trek/tools/screwdriver.ogg',100,1)
					if(do_after(user, 50, target = src))
						to_chat(L, "<span class='notice'>Relay depowered.</span>")
						powered = FALSE
				else
					to_chat(L, "You begin to enable [src]'s main power")
					playsound(L.loc,'StarTrek13/sound/trek/tools/screwdriver.ogg',100,1)
					if(do_after(user, 50, target = src))
						to_chat(L, "<span class='notice'>Relay powered.</span>")
						powered = TRUE
		if(!powered)
			if(href_list["decouple"])
				var/obj/item/l_hand = L.get_item_for_held_index(1) //hardcoded 2-hands only, for now. No doctor octopi thanks.
				var/obj/item/r_hand = L.get_item_for_held_index(2)
				if(istype(l_hand, /obj/item/screwdriver) || istype(r_hand, /obj/item/screwdriver))
					to_chat(L, "You begin to decouple [src]s plasma relays")
					playsound(L.loc,'StarTrek13/sound/trek/tools/spanner.ogg',100,1)
					if(do_after(user, 50, target = src))
						to_chat(L, "<span class='notice'>Warning: Plasma relays decoupled. Functionality limited.</span>")
						decoupled = TRUE
		if(decoupled)
			if(href_list["descramble"])
				var/obj/item/l_hand = L.get_item_for_held_index(1) //hardcoded 2-hands only, for now. No doctor octopi thanks.
				var/obj/item/r_hand = L.get_item_for_held_index(2)
				if(istype(l_hand, /obj/item/wrench) || istype(r_hand, /obj/item/wrench))
					to_chat(L, "You begin to repair [src]s plasma relays")
					playsound(L.loc,'StarTrek13/sound/trek/tools/spanner.ogg',100,1)
					if(do_after(user, 50, target = src))
						to_chat(L, "<span class='notice'>You've finished repairing [src]'s plasma relays</span>")
						descrambled = TRUE
		if(descrambled)
			if(href_list["reconnect"])
				var/obj/item/l_hand = L.get_item_for_held_index(1) //hardcoded 2-hands only, for now. No doctor octopi thanks.
				var/obj/item/r_hand = L.get_item_for_held_index(2)
				if(istype(l_hand, /obj/item/screwdriver) || istype(r_hand, /obj/item/screwdriver))
					to_chat(L, "You begin to reconnect [src]s plasma relays")
					playsound(L.loc,'StarTrek13/sound/trek/tools/spanner.ogg',100,1)
					if(do_after(user, 50, target = src))
						to_chat(L, "<span class='notice'>Plasma relays reconnected. You still need to re-enable power.</span>")
						health = 100
						reset_state()
	else
		to_chat(user, "Move closer to [src]")



/obj/structure/subsystem_panel		//so these lil guys will directly affect subsystem health, they can get damaged when the ship takes hits, so keep your hyperfractalgigaspanners handy engineers!
	name = "ODN Relay (Shields)"
	anchored = TRUE
	desc = "A breaker box housing an ODN relay which bridges the ship's power-grid to the shields subsystem"
	icon = 'StarTrek13/icons/trek/subsystem_parts.dmi'
	icon_state = "subsystem_panel"
	var/obj/structure/overmap/our_ship
	var/datum/shipsystem/chosen
	var/open = FALSE
	var/obj/effect/panel_overlay/cover = new
	var/powered = TRUE //Used for repairs, replace me with bitflags asap.
	var/voiceline = "shields"
	var/decoupled = FALSE
	var/descrambled = FALSE
	var/arraysdecoupled = FALSE
	var/arraysdisengaged = FALSE

/obj/structure/subsystem_panel/proc/reset_stats()
	decoupled = FALSE
	descrambled = FALSE
	arraysdecoupled = FALSE
	arraysdisengaged = FALSE

/obj/structure/subsystem_panel/proc/check_ship()
	var/area/a = get_area(src) //If you're making a new subsystem panel, copy this and change vvvvv
	for(var/obj/structure/fluff/helm/desk/tactical/T in a)
		var/obj/structure/overmap/S = T.theship
		if(T.theship)
			chosen = S.SC.shields //This line


/obj/structure/subsystem_panel/weapons		//so these lil guys will directly affect subsystem health, they can get damaged when the ship takes hits, so keep your hyperfractalgigaspanners handy engineers!
	name = "ODN Relay (Weapons)"
	desc = "A breaker box housing an ODN relay which bridges the ship's power-grid to the weapons subsystem"
	icon = 'StarTrek13/icons/trek/subsystem_parts.dmi'
	icon_state = "subsystem_panel"
	voiceline = "phasers"

/obj/structure/subsystem_panel/weapons/check_ship()
	var/obj/structure/fluff/helm/desk/tactical/W = locate(/obj/structure/fluff/helm/desk/tactical) in(get_area(src))
	if(W)
		if(W.theship && W.theship.SC && W.theship.SC.weapons)
			chosen = W.theship.SC.weapons

/obj/structure/subsystem_panel/engines		//so these lil guys will directly affect subsystem health, they can get damaged when the ship takes hits, so keep your hyperfractalgigaspanners handy engineers!
	name = "ODN Relay (engines)"
	desc = "A breaker box housing an ODN relay which bridges the ship's power-grid to the engines subsystem"
	icon = 'StarTrek13/icons/trek/subsystem_parts.dmi'
	icon_state = "subsystem_panel"
	voiceline = "warpengines"

/obj/structure/subsystem_panel/engines/check_ship()
	var/obj/structure/fluff/helm/desk/tactical/W = locate(/obj/structure/fluff/helm/desk/tactical) in(get_area(src))
	if(W)
		if(W.theship && W.theship.SC && W.theship.SC.engines)
			chosen = W.theship.SC.engines

/*
	var/state = 1
	var/state_open = 2
	var/state_closed = 4
	var/state_wrenched = 6
	var/state_crowbar = 8
	var/state_screwdriver = 10
	var/state_rewire = 12
*/

/obj/structure/subsystem_panel/New()
	. = ..()
	check_ship()
	START_PROCESSING(SSobj,src)

/obj/structure/subsystem_panel/process()
	if(!chosen)
		check_ship()
	check_overlays()
	if(!powered)
		powered = FALSE
		chosen.failed = TRUE
		chosen.stored_power = 0 //Thanos snap the power because the SS has failed.
		STOP_PROCESSING(SSobj, chosen)

/obj/structure/subsystem_panel/attack_hand(mob/user)
	if(open)
		var/datum/asset/assets = get_asset_datum(/datum/asset/simple/weaponsconsole)
		assets.send(user)
		if(user in orange(1, src))
			var/s = ""
			s+= "<style>body{background-color:#000000}</style>"
			s+= "<!-- Image Map Generated by http://www.image-map.net/ -->"
			s+= "<img src='odnrelay.gif' usemap='#image-map'>"
			s+= "<map name='image-map'>"
			s+= "<area target='' alt='decouple nodes' title='decouple nodes' href='?src=\ref[src];decouplenode=1;clicker=\ref[user]' coords='166,283,15' shape='circle'>"
			s+= "<area target='' alt='disengage nodes' title='disengage nodes' href='?src=\ref[src];disengagenode=1;clicker=\ref[user]' coords='202,302,14' shape='circle'>"
			s+= "<area target='' alt='decouple arrays' title='decouple arrays' href='?src=\ref[src];decouplearray=1;clicker=\ref[user]' coords='360,76,12' shape='circle'>"
			s+= "<area target='' alt='disengage arrays' title='disengage arrays' href='?src=\ref[src];disengagearray=1;clicker=\ref[user]' coords='398,104,13' shape='circle'>"
			s+= "<area target='' alt='repair isolinear circuitry' title='repair isolinear circuitry' href='?src=\ref[src];repair=1;clicker=\ref[user]' coords='63,53,145,194' shape='rect'>"
			s+= "<area target='' alt='toggle power' title='toggle power' href='?src=\ref[src];powertoggle=1;clicker=\ref[user]' coords='58,236,145,369' shape='rect'>"
			s+= "</map>"
			var/datum/browser/popup = new(user, "[src]", name, 580, 500)
			popup.set_content(s)
			popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
			popup.open()
		else
			user = null
			return
	else
		to_chat(user, "[src]'s access lid is still engaged.")

/obj/structure/subsystem_panel/Topic(href, href_list) //For some reason, S is null
	..()
	var/mob/living/carbon/human/user = locate(href_list["clicker"])
	if(user in orange(1, src))
		var/mob/living/carbon/human/L = locate(href_list["clicker"])
		if(href_list["powertoggle"])
			if(powered)
				to_chat(L, "You begin to disable [src]'s main power")
				playsound(L.loc,'StarTrek13/sound/trek/tools/screwdriver.ogg',100,1)
				if(do_after(user, 50, target = src))
					to_chat(L, "<span class='notice'>[chosen] system disengaged.</span>")
					powered = FALSE
			else
				to_chat(L, "You begin to enable [src]'s main power")
				playsound(L.loc,'StarTrek13/sound/trek/tools/screwdriver.ogg',100,1)
				if(do_after(user, 50, target = src))
					to_chat(L, "<span class='notice'>[chosen] system re-engaged.</span>")
					powered = TRUE
		if(!powered)
			if(href_list["decouplenode"])
				var/obj/item/l_hand = L.get_item_for_held_index(1) //hardcoded 2-hands only, for now. No doctor octopi thanks.
				var/obj/item/r_hand = L.get_item_for_held_index(2)
				if(istype(l_hand, /obj/item/wrench) || istype(r_hand, /obj/item/wrench))
					to_chat(L, "You begin to decouple [src]s plasma nodes")
					playsound(L.loc,'StarTrek13/sound/trek/tools/spanner.ogg',100,1)
					if(do_after(user, 50, target = src))
						to_chat(L, "<span class='notice'>Warning: Plasma nodes decoupled. Functionality limited.</span>")
						decoupled = TRUE
						powered = FALSE
		if(decoupled)
			if(href_list["disengagenode"])
				var/obj/item/l_hand = L.get_item_for_held_index(1) //hardcoded 2-hands only, for now. No doctor octopi thanks.
				var/obj/item/r_hand = L.get_item_for_held_index(2)
				if(istype(l_hand, /obj/item/wrench) || istype(r_hand, /obj/item/wrench))
					to_chat(L, "You begin to disengage [src]s plasma relays")
					playsound(L.loc,'StarTrek13/sound/trek/tools/spanner.ogg',100,1)
					if(do_after(user, 50, target = src))
						to_chat(L, "<span class='notice'>You've finished disengaging [src]'s plasma relays</span>")
						descrambled = TRUE
						powered = FALSE
						decoupled = FALSE
		if(descrambled)
			if(href_list["decouplearray"])
				var/obj/item/l_hand = L.get_item_for_held_index(1) //hardcoded 2-hands only, for now. No doctor octopi thanks.
				var/obj/item/r_hand = L.get_item_for_held_index(2)
				if(istype(l_hand, /obj/item/screwdriver) || istype(r_hand, /obj/item/screwdriver))
					to_chat(L, "You begin to decouple [src]s isolinear arrays")
					playsound(L.loc,'StarTrek13/sound/trek/tools/spanner.ogg',100,1)
					if(do_after(user, 50, target = src))
						to_chat(L, "<span class='notice'>Isolinear arrays decoupled.</span>")
						arraysdecoupled = TRUE
						powered = FALSE
						descrambled = FALSE
		if(arraysdecoupled)
			if(href_list["disengagearray"])
				var/obj/item/l_hand = L.get_item_for_held_index(1) //hardcoded 2-hands only, for now. No doctor octopi thanks.
				var/obj/item/r_hand = L.get_item_for_held_index(2)
				if(istype(l_hand, /obj/item/wrench) || istype(r_hand, /obj/item/wrench))
					to_chat(L, "You begin to disengage [src]s isolinear arrays")
					playsound(L.loc,'StarTrek13/sound/trek/tools/spanner.ogg',100,1)
					if(do_after(user, 50, target = src))
						to_chat(L, "<span class='notice'>Isolinear arrays disengaged.</span>")
						arraysdisengaged = TRUE
						powered = FALSE
						arraysdecoupled = FALSE
		if(arraysdisengaged)
			if(href_list["repair"])
				var/obj/item/l_hand = L.get_item_for_held_index(1) //hardcoded 2-hands only, for now. No doctor octopi thanks.
				var/obj/item/r_hand = L.get_item_for_held_index(2)
				if(istype(l_hand, /obj/item/wrench) || istype(r_hand, /obj/item/wrench))
					to_chat(L, "You begin to repair [src]'s damaged isolinear circuitry")
					playsound(L.loc,'StarTrek13/sound/trek/tools/spanner.ogg',100,1)
					if(do_after(user, 50, target = src))
						to_chat(L, "<span class='notice'>Isolinear circuits repaired. You still need to repower [src].</span>")
						reset_stats()
						chosen.integrity = chosen.max_integrity
						chosen.failed = FALSE
						chosen.heat = 0
						START_PROCESSING(SSobj, chosen)
						our_ship.weapons.voiceline(voiceline)
	else
		to_chat(user, "Move closer to [src]")

/obj/structure/subsystem_panel/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/crowbar))
		if(!chosen)
			check_ship()
		switch(open)
			if(TRUE)
				cut_overlays()
				to_chat(user, "You close [src]'s lid")
				cover.icon_state = "[icon_state]-cover"
				open = FALSE
				add_overlay(cover)
			if(FALSE)
				cut_overlays()
				to_chat(user, "You open [src]'s lid")
				cover.icon_state = "[icon_state]-cover-open"
				open = TRUE
				add_overlay(cover)
		check_overlays()

/obj/effect/panel_overlay
	name = "subsystem panel cover"
	icon = 'StarTrek13/icons/trek/subsystem_parts.dmi'
	icon_state = "subsystem_panel-cover"
	var/obj/structure/overmap/ship
	anchored = TRUE

/obj/structure/subsystem_panel/proc/check_overlays()
	if(chosen)
		cut_overlays()
		cover.icon = icon
		var/goal = chosen.max_integrity
		var/progress = chosen.integrity
		progress = CLAMP(progress, 0, goal)
		icon_state = "subsystem_panel-[round(((progress / goal) * 100), 25)]" //Get more fucked as our subsystem is damaged
		switch(open)
			if(TRUE)
				cover.icon_state = "subsystem_panel-cover-open"
			if(FALSE)
				cover.icon_state = "subsystem_panel-cover"
	//	cover.icon_state = "[icon_state]-cover-[round(((progress / goal) * 100), 50)]"
		cover.layer = 4.5
		add_overlay(cover)
	else
		STOP_PROCESSING(SSobj,src)