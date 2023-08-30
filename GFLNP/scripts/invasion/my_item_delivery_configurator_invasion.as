// generic trackers
#include "item_delivery_objective.as"
#include "item_delivery_organizer.as"
#include "gift_item_delivery_rewarder.as"
#include "loot_reward.as"
#include "reward_setting.as"

// ------------------------------------------------------------------------------------------------
class MyItemDeliveryConfiguratorInvasion : ItemDeliveryConfigurator {
	protected GameModeInvasion@ m_metagame;
	protected ItemDeliveryOrganizer@ m_itemDeliveryOrganizer;

	// ------------------------------------------------------------------------------------------------
	MyItemDeliveryConfiguratorInvasion(GameModeInvasion@ metagame) {
		@m_metagame = @metagame;
	}

	// --------------------------------------------
	void setup(ItemDeliveryOrganizer@ organizer) {
		@m_itemDeliveryOrganizer = @organizer;

		setupBriefcaseUnlocks();
		setupLaptopUnlocks();
		setupEnemyWeaponUnlocks();
		
		setupGift1();
		setupGift2();
		setupGift3();
		setupCommunity1();    
		setupCommunity2(); 
		setupSRcard(); 
		setupSSRcard(); 
		setupURcard(); 
		setupCommunity3(); 
        setupCommunity4();                
        setupHalloween1();                
		setupIcecream();      
		setupXmasBox();          
		setupNewyearBox();          
		setupPlayBox();      
		setupVB1();    
		setupLoot1();    
		setupLoot2();    
		setupLoot3();    
		

		
		setupContract1();
		setupContract1_1();
		setupContract1_2();
		setupContract1_3();
		setupContract2();
		setupContract3();
		setupContract3_1();
		setupContract3_2();
		setupTokenBox();
	}

	// --------------------------------------------
	void refresh() {
		// called each time an item unlock is removed
		refreshEnemyWeaponDeliveryObjectives();
	}

	// ----------------------------------------------------
	protected void setupLaptopUnlocks() {
		_log("adding laptop unlocks", 1);
		array<Resource@> deliveryList;
		{
			 deliveryList.insertLast(Resource("laptop.carry_item", "carry_item"));
		}

		dictionary unlockList;
		{
			string target = "laptop.carry_item";
			array<Resource@>@ list = getUnlockWeaponList2();
			unlockList.set(target, @list);
		}
		ResourceUnlocker@ unlocker = ResourceUnlocker(m_metagame, 0, unlockList, m_metagame);

		string instructions = "item objective instruction";
		string mapText = "item objective map text";
		string thanks = "item objective thanks";
		string thanksIncomplete = "";

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, unlocker, instructions, mapText, thanks, thanksIncomplete, -1 /* loop */)
			);
	}
	
	// ----------------------------------------------------
	protected void setupBriefcaseUnlocks() {
		_log("adding briefcase unlocks", 1);
		array<Resource@> deliveryList;
		{
			 deliveryList.insertLast(Resource("suitcase.carry_item", "carry_item"));
		}

		dictionary unlockList;
		{
			string target = "suitcase.carry_item";
			array<Resource@>@ list = getUnlockWeaponList();
			unlockList.set(target, @list);
		}
		ResourceUnlocker@ unlocker = ResourceUnlocker(m_metagame, 0, unlockList, m_metagame);

		string instructions = "item objective instruction";
		string mapText = "item objective map text";
		string thanks = "item objective thanks";
		string thanksIncomplete = "";

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, unlocker, instructions, mapText, thanks, thanksIncomplete, -1 /* loop */)
			);
	}

	// --------------------------------------------
	protected void processRewardPasses(array<array<ScoredResource@>>@ passes) {
		// campaign can use this to cleanup unavailable experimental resources in passes 
	}

	// --------------------------------------------
	protected void setupVB1() {
		_log("adding vehicle box config", 1);
		array<Resource@> deliveryList = {
			 Resource("vb1.carry_item", "carry_item")
		};
		processRewardPasses(reward_vb1);
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, reward_vb1);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}


	// --------------------------------------------
	protected void setupPlayBox() {
		_log("adding play box config", 1);
		array<Resource@> deliveryList = {
			 Resource("play_box.carry_item", "carry_item")
		};


		
		processRewardPasses(reward_pb);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, reward_pb);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	protected void setupNewyearBox() {
		_log("adding newyear box config", 1);
		array<Resource@> deliveryList = {
			 Resource("newyear_box.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
				ScoredResource("gw_qlt89_mortar.weapon" , "weapon", 1.0f),
				ScoredResource("gw_js09.weapon", "weapon", 1.0f),
				ScoredResource("gw_js09_4204.weapon", "weapon", 1.0f),
				ScoredResource("gw_cslr4.weapon" , "weapon", 1.0f),
				ScoredResource("gw_qbz191.weapon" , "weapon", 1.0f),
				ScoredResource("gw_qbz191_hibiki.weapon" , "weapon", 1.0f)
			},
			{
				ScoredResource("pf89.weapon" , "weapon", 1.0f, 10),
				ScoredResource("gw_qts11.weapon" , "weapon", 1.0f),
				ScoredResource("gw_lvoac.weapon" , "weapon", 1.0f),
				ScoredResource("gw_iws2000_he.weapon" , "weapon", 1.0f),
				ScoredResource("gw_lewis_5501.weapon" , "weapon", 1.0f)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}


	// --------------------------------------------
	protected void setupTokenBox() {
		_log("adding token box config", 1);
		array<Resource@> deliveryList = {
			 Resource("token_box.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
				ScoredResource("gem.carry_item", "carry_item", 1.0f), 
				ScoredResource("gold_bar.carry_item", "carry_item", 1.0f)
			},
			{	
				// 0.40
				ScoredResource("token_acg_graf_spee.projectile", "projectile", 2.0f, 2),
				ScoredResource("token_acg_gawr_gura.projectile", "projectile", 2.0f, 2),
				ScoredResource("token_keqing.projectile", "projectile", 2.0f, 2),
				ScoredResource("token_kiriko.projectile", "projectile", 2.0f, 2),
				ScoredResource("token_yuuki_ggo.projectile", "projectile", 2.0f, 2),


				// 0.39
				ScoredResource("token_ononoki.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_misaka_10032.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_misaka_mikoto.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_rem.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_tachibana_kanade.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_yukikaze.projectile", "projectile", 1.0f, 2),


				ScoredResource("token_inori.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_luna2.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_naoto.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_hakuryu.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_252.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_benben_bw.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_blackrock.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_suzakuin_tsubaki.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_suzakuin_tsubaki_swim.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_katou_megumi.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_poi.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_orga.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_qswan1.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_86leina.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_chara_neko.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_remilia.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_elaina.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_shigure_summer.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_yuudachi.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_rumia.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_flandre.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_nazrin.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_luka_china.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_miku_china.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_luotianyi_china.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_koishi.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_rin.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_mingshi_arb.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_g41_maid.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_akemi_homura.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_rst.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_medic.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_pa15_3701.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_grey_cat.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_kurumi_wedding.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_douzi.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_raiden_mei.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_takina.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_alicemana.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_iruru_fire.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_shokuhou_misaki.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_neko_zero.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_api.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_angelia.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_tirpitz.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_reisenu_card.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_skyfire.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_sinon.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_rose.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_kana.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_sangonomiya_kokomi.projectile", "projectile", 1.0f, 2),
				ScoredResource("token_bronya_white.projectile", "projectile", 1.0f, 2)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// --------------------------------------------
	protected void setupGift1() {
		_log("adding gift1 config", 1);
		array<Resource@> deliveryList = {
			 Resource("gift_box_1.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("dollars.carry_item", "carry_item", 1.0f),
		ScoredResource("dollars_300.carry_item", "carry_item", 1.0f),
		ScoredResource("cigarettes.carry_item", "carry_item", 1.0f),
		ScoredResource("gem.carry_item", "carry_item", 1.0f),
		ScoredResource("gold_bar.carry_item", "carry_item", 1.0f),
		ScoredResource("fal_leina.weapon", "weapon", 1.0f),	
		ScoredResource("gw_type64.weapon", "weapon", 1.0f),	
		ScoredResource("gw_g41r.weapon", "weapon", 2.0f),	
		ScoredResource("gw_mk12.weapon", "weapon", 2.0f),	
		ScoredResource("gw_jefty_mn1891pu.weapon", "weapon", 1.0f),	
		ScoredResource("gw_supershorty.weapon", "weapon", 1.0f)      
			},
			{
		ScoredResource("playing_cards.carry_item", "carry_item", 1.0f),
		ScoredResource("underpants.carry_item", "carry_item", 1.0f),
		ScoredResource("camo_vest.carry_item", "carry_item", 1.0f),
		ScoredResource("vest3.carry_item", "carry_item", 1.0f),
		ScoredResource("laptop.carry_item", "carry_item", 1.0f),
		ScoredResource("token_inori.projectile", "projectile", 1.0f),
		ScoredResource("gw_tfq.weapon", "weapon", 1.0f),	
		ScoredResource("pistol_orga.weapon", "weapon", 1.0f, 1),
		ScoredResource("ares_shrike.weapon", "weapon", 1.0f),
        ScoredResource("stoner_lmg.weapon", "weapon", 1.0f)
			}
		};
		
		processRewardPasses(rewardPasses);
		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}
	// --------------------------------------------
	protected void setupGift2() {
		_log("adding gift2 config", 1);
		array<Resource@> deliveryList = {
			 Resource("gift_box_2.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{	
		ScoredResource("dollars_300.carry_item", "carry_item", 1.0f),
		ScoredResource("dollars.carry_item", "carry_item", 1.0f),
		ScoredResource("gem.carry_item", "carry_item", 1.0f),
		ScoredResource("costume_clown.carry_item", "carry_item", 1.0f),
		ScoredResource("gold_bar.carry_item", "carry_item", 1.0f),
		ScoredResource("laptop.carry_item", "carry_item", 1.0f),
		ScoredResource("gw_jefty_mn1891pu.weapon", "weapon", 1.0f),	
		ScoredResource("suitcase.carry_item", "carry_item", 1.0f),
        ScoredResource("stoner_lmg.weapon", "weapon", 1.0f)
			},
			{ 
		ScoredResource("underpants.carry_item", "carry_item", 1.0f),
		ScoredResource("vest3.carry_item", "carry_item", 1.0f),
		ScoredResource("teddy.carry_item", "carry_item", 1.0f), 
		ScoredResource("cigars.carry_item", "carry_item", 1.0f),
		ScoredResource("gw_mk23.weapon", "weapon", 1.0f),
		ScoredResource("gw_type64.weapon", "weapon", 1.0f),	
		ScoredResource("gw_g41r.weapon", "weapon", 2.0f),	
		ScoredResource("honey_badger.weapon", "weapon", 1.0f),
		ScoredResource("m60e4.weapon", "weapon", 1.0f),
		ScoredResource("gift_box_3.carry_item", "carry_item", 1.0f)         
			}
		};

		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// ----------------------------------------------------
	protected void setupGift3() {
		_log("adding gift3 config", 1);
		array<Resource@> deliveryList = {
			 Resource("gift_box_3.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("dollars_300.carry_item", "carry_item", 1.0f),
		ScoredResource("gold_bar.carry_item", "carry_item", 1.0f),
		ScoredResource("gem.carry_item", "carry_item", 1.0f),
		ScoredResource("desert_eagle_gold.weapon", "weapon", 1.0f),
		ScoredResource("gw_mp7.weapon", "weapon", 1.0f),
		ScoredResource("painting.carry_item", "carry_item", 1.0f),
        ScoredResource("stoner_lmg.weapon", "weapon", 1.0f),
        ScoredResource("gw_m4a1_qingqiuhu.weapon", "weapon", 1.0f), 
		ScoredResource("gw_hs50.weapon", "weapon", 2.0f),	//2X up 0.37
		ScoredResource("ew_bianchifa6lmg.weapon", "weapon", 1.0f),	
		ScoredResource("gw_type64.weapon", "weapon", 1.0f),	
        ScoredResource("gift_box_community_1.carry_item", "carry_item", 1.0f)      
			},
			{
		ScoredResource("vestjugger.carry_item", "carry_item", 1.0f),
		ScoredResource("ghs_box.carry_item", "carry_item", 0.1f),
		ScoredResource("suitcase.carry_item", "carry_item", 1.0f),
		ScoredResource("laptop.carry_item", "carry_item", 1.0f),
		ScoredResource("costume_werewolf.carry_item", "carry_item", 1.0f),
		ScoredResource("cd.carry_item", "carry_item", 1.0f),
		ScoredResource("honey_badger.weapon", "weapon", 1.0f),
		ScoredResource("ew_hmtech201.weapon", "weapon", 2.0f),	 	//0.38
		ScoredResource("ew_hmtech301.weapon", "weapon", 2.0f),		//0.38
		ScoredResource("ew_hmtech401.weapon", "weapon", 1.0f),	
		ScoredResource("ew_c8_sfw.weapon", "weapon", 1.0f),	
		ScoredResource("m60e4.weapon", "weapon", 1.0f),
		ScoredResource("gw_ebr800.weapon", "weapon", 1.0f),	 
		ScoredResource("ew_turcotte_rapid_smg.weapon", "weapon", 1.0f),	
        ScoredResource("paw20.weapon", "weapon", 1.0f),
		ScoredResource("token_cityhunter.projectile", "projectile", 1.0f, 1)        
			}
		};  
			
		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// ----------------------------------------------------
	protected void setupCommunity1() {
		_log("adding community box 1 config", 1);
		array<Resource@> deliveryList = {
			 Resource("gift_box_community_1.carry_item", "carry_item")
		};
		//CB1
		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("16lab_x4_exo.carry_item", "carry_item", 5.0f, 5),  		
        ScoredResource("42lab_uc_exo.carry_item", "carry_item", 5.0f, 5),
        ScoredResource("16lab_t4_exo.carry_item", "carry_item", 5.0f, 5),       
        ScoredResource("16lab_optical_camo_cloak.carry_item", "carry_item", 5.0f, 5),
        ScoredResource("16lab_t4_bp.carry_item", "carry_item", 5.0f, 5),
        ScoredResource("camo_vest.carry_item", "carry_item", 5.0f, 5), 
		ScoredResource("cb_part.projectile", "projectile", 5.0f), 
		ScoredResource("dooms_hammer.projectile", "projectile", 5.0f, 5),       
		ScoredResource("gi_ssr_weapon_card.carry_item", "carry_item", 18.0f),
		ScoredResource("gi_ur_weapon_card.carry_item", "carry_item", 6.0f),	  
		ScoredResource("gi_sr_weapon_card.carry_item", "carry_item", 36.0f)    

			},
			{
         ScoredResource("banana_car_flare.projectile", "projectile", 1.0f, 4),
         ScoredResource("wz550_flare.projectile", "projectile", 1.0f, 2),
         ScoredResource("tti.weapon", "weapon", 1.0f), 
		 ScoredResource("fal_bayonet.weapon", "weapon", 1.0f),       
         ScoredResource("gift_box_community_2.carry_item", "carry_item", 1.0f),         
	     ScoredResource("m712.weapon", "weapon", 1.0f),
         ScoredResource("leopard2a5_flare.projectile", "projectile", 1.0f, 2),   
		 ScoredResource("paw20.weapon", "weapon", 1.0f),
		 ScoredResource("centurion_avre_flare.projectile", "projectile", 1.0f, 2),   	
         ScoredResource("l30p.weapon", "weapon", 1.0f), 
         ScoredResource("enforcer.weapon", "weapon", 1.0f),
         ScoredResource("squall.weapon", "weapon", 1.0f),
         ScoredResource("tracer_dart.weapon", "weapon", 1.0f, 5),       
         ScoredResource("vest_repair.weapon", "weapon", 1.0f, 10), 
         ScoredResource("guntruck_flare.projectile", "projectile", 1.0f, 2),
         ScoredResource("vulcan_acav_flare.projectile", "projectile", 1.0f, 2),
         ScoredResource("gepard_m6_lynx.weapon", "weapon", 1.0f),
	     ScoredResource("golden_ak47.weapon", "weapon", 1.0f), 
		 ScoredResource("gw_m82a1_golden.weapon", "weapon", 1.0f),		//0.36恢复
	     ScoredResource("taser.weapon", "weapon", 1.0f),
	     ScoredResource("wiesel_flare.projectile", "projectile", 1.0f, 2),
	     ScoredResource("m528_flare.projectile", "projectile", 1.0f, 2),	
		 ScoredResource("aav7_flare.projectile", "projectile", 1.0f, 2),
         ScoredResource("flamer_tank_flare.projectile", "projectile", 1.0f, 2),
         ScoredResource("sev90_flare.projectile", "projectile", 1.0f, 2)
                  
			}
		};   
			
		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}
	
	// ----------------------------------------------------
    protected void setupCommunity2() {
		_log("adding community box 2 config", 1);
		array<Resource@> deliveryList = {
			 Resource("gift_box_community_2.carry_item", "carry_item")
		};
		// CB2
		array<array<ScoredResource@>> rewardPasses = {
			{
				ScoredResource("gift_box_community_1.carry_item", "carry_item", 20.0f),
        		ScoredResource("gi_battle_report.carry_item", "carry_item", 10.0f),
        		ScoredResource("token_box.carry_item", "carry_item", 20.0f)
  
			},
			{
				ScoredResource("gi_ssr_weapon_card.carry_item", "carry_item", 50.0f),
				ScoredResource("gi_ur_weapon_card.carry_item", "carry_item", 45.0f),

        		ScoredResource("le_fantasque.carry_item", "carry_item", 2.0f, 3),		//共用概率
        		ScoredResource("suit_hutao.carry_item", "carry_item", 1.0f, 3),		//共用概率
				ScoredResource("suit_dsr50_dress.carry_item", "carry_item", 1.0f, 3),	//共用概率
				ScoredResource("suit_asuna.carry_item", "carry_item", 1.0f, 3),	//共用概率
				ScoredResource("suit_momiji.carry_item", "carry_item", 1.0f, 3)		//共用概率
			}
		};   
			
		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

//---------------------------------------------------------

    protected void setupSRcard() {
		_log("adding SR weapon card config", 1);
		array<Resource@> deliveryList = {
			 Resource("gi_sr_weapon_card.carry_item", "carry_item")
		};

			
		processRewardPasses(reward_sr);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, reward_sr);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

//---------------------------------------------------------

    protected void setupSSRcard() {
		_log("adding SSR weapon card config", 1);
		array<Resource@> deliveryList = {
			 Resource("gi_ssr_weapon_card.carry_item", "carry_item")
		};

			
		processRewardPasses(reward_ssr);
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, reward_ssr);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

//---------------------------------------------------------

    protected void setupURcard() {
		_log("adding UR weapon card config", 1);
		array<Resource@> deliveryList = {
			 Resource("gi_ur_weapon_card.carry_item", "carry_item")
		};

			
		processRewardPasses(reward_ur);		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, reward_ur);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	
	// ----------------------------------------------------
	protected void setupCommunity3() {
		_log("adding community box 3 config", 1);
		array<Resource@> deliveryList = {
			 Resource("ghs_box.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
				ScoredResource("underpants.carry_item", "carry_item", 1.0f),
				ScoredResource("bizarre_rubber_bullet.carry_item", "carry_item", 1.0f),
				ScoredResource("kamasutra.carry_item", "carry_item", 1.0f),
				ScoredResource("it_p90.carry_item", "carry_item", 1.0f),
				ScoredResource("it_p9.carry_item", "carry_item", 1.0f),
				ScoredResource("it_0.carry_item", "carry_item", 1.0f),
				ScoredResource("dollars.carry_item", "carry_item", 1.0f),
				ScoredResource("teddy.carry_item", "carry_item", 1.0f),        
				ScoredResource("dollars_300.carry_item", "carry_item", 1.0f),
        		ScoredResource("gem.carry_item", "carry_item", 1.0f),
				ScoredResource("laptop.carry_item", "carry_item", 1.0f),
				ScoredResource("tsl_flare.projectile", "projectile", 0.4f, 1),
				ScoredResource("mzd_flare.projectile", "projectile", 0.4f, 1),
				ScoredResource("suitcase.carry_item", "carry_item", 1.0f)

			},
            {

            	ScoredResource("ls_flare.projectile", "projectile", 0.05f, 1),
            	ScoredResource("plane336_flare.projectile", "projectile", 0.2f, 1),
            	ScoredResource("hyl_flare.projectile", "projectile", 0.2f, 1),
            	ScoredResource("mzd_flare.projectile", "projectile", 0.4f, 1),
            	ScoredResource("asdmd_flare.projectile", "projectile", 0.4f, 1),
            	ScoredResource("jpc_flare.projectile", "projectile", 0.4f, 1),
            	ScoredResource("jc_flare.projectile", "projectile", 0.05f, 1),
            	ScoredResource("tsl_flare.projectile", "projectile", 0.4f, 1),
            	ScoredResource("mkl_flare.projectile", "projectile", 0.4f, 1),
            	ScoredResource("ts14_flare.projectile", "projectile", 0.1f, 1),
            	ScoredResource("dkc_flare.projectile", "projectile", 0.1f, 1),
            	ScoredResource("e100-wtp_flare.projectile", "projectile", 0.1f, 1),
            	ScoredResource("hsp_flare.projectile", "projectile", 0.3f, 1),
            	ScoredResource("hsbh_flare.projectile", "projectile", 0.3f, 1),
            	ScoredResource("cyl023.projectile", "projectile", 0.1f, 1),

	     		ScoredResource("ls_flare.projectile", "projectile", 0.1f, 1),
				ScoredResource("2g_flare.projectile", "projectile", 0.5f, 2),
				ScoredResource("2xsm_flare.projectile", "projectile", 0.5f,  3),
				ScoredResource("500t_flare.projectile", "projectile", 0.1f,  1),
				ScoredResource("e100ii_flare.projectile", "projectile", 0.1f,  1),
				ScoredResource("e100t_flare.projectile", "projectile", 0.1f,  2),
				ScoredResource("e50m_flare.projectile", "projectile", 0.1f,  1),
				ScoredResource("e752_flare.projectile", "projectile", 0.2f,  2),
				ScoredResource("gwehp_flare.projectile", "projectile", 0.025f,  2),
				ScoredResource("hbhp_flare.projectile", "projectile", 0.025f,  2),
				ScoredResource("hbm10_flare.projectile", "projectile", 0.3f,  2),
				ScoredResource("hshp_flare.projectile", "projectile", 0.025f,  2),
				ScoredResource("mhpm4043_flare.projectile", "projectile", 0.0025f,  2),
				ScoredResource("mhpm5355_flare.projectile", "projectile", 0.0025f,  2),
				ScoredResource("mhpm5355l_flare.projectile", "projectile", 0.0025f,  2),
				ScoredResource("mhpt92_flare.projectile", "projectile", 0.005f,  2),
				ScoredResource("mhpt92l_flare.projectile", "projectile", 0.005f,  1),
				ScoredResource("mm24e2sc_flare.projectile", "projectile", 0.3f,  2),
				ScoredResource("mmtm48a5_flare.projectile", "projectile", 0.1f,  1),
				ScoredResource("mmtm60_flare.projectile", "projectile", 0.1f,  2),
				ScoredResource("mmtt95e2_flare.projectile", "projectile", 0.2f,  2),
				ScoredResource("mmtt95e6_flare.projectile", "projectile", 0.1f,  1),
				ScoredResource("mmttl1lpc_flare.projectile", "projectile", 0.2f,  2),
				ScoredResource("mt49_flare.projectile", "projectile", 0.3f,  2),
				ScoredResource("mt71cmcd_flare.projectile", "projectile", 0.3f,  2),
				ScoredResource("mt92lt_flare.projectile", "projectile", 0.3f,  2),
				ScoredResource("mxm551_flare.projectile", "projectile", 0.1f,  1),
				ScoredResource("qxtk_flare.projectile", "projectile", 0.1f),
				ScoredResource("rhmpw_flare.projectile", "projectile", 0.1f,  1),
				ScoredResource("ru251_flare.projectile", "projectile", 0.2f,  2),
				ScoredResource("ss_flare.projectile", "projectile", 0.2f,  2),
				ScoredResource("swc58_flare.projectile", "projectile", 0.3f,  2),
				ScoredResource("vk16801_flare.projectile", "projectile", 0.2f,  2),

				ScoredResource("3h_flare.projectile", "projectile", 0.5f,  2),
				ScoredResource("3t_flare.projectile", "projectile", 0.4f,  2),
				ScoredResource("4ha_flare.projectile", "projectile", 0.4f,  1),
				ScoredResource("4tk_flare.projectile", "projectile", 0.4f,  2),
				ScoredResource("b1t_flare.projectile", "projectile", 0.1f,  1),
				ScoredResource("b2740_flare.projectile", "projectile", 0.5f,  2),
				ScoredResource("vk3601h_flare.projectile", "projectile", 0.4f,  1),
				ScoredResource("dw2_flare.projectile", "projectile", 0.4f,  2),
				ScoredResource("e75_flare.projectile", "projectile", 0.025f,  1),
				ScoredResource("fdn_flare.projectile", "projectile", 0.3f,  2),
				ScoredResource("hb2_flare.projectile", "projectile", 0.3f,  2),
				ScoredResource("hbzc_flare.projectile", "projectile", 0.3f,  2),
				ScoredResource("jpz45_flare.projectile", "projectile", 0.1f,  1),
				ScoredResource("lh_flare.projectile", "projectile", 0.3f,  2),
				ScoredResource("mhpm37_flare.projectile", "projectile", 0.15f,  1),
				ScoredResource("mhpm41_flare.projectile", "projectile", 0.15f,  1),
				ScoredResource("mhpm7ms_flare.projectile", "projectile", 0.15f,  1),
				ScoredResource("mhpm12_flare.projectile", "projectile", 0.1f,  1),
				ScoredResource("mhpt1hmc_flare.projectile", "projectile", 0.5f,  1),
				ScoredResource("mk4hp_flare.projectile", "projectile", 0.15f,  1),
				ScoredResource("mm5styt_flare.projectile", "projectile", 0.3f,  2),
				ScoredResource("mm7_flare.projectile", "projectile", 0.5f,  2),
				ScoredResource("mmtgy2_flare.projectile", "projectile", 0.4f,  1),
				ScoredResource("mmtls_flare.projectile", "projectile", 0.3f,  1),
				ScoredResource("mmtm2_flare.projectile", "projectile", 0.3f,  1),
				ScoredResource("mmtm26px_flare.projectile", "projectile", 0.3f,  2),
				ScoredResource("mmtm3l_flare.projectile", "projectile", 0.2f,  1),
				ScoredResource("mmtm46bd_flare.projectile", "projectile", 0.3f,  2),
				ScoredResource("mmtm46mh_flare.projectile", "projectile", 0.3f,  2),
				ScoredResource("mmtm4a3e8kn_flare.projectile", "projectile", 0.3f,  2),
				ScoredResource("mmtt20_flare.projectile", "projectile", 0.3f,  2),
				ScoredResource("mmtt26e3y_flare.projectile", "projectile", 0.3f,  2),

				ScoredResource("mmtt26e4cp_flare.projectile", "projectile", 0.2f,  2),

				ScoredResource("m1a2keqing_flare.projectile", "projectile", 0.5f,  2),
				ScoredResource("flak37_flare.projectile", "projectile", 0.5f,  2),

                // ScoredResource("swordfish_mk1.weapon", "weapon", 0.3f,  2),
				ScoredResource("mmtt42_flare.projectile", "projectile", 0.3f,  1),
				ScoredResource("mmtt69_flare.projectile", "projectile", 0.1f,  1),
				ScoredResource("mmtxfx_flare.projectile", "projectile", 0.2f, 1),
				ScoredResource("mt37_flare.projectile", "projectile", 0.3f,  2),
				ScoredResource("pzic_flare.projectile", "projectile", 0.3f,  1),
				ScoredResource("rhmbwt_flare.projectile", "projectile", 0.1f,  2),
				ScoredResource("spic_flare.projectile", "projectile", 0.4f,  1),
				ScoredResource("tx_flare.projectile", "projectile", 0.4f,  2),
				ScoredResource("vk2801_flare.projectile", "projectile", 0.3f,  2),
				ScoredResource("vk7201_flare.projectile", "projectile", 0.1f,  2),
				ScoredResource("vk7501k_flare.projectile", "projectile", 0.1f,  2),
				ScoredResource("xshp_flare.projectile", "projectile", 0.015f,  1),
				ScoredResource("yfhp_flare.projectile", "projectile", 0.01f,  1),
				ScoredResource("ynhp_flare.projectile", "projectile", 0.02f,  1),
				ScoredResource("-7_flare.projectile", "projectile", 0.01f,  1),
				ScoredResource("e100_flare.projectile", "projectile", 0.005f,  1),
				ScoredResource("490cg_flare.projectile", "projectile", 0.1f,  1),
				ScoredResource("ontos_flare.projectile", "projectile", 0.1f,  1),
				ScoredResource("pzh2000_flare.projectile", "projectile", 0.0025f,  1),
				ScoredResource("2s19msta_flare.projectile", "projectile", 0.00125f,  1),
				ScoredResource("40mmqyc_flare.projectile", "projectile", 0.4f,  1),
				ScoredResource("6237_flare.projectile", "projectile", 0.5f,  1),
				ScoredResource("zlz_flare.projectile", "projectile", 0.5f,  2)		
				
			} 
		};   

		processRewardPasses(rewardPasses);
    
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// ----------------------------------------------------
	protected void setupCommunity4() {
		_log("adding community box 4 config", 1);
		array<Resource@> deliveryList = {
			 Resource("gift_box_community_4.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
         		ScoredResource("lottery.carry_item", "carry_item", 1.0f), 
         		ScoredResource("tkb059.weapon", "weapon", 1.0f),
         		ScoredResource("compound_bow.weapon", "weapon", 1.0f),
         		ScoredResource("blowgun.weapon", "weapon", 1.0f),
         		ScoredResource("rw_gm94.weapon", "weapon", 1.0f),
         		ScoredResource("pf98.weapon", "weapon", 1.0f),                  
         		ScoredResource("icecream.projectile", "projectile", 1.0f, 1)
			},
            {
         		ScoredResource("gepard_m6_lynx.weapon", "weapon", 1.0f),
	     		ScoredResource("golden_ak47.weapon", "weapon", 1.0f), 
         		ScoredResource("zjx19_flare.projectile", "projectile", 1.0f, 2),
	     		ScoredResource("portable_mortar.weapon", "weapon", 1.0f),
	     		ScoredResource("rgm40.weapon", "weapon", 1.0f), 
	     		ScoredResource("uw_m320.weapon", "weapon", 1.0f),
		 		ScoredResource("gift_box_community_3.carry_item", "carry_item", 1.0f),
		 		ScoredResource("gift_box_community_1.carry_item", "carry_item", 1.0f)                                   
			} 
		};   

		processRewardPasses(rewardPasses);
    
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}
	
	// ----------------------------------------------------
	protected void setupIcecream() {
		_log("adding icecream van config", 1);
		array<Resource@> deliveryList = {
			 Resource("lottery.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{

        ScoredResource("icecream.projectile", "projectile", 1.0f, 1)
   
			},  		
        	{
        ScoredResource("vb1.carry_item", "carry_item", 0.5f),
		ScoredResource("cigarettes.carry_item", "carry_item", 1.0f),
        ScoredResource("playing_cards.carry_item", "carry_item", 1.0f),
        ScoredResource("cigars.carry_item", "carry_item", 1.0f),
        ScoredResource("zjx19_flare.projectile", "projectile", 1.0f, 4),  //UP
        ScoredResource("repair_crane_resource.weapon", "weapon", 1.0f, 4), //UP
		ScoredResource("dollars.carry_item", "carry_item", 1.0f),
		ScoredResource("teddy.carry_item", "carry_item", 1.0f),        
		ScoredResource("dollars_300.carry_item", "carry_item", 2.0f),
        ScoredResource("gem.carry_item", "carry_item", 1.0f),
		ScoredResource("laptop.carry_item", "carry_item", 2.0f),
		ScoredResource("suitcase.carry_item", "carry_item", 2.0f), 
   		ScoredResource("painting.carry_item", "carry_item", 2.0f),
		ScoredResource("gold_bar.carry_item", "carry_item", 2.0f),
		ScoredResource("cd.carry_item", "carry_item", 2.0f),                          
		ScoredResource("gift_box_1.carry_item", "carry_item", 1.0f),
		ScoredResource("gift_box_2.carry_item", "carry_item", 1.0f),
		ScoredResource("gift_box_3.carry_item", "carry_item", 1.0f),
		// ScoredResource("ew_rx1_railgun_ap.weapon", "weapon", 0.1f),
		// ScoredResource("ew_rumbler.weapon", "weapon", 0.1f),	
		ScoredResource("wingman_med.weapon", "weapon", 0.1f),	
		ScoredResource("china_lake.weapon", "weapon", 0.3f),	
		ScoredResource("ew_p33_pereira.weapon", "weapon", 1.0f),	
		ScoredResource("ew_mallorian_armscompany_3516.weapon", "weapon", 0.5f),	
		ScoredResource("ew_hemogoblin_gun.weapon", "weapon", 1.0f), 	
		ScoredResource("gw_qbu10_he.weapon", "weapon", 0.2f),	
		ScoredResource("gift_box_community_1.carry_item", "carry_item", 1.0f),             
        ScoredResource("m712.weapon", "weapon", 1.0f),
		ScoredResource("underpants.carry_item", "carry_item", 1.0f, 2),
		ScoredResource("costume_clown.carry_item", "carry_item", 1.0f, 2),
        ScoredResource("costume_banana.carry_item", "carry_item", 1.0f, 2),
        ScoredResource("costume_lizard.carry_item", "carry_item", 1.0f, 2),                
		ScoredResource("costume_werewolf.carry_item", "carry_item", 1.0f, 2),        
		ScoredResource("vest2.carry_item", "carry_item", 1.0f, 5),
		ScoredResource("vest_blackops.carry_item", "carry_item", 1.0f, 5),
        ScoredResource("costume_butcher.carry_item", "carry_item", 1.0f, 2),
        ScoredResource("vestjugger.carry_item", "carry_item", 1.0f),                
		ScoredResource("vest3.carry_item", "carry_item", 2.0f, 5),
        ScoredResource("camo_vest.carry_item", "carry_item", 2.0f, 2),
        
        ScoredResource("banana_peel.projectile", "projectile", 1.0f, 2),
        ScoredResource("summon_targetdrone.projectile", "projectile", 1.0f, 5),
		//ScoredResource("gw_mk23.weapon", "weapon", 1.0f),
		//ScoredResource("gw_mp5.weapon", "weapon", 1.0f),
        ScoredResource("shuriken.projectile", "projectile", 1.0f, 20),                
		ScoredResource("desert_eagle_gold.weapon", "weapon", 1.0f),   
        ScoredResource("dooms_hammer.projectile", "projectile", 1.0f, 5),         
     	ScoredResource("ump40.weapon", "weapon", 1.0f),       
        //ScoredResource("mx4_storm.weapon", "weapon", 1.0f),
        //ScoredResource("bizon.weapon", "weapon", 1.0f),
        ScoredResource("m202_flash.weapon", "weapon", 1.0f, 4),
        ScoredResource("gw_aug.weapon", "weapon", 1.0f),
        ScoredResource("vest_repair.weapon", "weapon", 1.0f, 5),           
        //ScoredResource("gw_m870.weapon", "weapon", 1.0f),                       
		//ScoredResource("gw_kp31.weapon", "weapon", 1.0f),
        //ScoredResource("gw_supershorty.weapon", "weapon", 1.0f),
        //ScoredResource("l30p.weapon", "weapon", 1.0f),     
        ScoredResource("chain_saw.weapon", "weapon", 2.0f),
        ScoredResource("vss_vintorez.weapon", "weapon", 2.0f),
        //ScoredResource("ns2000.weapon", "weapon", 1.0f),              
        //ScoredResource("gw_pkp.weapon", "weapon", 1.0f),              
		//ScoredResource("gw_mp7.weapon", "weapon", 1.0f),
        ScoredResource("tti.weapon", "weapon", 1.0f), 
        //ScoredResource("gw_m82a1.weapon", "weapon", 0.2f),        
        ScoredResource("gw_g28.weapon", "weapon", 1.0f),
        //ScoredResource("kriss_vector.weapon", "weapon", 1.0f),                                
        ScoredResource("stoner_lmg.weapon", "weapon", 2.0f),
        ScoredResource("vest_repair.weapon", "weapon", 1.0f, 10),        
        ScoredResource("scarssr.weapon", "weapon", 1.0f),
        ScoredResource("paw20.weapon", "weapon", 1.0f),
        ScoredResource("xm25.weapon", "weapon", 2.0f),
		ScoredResource("gw_mg5.weapon", "weapon", 2.0f),        
        //ScoredResource("steyr_tmp.weapon", "weapon", 1.0f),       
        //ScoredResource("fal_bayonet.weapon", "weapon", 1.0f), 
        ScoredResource("microgun.weapon", "weapon", 0.0001f),                     
        ScoredResource("lightsaber.weapon", "weapon", 0.1f),                     
        //ScoredResource("enforcer.weapon", "weapon", 1.0f),       
        //ScoredResource("gw_idw.weapon", "weapon", 1.0f), 
        ScoredResource("gw_repair_em.weapon", "weapon", 1.0f),                       
		ScoredResource("honey_badger.weapon", "weapon", 2.0f),
        ScoredResource("milkor_mgl.weapon", "weapon", 2.0f),
		//ScoredResource("m60e4.weapon", "weapon", 1.0f),
		ScoredResource("gw_m99_404.weapon", "weapon", 2.0f),
        ScoredResource("lahti_l39.weapon", "weapon", 2.0f),
        ScoredResource("mg42.weapon", "weapon", 2.0f),
        ScoredResource("javelin.weapon", "weapon", 1.0f, 5),
        ScoredResource("banana_car_flare.projectile", "projectile", 1.0f, 2),
	    ScoredResource("hornet_resource.weapon", "weapon", 1.0f, 2),                
        ScoredResource("guntruck_flare.projectile", "projectile", 1.0f, 2),
        ScoredResource("aav7_flare.projectile", "projectile", 1.0f, 2),
        ScoredResource("dicem_flare.projectile", "projectile", 3.0f, 3),
        ScoredResource("wiesel_flare.projectile", "projectile", 1.0f, 2),
        //ScoredResource("beretta_93r.weapon", "weapon", 1.0f),
        ScoredResource("rw_rpk16.weapon", "weapon", 2.0f),
        ScoredResource("sawnoff.weapon", "weapon", 2.0f),
        ScoredResource("token_4th.projectile", "projectile", 1.0f, 5),
        ScoredResource("token_chinadress.projectile", "projectile", 1.0f, 5),
        ScoredResource("token_cityhunter.projectile", "projectile", 1.0f, 5),   
        ScoredResource("dummy_core.projectile", "projectile", 5.0f),               
        ScoredResource("vulcan_acav_flare.projectile", "projectile", 1.0f, 2)      
			} 
		};   
    
		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

			

	protected void setupContract1() {
		_log("adding t-doll contract config", 1);
		array<Resource@> deliveryList = {
			 Resource("gi_contract_tdoll.carry_item", "carry_item")
		};

		
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, reward_white);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}



	protected void setupContract1_1() {
		_log("adding t-doll contract config", 1);
		array<Resource@> deliveryList = {
			 Resource("gi_contract_tdoll_1.carry_item", "carry_item")
		};

  
		 
			
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, reward_white_mgsg);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	protected void setupContract1_2() {
		_log("adding t-doll contract config", 1);
		array<Resource@> deliveryList = {
			 Resource("gi_contract_tdoll_2.carry_item", "carry_item")
		};

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, reward_white_arsmg);
		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}


	protected void setupContract1_3() {
		_log("adding t-doll contract config", 1);
		array<Resource@> deliveryList = {
			 Resource("gi_contract_tdoll_3.carry_item", "carry_item")
		};
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, reward_white_hgrf);
		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}


	protected void setupContract2() {
		_log("adding equipment contract config", 1);
		array<Resource@> deliveryList = {
			 Resource("gi_contract_equip.carry_item", "carry_item")
		};	
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, reward_equip);
		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	protected void setupContract3() {
		_log("adding black card config", 1);
		array<Resource@> deliveryList = {
			 Resource("gi_black_card.carry_item", "carry_item")
		};

		
		 
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, reward_black);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	protected void setupContract3_1() {
		_log("adding black_arsmghg config", 1);
		array<Resource@> deliveryList = {
			 Resource("gi_black_card_1.carry_item", "carry_item")
		};

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, reward_black_arsmghg);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}


		protected void setupContract3_2() {
		_log("adding reward_black_rfsgmg config", 1);
		array<Resource@> deliveryList = {
			 Resource("gi_black_card_2.carry_item", "carry_item")
		};

		
		 
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, reward_black_rfsgmg);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}



	// ----------------------------------------------------
	protected void setupHalloween1() {
		_log("adding halloween box 1 config", 1);
		array<Resource@> deliveryList = {
			 Resource("halloween_box_1.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("costume_chicken.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("costume_bat.carry_item" , "carry_item", 14.0f, 2),
		ScoredResource("costume_butcher.carry_item" , "carry_item", 6.0f, 1),
		ScoredResource("costume_lizard.carry_item" , "carry_item", 5.0f, 1),
		ScoredResource("costume_clown.carry_item" , "carry_item", 5.0f, 1),
		ScoredResource("fancy_sunglasses.carry_item" , "carry_item", 5.0f, 1),	
		ScoredResource("costume_underpants.carry_item" , "carry_item", 6.0f, 1),
		ScoredResource("costume_werewolf.carry_item" , "carry_item", 14.0f, 2),
		ScoredResource("costume_scream.carry_item" , "carry_item", 14.0f, 2),
		ScoredResource("vampire.projectile", "projectile", 8.0f, 10),
		ScoredResource("werewolf.projectile", "projectile", 8.0f, 10),
		ScoredResource("costume_banana.carry_item" , "carry_item", 3.0f, 1)
			},
			{
		ScoredResource("shock_paddle.weapon" , "weapon", 6.0f),
		ScoredResource("gw_g11_9.weapon" , "weapon", 10.0f),
		ScoredResource("gw_wa2000_6.weapon" , "weapon", 10.0f),
		ScoredResource("torch.weapon", "weapon", 9.0f, 2),
		ScoredResource("banner_rwr.weapon" , "weapon", 5.0f),
		ScoredResource("banner_ee.weapon", "weapon", 8.0f),
		ScoredResource("banner_voting_0.weapon", "weapon", 8.0f),
		ScoredResource("banner_smile.weapon", "weapon", 7.0f),
		ScoredResource("scythe.weapon", "weapon", 18.0f),
        ScoredResource("banner_president.weapon", "weapon", 5.0f),
		ScoredResource("chainsaw.weapon", "weapon", 10.0f)			
			}
		};   
			
		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}	

	// ----------------------------------------------------
		protected void setupLoot1() {
		_log("adding loot1 config", 1);
		array<Resource@> deliveryList = {
			 Resource("loot1.carry_item", "carry_item")
		};
		//loot1
		array<array<ScoredResource@>> rewardPasses = {
			{
				ScoredResource("whiskey_bottle.carry_item", "carry_item", 2.0f ), 
				ScoredResource("cigarettes.carry_item", "carry_item", 2.0f ), 
				ScoredResource("dollars.carry_item", "carry_item", 2.0f ), 
				ScoredResource("gamingdevice.carry_item", "carry_item", 2.0f ), 
				ScoredResource("gem.carry_item", "carry_item", 2.0f ), 
				ScoredResource("painting.carry_item", "carry_item", 2.0f ), 
				ScoredResource("horny_magazine.carry_item", "carry_item", 2.0f ), 
				ScoredResource("comic_book.carry_item", "carry_item", 2.0f ), 
				ScoredResource("rwr_handbook.carry_item", "carry_item", 2.0f ), 
				ScoredResource("oscar_statue.carry_item", "carry_item", 2.0f ), 
				ScoredResource("cigars.carry_item", "carry_item", 2.0f ), 
				ScoredResource("beer_can.carry_item", "carry_item", 2.0f ), 
				ScoredResource("lighter.carry_item", "carry_item", 2.0f ),    
				ScoredResource("steroids.carry_item", "carry_item", 2.0f ),   
				ScoredResource("teddy.carry_item", "carry_item", 2.0f ),       
				ScoredResource("bible.carry_item", "carry_item", 2.0f ),  
				ScoredResource("koran.carry_item", "carry_item", 2.0f ),  
				ScoredResource("chewing_gum.carry_item", "carry_item", 2.0f ), 
				ScoredResource("bizarre_rubber_bullet.carry_item", "carry_item", 2.0f ), 
				ScoredResource("chocolate.carry_item", "carry_item", 2.0f ), 
				ScoredResource("dollars_300.carry_item", "carry_item", 2.0f ),  
				ScoredResource("gold_bar.carry_item", "carry_item", 0.5f ),  
				ScoredResource("digcoin.carry_item", "carry_item", 0.5f ),  
				ScoredResource("energy_drink.carry_item", "carry_item", 2.0f ), 
				ScoredResource("fancy_sunglasses.carry_item", "carry_item", 2.0f ), 
				ScoredResource("radio.carry_item", "carry_item", 2.0f ), 
				ScoredResource("razor.carry_item", "carry_item", 2.0f ),    
				ScoredResource("sheaths.carry_item", "carry_item", 2.0f ), 
				ScoredResource("sheaths_xxl.carry_item", "carry_item", 2.0f ),   
				ScoredResource("sunglasses.carry_item", "carry_item", 2.0f ),  
				ScoredResource("ipoo_player_blue.carry_item", "carry_item", 2.0f ),  
				ScoredResource("ipoo_player_red.carry_item", "carry_item", 2.0f ), 
				ScoredResource("ipoo_player_white.carry_item", "carry_item", 2.0f ),      
				ScoredResource("ipoo_player_silver.carry_item", "carry_item", 2.0f ), 
				ScoredResource("ipoo_player_yellow.carry_item", "carry_item", 2.0f ), 
				ScoredResource("ipoo_player_green.carry_item", "carry_item", 2.0f ), 
				ScoredResource("ipoo_player_pink.carry_item", "carry_item", 1.0f ),    
				ScoredResource("playing_cards.carry_item", "carry_item", 2.0f ), 
				ScoredResource("underpants.carry_item", "carry_item", 1.0f ),  
				ScoredResource("kamasutra.carry_item", "carry_item", 1.0f ),  
				ScoredResource("cd.carry_item", "carry_item", 0.5f ),  
				ScoredResource("pickashoe.carry_item", "carry_item", 2.0f ),  
				ScoredResource("it_p90.carry_item", "carry_item", 2.0f ), 
				ScoredResource("it_p9.carry_item", "carry_item", 2.0f ), 
				ScoredResource("it_0.carry_item", "carry_item", 2.0f ), 				//以上为基础垃圾
				ScoredResource("redstar.carry_item", "carry_item", 0.5f ),	
				ScoredResource("it_qlz.carry_item", "carry_item", 2.0f ),	
				ScoredResource("it_fire_control.carry_item", "carry_item", 1.0f ),	
				ScoredResource("it_cpu.carry_item", "carry_item", 1.0f ),	
				ScoredResource("it_broken_cpu.carry_item", "carry_item", 2.0f ),	
				ScoredResource("it_broken_fire_control.carry_item", "carry_item", 2.0f ),	
				ScoredResource("it_ecigar.carry_item", "carry_item", 2.0f ),	
				ScoredResource("it_gundam.carry_item", "carry_item", 0.5f ),			//以上为特殊垃圾
				ScoredResource("play_box.carry_item", "carry_item", 0.5f ),				//玩具
				ScoredResource("newyear_box.carry_item", "carry_item", 0.5f ),			//新年
				ScoredResource("token_box.carry_item", "carry_item", 0.5f ),			//信物
				ScoredResource("vb1.carry_item", "carry_item", 0.3f ),					//载具
				ScoredResource("halloween_box_1.carry_item", "carry_item", 0.5f ),		//南瓜
				ScoredResource("xmas_box.carry_item", "carry_item", 0.1f ),				//圣诞
				ScoredResource("gift_box_1.carry_item", "carry_item", 0.3f ),			//蓝
				ScoredResource("gift_box_2.carry_item", "carry_item", 0.3f ),			//紫
				ScoredResource("gift_box_3.carry_item", "carry_item", 0.2f ),			//泰坦
				ScoredResource("gi_black_card.carry_item", "carry_item", 0.5f ),		//黑卡
				ScoredResource("gi_contract_equip.carry_item", "carry_item", 1.3f ),	//装备
				ScoredResource("gi_contract_tdoll.carry_item", "carry_item", 1.3f ),	//白卡
				ScoredResource("gift_box_community_1.carry_item", "carry_item", 0.2f )	//CB1

			}
		};   
			
		processRewardPasses(rewardPasses);
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);
		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}


	protected void setupLoot2() {
		_log("adding loot2 config", 1);
		array<Resource@> deliveryList = {
			 Resource("loot2.carry_item", "carry_item")
		};
		//loot2
		array<array<ScoredResource@>> rewardPasses = {
			{
				ScoredResource("gold_bar.carry_item", "carry_item", 10.0f ),  			//金条
		        ScoredResource("gem.carry_item", "carry_item", 10.0f ),					//钻石
				ScoredResource("it_gundam.carry_item", "carry_item", 1.0f ),			//1Wrp高达
				ScoredResource("it_plashspeed.carry_item", "carry_item", 2.0f ),		//不认识，但是挺贵的
				ScoredResource("it_2099.carry_item", "carry_item", 3.0f ),				//2099
				ScoredResource("it_engine_oil.carry_item", "carry_item", 3.0f ),		//机油
				ScoredResource("it_4080ti.carry_item", "carry_item", 3.0f ),			//显卡
				ScoredResource("it_fire_control.carry_item", "carry_item", 10.0f ),		//火控
				ScoredResource("it_cpu.carry_item", "carry_item", 10.0f ),				//CPU
				ScoredResource("gift_box_1.carry_item", "carry_item", 10.0f ),			//蓝
				ScoredResource("gift_box_2.carry_item", "carry_item", 8.0f ),			//紫
				ScoredResource("gift_box_3.carry_item", "carry_item", 3.0f ),			//泰坦
				ScoredResource("gift_box_community_1.carry_item", "carry_item", 0.5f ),	//CB1
		        ScoredResource("gi_black_card.carry_item", "carry_item", 5.0f ),  		//黑卡
				ScoredResource("newyear_box.carry_item", "carry_item", 5.0f ),			//新年
				ScoredResource("token_box.carry_item", "carry_item", 5.0f ),			//信物
				ScoredResource("vb1.carry_item", "carry_item", 3.0f ),					//载具
				ScoredResource("halloween_box_1.carry_item", "carry_item", 5.0f ),		//南瓜
				ScoredResource("xmas_box.carry_item", "carry_item", 2.0f ),				//圣诞
				ScoredResource("cb_part.projectile", "projectile", 1.3f ),				//CBP
				ScoredResource("gift_box_community_2.carry_item", "carry_item", 0.2f )	//CB2
			}
		};   
			
		processRewardPasses(rewardPasses);
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);
		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	protected void setupLoot3() {
		_log("adding loot3 config", 1);
		array<Resource@> deliveryList = {
			 Resource("loot3.carry_item", "carry_item")
		};
		//loot3
		array<array<ScoredResource@>> rewardPasses = {
			{
				ScoredResource("it_gundam.carry_item", "carry_item", 1.5f ),			//1Wrp高达
				ScoredResource("it_plashspeed.carry_item", "carry_item", 2.0f ),		//不认识，但是挺贵的
				ScoredResource("it_2099.carry_item", "carry_item", 3.0f ),				//2099
				ScoredResource("it_engine_oil.carry_item", "carry_item", 3.0f ),		//机油
				ScoredResource("it_4080ti.carry_item", "carry_item", 5.0f ),			//显卡
				ScoredResource("it_fire_control.carry_item", "carry_item", 15.0f ),		//火控
				// ScoredResource("drop_pod_maxops_flare.projectile", "projectile", 5.0f， 2),		//CB全装AI舱降信标
				ScoredResource("it_cpu.carry_item", "carry_item", 15.0f ),				//CPU
				ScoredResource("gi_battle_report.carry_item", "carry_item", 0.5f),		//作战报告书
				ScoredResource("gift_box_1.carry_item", "carry_item", 10.0f ),			//蓝
				ScoredResource("gift_box_2.carry_item", "carry_item", 10.0f ),			//紫
				ScoredResource("gift_box_3.carry_item", "carry_item", 3.0f ),			//泰坦
				ScoredResource("gift_box_community_1.carry_item", "carry_item", 1.0f ),	//CB1
		        ScoredResource("gi_black_card.carry_item", "carry_item", 5.0f),  		//黑卡
				ScoredResource("newyear_box.carry_item", "carry_item", 5.0f ),			//新年
				ScoredResource("token_box.carry_item", "carry_item", 5.0f ),			//信物
				ScoredResource("vb1.carry_item", "carry_item", 3.0f ),					//载具
				ScoredResource("halloween_box_1.carry_item", "carry_item", 5.0f ),		//南瓜
				ScoredResource("xmas_box.carry_item", "carry_item", 4.0f ),				//圣诞
				ScoredResource("gi_ssr_weapon_card.carry_item", "carry_item", 0.6f),	//SSR刮刮卡
				ScoredResource("gi_sr_weapon_card.carry_item", "carry_item", 1.6f),		//SR刮刮卡
				ScoredResource("cb_part.projectile", "projectile", 1.6f ),				//CBP
				ScoredResource("gift_box_community_2.carry_item", "carry_item", 0.2f )	//CB2 
			}
		};   
			
		processRewardPasses(rewardPasses);
		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);
		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// ----------------------------------------------------
	protected void setupXmasBox() {
		_log("adding xmas box config", 1);
		array<Resource@> deliveryList = {
			 Resource("xmas_box.carry_item", "carry_item")
		};

		array<array<ScoredResource@>> rewardPasses = {
			{
		ScoredResource("banner_santa.weapon" , "weapon", 20.0f),
		ScoredResource("banner_gingerbread.weapon" , "weapon", 20.0f),
		ScoredResource("banner_rwr.weapon" , "weapon", 5.0f),
		ScoredResource("gw_ameli_1605.weapon" , "weapon", 5.0f, 1),
		ScoredResource("gw_art556_2803.weapon" , "weapon", 5.0f, 1),
		ScoredResource("gw_fnfal_308.weapon" , "weapon", 5.0f, 1),
		ScoredResource("gw_m14_303.weapon" , "weapon", 5.0f, 1),
		ScoredResource("gw_m1873_301.weapon" , "weapon", 5.0f, 1),
		ScoredResource("gw_rfb_1601.weapon" , "weapon", 5.0f, 1),
		ScoredResource("gw_wa2000_306.weapon" , "weapon", 5.0f, 1),
		ScoredResource("gw_kp31_310.weapon" , "weapon", 5.0f, 1),
		ScoredResource("gw_type100_4004.weapon" , "weapon", 5.0f, 1),
		ScoredResource("gw_svd_305.weapon" , "weapon", 5.0f, 1),
		ScoredResource("gw_p90_2802.weapon" , "weapon", 5.0f, 1),
		ScoredResource("gw_m1918bar_1606.weapon" , "weapon", 5.0f, 1),
		ScoredResource("gw_mg5_309.weapon" , "weapon", 5.0f, 1),		
		ScoredResource("hyz88_xmas.weapon" , "weapon", 10.0f, 1),		
		ScoredResource("xmas_tree_resource.weapon" , "weapon", 20.0f, 5),
		ScoredResource("xmas_bamboo_resource.weapon" , "weapon", 20.0f, 5),
		ScoredResource("gift_box_1.carry_item", "carry_item", 10.0f, 1),
		ScoredResource("gift_box_2.carry_item", "carry_item", 8.0f, 1),
		ScoredResource("gift_box_3.carry_item", "carry_item", 5.0f, 1),
        ScoredResource("gift_box_community_1.carry_item", "carry_item", 3.0f, 1),
        ScoredResource("gift_box_community_2.carry_item", "carry_item", 3.0f, 1),
		ScoredResource("balloon.carry_item", "carry_item", 8.0f, 5)
			},
			{
		ScoredResource("costume_santa.carry_item", "carry_item", 20.0f, 2),
		ScoredResource("costume_tree.carry_item", "carry_item", 20.0f, 2),
		ScoredResource("costume_gingerbread.carry_item", "carry_item", 20.0f, 2),
		ScoredResource("lottery.carry_item", "carry_item", 5.0f, 2),
		ScoredResource("xmas_candycane.carry_item", "carry_item", 15.0f, 3),
		ScoredResource("xmas_bell.carry_item", "carry_item", 10.0f, 3),
		ScoredResource("xmas_biscuit.carry_item", "carry_item", 15.0f, 3),
		ScoredResource("xmas_stocking.carry_item", "carry_item", 15.0f, 3),
		ScoredResource("jeep_xmas_flare.projectile", "projectile", 15.0f, 3),
		ScoredResource("chocolate.carry_item", "carry_item", 7.0f, 1),
		ScoredResource("teddy.carry_item", "carry_item", 7.0f, 1),
		ScoredResource("gamingdevice.carry_item", "carry_item", 6.0f, 1)

			}
		};

		processRewardPasses(rewardPasses);

		GiftItemDeliveryRandomRewarder@ rewarder = GiftItemDeliveryRandomRewarder(m_metagame, rewardPasses);

		m_itemDeliveryOrganizer.addObjective(
			ItemDeliveryObjective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, null, "", "", "", -1 /* loop */, rewarder)
			);
	}

	// ----------------------------------------------------  
	protected void setupEnemyWeaponUnlocks() {
		array<ItemDeliveryObjective@> objectives = createEnemyWeaponDeliveryObjectives();

		for (uint i = 0; i < objectives.size(); ++i) {
			m_itemDeliveryOrganizer.addObjective(objectives[i]);
		}
	}

	// ----------------------------------------------------
	protected array<Resource@>@ getEnemyWeaponDeliverables() const {
		array<Resource@> results;

		string type = "weapon";
		string typePlural = "weapons";

		// get the stuff we have in stock
		array<const XmlElement@> own = getFactionDeliverables(m_metagame, 0, type, typePlural);
		if (own is null) {
			_log("WARNING, getEnemyWeaponDeliverables, couldn't get own resources", -1);
			return results;
		}

		// get the grand list of deliverable weapons, all of them
		array<Resource@> deliverables = getDeliverablesList();
		for (uint i = 0; i < deliverables.size(); ++i) {
			Resource@ r = deliverables[i];
			// go through the list and only leave the ones in we're interested of, those which we don't have yet
			// check if we have this key
			bool add = true;
			for (uint j = 0; j < own.size(); ++j) {
				const XmlElement@ ownNode = own[j];
				string ownKey = ownNode.getStringAttribute("key");
				if (r.m_key != ownKey) {
					// no match, continue searching
				} else {
					// we already have this, skip it
					add = false;
					break;
				}
			}

			if (add) {
				// ensure it's not already in results
				if (results.findByRef(r) < 0) {
					results.insertLast(r);
				}
			}
		}

		return results;
	}

	// ----------------------------------------------------
	protected array<ItemDeliveryObjective@>@ createEnemyWeaponDeliveryObjectives() const {
		_log("createEnemyWeaponDeliveryObjectives", 1);

		array<ItemDeliveryObjective@> newObjectives;

		string instructions = "enemy item objective instruction";
		string thanks = "enemy item objective thanks";
		string thanksIncomplete = "enemy item objective thanks incomplete";

		// add objective for every enemy weapon not owned by friendlies yet
		array<Resource@>@ enemyWeaponResources = getEnemyWeaponDeliverables();
		for (uint i = 0; i < enemyWeaponResources.size(); ++i) {
			Resource@ resource = enemyWeaponResources[i];
			_log("enemy unlock target " + resource.m_key, 1);
			array<Resource@> deliveryList = {resource};
			// delivering certain amount of specific weapon unlocks that particular weapon
			dictionary unlockList = {
				{resource.m_key, array<Resource@> = {resource}}
			};
			ResourceUnlocker@ unlocker = ResourceUnlocker(m_metagame, 0, unlockList, m_metagame, /* custom stat tracker tag */ "enemy_weapon_delivered");

			int amount = 5;

			ItemDeliveryObjective objective(m_metagame, 0, deliveryList, m_itemDeliveryOrganizer, unlocker, instructions, "", thanks, thanksIncomplete, amount, 0, 50);

			if (m_itemDeliveryOrganizer.getObjectiveById(objective.getId()) is null) {
				newObjectives.insertLast(objective);
			}			
		}

		return newObjectives;
	}

	// ----------------------------------------------------
	protected void refreshEnemyWeaponDeliveryObjectives() {
		// only creates ones that don't already exist
		array<ItemDeliveryObjective@>@ newObjectives = createEnemyWeaponDeliveryObjectives();

		for (uint i = 0; i < newObjectives.size(); ++i) {
			ItemDeliveryObjective@ objective = newObjectives[i];
			m_itemDeliveryOrganizer.addObjective(objective);
			// insta-add tracker
			m_metagame.addTracker(objective);
		}
	}

	// --------------------------------------------
	array<Resource@>@ getUnlockWeaponList() const {
		array<Resource@> list;


		list.push_back(Resource("smaw.weapon", "weapon"));
		list.push_back(Resource("l85a2.weapon", "weapon"));
		list.push_back(Resource("famasg1.weapon", "weapon"));
		list.push_back(Resource("sg552.weapon", "weapon"));
		list.push_back(Resource("uw_m320.weapon", "weapon"));
		list.push_back(Resource("minig_resource.weapon", "weapon"));
		list.push_back(Resource("desert_eagle.weapon", "weapon"));
		list.push_back(Resource("tow_resource.weapon", "weapon"));   
		list.push_back(Resource("kriss_vector.weapon", "weapon")); 
		list.push_back(Resource("gl_resource.weapon", "weapon"));


		return list;
	}

	// --------------------------------------------
	array<Resource@>@ getUnlockWeaponList2() const {
		array<Resource@> list;

//		list.push_back(Resource("gk_supply_hg.weapon", "weapon"));
//		list.push_back(Resource("gk_supply_smg.weapon", "weapon"));
//		list.push_back(Resource("gk_supply_ar.weapon", "weapon"));
//		list.push_back(Resource("gk_supply_rf.weapon", "weapon"));
//		list.push_back(Resource("gk_supply_mg.weapon", "weapon"));
//		list.push_back(Resource("gk_supply_sg.weapon", "weapon"));

//		list.push_back(Resource("mp5sd.weapon", "weapon"));
//		list.push_back(Resource("beretta_m9.weapon", "weapon"));
		list.push_back(Resource("gw_sr3mp.weapon", "weapon"));
//		list.push_back(Resource("glock17.weapon", "weapon"));
		list.push_back(Resource("qcw-05.weapon", "weapon"));
		list.push_back(Resource("m202_flash.weapon", "weapon"));    
//    	list.push_back(Resource("vest_blackops.carry_item", "carry_item")); 
//		list.push_back(MultiGroupResource("vest_blackops.carry_item", "carry_item", array<string> = {"default", "supply"}));
		list.push_back(Resource("apr.weapon", "weapon")); 
//		list.push_back(Resource("mk23.weapon", "weapon")); 
//		list.push_back(MultiGroupResource("mk23.weapon", "weapon", array<string> =	 {"default", "supply"}));   

		return list;
	}
	


	// --------------------------------------------
	array<Resource@>@ getDeliverablesList() const {
		array<Resource@> list;

		// list here what we want to track as delivering to armory, with intention of unlocking that same item

		// the upgrade weapons, l85a2, famas, sg552, are considered semi-rare, only unlockable through cargo truck & suitcases, see get_unlock_weapon_list
		// in 1.31 we removed the weapons as unlockables that are not dropped by the AI 

		// green weapons
//		list.push_back(Resource("m16a4.weapon", "weapon"));
//		list.push_back(Resource("uw_m4a1acog.weapon", "weapon"));
		list.push_back(Resource("uw_m320.weapon", "weapon"));
		list.push_back(Resource("uw_m14ebr.weapon", "weapon"));
		list.push_back(Resource("uw_m16a4.weapon", "weapon"));
		list.push_back(Resource("uw_m249.weapon", "weapon"));
		list.push_back(Resource("uw_mk46.weapon", "weapon"));
		list.push_back(Resource("uw_at4.weapon", "weapon"));
		list.push_back(Resource("uw_m1014.weapon", "weapon"));
		list.push_back(Resource("m240.weapon", "weapon"));
		list.push_back(Resource("m24_a2.weapon", "weapon"));
		//list.push_back(Resource("mp5sd.weapon", "weapon"));
//		list.push_back(Resource("mossberg.weapon", "weapon"));
		//list.push_back(Resource("l85a2.weapon", "weapon"));
//		list.push_back(Resource("uw_acr.weapon", "weapon"));
		//list.push_back(Resource("beretta_m9.weapon", "weapon"));
		//list.push_back(Resource("mini_uzi.weapon", "weapon"));     

		// grey weapons
		list.push_back(Resource("g36.weapon", "weapon"));
//		list.push_back(Resource("imi_negev.weapon", "weapon"));
		list.push_back(Resource("psg90.weapon", "weapon"));
		//list.push_back(Resource("scorpion-evo.weapon", "weapon"));
		list.push_back(Resource("spas-12.weapon", "weapon"));
		//list.push_back(Resource("famasg1.weapon", "weapon"));
//		list.push_back(Resource("m2_carlgustav.weapon", "weapon"));
		//list.push_back(Resource("glock17.weapon", "weapon"));
		//list.push_back(Resource("steyr_tmp.weapon", "weapon"));     

		// brown weapons
		list.push_back(Resource("ak47.weapon", "weapon"));
//		list.push_back(Resource("rw_akm.weapon", "weapon"));
		list.push_back(Resource("pkm.weapon", "weapon"));
		list.push_back(Resource("rw_ak74m.weapon", "weapon"));
//		list.push_back(Resource("gw_ak12.weapon", "weapon"));
//		list.push_back(Resource("gw_an94.weapon", "weapon"));
		list.push_back(Resource("rw_rpk74.weapon", "weapon"));
		list.push_back(Resource("gw_pkp.weapon", "weapon"));
		list.push_back(Resource("gw_svd.weapon", "weapon"));
		list.push_back(Resource("rw_cb98.weapon", "weapon"));
//		list.push_back(Resource("dragunov_svd.weapon", "weapon"));
		//list.push_back(Resource("qcw-05.weapon", "weapon"));
//		list.push_back(Resource("qbs-09.weapon", "weapon"));
		//list.push_back(Resource("sg552.weapon", "weapon"));
		list.push_back(Resource("rpg-7.weapon", "weapon"));
		//list.push_back(Resource("pb.weapon", "weapon")); 
		//list.push_back(Resource("aek_919k.weapon", "weapon"));     

		return list;
	}

}
