#include "tracker.as"
#include "helpers.as"
#include "admin_manager.as"
#include "log.as"
#include "query_helpers.as"
#include "query_helpers2.as"

class GFLEquipmentEvent : Tracker {
	protected Metagame@ m_metagame;
    GFLEquipmentEvent(Metagame@ metagame) {
		@m_metagame = @metagame;
	}
	protected void handleItemDropEvent(const XmlElement@ event) 
	{
		
// 0 Drop
// 1 Sell



		dictionary dict = {
				{"ags30.weapon","ur"},
				{"ags30_n.weapon","ur"},
				{"zero_ninjato.weapon","ur"},
				{"tac50hs_35.weapon","ur"},
				{"tac50hs_12.7.weapon","ur"},
				{"aek971_camo.weapon","ur"},
				{"aek971_camo_sl.weapon","ur"},
				{"mg4td_ap.weapon","ur"},
				{"mg4td_ke.weapon","ur"},
				{"m200sk.weapon","ur"},
				{"m200sk_drone.weapon","ur"},
				{"gw_g41_bp2077.weapon","ur"},
				{"gw_g41_bp2077_gl.weapon","ur"},
				{"vex.weapon","ur"},
				{"vex_positron.weapon","ur"},
				{"ew_baiz.weapon","ur"},
				{"ew_baiz_r.weapon","ur"},
				{"ew_m16a5.weapon","ur"},
				{"ew_m16a5_gl.weapon","ur"},
				{"ew_m16a5.308.weapon","ur"},
				{"bronia_hg.weapon","ur"},
				{"bronia_gl.weapon","ur"},
				{"gw_iws2000_banisher_he.weapon","ur"},
				{"gw_iws2000_banisher_fsds.weapon","ur"},
				{"ace_of_spades.weapon","ur"},
				{"ew_rpl20.weapon","ur"},
				{"ew_heir_apparent.weapon","ur"},
				{"kf2_seekersix_ap.weapon","ur"},
				{"kf2_seekersix_he.weapon","ur"},
				{"gw_g41_lasercanno_diffusion.weapon","ur"},
				{"gw_g41_lasercanno_at.weapon","ur"},
				{"emmmm_f.weapon","ur"},
				{"emmmm_t.weapon","ur"},
				{"ew_fiammetta_m.weapon","ur"},
				{"ew_fiammetta_s.weapon","ur"},
				{"ew_mcxtang.weapon","ur"},
				{"ew_mcxtang_sg.weapon","ur"},
				{"ew_shoki.weapon","ur"},
				{"gw_ltlx7000_6702.weapon","ur"},
				{"gw_ltlx7000_6702_d.weapon","ur"},
				{"gw_ak308.weapon","ssr"},
				{"williams.22.weapon","ssr"},
				{"ew_n_mp5k.weapon","ssr"},
				{"gw_scarc.weapon","ssr"},
				{"gw_scarc_300.weapon","ssr"},
				{"m200sm.weapon","ssr"},
				{"gw_svdm.weapon","ssr"},
				{"gw_svdm_sl.weapon","ssr"},
				{"gw_mk22.weapon","ssr"},
				{"gw_mk22_50.weapon","ssr"},
				{"gw_vector.weapon","ssr"},
				{"gw_vector_b.weapon","ssr"},
				{"portable_mortar.weapon","ssr"},
				{"javelin_ap.weapon","ssr"},
				{"gw_qlu11.weapon","ssr"},
				{"javelin_ap.weapon","ssr"},
				{"akalfa_defy.weapon","ssr"},
				{"akalfa_defy_sl.weapon","ssr"},
				{"ew_microgun_univ.weapon","ssr"},
				{"pf98.weapon","sr"},
				{"gw_mk153.weapon","sr"},
				{"gw_an94_mod4_s.weapon","sr"},
				{"gw_an94_mod4.weapon","sr"},
				{"ew_dragunov_ince.weapon","sr"},
				{"ew_dragunov_ince_pnt.weapon","sr"},
				{"aa12_frag.weapon","sr"},
				{"aa12_frag_b.weapon","sr"},
				{"ew_athena.weapon","sr"},
				{"ew_athena_s.weapon","sr"},
				{"baw_miyu.weapon","ssr"},
				{"baw_miyu_bin.weapon","ssr"},
				{"chain_sawr.weapon","ssr"},
				{"ew_amamiya_kokoro.weapon","ur"},
				{"xm177e1.weapon","ur"},
				{"xm177e2.weapon","ur"},
				{"tkb059.weapon","ur"},
				{"gw_kaluo.weapon","ur"},
				{"gw_kaluo_gl.weapon","ur"},
				{"ew_caa.weapon","ssr"},
				{"gw_six12sd_slug.weapon","ssr"},
				{"gw_six12sd.weapon","ssr"},
				{"gw_kn57.weapon","sr"},
				{"gw_aa12_2403_he.weapon","sr"},
				{"gw_aa12_2403_s.weapon","sr"},
				{"ew_amb17.weapon","ur"},
				{"gw_hk416_starry_cocoon.weapon","ur"},
				{"gw_hk416_starry_cocoon_gl.weapon","ur"},
				{"mg4a3td.weapon","ur"},
				{"mg4a3td_sl.weapon","ur"},
				{"ew_disaster_railgun.weapon","ur"},
				{"gw_m16_astatoz.weapon","ur"},
				{"ar_14b_1.weapon","ur"},
				{"ar_14b_2.weapon","ur"},
				{"m27_ar.weapon","ssr"},
				{"m27_mg.weapon","ssr"},
				{"ew_25a2_k.weapon","ssr"},
				{"ew_sig516.weapon","ssr"},
				{"ew_sig516_300blk.weapon","ssr"},
				{"ew_hmtech501.weapon","sr"},
				{"ew_hmtech501_hesh.weapon","sr"},
				{"gw_m37_1706.weapon","ssr"},
				{"gw_m37_1706_run.weapon","ssr"}
		};
		dictionary dict2 = {
				{"mg4td_ap.weapon","mg4a3td.weapon"},
				{"mg4td_ke.weapon","mg4a3td_sl.weapon"},
				{"mg4a3td.weapon","mg4td_ap.weapon"},
				{"mg4a3td_sl.weapon","mg4td_ke.weapon"}
		};
		dictionary dict3 = {
				{"gw_ar15mod_sl.weapon","gw_ar15mod_sl_oath.weapon"},
				{"gw_ar15mod.weapon","gw_ar15mod_oath.weapon"},
				{"gw_m4_sopmod_iimod.weapon","gw_m4_sopmod_iimod_oath.weapon"},
				{"gw_m4_sopmod_iimod_gl.weapon","gw_m4_sopmod_iimod_gl_oath.weapon"},
				{"gw_m4a1mod3.weapon","gw_m4a1mod3_oath.weapon"},
				{"gw_supersass_mod.weapon","gw_supersass_mod_oath.weapon"},
				{"gw_supersass_mod_2.weapon","gw_supersass_mod_2_oath.weapon"},
				{"gw_vector_agent.weapon","gw_vector_agent_oath.weapon"},
				{"ro635_mod.weapon","ro635_mod_oath.weapon"},
				{"ro635_mod_am.weapon","ro635_mod_am_oath.weapon"},
				{"gw_mg4_mod.weapon","gw_mg4_mod_oath.weapon"},
				{"gw_mg4_mod_n.weapon","gw_mg4_mod_n_oath.weapon"},
				{"sat8_1802.weapon","sat8_1802_oath.weapon"},
				{"sv98_mod.weapon","sv98_mod_oath.weapon"},
				{"sv98_mod_ap.weapon","sv98_mod_ap_oath.weapon"},
				{"gw_ntw20mod3.weapon","gw_ntw20mod3_oath.weapon"},
				{"gw_ntw20mod3_he.weapon","gw_ntw20mod3_he_oath.weapon"}
		};



		//��ȡ�¼���Ʒ��ֵ
		string key = event.getStringAttribute("item_key");	
		int copyfail = -7000;
		int oathfail = -1500;
		int exchangeRP = -100;
		if(dict.exists(key)){
			string value = string(dict[key]);

			//UR�������
			//ȷ���Ƿ���UR��Ʒ������

			if(value == "ur" && event.getIntAttribute("target_container_type_id") == 1){

				//��ȡ�¼����ID
				int characterId = event.getIntAttribute("character_id");
				//��ȡ������ͼ�Ƿ�װ��ʲô����
				string key2 = getFunctionKey(m_metagame, characterId);
			
				//�ֽ�
				if(key2 == "blueprint_decomposition.weapon"){
				
					//����CB��Ƭ
					receiveCBpart(m_metagame, characterId, 10);

				}

				//�ϳ�

				else if(key2 == "blueprint_copy.weapon"){

					int k  = 50;
					int k1 = 0;
					const XmlElement@ characterInfo = getCharacterInfo(m_metagame, characterId);

				//�����Ҳ�Ϊ��ֵ��ִ�����
					if(characterInfo !is null){

						//��ȡ�����������Ʒ��ֵ�����ΪCB��Ƭ����ȡ��Ƭ��������k1.
						string key3 = getPartKey(m_metagame, characterId);
						if(key3 == "cb_part.projectile"){
							k1 = getpartAmount(m_metagame, characterId);
						}

						//�����Ƭ����������Ҫ������ɾ����Ҫ��������Ƭ�����CB����
						if(k1 >= k){
							receiveCB(m_metagame, characterId, "weapon", key);
							deletepart(m_metagame, characterId, k, "projectile", "cb_part.projectile");
							receiveCB(m_metagame, characterId, "weapon", key);
						}else{
							//�ϳ�ʧ�ܷ����������۳�����RP����ֹ��������������ˢǮ
							receiveCB(m_metagame, characterId, "weapon", key);
							string command = "";
							command = "<command class='rp_reward' character_id='" + characterId + "' reward='" + copyfail + "' />";
							m_metagame.getComms().send(command);
							sendPrivateMessageKey(m_metagame, characterId, "CBpart not enough");
						}		
					}


				}

			}
			//SSR�������
			//ȷ���Ƿ���SSR��Ʒ������
			if(value == "ssr" && event.getIntAttribute("target_container_type_id") == 1){

				//��ȡ�¼����ID
				int characterId = event.getIntAttribute("character_id");
				//��ȡ������ͼ�Ƿ�װ��ʲô����
				string key2 = getFunctionKey(m_metagame, characterId);
			
				//�ֽ�
				if(key2 == "blueprint_decomposition.weapon"){
				
					//����CB��Ƭ
					receiveCBpart(m_metagame, characterId, 5);

				}

				//�ϳ�

				else if(key2 == "blueprint_copy.weapon"){

					int k  = 25;
					int k1 = 0;
					const XmlElement@ characterInfo = getCharacterInfo(m_metagame, characterId);

				//�����Ҳ�Ϊ��ֵ��ִ�����
					if(characterInfo !is null){

						//��ȡ�����������Ʒ��ֵ�����ΪCB��Ƭ����ȡ��Ƭ��������k1.
						string key3 = getPartKey(m_metagame, characterId);
						if(key3 == "cb_part.projectile"){
							k1 = getpartAmount(m_metagame, characterId);
						}

						//�����Ƭ����������Ҫ������ɾ����Ҫ��������Ƭ�����CB����
						if(k1 >= k){
							receiveCB(m_metagame, characterId, "weapon", key);
							deletepart(m_metagame, characterId, k, "projectile", "cb_part.projectile");
							receiveCB(m_metagame, characterId, "weapon", key);
						}else{
							//�ϳ�ʧ�ܷ����������۳�����RP����ֹ��������������ˢǮ
							receiveCB(m_metagame, characterId, "weapon", key);
							string command = "";
							command = "<command class='rp_reward' character_id='" + characterId + "' reward='" + copyfail + "' />";
							m_metagame.getComms().send(command);
							sendPrivateMessageKey(m_metagame, characterId, "CBpart not enough");
						}		
					}


				}

			}
			//SR�������
			//ȷ���Ƿ���SR��Ʒ������
			if(value == "sr" && event.getIntAttribute("target_container_type_id") == 1){

				//��ȡ�¼����ID
				int characterId = event.getIntAttribute("character_id");
				//��ȡ������ͼ�Ƿ�װ��ʲô����
				string key2 = getFunctionKey(m_metagame, characterId);
			
				//�ֽ�
				if(key2 == "blueprint_decomposition.weapon"){
				
					//����CB��Ƭ
					receiveCBpart(m_metagame, characterId, 1);

				}

				//�ϳ�

				else if(key2 == "blueprint_copy.weapon"){

					int k  = 5;
					int k1 = 0;
					const XmlElement@ characterInfo = getCharacterInfo(m_metagame, characterId);

				//�����Ҳ�Ϊ��ֵ��ִ�����
					if(characterInfo !is null){

						//��ȡ�����������Ʒ��ֵ�����ΪCB��Ƭ����ȡ��Ƭ��������k1.
						string key3 = getPartKey(m_metagame, characterId);
						if(key3 == "cb_part.projectile"){
							k1 = getpartAmount(m_metagame, characterId);
						}

						//�����Ƭ����������Ҫ������ɾ����Ҫ��������Ƭ�����CB����
						if(k1 >= k){
							receiveCB(m_metagame, characterId, "weapon", key);
							deletepart(m_metagame, characterId, k, "projectile", "cb_part.projectile");
							receiveCB(m_metagame, characterId, "weapon", key);
						}else{
							//�ϳ�ʧ�ܷ����������۳�����RP����ֹ��������������ˢǮ
							receiveCB(m_metagame, characterId, "weapon", key);
							string command = "";
							command = "<command class='rp_reward' character_id='" + characterId + "' reward='" + copyfail + "' />";
							m_metagame.getComms().send(command);
							sendPrivateMessageKey(m_metagame, characterId, "CBpart not enough");
						}		
					}
				}	
			}
		}
		//CBǹеͬ��ת�����ܣ�������MG4TD��MG4A3TD����ת��
		if(dict2.exists(key) && event.getIntAttribute("target_container_type_id") == 1){
			string v2 = string(dict2[key]);
			int characterId = event.getIntAttribute("character_id");
			string key2 = getFunctionKey(m_metagame, characterId);

			if(key2 == "blueprint_exchange.weapon"){
					string command = "";
					command = "<command class='rp_reward' character_id='" + characterId + "' reward='" + exchangeRP + "' />";
					m_metagame.getComms().send(command);
					receiveCB(m_metagame, characterId, "weapon", v2);
				
			}
		}
		//������ӡ����ΪREǹ��
		if(dict3.exists(key) && event.getIntAttribute("target_container_type_id") == 1){

			//��ѯ��ӦOATHģʽ��RE�ļ�ֵ
			string v3 = string(dict3[key]);
			//��ȡ�¼����ID
			int characterId = event.getIntAttribute("character_id");
			//��ȡ������ͼ�Ƿ�װ��ʲô����
			string key2 = getFunctionKey(m_metagame, characterId);

			//��ӡ
			if(key2 == "blueprint_oath.weapon"){
				int k  = 1;
				int k1 = 0;
				const XmlElement@ characterInfo = getCharacterInfo(m_metagame, characterId);

				//�����Ҳ�Ϊ��ֵ��ִ�����
				if(characterInfo !is null){

					//��ȡ�����������Ʒ��ֵ�����Ϊ��ӡ���ģ���ȡ������������k1.
					string key3 = getPartKey(m_metagame, characterId);
					if(key3 == "oath_core.projectile"){
						k1 = getpartAmount(m_metagame, characterId);
					}

					//�����Ƭ����������Ҫ������ɾ����Ҫ�����ĺ��ģ����oath����
					if(k1 >= k){

						deletepart(m_metagame, characterId, k, "projectile", "oath_core.projectile");
						receiveCB(m_metagame, characterId, "weapon", v3);
						receiveCB(m_metagame, characterId, "weapon", v3);
						receiveCB(m_metagame, characterId, "weapon", v3);
					}else{
						//�ϳ�ʧ�ܷ����������۳�����RP����ֹ��������������ˢǮ
						receiveCB(m_metagame, characterId, "weapon", key);
						string command = "";
						command = "<command class='rp_reward' character_id='" + characterId + "' reward='" + oathfail + "' />";
						m_metagame.getComms().send(command);
						sendPrivateMessageKey(m_metagame, characterId, "CBpart not enough");
						sendPrivateMessageKey(m_metagame, characterId, "oath_core not enough");
					}		
				}
			}

		}
		//��ӡ���ĺϳ�
		if(key == "blueprint_oath_core.weapon" && event.getIntAttribute("target_container_type_id") == 1){
			//��ȡ�¼����ID
			int characterId = event.getIntAttribute("character_id");
			int k  = 10;
			int k1 = 0;
			const XmlElement@ characterInfo = getCharacterInfo(m_metagame, characterId);
			if(characterInfo !is null){
				string key3 = getPartKey(m_metagame, characterId);
				if(key3 == "cb_part.projectile"){
					k1 = getpartAmount(m_metagame, characterId);
					if(k1 >= k){
						deletepart(m_metagame, characterId, k, "projectile", "cb_part.projectile");
						receiveCB(m_metagame, characterId, "projectile", "oath_core.projectile");

					}else{
						receiveCB(m_metagame, characterId, "weapon", key);
						sendPrivateMessageKey(m_metagame, characterId, "CBpart not enough");
					}
				}
			}

		}
            
     }
		
    

	// --------------------------------------------
    	bool hasEnded() const {
		// always on
		return false;
	}

	// --------------------------------------------
	bool hasStarted() const {
		// always on
		return true;
	}
	
	//�ֽ���CB��Ƭ,�������ID����Ƭ������
	void receiveCBpart(Metagame@ metagame, int characterId, int num) {
		for(int i = 0;i < num;++i){

			XmlElement c3 ("command");
			c3.setStringAttribute("class", "update_inventory");
			c3.setStringAttribute("container_type_class", "backpack");
			c3.setIntAttribute("character_id", characterId); 
			XmlElement c3c("item");
			c3c.setStringAttribute("class", "projectile");
			c3c.setStringAttribute("key", "cb_part.projectile");
			c3.appendChild(c3c);
			m_metagame.getComms().send(c3);
		}
	}

	//�ϳɻ��CB�������װ������������������ID���������ͣ�Ĭ��Ϊweapon����������ֵ���ɡ�ͼֽ��Ӧ�����ɣ�
	void receiveCB(Metagame@ metagame, int characterId, string itemClass, string key) {
		XmlElement c1 ("command");
		c1.setStringAttribute("class", "update_inventory");
		c1.setStringAttribute("container_type_class", "backpack");
		c1.setIntAttribute("character_id", characterId); 
		{
			XmlElement c1c("item");
			c1c.setStringAttribute("class", itemClass);
			c1c.setStringAttribute("key", key);
			c1.appendChild(c1c);
		}
		m_metagame.getComms().send(c1);
	}

	//����CB��Ƭ�����
	void deletepart(Metagame@ metagame, int characterId, int parts, string itemClass, string key){
		for(int i = 0;i < parts ; ++i){
			XmlElement c2 ("command");
			c2.setStringAttribute("class", "update_inventory");
			c2.setIntAttribute("container_type_id",4);
			c2.setIntAttribute("character_id", characterId); 
			c2.setIntAttribute("add",0);
			XmlElement c2c("item");
			c2c.setStringAttribute("class", itemClass);
			c2c.setStringAttribute("key", key);
			c2.appendChild(c2c);
			m_metagame.getComms().send(c2);
		}
		
	}

	//��ȡCB��Ƭ���������
	int getpartAmount(Metagame@ metagame, int characterId){
			const XmlElement@ characterInfo2 = getCharacterInfo2(metagame, characterId);
			if (characterInfo2 is null){
				return -1;
			}
			array<const XmlElement@>@ equipment = characterInfo2.getElementsByTagName("item");
			if (equipment.size() == 0){
				return -1;
			}
			string itemKey = equipment[2].getStringAttribute("key");
			int amount = -1;
			amount = equipment[2].getIntAttribute("amount") ;
			return amount;

	}



	//��ȡ�������Ƭ��ֵ
	string getPartKey(Metagame@ metagame, int characterId){
		const XmlElement@ characterInfo2 = getCharacterInfo2(metagame,characterId);
		if (characterInfo2 is null){
				return "";
			}
		array<const XmlElement@>@ equipment = characterInfo2.getElementsByTagName("item");
		if (equipment.size() == 0){
				return "";
			}
		string itemKey = equipment[2].getStringAttribute("key");
		return itemKey;
	}

	//��ȡ����ִ����ͼ��ֵ
	string getFunctionKey(Metagame@ metagame, int characterId){
		const XmlElement@ characterInfo2 = getCharacterInfo2(metagame,characterId);
		if (characterInfo2 is null){
				return "";
			}
		array<const XmlElement@>@ equipment = characterInfo2.getElementsByTagName("item");
		if (equipment.size() == 0){
				return "";
			}
		string itemKey = equipment[1].getStringAttribute("key");
		return itemKey;
	}






}

