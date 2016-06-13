//: [Previous](@previous)

import Foundation

var sharks: [[String: AnyObject]] = []
var dragons: [[String: AnyObject]] = []
var raptors: [[String: AnyObject]] = []

var teams = [sharks, dragons, raptors]

let soccerLeague: [[String: AnyObject]] = [
	["Name": "Joe Smith","Height": 42,"Experience": true,"Guardians": "Jim and Jan Smith"],
	["Name": "Jill Tanner","Height": 36,"Experience": true,"Guardians": "Clara Tanner"],
	["Name": "Bill Bon","Height": 43,"Experience": true,"Guardians": "Sara and Jenny Bon"],
	["Name": "Eva Gordon","Height": 45,"Experience": false,"Guardians": "Wendy and Mike Gordon"],
	["Name": "Matt Gill","Height": 40,"Experience": false,"Guardians": "Charles and Sylvia Gill"],
	["Name": "Kimmy Stein","Height": 41,"Experience": false,"Guardians": "Bill and Hillary Stein"],
	["Name": "Sammy Adams","Height": 45,"Experience": false,"Guardians": "Jeff Adams"],
	["Name": "Karl Saygan","Height": 42,"Experience": true,"Guardians": "Heather Bledsoe"],
	["Name": "Suzane Greenberg","Height": 44,"Experience": true,"Guardians": "Henrietta Dumas"],
	["Name": "Sal Dali","Height": 41,"Experience": false,"Guardians": "Gala Dali"],
	["Name": "Joe Kavalier","Height": 39,"Experience": false,"Guardians": "Sam and Elaine Kavalier"],
	["Name": "Ben Finkelstein","Height": 44,"Experience": false,"Guardians": "Aaron and Jill Finkelstein"],
	["Name": "Diego Soto","Height": 41,"Experience": true,"Guardians": "Robin and Sarika Soto"],
	["Name": "Chloe Alaska","Height": 47,"Experience": false,"Guardians": "David and Jamie Alaska"],
	["Name": "Arnold Willis","Height": 43,"Experience": false,"Guardians": "Claire Willis"],
	["Name": "Phillip Helm","Height": 44,"Experience": true,"Guardians": "Thomas Helm and Eva Jones"],
	["Name": "Les Clay","Height": 42,"Experience": true,"Guardians": "Wynonna Brown"],
	["Name": "Herschel Krustofski","Height": 45,"Experience": true,"Guardians": "Hyman and Rachel Krustofski"]
]

//Functions
func getPlayersAvgHeight(players: [[String: AnyObject]]) -> Double {
	
	if players.count > 0 {
		
		var totalHeight = 0.0
		
		for player in players {
			
			totalHeight += player["Height"] as! Double
		}
		
		return Double(totalHeight) / Double(players.count)
		
	} else {
		
		return 0.0
	}
}

func playersCountBySkill(team: [[String: AnyObject]], skilled: Bool) -> Int {
	
	var result: Int = 0
	
	for player in team {
		
		if player["Experience"] as! Bool == skilled {
			result += 1
		}
	}
	
	return result
}


func teamsWithLackOfPlayersIndexes(threshold: Int, skilled: Bool) -> [Int] {
	
	var result: [Int] = []
	
	for i in 0..<teams.count {
		
		if playersCountBySkill(teams[i], skilled: skilled) < threshold {
			
			result.append(i)
		}
	}
	
	return result
}

func candidateTeam(player: [String: AnyObject], team: [[String: AnyObject]]) -> [[String: AnyObject]] {
	
	var candidateTeam: [[String: AnyObject]] = []
	candidateTeam.append(player)
	candidateTeam += team
	
	return candidateTeam
}

func teamWithMinimumHeightDeviationIndex(player: [String: AnyObject], indexes: [Int]) -> Int {
	
	
	
	var tempTeam: [[String: AnyObject]] = []
	tempTeam.append(player)
	tempTeam += teams[indexes[0]]
	
	var currentMin = abs(getPlayersAvgHeight(soccerLeague) - getPlayersAvgHeight(tempTeam))
	var minDeviationTeamIndex = indexes[0]
	
	for index in indexes {
		
		tempTeam = []
		tempTeam.append(player)
		tempTeam += teams[index]
		
		let tempMin = abs(getPlayersAvgHeight(soccerLeague) - getPlayersAvgHeight(tempTeam))
		
		if tempMin < currentMin {
			
			currentMin = tempMin
			minDeviationTeamIndex = index
		}
	}
	
	return minDeviationTeamIndex
}

func teamWithMinimumHeightDeviationIndexNotExceeding(threshold inches: Double, player: [String: AnyObject], indexes: [Int]) -> Int? {
	
	var tempTeam: [[String: AnyObject]] = []
	tempTeam.append(player)
	tempTeam += teams[indexes[0]]
	
	var currentMin = abs(getPlayersAvgHeight(soccerLeague) - getPlayersAvgHeight(tempTeam))
	var minDeviationTeamIndex = indexes[0]
	
	for index in indexes {
		
		tempTeam = []
		tempTeam.append(player)
		tempTeam += teams[index]
		
		let tempMin = abs(getPlayersAvgHeight(soccerLeague) - getPlayersAvgHeight(tempTeam))
		
		if tempMin < currentMin {
			
			currentMin = tempMin
			minDeviationTeamIndex = index
		}
	}
	
	if currentMin <= inches {
		
		return minDeviationTeamIndex
		
	} else {
	
		return nil
	}
}

func distributeWithin(threshold inches: Double, undistributed players: [[String: AnyObject]]) {
	
	let skilledPlayersPerTeamTarget = playersCountBySkill(soccerLeague, skilled: true) / teams.count
	let newbiePerTeamTarget = soccerLeague.count / teams.count - skilledPlayersPerTeamTarget
	
	var undistributedPlayers: [[String: AnyObject]] = []
	
	for player in players {
		
		let skilled = player["Experience"] as! Bool
		
		let playerCountTarget: Int = skilled ? skilledPlayersPerTeamTarget : newbiePerTeamTarget
		
		let candidateTeamsIndexes = teamsWithLackOfPlayersIndexes(playerCountTarget, skilled: skilled)
		
		if let teamIndex = teamWithMinimumHeightDeviationIndexNotExceeding(threshold: 1.5, player: player, indexes: candidateTeamsIndexes) {
			
			teams[teamIndex].append(player)
			
		} else {
			
			undistributedPlayers.append(player)
		}
	}
	
	//Evaluate to avoid infinite recursion if undistributed players count didn't change
	if(undistributedPlayers.count < players.count && undistributedPlayers.count > 0) {
	
		distributeWithin(threshold: inches, undistributed: undistributedPlayers)
		
	} else {
		
		//Since kid is undistributable within 1.5 inch threshold, force distribution to the team with minimal height deviation.
		distributeWithMinimumHeightDeviation(undistributedPlayers)
	}
	
}


func distributeWithMinimumHeightDeviation(players: [[String: AnyObject]]) {
	
	let skilledPlayersPerTeamTarget = playersCountBySkill(soccerLeague, skilled: true) / teams.count
	let newbiePerTeamTarget = soccerLeague.count / teams.count - skilledPlayersPerTeamTarget
	
	for player in players {
		
		//Getting player's experience
		let skilled = player["Experience"] as! Bool
		
		//Getting the number of required players by given type
		let playerCountTarget: Int = skilled ? skilledPlayersPerTeamTarget : newbiePerTeamTarget
		
		//Getting an array of indexes of uncomplete teams.
		//It is safe to assume the array would have at least 1 element at this point with a strongly-typed collection of given specification of players:
		//entire collection and skilled players are both evenly divisible by the number of teams.
		let candidateTeamsIndexes = teamsWithLackOfPlayersIndexes(playerCountTarget, skilled: skilled)
		
		//Picking an array index of team with minimum height deviation AFTER the candidate would have been potentially added to it
		let teamIndex = teamWithMinimumHeightDeviationIndex(player, indexes: candidateTeamsIndexes)
		//Distribute player to the team with minimal Height deviation.
		teams[teamIndex].append(player)
	}
}

func distribute() {
	
	let skilledPlayersPerTeamTarget = playersCountBySkill(soccerLeague, skilled: true) / teams.count
	let newbiePerTeamTarget = soccerLeague.count / teams.count - skilledPlayersPerTeamTarget
	
	for player in soccerLeague {
		
		//Getting player's experience
		let skilled = player["Experience"] as! Bool
		
		//Getting the number of required players by given type
		let playerCountTarget: Int = skilled ? skilledPlayersPerTeamTarget : newbiePerTeamTarget
		
		//Getting an array of indexes of uncomplete teams
		let candidateTeamsIndexes = teamsWithLackOfPlayersIndexes(playerCountTarget, skilled: skilled)
		
		//Distribute player to the first available team. It is safe to assume the array would have at least 1 element at this point with a strongly-typed collection of given specification of players: entire collection and skilled players are both evenly divisible by the number of teams.
		teams[candidateTeamsIndexes[0]].append(player)
	}
}

//Distribute not considering height deviation

distribute()

sharks = teams[0]
dragons = teams[1]
raptors = teams[2]

getPlayersAvgHeight(sharks) - getPlayersAvgHeight(soccerLeague)
getPlayersAvgHeight(dragons) - getPlayersAvgHeight(soccerLeague)
getPlayersAvgHeight(raptors) - getPlayersAvgHeight(soccerLeague)

playersCountBySkill(sharks, skilled: true)
playersCountBySkill(dragons, skilled: true)
playersCountBySkill(raptors, skilled: true)

playersCountBySkill(sharks, skilled: false)
playersCountBySkill(dragons, skilled: false)
playersCountBySkill(raptors, skilled: false)


teams = [sharks,dragons,raptors]

//Distribute with minimizing height deviaton

sharks.removeAll()
dragons.removeAll()
raptors.removeAll()

teams = [sharks,dragons,raptors]

distributeWithMinimumHeightDeviation(soccerLeague)

sharks = teams[0]
dragons = teams[1]
raptors = teams[2]

getPlayersAvgHeight(sharks) - getPlayersAvgHeight(soccerLeague)
getPlayersAvgHeight(dragons) - getPlayersAvgHeight(soccerLeague)
getPlayersAvgHeight(raptors) - getPlayersAvgHeight(soccerLeague)

playersCountBySkill(sharks, skilled: true)
playersCountBySkill(dragons, skilled: true)
playersCountBySkill(raptors, skilled: true)

playersCountBySkill(sharks, skilled: false)
playersCountBySkill(dragons, skilled: false)
playersCountBySkill(raptors, skilled: false)


//Distribute with minimizing height deviaton within threshold

sharks.removeAll()
dragons.removeAll()
raptors.removeAll()

teams = [sharks,dragons,raptors]

distributeWithin(threshold: 1.5, undistributed: soccerLeague)

sharks = teams[0]
dragons = teams[1]
raptors = teams[2]

getPlayersAvgHeight(sharks)
getPlayersAvgHeight(dragons)
getPlayersAvgHeight(raptors)

getPlayersAvgHeight(sharks) - getPlayersAvgHeight(soccerLeague)
getPlayersAvgHeight(dragons) - getPlayersAvgHeight(soccerLeague)
getPlayersAvgHeight(raptors) - getPlayersAvgHeight(soccerLeague)

playersCountBySkill(sharks, skilled: true)
playersCountBySkill(dragons, skilled: true)
playersCountBySkill(raptors, skilled: true)

playersCountBySkill(sharks, skilled: false)
playersCountBySkill(dragons, skilled: false)
playersCountBySkill(raptors, skilled: false)





