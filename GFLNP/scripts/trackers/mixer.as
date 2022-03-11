#include "tracker.as"
#include "helpers.as"
#include "admin_manager.as" 
#include "log.as"  
#include "query_helpers.as"
#include "query_helpers2.as" 

//square 2021/10/11

class formula 
{
	string m_key1;
	string m_key2;
	string m_reward;
	int m_cost1;
	int m_cost2;
	formula(string key1,string key2,int cost1,int cost2,string reward)
	{
			m_key1 = key1;
			m_key2 = key2;
			m_cost1 = cost1;
			m_cost2 = cost2; 
			m_reward = reward;
	}
}

class workingItem 
{
	int m_state;
	int m_playerId;
	float m_timeRemain;
	string m_itemIn;
	int m_lineIndex;
	workingItem(int state,int playerId,string itemIn,int lineIndex)
	{
		m_state = state;
		m_playerId = playerId;
		m_timeRemain = 10.0f;
		m_itemIn = itemIn;
		m_lineIndex = lineIndex;
	}

}


 
class Mixer : Tracker {
	protected Metagame@ m_metagame;

	protected array<formula@> formulaQueue;
	protected array<workingItem@> workingQueue;
	int totLineIndex=0;
	void getNewLineIndex()
	{
		totLineIndex++;
		totLineIndex=totLineIndex%11451;
	}


	Mixer(Metagame@ metagame) {
		_log("start it");
		@m_metagame = @metagame;
		formulaQueue.insertLast(formula("gw_qlu11.weapon","gw_qlu11.weapon",150,200,"gw_an94.weapon"));
	}

	// --------------------------------------------
	bool hasEnded() const {
		return false;
	}

	// -------------------------------------------- 
	bool hasStarted() const {
		return true;
	}

	array<int> SearchTheFormulaQueueAboutKey(string key)
	{
		array<int>answer;
		answer.resize(0);
		for(uint i=0;i<formulaQueue.length();i++)
		{
			if(key == formulaQueue[i].m_key1)
			{
				answer.insertLast(i*10+1);
			}
			else if(key == formulaQueue[i].m_key2)
			{
				answer.insertLast(i*10+2);
			}
		}
		return answer;
	}

	int SearchVehicles(Vector3 Pos)
	{
		array<const XmlElement@>@ vehicles = getAllVehicles(m_metagame, 0);
		for (uint i = 0;i<vehicles.length();i++)
		{
			Vector3 vehiclePos = stringToVector3(vehicles[i].getStringAttribute("position"));
			if (checkRange(Pos, vehiclePos, 2.0f))
			{
				int vehicleId = vehicles[i].getIntAttribute("id");
				const XmlElement@ vehicleInfo = getVehicleInfo(m_metagame, vehicleId);
				if (vehicleInfo !is null) 
				{
					string vehicleKey = vehicleInfo.getStringAttribute("key");
					if (vehicleKey == "assembly_table.vehicle")
					{
						return vehicleId;
					}
				}
			}
		}
		return -1;
	}

	string getTail(string x)
	{
		int pos = x.findFirst(".");
		return x.substr(pos+1);
	}

	void rewardPlayer(int state,int playerId) 
	{
		_log("reward You");

		string RewardKey = formulaQueue[state/10].m_reward;
		string itemType = getTail(RewardKey); 
		int backRP = formulaQueue[state/10].m_cost1+formulaQueue[state/10].m_cost2;
		const XmlElement@ info = getPlayerInfo(m_metagame,playerId);
		int characterId = info.getIntAttribute("character_id");
		@info = getCharacterInfo(m_metagame, characterId);
		if (info !is null) 
		{
			XmlElement c("command");
			c.setStringAttribute("class", "update_inventory");

			c.setIntAttribute("character_id", characterId); 
			c.setIntAttribute("container_type_id", 2);
			{
				XmlElement j("item");
				j.setStringAttribute("class", itemType);
				j.setStringAttribute("key", RewardKey);
				c.appendChild(j);
			}
			m_metagame.getComms().send(c);		
			_log("reward command "+c.toString());
			string command =
				"<command class='rp_reward'" +
				"	character_id='" + characterId + "'" +
				"	reward='"+backRP*-1+"'>" + // multiplier affected..
				"</command>";
			m_metagame.getComms().send(command);
		}


	}
	void returnPlayer(int state,int playerId)
	{
		_log("return You");

		string itemKey;
		int rpBack;
		if(state%10 == 2)
		{
			itemKey = formulaQueue[state/10].m_key1;	
			rpBack = formulaQueue[state/10].m_cost1;
		}
		else
		{
			itemKey = formulaQueue[state/10].m_key2;	
			rpBack = formulaQueue[state/10].m_cost2;
		}
		
		string itemType = getTail(itemKey);

		const XmlElement@ info = getPlayerInfo(m_metagame,playerId);
		int characterId = info.getIntAttribute("character_id");
		@info = getCharacterInfo(m_metagame, characterId);
		if (info !is null) 
		{
			XmlElement c("command");
			c.setStringAttribute("class", "update_inventory");

			c.setIntAttribute("character_id", characterId); 
			c.setIntAttribute("container_type_id", 2);
			{
				XmlElement j("item");
				j.setStringAttribute("class", itemType);
				j.setStringAttribute("key", itemKey);
				c.appendChild(j);
			}
			m_metagame.getComms().send(c);		
			_log("reward command "+c.toString());
			string command =
				"<command class='rp_reward'" +
				"	character_id='" + characterId + "'" +
				"	reward='"+rpBack*-1+"'>" + // multiplier affected..
				"</command>";
			m_metagame.getComms().send(command);

		}

	}


	protected void handleItemDropEvent(const XmlElement@ event) 
	{
		_log("see this");
		string itemKey = event.getStringAttribute("item_key");
		int characterId= event.getIntAttribute("character_id");
		int playerId   = event.getIntAttribute("player_id");
		Vector3 Pos    = stringToVector3(event.getStringAttribute("position"));	 
		array<int> quePos 	   = SearchTheFormulaQueueAboutKey(itemKey);
		_log("search the menu");
		if(event.getIntAttribute("target_container_type_id")!=1 || quePos.length()==0)return;
		_log("get in menu");
		_log("search the vehcle");
		int workPlaceId= SearchVehicles(Pos);
		if(workPlaceId == -1)return;
		_log("get the vehicle");
//
		uint i=0;
		uint j=0;
		uint MAXI = quePos.length();
		uint MAXJ = workingQueue.length();
		while(i<MAXI && j<MAXJ)
		{
			if(workingQueue[j].m_playerId!=playerId)
			{
				j++;
				continue;
			}
			if(quePos[i]==workingQueue[j].m_state)
			{
				rewardPlayer(workingQueue[j].m_state,workingQueue[j].m_playerId);
				float nowIndex = workingQueue[j].m_lineIndex;
				workingQueue.removeAt(j);
				for (uint k=0;k<workingQueue.length();k++)
				{
					if(workingQueue[k].m_lineIndex==nowIndex)
					{
						workingQueue.removeAt(k);
						k--;
					}
				}
				return;
			}
			if(quePos[i]<workingQueue[j].m_state)
			{
				i++;
			}
			else if(quePos[i]>workingQueue[j].m_state)
			{
				j++;
			}
		}
//
		_log("not find in the waiting line");
		i=0;
		j=0;
		getNewLineIndex();
		while(i<MAXI&&j<MAXJ)
		{
			if(quePos[i]>workingQueue[j].m_state)
			{
				j++;
			}
			else
			{
				if(quePos[i]%10 == 1)
				{
					workingQueue.insertAt(j,workingItem( (quePos[i]/10)*10+(3-(quePos[i]%10)) , playerId ,formulaQueue[quePos[i]/10].m_key1,totLineIndex));
				}
				else
				{
					workingQueue.insertAt(j,workingItem( (quePos[i]/10)*10+(3-(quePos[i]%10)) , playerId ,formulaQueue[quePos[i]/10].m_key2,totLineIndex));
				}
				_log("insect in waiting line at "+j);
				i++;
				j++;
			}
		}
		while(i<MAXI)
		{
			if(quePos[i]%10 == 1)
			{
				workingQueue.insertLast( workingItem( (quePos[i]/10)*10+(3-(quePos[i]%10)) , playerId ,formulaQueue[quePos[i]/10].m_key1,totLineIndex));
			}
			else
			{
				workingQueue.insertLast( workingItem( (quePos[i]/10)*10+(3-(quePos[i]%10)) , playerId ,formulaQueue[quePos[i]/10].m_key2,totLineIndex));
			}
			
			i++;
			_log("insect in waiting line at least");
		}

	}

	void update(float time) 
	{
		for(uint i=0;i<workingQueue.length();i++)
		{
			
			workingQueue[i].m_timeRemain-=time;
			if(workingQueue[i].m_timeRemain<0.0)
			{
				float nowIndex = workingQueue[i].m_lineIndex;
				returnPlayer(workingQueue[i].m_state,workingQueue[i].m_playerId);
				workingQueue.removeAt(i);
				for(uint j=i;j<workingQueue.length();j++)
				{
					if(workingQueue[j].m_lineIndex == nowIndex)
					{
						workingQueue.removeAt(j);
						j--;
					}
				}
			}
		}
	}
}

