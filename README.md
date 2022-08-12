# 使用方法
下载后替换到packages /v test 召唤28测试版本箱子 读取太慢可以注释掉 gfl_w gfl_c gfl_v

# 0.36

## 0.36a
	1.取消各阵营的F16支援，注释掉F16的支援项目，注册及脚本应用
	2.CBP武器转化需要手雷栏材料而不是直接扣除RP了
	3.MG4的转换器除了充当转换作用，还充当了信物及指示型A10支援烟的作用
	4.MG4A3TD的换弹时间减少至3.25秒，原为3.8秒
	5.沉默小姐的榴弹增加至2发，此改动在0.35.5推送
	6.修改了AR14B与M27不消音的问题，此改动在0.35.5推送
	7.A10支援价格提升至360rp，增加4枚12范围20伤害的航弹，扫射X轴扩大至4.0f，30mm溅射增加至5.0范围，30mm机炮数量减少至60发，现在A10出圈机炮数很少。
	
## 0.36b
	1.调整A10音效触发时间
	2.调整0.34 0.35部分道具注册位置
	3.修复美军架设问题（主要架设物修复）
	4.美军阵营新增两个精英单位，出率0.08，为UPA部队的雇佣兵：
		UPA_PMC:精英步枪手，使用.50 BEOWULF作为主武器，副手携带M202，投掷物为呼叫AH64的红色空袭烟，护甲为IOTV甲，仅能呼叫AH64支援，不能呼叫伞兵（雇佣兵性质）
		UPA_TERRORIST:精英榴弹兵，使用XM25作为主武器，副手携带UPA科技的小型木星炮发射器，投掷物为九连闪，护甲为6B45，仅能呼叫A10，不能呼叫伞兵（雇佣兵性质）
		关于新道具简要说明：
		(1).50 BEOWULF 弹容12 1.5致死 1.0击穿后效 1.1视野 后座大 射速750 黑卡强度的敌方武器
		(2)IOTV护甲	6层 抗致死1.0，每层递减0.1 移速固定-0.1 隐蔽-0.1 夜间隐蔽-0.1
		(3)UPA科技小型木星发射器	消耗品，最大携带2，能够发射10范围10伤害的小型木星炮，目前仅有UPA单位装备，该道具在死亡之后会产生爆炸，爆炸产生6范围10伤害，爆炸后道具会存在15秒，拾取后能正常使用
	5.AC130空袭烟增加红色烟雾

## 0.36c
	1.小幅度修改投掷指向型A10音效
	2.修改EX难度下REDDAWN2的地图脚本敌人数量
	3.修改CB1 CB2抽奖机制：
		添加SR SSR UR抽奖卡，CB1 CB2不再直接出现武器，而是抽奖卡，再由抽奖卡抽出武器
		统合CB1 CB2抽出各品级的几率：	CB1 6%UR 18%SSR 36%SR 40%杂物，另一个池子4%CB2		
										CB2 45%UR  50%SSR 5%护甲
		SR抽奖卡必出一把SR，另一池子5%几率出现1枚CBP
		SSR抽奖卡必出一把SSR，另一池子5%几率出现1枚CBP，2%几率出现2枚CBP
		UR抽奖卡必出一把UR，另一池子5%几率出现1枚CBP，2%几率出现2枚CBP，1%几率出现5枚CBP
		武器不再区分是CB1的UR还是CB2的UR
	4.0.34UP到期

## 0.36d
	1.注释掉格里芬阵营改造人关于F16的调用
	2.黑涅托护甲更换为白高达甲
	3.铁血阵营巡游者变为普通单位，新增单位捷豹及其对应动作
	4.铁血阵营新增SP65稻草人 SP721猎手
		稻草人为浮游冲锋枪，1.7致死，0.2移速，1500射速，能够召唤自己的1-3个假身（手雷），假身武器致死为0，假身的经验值低于真身，假身死亡后会自爆，8范围3.3伤害
		猎手为双持手枪，2.0致死，0.2移速，1000射速
		以上两个BOSS均为白高达甲

## 0.36e
	1.增加白教白高达，黑涅托死亡后的武器转化，白高达武器在死亡后会掉落成1-5张彩票，黑涅托则为1-3张，作为精锐单位的击杀额外奖励
	2.增加铁血两位BOSS的击杀额外掉落（由武器转化而成），BOSS击杀后武器会变为1-2张彩票，作为精锐单位的击杀额外奖励
	3.铁血BOSS猎手新增手雷技能，用攻击动作发射一枚类QLU弹道的闪光子弹，造成10范围的眩晕效果，并对载具产生2.0的伤害，可使用10次，使用间隔10-20秒（AI决定）
	4.HVY3的装甲板重量降低至2%，动作加快18%
	5.ERC的ECM存在时间延长至60秒
	6.SCT3的副手榴弹修改弹道为低高度快速曲射弹道，伤害从5*1.0降低至2-5*1.0
	7.MED新增主手武器MP9，MP9侧面加装了一个可以发射小型修复榴弹的发射筒，可以发射具备2层修复力的医疗榴弹，但是由于装药不足，榴弹落地后会需要一定时间才能产生效果
		MP9属性：25发 900射速 1.21致死 0.5后效 1.0视野 +0.05移速 后座力与SCT3副手MP7A2相同 消音
		MP9榴弹属性： 修复2层 与小帮手同弹道 2.5秒的延迟榴弹
	8.GST3的MP5SD致死增加至1.25 后效变为0.5