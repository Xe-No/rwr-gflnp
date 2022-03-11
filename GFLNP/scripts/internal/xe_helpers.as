#include "helpers.as"
#include "query_helpers.as"

const XmlElement@ readXML(const Metagame@ metagame, string filename){
	XmlElement@ query = XmlElement(
		makeQuery(metagame, array<dictionary> = {
			dictionary = { {"TagName", "data"}, {"class", "saved_data"}, {"filename", filename}, {"location", "app_data"} } }));
	const XmlElement@ xml = metagame.getComms().query(query).getFirstChild();
	return xml;
}

void writeXML(const Metagame@ metagame, string filename, XmlElement@ xml, string location = "app_data" ){
	XmlElement command("command");
		command.setStringAttribute("class", "save_data");
		command.setStringAttribute("filename", filename);
		command.setStringAttribute("location", location);
		command.appendChild(xml);
	metagame.getComms().send(command);
}


void removeTagFromXML(const Metagame@ metagame, string filename, string tagName, int index ){
	const XmlElement@ xml = readXML(metagame, filename);

	XmlElement kxml(xml.toDictionary());
	// xml.removeAt(index);
	// xml.toString(1);
	kxml.removeChild(tagName, index);

	writeXML(metagame, filename, kxml );
}

string checkAttr1ForAttr2(const Metagame@ metagame, string filename, string tag, string attr1, string value1, string attr2 ){
	const XmlElement@ xml = readXML(metagame, filename);
	XmlElement kxml(xml.toDictionary());

	if (kxml !is null) {
		array<const XmlElement@> items = kxml.getElementsByTagName(tag);
		for (uint i = 0; i < items.size(); ++i) {
			const XmlElement@ item = items[i];
			if (items[i].getStringAttribute(attr1) == value1){
				string value2 = items[i].getStringAttribute(attr2);
				return value2;
			}
		}
	}
	return "Failed";
}