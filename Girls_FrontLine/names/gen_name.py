from xml.etree.ElementTree import parse

with open("../factions/grey.xml") as fd:          
	et = parse(fd)
	root = et.getroot()
	for tag in root.findall('soldier[@firstnames_file]'):
		file = tag.attrib["firstnames_file"]
		if file[0] == "_":
			print(file)
			with open(file, "w") as f2:
				f2.write(file[1:-5])
