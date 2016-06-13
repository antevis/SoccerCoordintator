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


let skilledPlayersPerTeamTarget = playersCountBySkill(soccerLeague, skilled: true) / teams.count
let newbiePerTeamTarget = soccerLeague.count / teams.count - skilledPlayersPerTeamTarget


func distributeWithMinimumHeightDeviation() {
	
	for player in soccerLeague {
		
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


distribute() //Excluding height deviation

teams[0]
teams[1]
teams[2]

getPlayersAvgHeight(teams[0]) - getPlayersAvgHeight(soccerLeague)
getPlayersAvgHeight(teams[1]) - getPlayersAvgHeight(soccerLeague)
getPlayersAvgHeight(teams[2]) - getPlayersAvgHeight(soccerLeague)

playersCountBySkill(teams[0], skilled: true)
playersCountBySkill(teams[1], skilled: true)
playersCountBySkill(teams[2], skilled: true)

playersCountBySkill(teams[0], skilled: false)
playersCountBySkill(teams[1], skilled: false)
playersCountBySkill(teams[2], skilled: false)


teams = [sharks,dragons,raptors]

distributeWithMinimumHeightDeviation() //Distribute with minimizing height deviaton

teams[0]
teams[1]
teams[2]

getPlayersAvgHeight(teams[0]) - getPlayersAvgHeight(soccerLeague)
getPlayersAvgHeight(teams[1]) - getPlayersAvgHeight(soccerLeague)
getPlayersAvgHeight(teams[2]) - getPlayersAvgHeight(soccerLeague)

playersCountBySkill(teams[0], skilled: true)
playersCountBySkill(teams[1], skilled: true)
playersCountBySkill(teams[2], skilled: true)

playersCountBySkill(teams[0], skilled: false)
playersCountBySkill(teams[1], skilled: false)
playersCountBySkill(teams[2], skilled: false)


