import os, sys, re
import datetime
from lxml import etree as et
import json
import copy
from itertools import chain

# TODO： 检查models要求的模型是否存在
# 重复载入武器会导致卡75%，做一个分析
# 检测重名粒子特效
# 检测重复键值的武器
# 检测不存在的特效

def dict2json(file_name,the_dict):
    '''
    将字典文件写如到json文件中
    :param file_name: 要写入的json文件名(需要有.json后缀),str类型
    :param the_dict: 要写入的数据，dict类型
    :return: 1代表写入成功,0代表写入失败
    '''
    try:
        json_str = json.dumps(the_dict,indent=4)
        with open(file_name, 'w') as json_file:
            json_file.write(json_str)
        return 1
    except:
        return 0

def printE(element):
    if element:
        print(et.tostring(element))

def findTagGetAttrib(element, xpath, attrib):
    return [ subelement.get(attrib) for subelement in element.findall(xpath)]





def getSubFiles(root_path):
    root_depth = len(root_path.split(os.path.sep))
    paths = []  

    for root, dirs, files in os.walk(root_path, topdown=True):
        for file in files:
            file_path = os.path.join(root, file)
            file_depth = len(file_path.split(os.path.sep))
 
            if  file_depth -  root_depth <= 3:
                paths.append(file_path)
                # print(file_path)
            else:

                break
    return paths

def pure_parse(path):
    if not path:
        return False
    parser = et.XMLParser(remove_blank_text=True, remove_comments=True)
    return et.XML(et.tostring(et.parse(path).getroot()), parser)

def remove_sub_elem(elem, tag):
    for sub_elem in elem.findall(tag):
        elem.remove(sub_elem)

class PRX(object):
    """docstring for LF"""
    __dict_file = {}

    def __init__(self, path_list):
        self.dict_file = {}
        self.path_list = path_list
        self.get_dict_file()
        
        

    def get_dict_file(self):
        

        self.dict_file = {}
        for root_path in self.path_list:
            for path in getSubFiles(root_path):
                name = os.path.basename(path)
                # if name == "all_weapons.xml":
                #     print(root_path)
                #     print(path)
                if name not in self.dict_file.keys():
                    self.dict_file[name] = path
        
    def lf(self, file):
        # print(file)
        if file in self.dict_file.keys():
            # print(file)
            return self.dict_file[file]
        else:
            print(file + " not found")
            return False



    def parse_file(self, file):
        # preserve_tags = ['projectile']
        preserve_tags = [ 'sound', 'rev_sound', 'model', 'addon_model', 'hud_icon']
        clear_attribs = [ 'clear_weapons', 'clear_carry_items', 'clear_grenades', 'clear_vehicles', 'clear_calls']
        # print(file)
        ret = self.lf(file)

        ele0 = pure_parse(ret)
        # printE(ele0)  
        if ele0.get('file') is not None:

            file2 = ele0.get('file')
            ele2 = self.parse_file(file2)
            merge_element(ele0, ele2 )
            ele0.attrib.pop('file')

        # apply attrib file
        for ele1 in ele0.iterfind(".//*[@file]"):
            if  ( ele1.tag not in preserve_tags ):
                file2 = ele1.get('file') 
                ele2 = self.parse_file(file2)

                merge_element(ele1, ele2 )
                ele1.attrib.pop('file')

        # TODO:apply attrib clear resource
        # for ele1 in ele0.findall(".//resources"):
        #     if ele1.tag == 'clear_weapons':
        #         remove_sub_elem(elem, tag)

        return ele0



        


def merge_element(ele1, ele2):
    # ele2 over ele1
    if ele1.tag != ele2.tag:
        for ele2_sub in ele2:
            ele1.append(ele2_sub)

    # revert_tags = ['specification', 'model', 'hud_icon', ' commonness', 'inventory']
    adding_tags = ['sound', 'effect', 'event', 'shield', 'turret', 'tire_set', 'target_factors', 'visual', 'vehicle', 'weapon', 'carry_item', 'throwable', 'projectile']
    
    ele2.attrib.update(ele1.attrib)
    for key,value in dict(ele2.attrib).items():
        ele1.set(key, value)
    # if ele1.tag =="specification":

    for ele2_sub in ele2:
        ele1_tags = [ele.tag for ele in ele1]
        if (ele2_sub.tag in adding_tags) |  ( ele2_sub.tag not in ele1_tags):
            ele1.append(ele2_sub)
        # merge
        else:
            for ele1_sub in ele1:
                if ele2_sub.tag == ele1_sub.tag:
                    merge_element(ele1_sub, ele2_sub)
        
            # else:
            
    # print("merged element")
    # printE(ele1)
    # return copy.deepcopy(ele1)

def get_index(ele, list):
    if ele in list:
        return list.index(ele)
    else:
        return 9999


path_list = [
    # 'C:/Users/Administrator/Desktop/_S07E',
    # 'C:/rwr_test_env/rwr/media/packages/GFL28',
    # 'C:/rwr/media/packages/Gext/_ec',
    'C:/rwr_test_env/rwr/media/packages/Girls_FrontLine',
    'C:/rwr_test_env/rwr/media/packages/vanilla'
    # 'D:/Girls_FrontLine',
    # r'D:\Games\SteamGames\steamapps\common\RunningWithRifles\media\packages\vanilla'  
    ]
prx = PRX(path_list)
dict2json('prx.dict_file.json', prx.dict_file) 

print("RWR Resource Checker")
print("Author: Xe-No")


# prx.parse_file("map_config.xml")

# print('Parse faction')
# faction = prx.parse_file("grey.xml")
# for soldier in faction.findall('.//soldier'):
#     print(soldier.get('name'))


# for elem in faction.iter():
#     elem.tail = ''
# et.indent(faction, space="\t")
# tree = et.ElementTree(faction)

# tree.write('faction_info.xml', pretty_print=True)
# sys.exit()

print("Parse weapon")
compact_weapons = et.Element('weapons')
# all_weapons = prx.parse_file("te_w.xml")
all_weapons = prx.parse_file("all_weapons.xml")
for weapon in all_weapons.findall(".//weapon[@key]"):
    predefined_order = [
    'specification',
    'model',
    'hud_icon'
    ]
    children = weapon.xpath("*")

    children = sorted(
        children,
        key = lambda x: get_index(x.tag, predefined_order))
    compact_weapons.append(weapon) 




print("Parse throwable")
compact_throwables = et.Element('throwables')
all_throwables = prx.parse_file("all_throwables.xml")
[ compact_throwables.append(throwable) for throwable in all_throwables.iterfind(".//projectile[@key]")]

print("Parse item")
compact_carry_items = et.Element('carry_items')
all_carry_items = prx.parse_file("all_carry_items.xml")
[ compact_carry_items.append(carry_item) for carry_item in all_carry_items.iterfind(".//carry_item[@key]")]

print("Parse vehicle")
compact_vehicles = et.Element('vehicles')
all_vehicles = prx.parse_file("all_vehicles.xml")
[ compact_vehicles.append(vehicle) for vehicle in all_vehicles.iterfind(".//vehicle[@key]")]



meta_objects = et.Element("meta")
meta_objects.append(compact_weapons)
meta_objects.append(compact_throwables)
meta_objects.append(compact_carry_items)

meta_objects.append(compact_vehicles)

all_extra_models = prx.parse_file("extra_costume.models")
all_gk_models = prx.parse_file("gk.models")
meta_objects.append(all_extra_models)
meta_objects.append(all_gk_models)


for elem in meta_objects.iter():
    elem.tail = ''


tree = et.ElementTree(meta_objects)

root = tree.getroot()
weapons = root.find('weapons')
for weapon in weapons.findall('./weapon'):
    if weapon.attrib =={}:
        print("")
        # weapons.append(weapon)
        # for sub in weapon:
        #   print(sub.get('key'))
        #   weapons.append(sub)

et.indent(tree.getroot(),"    ")
tree.write('meta.objects.xml', pretty_print=True)



print("====================weapon tree check")

files_all = set(prx.dict_file.keys())
print(f"总文件数： {len(files_all)} ")

# print(files_all)
with open("all_files.txt", "w") as f:
    for filename in files_all:
        f.write(filename)
        f.write("\n")
print("进入根节点")
root = tree.getroot()

# files_meta_hud = set(findTagGetAttrib(root, './/hud_icon', 'filename'))
# # print(files_meta_hud)
# print("检查hud Missing hud:")
# print(files_meta_hud-files_all)

print("检查hud")
for hud_icon in root.findall('.//hud_icon'):
    file = hud_icon.get('filename')
    if file is not None:
        if file not in files_all:
            key = hud_icon.getparent().get('key')
            print(f"【致命错误】 对象 【{key}】 引用了不存在的图标 【{file}】 ")

files_meta_model = set(findTagGetAttrib(root, './/model', 'filename'))
files_meta_model = files_meta_model | set(findTagGetAttrib(root, './/model', 'mesh_filename'))
# print(files_meta_model)
print("检查体素模型 Missing model:")
print(files_meta_model-files_all)

keys_all_vehicle = set(findTagGetAttrib(root, './/vehicle', 'key'))
# print(keys_all_vehicle)

files_meta_mesh_model = set(findTagGetAttrib(root, './/visual', 'mesh_filename'))
# print(files_meta_mesh_model)
print("检查网格模型 Missing mesh model:")
print(files_meta_mesh_model-files_all)

files_meta_mesh_texture = set(findTagGetAttrib(root, './/visual', 'texture_filename'))
# print(files_meta_mesh_texture)
print("检查网格模型贴图 Missing mesh texture:")
print(files_meta_mesh_texture-files_all)



keys_all_weapon = set(findTagGetAttrib(root, './/weapon', 'key'))
keys_turret_weapon = set(findTagGetAttrib(root, './/turret', 'weapon_key'))
keys_next_in = set(findTagGetAttrib(root, './/next_in_chain', 'key'))
print("检查武器键值 Missing vehicle weapon key")
keys_missing_vw = keys_turret_weapon - keys_all_weapon
print(keys_missing_vw )
for turret in root.findall('.//vehicle//turret'):
    key = turret.get('weapon_key')
    if key is not None:
        if key not in keys_all_weapon:
            v_key = turret.getparent().get('key')
            print(f"【致命错误】 载具 【{v_key}】 引用了未注册的武器 【{key}】 ")



print("检查切换武器键值")
# print( keys_next_in - keys_all_weapon)
for next_in_chain in root.findall('.//weapon//next_in_chain'):
    key = next_in_chain.get('key')
    if key is not None:
        if key not in keys_all_weapon:
            w_key = next_in_chain.getparent().get('key')
            print(f"【致命错误】 武器 【{w_key}】 引用了未注册的切换武器 【{key}】 ")




files_meta_sound = \
set(findTagGetAttrib(root, './/sound', 'fileref')) |\
set(findTagGetAttrib(root, './/sound', 'filename')) |\
set(findTagGetAttrib(root, './/rev_sound', 'filename'))
# print(files_meta_sound)
file_sound = set([ file for file in files_all if os.path.splitext(file)[-1] == ".wav"])
# print(file_sound)
print(f"【信息】 总音效数： {len(file_sound)} ")
file_missing_sound = files_meta_sound-file_sound
print("检查音效 Missing sound:")
print(file_missing_sound)
# print("Unused sound:")
# print(file_sound-files_meta_sound)


print("检查动作引用")
keys_animation = [animation.get('comment') for animation in et.parse(prx.lf('soldier_animations.xml')).getroot().findall('animation')]
print(f"【信息】 总动作数： {len(keys_animation)} ")
for animation in root.findall('.//weapon//animation'):
    key = animation.get('animation_key')
    if key is not None:
        if key not in keys_animation:
            w_key = animation.getparent().get('key')
            print(f"【致命错误】 武器 【{w_key}】 引用了未注册的动作 【{key}】 ")



files_meta_anim = set(findTagGetAttrib(root, './/animation', 'animation_key'))
# print(files_meta_anim)

print("检查人物模型引用")
all_extra_models = set(findTagGetAttrib(root, './/model', 'filename'))
print(all_extra_models-files_all)


input()