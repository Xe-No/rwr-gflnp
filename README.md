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