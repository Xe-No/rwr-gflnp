#include "tracker.as"
#include "helpers.as"
#include "admin_manager.as"
#include "log.as"
#include "query_helpers.as"
#include "query_helpers2.as"
#include "gamemode.as"


dictionary AC_notify_key = {
	 // 空
	{"",0},

    {"ac_medic",1},
    {"ac_ahead_knife",1},

    {"",0}

};

//----------------------------------
class ac_exo : Tracker {
	protected Metagame@ m_metagame;

	// --------------------------------------------
	ac_exo(Metagame@ metagame) {
		@m_metagame = @metagame;
	}

	bool hasEnded() const {
		return false;
	}

	bool hasStarted() const {
		return true;
	}

    void update(float time){
    }

    protected void handleResultEvent(const XmlElement@ event) {
        string EventKeyGet = event.getStringAttribute("key");
        _log("projectile event key= " + EventKeyGet);
        if(AC_notify_key.exists(EventKeyGet)){
            handelMedicEvent(event);
            handelAttackEvent(event);
        } 
    }

    protected void handelMedicEvent(const XmlElement@ event) {
        string EventKeyGet = event.getStringAttribute("key");
        if(EventKeyGet == "ac_medic"){
            int characterId = event.getIntAttribute("character_id");
            if (characterId == -1) {
                _log("characterId = -1,null occur");
                return;
            }
            Vector3 t_pos = stringToVector3(event.getStringAttribute("position"));
            array<const XmlElement@>@ players = getPlayers(m_metagame);
            _log("players.size()= "+players.size());
            for (uint i = 0; i < players.size(); ++i) {
                const XmlElement@ player = players[i];
                if (player.hasAttribute("character_id")) {
                    int p_character_id = player.getIntAttribute("character_id");
                    if(p_character_id == characterId){continue;}//取消自奶
                    if(p_character_id == -1){continue;}
                    const XmlElement@ p_character = getCharacterInfo(m_metagame,p_character_id);
                    if (p_character !is null) {
                        Vector3 p_position = stringToVector3(p_character.getStringAttribute("position"));
                        t_pos = t_pos.add(Vector3(0,-1,0));
                        float distance = getFlatPositionDistance(p_position,t_pos);
                        if(distance <= 3){
                            healCharacter(m_metagame,p_character_id,20);//此处修改回复层数
                        }
                    }
                }
            }
            spawnStaticProjectile(m_metagame,"medic_grenade.projectile",t_pos,characterId,0);
        }
    }
    protected void handelAttackEvent(const XmlElement@ event) {
        string EventKeyGet = event.getStringAttribute("key");
        if(EventKeyGet == "ac_ahead_knife"){
            int cid = event.getIntAttribute("character_id");
           
            const XmlElement@ character = getCharacterInfo(m_metagame,cid);
            if(character is null){return;}
            int fid = 0;
            Vector3 ePos = stringToVector3(event.getStringAttribute("position"));
            Vector3 sPos = stringToVector3(character.getStringAttribute("position"));
            Vector3 aim_unit_vector = getAimUnitVector(1,sPos,ePos);
            ePos = ePos.add(aim_unit_vector.scale(45));

            string key = "ac_knife_damage.projectile";
            float speed = 1;
            float delaytime = 0;
            TaskSequencer@ tasker = m_metagame.getTaskManager().newTaskSequencer();
            CreateProjectile@ task1 = CreateProjectile(m_metagame,sPos,ePos,key,cid,fid,speed,0,10,delaytime);
            tasker.add(task1);
        }
    }

    protected float getFlatPositionDistance(const Vector3@ pos1, const Vector3@ pos2) {
        //_log("get_position_distance, pos1=" + $pos1[0] + ", " + $pos1[1] + ", " + $pos1[2] + ", pos2=" + $pos2[0] + ", " + $pos2[1] + ", " + $pos2[2]);
        Vector3 d = pos1.subtract(pos2);

        d.m_values[0] *= d.m_values[0];
        d.m_values[2] *= d.m_values[2];

        float result = sqrt(d.m_values[0] + d.m_values[2]);
        return result;
    }
    protected Vector3 getAimUnitVector(float scale, Vector3 s_pos, Vector3 e_pos) {
        float dx = e_pos.m_values[0]-s_pos.m_values[0];
        float dy = e_pos.m_values[2]-s_pos.m_values[2];
        float ds = sqrt(dx*dx+dy*dy);
        if(ds<=0.000005f) {ds=0.000005f;dx=0.000004f;dy=0.000003f;}
        return Vector3(dx*scale/ds,0,dy*scale/ds);
    }
    protected void healCharacter(Metagame@ metagame,int characterId,int healnum) {
        XmlElement c ("command");
        c.setStringAttribute("class", "update_inventory");
        c.setIntAttribute("character_id", characterId); 
        c.setIntAttribute("untransform_count", healnum);
        metagame.getComms().send(c);
    }
    protected void spawnStaticProjectile(Metagame@ metagame,string key,Vector3 pos,int characterId,int factionId)
    {
        string m_pos = pos.toString();

        XmlElement command("command");
        command.setStringAttribute("class", "create_instance");
        command.setIntAttribute("character_id", characterId);
        command.setIntAttribute("faction_id", factionId);

        command.setStringAttribute("instance_class", "grenade");
        command.setStringAttribute("instance_key", key);	
        command.setStringAttribute("position", m_pos);	
        command.setStringAttribute("offset", "0 0 0");	

        metagame.getComms().send(command);
    }
}

class CreateProjectile : Task{
	protected Metagame@ m_metagame;
	protected float m_time;
    protected int m_num;
    protected int m_num_left;
    protected Vector3 m_startPos;
    protected Vector3 m_endPos;
    protected string m_key;
    protected int m_cid;
    protected int m_fid;
    protected float m_speed;
	protected Vector3 aim_unit_vector;
	protected float m_distance;
	protected float m_delaytime;
	protected float m_delaytimer;
	protected bool m_ended;

	CreateProjectile(Metagame@ metagame,Vector3 sPos,Vector3 ePos,string key,int cid,int fid,float speed,float time,int num = 1,float delaytime = 0){
		@m_metagame = @metagame;
		m_time = time;
		m_num = num;
		m_num_left = num;
		m_startPos = sPos;
		m_endPos = ePos;
		m_key = key;
		m_cid = cid;
		m_fid = fid;
		m_speed = speed; 	
		m_delaytime = delaytime;
		m_delaytimer = delaytime;
		m_ended = false;
		aim_unit_vector = getAimUnitVector(1,sPos,ePos);
		m_distance = getAimUnitDistance(1,sPos,ePos);
	}

	void start(){
	}

	void update(float time){
		m_time -= time;
		m_delaytimer -= time;

		if(m_time < 0 ){ //delay ready
			if(m_delaytimer <= 0){ // internal delay ready
				m_delaytimer = m_delaytime;	//reset internal delay time
				if(m_num_left > 0){
					create();
				}else{
					m_ended = true;
				}
			}
		}
		
	}

	protected void create(){
		m_startPos = m_endPos.subtract(aim_unit_vector.scale((m_distance*(m_num_left))/m_num));
		CreateDirectProjectile(m_metagame,m_startPos.add(Vector3(0,1,0)),m_startPos,m_key,m_cid,m_fid,m_speed);
		m_num_left--;
	}

	bool hasEnded() const {
		return m_ended;
	}
    protected void CreateDirectProjectile(Metagame@ m_metagame,Vector3 startPos,Vector3 endPos,string key,int cId,int fId,float initspeed){
        initspeed=initspeed/60;
        Vector3 direction = endPos.subtract(startPos);
        float Vmod = sqrt(pow(direction.get_opIndex(0),2)  + pow(direction.get_opIndex(1),2) + pow(direction.get_opIndex(2),2));
        if (Vmod< 0.00001f) Vmod= 0.00001f;
        direction.set(direction.get_opIndex(0)/Vmod,direction.get_opIndex(1)/Vmod,direction.get_opIndex(2)/Vmod);
        direction = direction.scale(initspeed);
        string c = 
            "<command class='create_instance'" +
            " faction_id='" + fId + "'" +
            " instance_class='grenade'" +
            " instance_key='" + key + "'" +
            " position='" + startPos.toString() + "'" +
            " character_id='" + cId + "'" +
            " offset='" + direction.toString() + "' />";
        m_metagame.getComms().send(c);
    }
    protected Vector3 getAimUnitVector(float scale, Vector3 s_pos, Vector3 e_pos) {
        float dx = e_pos.m_values[0]-s_pos.m_values[0];
        float dy = e_pos.m_values[2]-s_pos.m_values[2];
        float ds = sqrt(dx*dx+dy*dy);
        if(ds<=0.000005f) {ds=0.000005f;dx=0.000004f;dy=0.000003f;}
        return Vector3(dx*scale/ds,0,dy*scale/ds);
    }
    protected float getAimUnitDistance(float scale, Vector3 s_pos, Vector3 e_pos) {
        float dx = e_pos.m_values[0]-s_pos.m_values[0];
        float dy = e_pos.m_values[2]-s_pos.m_values[2];
        float ds = sqrt(dx*dx+dy*dy);
        return scale*ds;
    }
}