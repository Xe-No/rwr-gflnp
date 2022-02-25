# 使用方法
下载后替换到packages /v test 召唤28测试版本箱子 读取太慢可以注释掉 gfl_w gfl_c gfl_v

# 0.30

## 0.30b
	美术调整：

		模型：
			SASS三改2模式模型
			AN94白卡及黑卡枪械模型替换
			MG4TD及其中两个黑卡头发绑骨修改。
			信物朱雀院椿泳装模型修改。
			AGS30武器模型替换
			时雨和夕立模型修改
		HUD：
			AK12白卡
			toz81
			RPK16白卡
			特工416曼岛之盾
			新春、玩具、信物箱子UI替换
		特效：
			RX1特效调整

## 0.30c
	M4A1青丘狐添加架设精准1.0，走射精准改为0.8/0.78
	MP5K，弹容62调整至122
	SAW链锯机枪最大扩散0.31上调至0.25，精准度1.1下调至1.0
	MDR键盘侠榴弹伤害改为1.05*2，榴弹弹容调整回2，榴弹装填机制改为弹匣式装填，装填时间延长至2.5秒。
	TOZ81射程提升6米。

## 0.30d
	因护甲平衡性调整未装，对原来因为护甲调整而提前被削弱移速的42LAB外骨骼进行了调整。
	除最后一层，每层移速+0.05。
	有夜间隐蔽的层数：夜间隐蔽-0.05，常驻隐蔽+0.05

## 0.30e
	BASE修改：
	base_MG 		& 	base_card_mg：

	<stance state_key="prone" accuracy="1.1" /> 
	<modifier class="speed" value="-0.15" />


	base_MG_n 	& 	base_card_mg_n：

	<stance state_key="prone" accuracy="0.95" /> 
	<modifier class="speed" value="-0.15" />


	枪械平衡：
	AEK-999 - kill_pro：1.6（0）/ accuracy：0.95（-0.05）/ spread_range：0.15（0）/  sight_range：1.15（+0.15）/ projectile_speed：160（-20） / distance：80（-10）/115.2（-14.4）/ speed：-0.21（0）
	AEK-999_n - kill_pro：1.6（0）/ accuracy：0.95（+0.23）/ spread_range：0.31（0）/  sight_range：1.0（0）/ projectile_speed：160（-20） / distance：80（-10）/115.2（-14.4）/ speed：-0.21（0）
	
	AAT 52 - kill_pro：1.55（0）/ accuracy：0.88（+0.05）/ spread_range：0.21（0）/  sight_range：1.2（+0.2）/ projectile_speed：135（0） / distance：60.75（+10.8）/101.25（+5.4）/ speed：-0.25（+0.03）
	AAT 52_n - kill_pro：1.55（0）/ accuracy：0.88（+0.05）/ spread_range：0.41（-0.03）/  sight_range：1.0（0）/ projectile_speed：135（0） / distance：60.75（+10.8）/101.25（+5.4）/ speed：-0.25（+0.03）
	
	AMELI - kill_pro：1.55（0）/ accuracy：0.95（-0.05）/ spread_range：0.21（0）/  sight_range：1.2（+0.2）/ projectile_speed：180（0） / distance：81（0）/153（0）/ speed：-0.2（0）
	AMELI_n - kill_pro：1.55（0）/ accuracy：0.95（+0.25）/ spread_range：0.39（-0.02）/  sight_range：1.0（0）/ projectile_speed：180（0） / distance：81（0）/153（0）/ speed：-0.2（0）

	AMELI_1605 - kill_pro：1.59（0）/ accuracy：0.98（-0.02）/ spread_range：0.15（0）/  sight_range：1.2（+0.2）/ projectile_speed：180（0） / distance：81（0）/153（0）/ speed：-0.15（0）
	AMELI_1605_n - kill_pro：1.59（0）/ accuracy：0.98（+0.28）/ spread_range：0.35（0）/  sight_range：1.0（0）/ projectile_speed：180（0） / distance：81（0）/153（0）/ speed：-0.15（0）

	AMELI_1605 - kill_pro：1.69（+0.1）/ accuracy：0.98（-0.02）/ spread_range：0.25（0）/  sight_range：1.2（+0.2）/ projectile_speed：180（0） / distance：81（0）/153（0）/ speed：-0.15（0）
	AMELI_1605_n - kill_pro：1.69（+0.1）/ accuracy：0.98（+0.28）/ spread_range：0.35（0）/  sight_range：1.0（0）/ projectile_speed：180（0） / distance：81（0）/153（0）/ speed：-0.15（0）

	DP-28 - kill_pro：1.73（0）/ accuracy：0.88（+0.05）/ spread_range：0.24（+0.012）/  sight_range：1.2（+0.2）/ projectile_speed：170（-10） / distance：62.9（-3.7）/120.7（-7.1）/ speed：-0.20（+0.08）
	DP-28_n - kill_pro：1.73（0）/ accuracy：0.88（+0.05）/ spread_range：0.45（-0.07）/  sight_range：1.0（0）/ projectile_speed：170（-10） / distance：62.9（-3.7）/120.7（-7.1）/ speed：-0.20（+0.08）

	M2HB - blast：1.0*0.1*2（0）/ accuracy：0.95（0）/ spread_range：0.2（0）/  sight_range：1.15（+0.15）/ projectile_speed：180（0） / distance：N/A / speed：-0.45（0）

	M1919 - kill_pro：1.75（0）/ accuracy：0.95（-0.05）/ spread_range：0.20（+0.02）/  sight_range：1.1（+0.1）/ projectile_speed：180（0） / distance：72（0）/180（0）/ speed：-0.15（-0.025）
	M1919_n - kill_pro：1.75（0）/ accuracy：0.95（+0.29）/ spread_range：0.42（-0.06）/  sight_range：1.0（0）/ projectile_speed：180（0） / distance：72（0）/180（0）/ speed：-0.15（-0.025）

	MG5 - kill_pro：1.75（0）/ accuracy：0.92（0）/ spread_range：0.24（0）/  sight_range：1.45（+0.15）/ projectile_speed：180（0） / distance：63（0）/135（0）/ speed：-0.2（0）
	MG5_n - kill_pro：1.75（0）/ accuracy：0.92（+0.17）/ spread_range：0.46（-0.13）/  sight_range：1.3（0）/ projectile_speed：180（0） / distance：63（0）/135（0）/ speed：-0.2（0）

	MG5_309 - kill_pro：1.8（0）/ accuracy：0.92（0）/ spread_range：0.24（0）/  sight_range：1.5（+0.2）/ projectile_speed：180（0） / distance：63（0）/135（0）/ speed：-0.2（0）
	MG5_309_n - kill_pro：1.8（0）/ accuracy：0.92（+0.17）/ spread_range：0.46（-0.13）/  sight_range：1.3（0）/ projectile_speed：180（0） / distance：63（0）/135（0）/ speed：-0.2（0）

	MG34 - kill_pro：1.7（+0.03）/ accuracy：0.91（+0.1）/ spread_range：0.24（0）/  sight_range：1.15（+0.15）/ projectile_speed：167（0） / distance：58.45（0）/167（0）/ speed：-0.18（0）
	MG34_n - kill_pro：1.7（+0.03）/ accuracy：0.91（+0.1）/ spread_range：0.45（-0.08）/  sight_range：1.0（0）/ projectile_speed：167（0） / distance：58.45（0）/167（0）/ speed：-0.18（0）

	NEGEV - kill_pro：1.5（0）/ accuracy：0.93（0）/ spread_range：0.14（-0.03）/  sight_range：1.2（+0.2）/ projectile_speed：160（+50） / distance：64（+23.3）/112（+33.9）/ speed：-0.08（+0.12）
	NEGEV_n - kill_pro：1.5（0）/ accuracy：0.93（0）/ spread_range：0.28（-0.07）/  sight_range：1.0（0）/ projectile_speed：160（+50） / distance：64（+23.3）/112（+33.9）/ speed：-0.08（+0.12）

	NEGEV_904 - kill_pro：1.63（+0.1）/ accuracy：0.95（+0.05）/ spread_range：0.2（0）/  sight_range：1.1（+0.1）/ projectile_speed：160（+50） / distance：64（+23.3）/112（+33.9）/ speed：-0.08（+0.1）
	prone accuracy：1.05（+0.15）		over_wall accuracy：1.0（+0.08）

	PKP - kill_pro：1.72（0）/ accuracy：0.9（0）/ spread_range：0.23（0）/  sight_range：1.2（+0.2）/ projectile_speed：180（0） / distance：75.6（0）/126（0）/ speed：-0.23（0）
	PKP_n - kill_pro：1.72（0）/ accuracy：0.9（0）/ spread_range：0.38（0）/  sight_range：1.0（0）/ projectile_speed：180（0） / distance：75.6（0）/126（0）/ speed：-0.23（0）
 
	PKP_4203 - kill_pro：1.78（0）/ accuracy：0.95（0）/ spread_range：0.21（0）/  sight_range：1.1（+0.1）/ projectile_speed：180（0） / distance：75.6（0）/126（0）/ speed：-0.23（+0.1）
	prone accuracy：1.05（+0.15）		over_wall accuracy：1.0（+0.08）

	ZB26 - kill_pro：1.75（0）/ accuracy：1.0（0）/ spread_range：0.2（+0.02）/  sight_range：1.2（+0.2）/ projectile_speed：180（0） / distance：66.6（0）/127.8（0）/ speed：-0.1（0）
	ZB26_n - kill_pro：1.75（0）/ accuracy：1.0（0）/ spread_range：0.3（-0.01）/  sight_range：0（0）/ projectile_speed：180（0） / distance：66.6（0）/127.8（0）/ speed：-0.1（0）

	M60 - kill_pro：1.67（+0.1）/ accuracy：0.95（-0.05）/ spread_range：0.25（0）/  sight_range：1.2（+0.2）/ projectile_speed：180（0） / distance：63（0）/117（0）/ speed：-0.15（-0.04）
	M60_n - kill_pro：1.67（+0.1）/ accuracy：0.95（+0.225）/ spread_range：0.4（-0.08）/  sight_range：1.0（0）/ projectile_speed：180（0） / distance：63（0）/117（0）/ speed：-0.15（-0.04）

	PKM - kill_pro：1.65（0）/ accuracy：0.95（-0.05）/ spread_range：0.2（0）/  sight_range：1.2（+0.2）/ projectile_speed：165（0） / distance：66（0）/140.25（0）/ speed：-0.21（0）
	PKM_n - kill_pro：1.65（0）/ accuracy：0.95（+0.06）/ spread_range：0.35（-0.05）/  sight_range：1.0（0）/ projectile_speed：165（0） / distance：66（0）/140.25（+11.55）/ speed：-0.21（0）

	M240 - kill_pro：1.55（0）/ accuracy：0.95（0）/ spread_range：0.2（0）/  sight_range：1.2（+0.2）/ projectile_speed：180（0） / distance：63（0）/126（0）/ speed：-0.15（0）
	M240_n - kill_pro：1.55（0）/ accuracy：0.95（0）/ spread_range：0.35（-0.03）/  sight_range：1.0（0）/ projectile_speed：180（0） / distance：63（0）/126（0）/ speed：-0.15（0）

	M249 - kill_pro：1.57（0）/ accuracy：0.93（0）/ spread_range：0.2（0）/  sight_range：1.2（+0.2）/ projectile_speed：180（0） / distance：59.04（0）/142.2（0）/ speed：-0.11（+0.1）
	M249_n - kill_pro：1.57（0）/ accuracy：0.93（0）/ spread_range：0.35（-0.05）/  sight_range：1.0（0）/ projectile_speed：180（0） / distance：59.04（0）/142.2（0）/ speed：-0.11（+0.1）

	MK46 - kill_pro：1.6（0）/ accuracy：0.92（0）/ spread_range：0.22（0）/  sight_range：1.2（+0.2）/ projectile_speed：180（0） / distance：73.8（0）/126（0）/ speed：-0.22（0）
	prone accuracy：1.1（+0.1）		over_wall accuracy：1.2（+0.2）
	MK46_n - kill_pro：1.6（0）/ accuracy：0.92（0）/ spread_range：0.38（-0.06）/  sight_range：1.0（0）/ projectile_speed：180（0） / distance：73.8（0）/126（0）/ speed：-0.22（0）

	MG4 - kill_pro：1.5（0）/ accuracy：0.92（0）/ spread_range：0.20（+0.02）/  sight_range：1.2（+0.2）/ projectile_speed：170（0） / distance：68（+17）/127.5（+8.5）/ speed：-0.10（+0.03）
	MG4_n - kill_pro：1.5（0）/ accuracy：0.92（+0.17）/ spread_range：0.4（-0.02）/  sight_range：1.0（0）/ projectile_speed：170（0） / distance：68（+17）/127.5（+8.5）/ speed：-0.10（+0.03）

	MG4_703(AS) - kill_pro：1.7（0）/ accuracy：0.92（0）/ spread_range：0.19（0）/  sight_range：1.2（+0.2）/ projectile_speed：170（0） / distance：68（+17）/127.5（+8.5）/ speed：-0.10（0）
	MG4_703(AS)_n - kill_pro：1.7（0）/ accuracy：0.92（+0.17）/ spread_range：0.38（-0.02）/  sight_range：1.0（0）/ projectile_speed：170（0） / distance：68（+17）/127.5（+8.5）/ speed：-0.10（0）

	MG4_mod3 - kill_pro：1.74（0）/ accuracy：0.94（0）/ spread_range：0.17（0）/  sight_range：1.3（+0.2）/ projectile_speed：170（0） / distance：68（+17）/127.5（+8.5）/ speed：-0.10（0）
	MG4_mod3_n - kill_pro：1.74（0）/ accuracy：0.94（+0.17）/ spread_range：0.34（0）/  sight_range：1.1（0）/ projectile_speed：170（0） / distance：68（+17）/127.5（+8.5）/ speed：-0.10（0）

	MG4TD_AP - blast：1.35*0.25（0）/ accuracy：0.95（0）/ spread_range：0.14（0）/  sight_range：1.35（+0.1）/ projectile_speed：190（0） / distance：N/A / speed：-0.1（0）
	prone accuracy：1.1（+0.1）
	MG4TD_KE - kill_pro：1.7（0）/ accuracy：0.94（0）/ spread_range：0.17（0）/  sight_range：1.2（+0.1）/ projectile_speed：160（0） / distance：64（+16）/120（+8）/ speed：-0.1（0）
	prone accuracy：1.05（+0.05）		over_wall accuracy：1.1（-0.1）

	//MG338性质特殊，不修改

	//QJY88不修改，但享受新精准加成

	//MK48不修改，但享受新精准加成

	//MG42不修改，但享受新精准加成

## 0.30f1
	整理v29版本武器及投掷物注册文件

## 0.30f2
	添加新武器及注册

## 0.30f3
	补全小帮手脚本及武器注册，添加新武器及难抽取的武器至测试箱。

## 0.30f5
	DEBUG，添加gk.model，修改部分武器以完成测试包，未添加抽奖代码。

## 0.30g
	二次平衡性及美术修改，添加抽奖脚本。
	将2期前提高了概率的部分物品概率调回，新物品概率UP↑。