#!/usr/bin/python2.7
from xml.dom import minidom
import json

def getXmlValueByTagAttribute1st(xdoc, tag, attr):
	if xdoc.getElementsByTagName(tag):
		if (xdoc.getElementsByTagName(tag)[0].getAttribute(attr)):
			# print(xdoc.getElementsByTagName(tag)[0].getAttribute(attr))
			return float(xdoc.getElementsByTagName(tag)[0].getAttribute(attr))
	else:
		return None

def getXmlStringByTagAttribute1st(xdoc, tag, attr):
	if xdoc.getElementsByTagName(tag):
		return xdoc.getElementsByTagName(tag)[0].getAttribute(attr)
	else:
		return None

def getXmlStringByTagAttribute(xdoc, tag, attr):
	return [node.getAttribute(attr) for node in xdoc.getElementsByTagName(tag)]

def calculateDistance(time, speed):
	if (time == None) or (speed == None) :
		return None
	else:
		return time * speed

def calculateRPM(weapon_xdoc):
	retrigger_time = getXmlValueByTagAttribute1st(weapon_xdoc, 'specification', 'retrigger_time')
	if retrigger_time: 
		if (retrigger_time > 0.0):
			return  60.0/retrigger_time
	
	return None

def getWeaponVector(weapon):
	print(weapon)
	with minidom.parse(weapon) as weapon_xdoc:
		vector=[\
		getXmlStringByTagAttribute1st(weapon_xdoc, 'specification', 'name'),\
		getXmlStringByTagAttribute1st(weapon_xdoc, 'specification', 'class'),\
		getXmlStringByTagAttribute1st(weapon_xdoc, 'tag', 'name'),\
		getXmlValueByTagAttribute1st(weapon_xdoc, 'inventory', 'price'),\
		getXmlValueByTagAttribute1st(weapon_xdoc, 'specification', 'magazine_size'),\
		calculateRPM(weapon_xdoc),\
		getXmlValueByTagAttribute1st(weapon_xdoc, 'specification', 'sustained_fire_grow_step'),\
		getXmlValueByTagAttribute1st(weapon_xdoc, 'specification', 'sustained_fire_diminish_rate'),\
		getXmlValueByTagAttribute1st(weapon_xdoc, 'result', 'kill_probability'),\
		calculateDistance(getXmlValueByTagAttribute1st(weapon_xdoc, 'result', 'kill_decay_start_time'), getXmlValueByTagAttribute1st(weapon_xdoc, 'specification', 'projectile_speed')),\
		calculateDistance(getXmlValueByTagAttribute1st(weapon_xdoc, 'result', 'kill_decay_end_time'), getXmlValueByTagAttribute1st(weapon_xdoc, 'specification', 'projectile_speed')) ,\
		getXmlValueByTagAttribute1st(weapon_xdoc, 'commonness', 'value'),\
		]
		keys = [
		'name',
		'class',
		'tag',
		'price',
		'magazine_size',
		'RPM',
		'sustained_fire_grow_step',
		'sustained_fire_diminish_rate',
		'kill_probability',
		'kill_decay_start_distance',
		'kill_decay_end_distance',
		'commonness']

		dict_w = {'key': weapon}
		for x in range(len(keys)):
			dict_w[keys[x]] = vector[x]

	return dict_w




with minidom.parse('all_gfl1_weapons.xml') as all_weapon_xdoc:
	weapons = getXmlStringByTagAttribute(all_weapon_xdoc, 'weapon', 'file')
	ww = []
	for weapon in weapons:
		
		# print(getXmlValueByTagAttribute1st(weapon_xdoc, 'specification', 'retrigger_time'))
		ww.append(getWeaponVector(weapon))


print(json.dumps(ww,indent=4))
with open('data_18.json','w',encoding='utf-8') as f:
	f.write(json.dumps(ww,indent=4))
	json.dumps(ww,f, skipkeys=False, ensure_ascii=True, check_circular=True, allow_nan=True, cls=None,indent=4)




