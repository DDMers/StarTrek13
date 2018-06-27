/obj/item/clothing/neck/combadge
	name = "combadge"
	icon = 'icons/obj/clothing/neck.dmi'
	desc = "Standard issue communications device issued by starfleet, you must alt click it first, which will allow you to use it on that ship, to link it to another ship, just alt click it again. Ctrl click it to toggle transmission and receipt of messages"
	icon_state = "combadge"
	var/obj/item/clothing/neck/combadge/ping //If we're pinging a specific person
	var/area/ship/linked
	var/mob/living/stored_user
	var/on = FALSE
	var/next_talk = 0 //used for move delays
	var/talk_delay = 0.1

/obj/item/clothing/neck/combadge/CtrlClick(mob/user)
	playsound(loc, 'StarTrek13/sound/borg/machines/combadge.ogg', 50, 1)
	stored_user = user
	if(on)
		to_chat(user, "Broadcasting disabled")
		on = FALSE
		return
	if(!on)
		to_chat(user, "Broadcasting enabled")
		on = TRUE
		return

/obj/item/clothing/neck/combadge/AltClick(mob/user)
	link_to_area(user)

/obj/item/clothing/neck/combadge/proc/link_to_area(mob/user)
	if(linked)
		linked.combadges -= src
	linked = null
	var/area/A = get_area(src)
	if(istype(A, /area/ship))
		var/area/ship/S = A
		linked = S
		S.combadges += src
		to_chat(user, "You've linked [src] to the [linked] comms subsystem")


/obj/item/clothing/neck/combadge/proc/send_message(var/message, mob/living/user)
	if(!linked) //Yeah. People got confused
		link_to_area(user)
		if(!on)
			CtrlClick(user)
	if(world.time < next_talk)
		return 0
	next_talk = world.time + talk_delay
	if(!linked)
		link_to_area(user)
	stored_user = user
//	to_chat(stored_user, "<span class='warning'><b>[linked] ship comms: </b><b>[user]</b> <b>([user.mind.assigned_role])</b>: [message]</span>")
	for(var/obj/item/clothing/neck/combadge/C in linked.combadges)
		if(C.on)
			playsound(C.loc, 'StarTrek13/sound/borg/machines/combadge.ogg', 10, 1)
			to_chat(C.stored_user, "<span class='warning'><b>[linked] ship comms:</b><b>[user]</b> <b>([user.mind.assigned_role])</b>: [message]</span>")
		else
			to_chat(C.stored_user, "Your [src] buzzes softly")

/obj/item/clothing/neck/combadge/proc/pm_user(var/message, mob/living/user)
	if(world.time < next_talk)
		return 0
	next_talk = world.time + talk_delay
	for(var/obj/item/clothing/neck/combadge/C in linked.combadges)
		if(C.stored_user)
			if(findtext(message, "[C.stored_user.first_name()] "))
				to_chat(world, "HAHAHAHA")

/*

/obj/effect/proc_holder/spell/aoe_turf/rage //I'm bored
	name = "Force Rage"
	desc = "Unleash your fury, tear down the walls, crush those in your way"
	charge_max = 400
	clothes_req = 0
	invocation = "FEAR ME"
	invocation_type = "shout"
	range = 10
	cooldown_min = 150
	selection_type = "view"
	sound = 'sound/magic/repulse.ogg'
	var/maxthrow = 5
	var/sparkle_path = /obj/effect/temp_visual/gravpush

	action_icon_state = "repulse"

/obj/effect/proc_holder/spell/aoe_turf/rage/cast(list/targets,mob/user = usr, var/stun_amt = 40)
	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromcaster
	playMagSound()
	for(var/turf/T in targets) //Done this way so things don't get thrown all around hilariously.
		for(var/atom/movable/AM in T)
			thrownatoms += AM

	for(var/am in thrownatoms)
		var/atom/movable/AM = am
		if(AM == user || AM.anchored)
			continue
		throwtarget = get_edge_target_turf(user, get_dir(user, get_step_away(AM, user)))
		distfromcaster = get_dist(user, AM)
		if(isliving(AM))
			var/mob/living/M = AM
			do_knockdown(M)


/obj/effect/proc_holder/spell/aoe_turf/rage/proc/do_knockdown(mob/living/carbon/M)
	to_chat(M, "mrmem forces you up into the air!")
//	M.stun(50)
	M.pixel_y += 10
	sleep(50)
	M.pixel_y += 10
	to_chat(M, "<span class='userdanger'>You feel a crushing force bear down on you as eee slams you into the deck plates!</span>")
	M.pixel_y = initial(M.pixel_y)
	M.Knockdown(100)
	shake_camera(M, 1, 20)
	M.adjustBruteLoss(5)

*/
/obj/item/clothing/suit/space/nanosuit
	name = "MT-X0F Nanosuit"
	desc = "A suit fusing borg technology with a highly advanced hardsuit, it contains several attachment points which are designed to interface with a borg, which will allow direct control over the nanites in their bloodstream. Using this exerts enormous physical strain on the user"
	icon_state = "skulls"
	item_state = null
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = FULL_BODY
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEGLOVES | HIDESHOES | HIDEJUMPSUIT
	slowdown = 2
	flags_1 = THICKMATERIAL_1 | STOPSPRESSUREDMAGE_1
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 0, bomb = 30, bio = 100, rad = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	allowed = list(/obj/item/device/flashlight)
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS|HEAD
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS|HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	var/InUse = FALSE

/obj/item/clothing/suit/space/nanosuit/ShiftClick(mob/user)
	. = ..()
	SpeedBoost()

/obj/item/clothing/suit/space/nanosuit/AltClick(mob/user)
	ArmourBoost()

/obj/item/clothing/suit/space/nanosuit/Initialize(timeofday)
	START_PROCESSING(SSobj,src)

/obj/item/clothing/shoes/combat/nanosuit
	name = "Nanofibre combat boots"

/obj/item/clothing/shoes/combat/nanosuit/step_action()
	. = ..()
	playsound(src,'StarTrek13/sound/trek/heavywalk.ogg',40,1)

/obj/item/clothing/suit/space/nanosuit/process()
	var/mob/living/carbon/human/user = src.loc
	if(ismob(user))
		if(InUse)
			user.adjustStaminaLoss(8)

/obj/item/clothing/suit/space/nanosuit/proc/CheckValidity() //Can we use this power?
	var/mob/living/carbon/human/user = src.loc
	user.update_inv_wear_suit()
	if(!/obj/item/clothing/shoes/combat/nanosuit in user.shoes)
		to_chat(user, "ERROR: No combat boots detected with a suitable interface.")
		return 0
	if(InUse)
		to_chat(user, "\[ <span style='color: #00ff00;'>ok</span> \] Nanoprobes returning to body.")
		InUse = FALSE
		armor = list(melee = 40, bullet = 30, laser = 30, energy = 0, bomb = 30, bio = 100, rad = 100)
		slowdown = initial(slowdown)
		icon_state = initial(icon_state)
		return 1
	else
		if(!InUse)
			to_chat(user, "\[ <span style='color: #00ff00;'>ok</span> \] Sending command to nanoprobes ..{}")
			to_chat(user, "\[ <span style='color: #00ff00;'>ok</span> \] Success!")
			return 1
		else
			to_chat(user, "\[ <span style='color: #00ff00;'>FAIL</span> \] ERROR: Nanoprobes already in distribution points.")
			return 0


/obj/item/clothing/suit/space/nanosuit/proc/SpeedBoost()
	armor = list(melee = 80, bullet = 50, laser = 45, energy = 20, bomb = 50, bio = 100, rad = 100)
	slowdown = 2
	icon_state = "skulls"
	if(CheckValidity())
		if(InUse)
			slowdown = initial(slowdown)
			InUse = FALSE
		else
			slowdown = 0 //Successfully active
			InUse = TRUE

/obj/item/clothing/suit/space/nanosuit/proc/ArmourBoost()
	if(CheckValidity())
		if(InUse)
			armor = list(melee = 40, bullet = 30, laser = 30, energy = 0, bomb = 30, bio = 100, rad = 100)
			slowdown = initial(slowdown)
			icon_state = initial(icon_state)
			InUse = TRUE
		else
			armor = list(melee = 80, bullet = 50, laser = 45, energy = 20, bomb = 50, bio = 100, rad = 100)
			slowdown = 5
			icon_state = "skulls-armour"
			InUse = FALSE