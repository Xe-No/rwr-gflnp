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


// void giveItem(int cid, string key, string type) {
// 	string c = 
// 		"<command class='update_inventory' character_id='" + cid + "' container_type_class='backpack'>" + 
// 			"<item class='" + type + "' key='" + key + "' />" +
// 		"</command>";
// 	m_metagame.getComms().send(c);  
// }

array<int>@ getCommonElement(array<int>@ list1, array<int>@ list2){
	int i=0; int j=0;
	int l1 = list1.size();
	int l2 = list2.size();
	array<int> listc;

	if (l1==0||l2==0) return listc;
	list1.sortAsc();
	list2.sortAsc();

	while(i<list1.size()&&j<list2.size()){
		if(list1[i]<list2[j]) {
			i++;
		}
		else if (list1[i]>list2[j]) {
			j++;
		} 
		else{
			listc.insertLast(list1[i]); i++;j++;
		}
	}
	return listc;

}

