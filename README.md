# 使用方法
下载后替换到packages /v test 召唤28测试版本箱子 读取太慢可以注释掉 gfl_w gfl_c gfl_v

# 0.35

## 0.35a
	1.上传CBP脚本及相关组件
	2.MG4A3初版上传

## 0.35b	
	1.完整版MG4A3上传
	2.0.34新增武器注册位置变更，updatelog归档
	3.IWS2000（CB2）平衡性改动：FSDS模式射击间隔2.1s -> 1.9s，弹容7 -> 8
								HE模式射击间隔1.5s -> 1.7s，视野2.5 -> 2.4
	4.G41BP2077榴弹模式视野1.45 -> 1.0

## 0.35c
	新武器增加：
	1.MG4A3TD	CB2	1.0f(与MG4TD共享出率) UR	轻机枪模板	mg4a3td/mg4a3td_sl		
	主模式：消音 视野1.2 3发最大扩散 最大扩散0.1 移速-0.1 致死1.6  架设精准提升至1.0（原0.95）
	副模式：不消音 视野1.2 3发最大扩散 最大扩散0.12 移速-0.05 致死1.7 走射精准提升至0.6（原0.4）

	2.天灾电磁炮	CB2 1.0f UR		连射AT（无模板）	ew_disaster_railgun	
	单模式：5发 -0.3移速 1.8射击间隔 长时间装填 3.99伤害 6.0范围 1.75视野 直射触爆

	3.HK416星之茧	CB1 0.2f UR		SMG模板+GL	gw_hk416_starry_cocoon/gw_hk416_starry_cocoon_gl		
	主模式：射速800 致死1.45 视野1.3 后座力0.3 回复2.8
	副模式：单发 4-5层0.7伤害的6范围榴弹 曲射触爆 有友伤 1.3视野

	4.M37夏日巡礼者	CB2 2.0f SSR	SG模板+加速模板	gw_m37_1706/gw_m37_1706_run			
	主模式：8发 6*2.4 消音霰弹 1.0视野 -0.03移速 22.5-90射程
	副模式：无法射击 +0.15移速 

	5.M27	CB1 0.5f SSR	AR+MG模板	m27_ar/m27_mg		
	主模式：31发 视野1.4 致死1.5 后座0.24 回复1.57 射速750
	副模式：60发 视野1.55 致死1.5 后座0.18 回复1.57 射速750 最大扩散0.2 仅能趴射+架射

	6.25A2	CB2 2.0f SSR	AR+MG模板	ew_25a2_k		
	单模式：98发 857射速 后座0.22 回复1.35 视野1.15 移速-0.1 有小盾块 致死1.7 全姿态

	7.SIG516	CB1 0.5f SSR		AR模板	ew_sig516/ew_sig516_300blk		
	主模式：射速700 致死1.45 视野1.1 后座力0.24 回复1.6 最大扩散0.16
	副模式：射速700 致死1.6 视野1.1 后座力0.5 回复1.6 最大扩散0.2

	8.M16 Astatoz	CB1 0.2f UR		AR模板	gw_m16_astatoz			
	单模式：50发 800射速 后座0.20 回复1.35 视野1.1 走射精准提升至0.75（原0.675） 

	9.mg94		彩票直售12000，helldivers系列	加特林模板的MG	 ew_hd_mg94		
	单模式：250发 1000射速 3发最大扩散 最大扩散0.18 BLAST伤害0.001 范围1.0 单次射击产生0-2发子弹

	10.P6神枪手重型左轮		彩票直售40000，helldivers系列	AP左轮	ew_p6_gunslinger		
	一把能打1-4层的左轮，1模式越射越准，2模式直接6连，换弹快，移速高，射程短（子弹消失时间），1模式需要3发才能精准，2模式最大扩散较大，只有在近距离才能发挥全部属性。

	11.P2 Peacemaker	彩票直售40000，helldivers系列	HG	ew_p2_peacemaker			
	一个模式，越打越准的负后座手枪，2.0致死，三连发，需要连续射击才能发挥战斗力。

	12.G36C心智升级		黑卡	AR-SMG模板		gw_g36c_mod		
	单模式：35发 750射速 后座0.28 回复2.0 视野1.0 致死1.55 移速+0.1

	13.洁芙缇	蓝，紫箱子	SR模板	gw_jefty_mn1891pu	
	单模式：5*0.4低伤害AP弹 5发 标准栓动

	14.G3A3兔女郎	黑卡	AR+MPC模板	gw_g3_spuhr/gw_g3_spuhr_sniper		
	主模式：20发 300射速 后座0.5 回复2.3 视野1.15 致死1.55 移速-0.06
	副模式：20发 120射速 后座0.6 回复1.8 视野1.55 致死2.7 移速-0.15

	抽奖脚本，CBP脚本及商店做出相应更改。

## 0.35d
	1.关于HELLDIVERS系列武器：
	DBS2：
		取消友伤
		弹丸增加至36，修改各姿态射击精度，架射时具有最低精度，专门应用于压制大规模敌方冲锋
		降低杀伤距离由32m->30m
		降低爆炸弹头伤害范围3.2->3.0
		降低push 1.0->0.2,勉强能推动车，但不容易打飞
		修改枪口位移，现在打墙不容易打死自己了
		增加经验限制：120w
		调低一点开火音量 1.0->0.8
		兑换券购买经验限制为：120w

	rx1:
		添加兑换券，价格3w，最低购买经验50w
		重置HUD贴图
		ap模式：
			改为半自动，设计间隔0.8s
			移速改为-0.07
			价格改为0
			弹速提高 250->300
			经验限制为: 50w
			降低push: 0.8->0.5
		charge模式：
			弹容改为	2->3
			优化弹道	
			调低push:	1.5->0.7
			移速改为-0.07
			价格改为0
			经验限制为：50w
		
	vindicator辩护者（脚本投掷物）：
		调低使用价格	450->200（几乎没人用，而打新图拆那些架设则挺好用的，鼓励用于突破）
		增加溅射范围	6.8->7.8
		增加溅射伤害	0.1->0.25	（拆架设应该够了）
		增加中心导弹杀伤范围	3->5
		降低溅射push	1.0-0.5
		调整携带量		max 9->15

	rumbler:
		添加兑换券，价格5w，最低购买经验100w
		修改弹道，现在下坠更快，精度更准
		增加使用经验限制：100w
		修改枪口位移
	rumbler消耗型：
		价格 200->150
		修复架射不能开火问题
		降低使用经验至100w，修改最大携带量解锁经验为200w

	2.AKALFA
		后座力下降至0.25/0.23
		致死下降至1.55/1.51
		视野提升至1.2
		移速上升至+0.05/0

	3.雅典娜炮
		重构弹道，改为从头顶50m处平抛0.8秒竖直落下，着弹时间约2.8秒，改良了着弹提示特效，提示时间改为2秒，改良了爆炸特效
		添加低功率二模式，消音，视野相对-0.7，固定+0.05被发现率（一模式由于不消音就没加），模式切换动画时长充分长
		稍稍减短了射击间隔，对射击cycle动画内容稍做了修改，时长不变，稍稍增大了爆炸范围以解决炸干扰塔对瞄准位置要求相当高的问题同时配合指示大致爆炸范围的特效

	4.反人员标枪
		视野1.0→1.35

	5.双手大剑+咸鱼剑
		抗致死+0.1

	6.ZERO
		抗致死+0.2

	7.白子
		后座力0.55→0.35

	8.SCT黏性炸弹
		声音减小
		弹速降低为50
		增加拖尾

	9.SVDM
		非消音致死+0.2→3.65

	10.9A91白卡
		修复消音模式复活不自带问题

	11.AEK971 CB2
		弹容增加至41

	12.M200SK
		修改无人机射击位置，射击高度+1.5→5.5，射击位置前移1.3

	13.GST纸箱
		移速减少至-0.55
		几乎无法近战杀人

	14.97式黑卡
		视野降低至1.2
		射速降低至666rpm
	
	15.95式黑卡
		视野提升至1.2
		射速降低至666rpm	
		非消音致死提升至1.52

	16.LTLX CB2
		消音伤害从8*2.0提高至8*2.1，初始衰减提升到0.2秒
		龙息弹增加5发弹丸至18弹丸

	17.G41BP2077跑步动作修改

	增加两个信物raiden_mei和takina，一个复活自带甲Asuna
	增加arb14
	抽奖脚本及CBP脚本与商店相应修改

## 0.35e
	1.M37声音降低，消音错误修改
	2.辩护者价格降低至150rp
	3.修改G41两个动作，跑步动作改回。
	4.添加两种地雷以供测试
	5.白教移除M72筒子，仅有精英单位可以反载具。
	6.416星之茧与M37夏日出处对调
	7.降低M27音量，更改模型调用
	8.洁芙缇修改为全姿态精准度1.0，防止霰射
	9.天灾电磁炮重量提升至30%
	10.AKALFA切换模式动作改为拆装消音（刺刀）
	11.消耗品雷鸣修复弹道
	12.mg94声音减小，天灾电磁炮声音加大

## 0.35f
	1.UD2地图替换（无需修改脚本）
	2.RED DAWN地图替换及应用
	3.明石信物修改
	4.洁芙缇枪口位置修改
	5.mg94音量修改，弹头数从0-2增加至0-3，因为0的概率过高
	6.M37枪口位置修改，双发装填动作延长0.1秒
	7.ARB14修改键值，特效,删除了原文件
	8.P-2致死增加至2.5
	9.RX1音效修改
	10.添加信物alicemana
	11.添加CB1 1.0f武器 HMT501

	此次改动删除的文件不删除会报错

## 0.35g
	1.添加CBP工作台，修复CBP脚本，指挥车内蓝图移动至工作台
	2.增加C8突击步枪，大后座，2发上天，霰弹很散，玩具性质的泰坦箱子武器
	3.0.34道具汉化实装

## 0.35h
	1.UD4地图难度修改，防守时间变为5分钟
	2.PKM PKP M249 M240 MK48的AI视野1.3变为1.1
	3.沉默小姐重做，一模式仿AA12F常规弹，二模式为高抛反人员
	4.lav6的榴弹伤害范围增加至5.1