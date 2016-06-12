import UIKit


let sharks: [[String: AnyObject]] = []
var dragons: [[String: AnyObject]] = []
var raptors: [[String: AnyObject]] = []

var teams = [sharks, dragons, raptors]

var skilledPlayers: [[String: AnyObject]] = []
var newbies: [[String: AnyObject]] = []


//Functions
func skilledPlayersCount(team: [[String: AnyObject]]) -> Int {
	
	var result: Int = 0
	
	for player in team {
		
		if player["Experience"] as! Bool {
			result += 1
		}
	}
	
	return result
}

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

func getCurrentMinSkilledCount(teams: [[[String: AnyObject]]]) -> Int {
	
	var currentMin = skilledPlayersCount(teams[0])
	
	for team in teams {
		
		let teamSkilledCount = skilledPlayersCount(team)
		
		if teamSkilledCount < currentMin {
			
			currentMin = teamSkilledCount
		}
	}
	
	return currentMin
}

func splitPlayers(players: [[String: AnyObject]]) {
	
	for player in players{
		
		if player["Experience"] as! Bool {
			
			skilledPlayers.append(player)
			
		} else {
			
			newbies.append(player)
		}
	}
}


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

let soccerLeaguePlayersAvgHeight = getPlayersAvgHeight(soccerLeague)


func distributeSkilled(players: [[String: AnyObject]]) {
	
	for player in players {
		
		//var candidates: [String: AnyObject] = [:]
			
		for i in 0..<teams.count {
			
			let minSkilledCount = getCurrentMinSkilledCount(teams)
			
			let teamSkilledCount = skilledPlayersCount(teams[i])
			
			if (teamSkilledCount <= minSkilledCount)  {
				
				teams[i].append(player)
				
				break
				
			}
		}
	}
}

func distributeNubies(players: [[String: AnyObject]]) {
	
	for player in players {
		
		for i in 0..<teams.count {
			
			if teams[i].count < soccerLeague.count / teams.count {
				
				teams[i].append(player)
				
				break
			}
		}
	}
}

splitPlayers(soccerLeague)

newbies
skilledPlayers

distributeSkilled(skilledPlayers)
distributeNubies(newbies)


teams[0].count
teams[1].count
teams[2].count

teams[0]
teams[1]
teams[2]


skilledPlayersCount(teams[0])
skilledPlayersCount(teams[1])
skilledPlayersCount(teams[2])

getPlayersAvgHeight(teams[0])
getPlayersAvgHeight(teams[1])
getPlayersAvgHeight(teams[2])






