import re 
import sys
from lxml import etree as et

box_path = "Girls_FrontLine/scripts/invasion/my_item_delivery_configurator_invasion.as"

# ScoredResource("pistol_orga.weapon", "weapon", 1.0f, 1),


ws = []
with open('box_weapon.txt') as f:
	for w in f:
		w = f.readline().strip('\n') 
		ws.append(w)

print(ws)

meta_path = 'meta.objects.xml'
tree = et.parse(meta_path)
root = tree.getroot()

aws = root.xpath('.//weapon/@key')

print(set(ws)-set(aws))