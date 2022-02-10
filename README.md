# 使用方法
下载后替换到packages /v test 召唤28测试版本箱子 读取太慢可以注释掉 gfl_w gfl_c gfl_v

# 0.29

## 0.29a
LVOAC枪模子弹效果替换		
取消掉子弹头的生成，并且将枪模向后调整2格，致死降低至1.6。
刘易斯黑卡属性重做	


G41泳装榴弹模式属性修改		整理完毕
进行了属性和弹道颜色的修改，有独立说明。

M16A5属性变动				整理完毕
三模式统一移速-0.03。
AR模式无其他变动。
.308模式切换为0.15射速的全自动模式，0.31后座，1.6回复，整体单发后座力0.07
榴弹模式微调弹道高度与下坠力，范围改至4.8。下个版本可能添加弹头衍生物以增加对步兵伤害。
模型实装已整理，分到了额外文件夹。

QBZ191信赖致死+0.02			


希尔装填时间增加	
装填0.48s一发增加至0.85s一发，替换了换弹动作。

QLT89榴弹平衡性或出率调整			
伤害3.52改为2.52，范围5.5降低至5.0。
修改弹头伤害。
	
G11三改属性重做		
后座力改为0.12 回复1.45，单发后座力效用为0.78675。
致死提升至1.75
仅变动SS模式

MP5K属性变动				
致死1.35提升至1.38
武器射击间隔retrigger_time="0.096"→retrigger_time="0.085" 
武器子弹magazine_size="60"→magazine_size="62" 
武器持有速度修正<modifier class="speed" value="-0.01" />→<modifier class="speed" value="+0.1" /> 

M4SOP2心智升级致死增加
致死1.45至1.55


刘易斯-迎寒客的枪械属性调整：
	基础精准		1.0	→ 	0.95
	视野		1.2	→	1.0
	最大扩散		无	→	0.12
	后座力扩散	0.3	→ 	0.4
	后座力回复	2.5	→	1.6
	致死		1.7	→	1.66	
	移速		-0.1	→	-0.15	
	
	全部姿态精准度：
    <stance state_key="running" accuracy="0.4" />				    <stance state_key="running" accuracy="0.05" />
    <stance state_key="walking" accuracy="0.5" />				    <stance state_key="walking" accuracy="0.4" />
    <stance state_key="crouch_moving" accuracy="0.6" />			    <stance state_key="crouch_moving" accuracy="0.1" />
    <stance state_key="standing" accuracy="0.75" />		→	    <stance state_key="standing" accuracy="0.95" />
    <stance state_key="crouching" accuracy="0.8" />			    <stance state_key="crouching" accuracy="1.0" />
    <stance state_key="prone" accuracy="1.0" /> 				    <stance state_key="prone" accuracy="1.0" /> 
    <stance state_key="prone_moving" accuracy="0.75" />			    <stance state_key="prone_moving" accuracy="0.1" />
    <stance state_key="over_wall" accuracy="1.2" />				    <stance state_key="over_wall" accuracy="0.95" />  
	改动之后依旧能执行短点射和连续火力压制，符合较为强力的黑卡无脚架MG水平

## 0.29b
T1 EXO：防御—— 0.1/0/0 → 0.5/0.4/0.3
        嘲讽—— 0.1 → 0

X1 EXO：防御—— 0.1/0 → 0.52/0.47
        嘲讽—— 0.1 → 0
        移速修正：0.02 → 0

T2 EXO：防御—— 0.2/0.15/0.1 → 0.55/0.45/0.35
        嘲讽—— 0.1 → 0

X2 EXO：防御—— 0.3/0.23/0.2/0.15 → 0.59/0.51/0.45/0.15
        嘲讽—— 0.1 → 0.05
        移速修正—— 0.02 → 0

T3 EXO：防御—— 0.6/0.55/0.25/0.25 → 0.6/0.5/0.45/0.45
        嘲讽—— 0.1 → 0

X3 EXO：防御—— 0.4/0.35/0.35/0.35 → 0.7/0.6/0.5/0.5
        嘲讽—— 0 → 0.05
        移速修正—— 0.05 → 0

T4 EXO：防御—— 0.84/0.84/0.8/0.8/0.75 → 0.85/0.8/0.8/0.75/0.7
        移速修正—— 0.15 → 0.1

X4 EXO：防御—— 1/1/0.9/0.8/0.75 → 0.9/0.85/0.85/0.8/0.75
        嘲讽—— 0 → 0.02
        移速修正—— 0.1 → 0.05

16LAB T4 EXO：防御—— 0.95/0.85/0.85/0.7/0.5 → 1/0.9/0.85/0.8/0.8
              移速修正—— 0.2 → 0.1
              
16LAB X4 EXO：防御—— 1/1/0.9/0.8/0.6/0.5 → 1.05/0.95/0.95/0.85/0.8
              移速修正—— 0.1 → 0

T1 BP：防御—— 0.5/0.5/0.35/0.35/0.3/0 → 0.6/0.6/0.55/0.55/0.45/0.45
       嘲讽—— 0.3 → 0.25

T2 BP：防御—— 0.7/0.7/0.65/0.6/0.6/0.6 → 0.7/0.7/0.7/0.65/0.65/0.65
       嘲讽—— 0.3 → 0.2

T3 BP：防御—— 1.1/1.1/1.1/1.1 → 0.9/0.9/0.9/0.8
       嘲讽—— 0.3 → 0.1
       移速修正—— -0.15 → -0.1

T4 BP：防御—— 0.8/0.8/0.7/0.7/0.6/0.6/0.6 → 0.9/0.9/0.8/0.8/0.7/0.7/0.7

16LAB T4 BP：防御—— 0.9/0.9/0.4/0.8/0.8/0.7/0.7/0.6/0.6/0.5 → 1/1/0.9/0.9/0.9/0.8/0.8/0.8/0.8/0.7

All Camouflage Cloak：隐蔽修正：0（修改前） → +0.01/0.02（修改后）（部分带有夜幕隐蔽加成的则夜幕额外隐蔽-0.02）

Camouflaged Vest：防御：0.4/0.4/0.4/0.4/0.4 → 0.5/0.45/0.45/0.4/0.35
                  隐蔽：0.25/0.25/0.25/0.25/0.25 → 0.25/0.2/0.15/0.15/0.1


## 0.29c
重要！所有枪械属性以全整理文件夹为准，解压包为原有属性。

三个信物模型重置		信物（覆盖原文件）			RST
TOZ81左轮霰弹枪 		军械库&补给车			投稿者：VAN花露水		
VOG25手榴弹		军械库及所有能够买手雷的地方		HUD：笨笨	数据&模型：BBBYJ
M4A1青丘狐		泰坦箱子				投稿者：司机酱
MG_BASE			军械库(MG标准模板)
山猫GM6 AP		黑卡				投稿者：Z-2414
SAW链锯机枪		CB1(12F出率)			模型：141		其余：252	
RUMBLER榴炮		彩票（0.2F//双倍）			RST
HUD更新			AN94黑卡及SASS三改HUD覆盖		Petrichor

其中M4A1青丘狐的出处因为选择了泰坦，保护时间给了黑卡的。
MG_BASE是女仆长说的MG模板。
SAW链锯机枪能全姿态，添加了0.34的最大扩散以平衡，致死待定
额外动作是给rumbler用的，我删除了开头和结尾，方便全选复制进去。

<weapon file="gw_toz81.weapon" />
<weapon file="gw_m4a1_qingqiuhu.weapon" />
<weapon file="gw_m4a1_qingqiuhu_annihilator.weapon" />
<weapon file="gw_mgnormal.weapon" />
<weapon file="gw_mgnormal_n.weapon" />
<weapon file="gm6_lynx_ap.weapon" />
<weapon file="gm6_lynx_ap_aim.weapon" />
<weapon file="chain_sawr.weapon" />
<weapon file="ew_rumbler.weapon" />
<weapon file="ew_rumbler_consume.weapon" />

<projectile file="vog_grenade.projectile" />
<projectile file="gm6_lynx_blast.projectile" />

<model filename="gs_m4a1_qingqiuhu_annihilator.xml"><requirement class="weapon" slot="0" key="gw_m4a1_qingqiuhu_annihilator.weapon"/></model>
<model filename="gs_m4a1_qingqiuhu.xml"><requirement class="weapon" slot="0" key="gw_m4a1_qingqiuhu.weapon"/></model>
<model filename="gs_t800.xml"><requirement class="weapon" slot="0" key="chain_sawr.weapon"/></model>
<model filename="gs_gm6_card.xml"><requirement class="weapon" slot="0" key="gm6_lynx_ap_aim.weapon"/></model>
<model filename="gs_gm6_card.xml"><requirement class="weapon" slot="0" key="gm6_lynx_ap.weapon"/></model>
<model filename="es_volcanic.xml"><requirement class="weapon" slot="0" key="ew_rumbler.weapon"/></model>


山猫GM6 AP
两个模式均为AP，均为6发x0.22blast伤害弹头（基于dsr弹头改成）
一模式（gm6_lynx_ap）是原gm6山猫的较高射速较低精度模式（不太会用生成系统，只能做成命中后生成弹头，于是没法穿人），二模式（gm6_lynx_ap_aim）是反器材式模式，较长时间瞄准较高精度射击
两个模式间只有射击方式不同，使用相同弹药，枪械结构无改变，切换几乎无延时
一模式可以站射，二模式不能立直射击
其他内容几乎与原gm6山猫相同

人物模型请绑原gm6山猫模型（gs_gm6.xml）

假如采纳希望能塞进黑卡之类的相对好获取的地方

（已经削过了点视野和弹速，也在dsr弹头基础上削了点伤害，我觉得已经不是很夸张了，如果采纳了但是还是需要削的话请优先考虑削弹头damage和武器retrigger_time，希望不动projectiles_per_shot）


投稿物品：TOZ-81“火星”宇航员自卫手枪
投稿人：VANDHEER（花露水）
投稿目标：军械库副手武器

TOZ-81是图拉兵工厂于1979年研制的小型多功能武器，作为是左轮手枪与折叠式刀具的组合体，
可以快速更换弹舱与枪管，也可以加装枪托。该枪能够使用特制霰弹或是5.45mm的小口径子弹，
尾部装弹，弹容量5发。

--------------------------------------------

希望该枪可以加入军械库副手（如果补给车也有就更好了）

现阶段，玩家缺乏便宜好用的副手类防身武器，投稿目的是为了改善玩家缺乏枪支类副手武器的现状。
举例而言， 主武器是狙击枪或PF98的玩家往往副手只能选择美军的mp5k，mp5k获取不够方便，而
cb2的黑桃A又过于稀有，导致玩家没有中间过渡型防身武器可以使用。同时，前线阵亡玩家有时会重
生携带m2hb等不够灵活的武器，导致路上再次阵亡，如果有更多可重生自带的副手武器，应该可以
减少这一情况的发生。

---------------------------------------------

toz81的属性我是在毛子的saw-off双管短喷上改的，弹容量5发，考虑到需要防身，加快了枪的射速与
精准度（mp5k经常刮不死人...），致死等其他属性未作修改。在测试的时候我还发现saw-off的子弹射程
挺猛的，1视野下基本一个屏幕内都可以2枪打死一个人（kcco九头蛇等大型步兵单位不算），于是
微削了toz81的伤害衰减，结果测试发现还是很猛，不过毕竟弹容只有5发，而且跑尸的时候副手武器
强一点是好事，所以不打算再改了。现在的toz81差不多就是个5发装的saw-off，或者说小博莱塔7000，
但精准度不如7000，无法狙人，只能远程把人刮死，所以toz作为主武器不太够格，但当副手绰绰有余。

本来打算是做双模式，一模式霰弹二模式消音手枪（同fn57），这样toz81又可以潜入用又可以打正面，
但考虑到目标是把枪加入军械库让所有人都可以直接用（抽白卡黑卡赌人品太折磨人了），而且需要
重生自带，就把消音手枪模式删了，改成了现在的单模式霰弹手枪。

属性我做了测试，感觉挺好用的，强度也适中。如果因强度问题需要调整，请尽量从射程上做改动。
有两点是希望保留且不作改动的：1、该枪加入军械库，可重生自带。 2、轻负重。如果枪负重太高就不
适合装进背包随取随用了。