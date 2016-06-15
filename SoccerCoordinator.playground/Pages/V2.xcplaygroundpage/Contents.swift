
import Foundation

//an empty collection variable to hold all the players’ data.
var soccerLeague: [[String: AnyObject]] = []

//manually enter the player data. Although, collection could be declared as constant and initialized in a single statement:
//let soccerLeague: [[String: AnyObject]] = [
//	["Name": "Joe Smith","Height": 42,"Experience": true,"Guardians": "Jim and Jan Smith"],
//	["Name": "Jill Tanner","Height": 36,"Experience": true,"Guardians": "Clara Tanner"],
//	...
//	
//]
soccerLeague.append(["Name": "Joe Smith","Height": 42,"Experience": true,"Guardians": "Jim and Jan Smith"])
soccerLeague.append(["Name": "Jill Tanner","Height": 36,"Experience": true,"Guardians": "Clara Tanner"])
soccerLeague.append(["Name": "Bill Bon","Height": 43,"Experience": true,"Guardians": "Sara and Jenny Bon"])
soccerLeague.append(["Name": "Eva Gordon","Height": 45,"Experience": false,"Guardians": "Wendy and Mike Gordon"])
soccerLeague.append(["Name": "Matt Gill","Height": 40,"Experience": false,"Guardians": "Charles and Sylvia Gill"])
soccerLeague.append(["Name": "Kimmy Stein","Height": 41,"Experience": false,"Guardians": "Bill and Hillary Stein"])
soccerLeague.append(["Name": "Sammy Adams","Height": 45,"Experience": false,"Guardians": "Jeff Adams"])
soccerLeague.append(["Name": "Karl Saygan","Height": 42,"Experience": true,"Guardians": "Heather Bledsoe"])
soccerLeague.append(["Name": "Suzane Greenberg","Height": 44,"Experience": true,"Guardians": "Henrietta Dumas"])
soccerLeague.append(["Name": "Sal Dali","Height": 41,"Experience": false,"Guardians": "Gala Dali"])
soccerLeague.append(["Name": "Joe Kavalier","Height": 39,"Experience": false,"Guardians": "Sam and Elaine Kavalier"])
soccerLeague.append(["Name": "Ben Finkelstein","Height": 44,"Experience": false,"Guardians": "Aaron and Jill Finkelstein"])
soccerLeague.append(["Name": "Diego Soto","Height": 41,"Experience": true,"Guardians": "Robin and Sarika Soto"])
soccerLeague.append(["Name": "Chloe Alaska","Height": 47,"Experience": false,"Guardians": "David and Jamie Alaska"])
soccerLeague.append(["Name": "Arnold Willis","Height": 43,"Experience": false,"Guardians": "Claire Willis"])
soccerLeague.append(["Name": "Phillip Helm","Height": 44,"Experience": true,"Guardians": "Thomas Helm and Eva Jones"])
soccerLeague.append(["Name": "Les Clay","Height": 42,"Experience": true,"Guardians": "Wynonna Brown"])
soccerLeague.append(["Name": "Herschel Krustofski","Height": 45,"Experience": true,"Guardians": "Hyman and Rachel Krustofski"])

let threshold = 1.5

var teams: [[[String: AnyObject]]] = [[], [], []]

//The idea is to get an array of indexes of teams with equal conditions where kid could be potentially distributed, and pick the first ([0]-th) element.
func distribute(players: [[String: AnyObject]], withinInches threshold: Double?) {
	
	var undistributedPlayers: [[String: AnyObject]] = []
	
	for player in players {
		
		let teamIndexes = getSuitableTeamsFor(player, league: players, teams: teams, withinInches: threshold)
		
		if teamIndexes.count > 0 {
		
			teams[teamIndexes[0]].append(player)
			
		} else {
			
			undistributedPlayers.append(player)
		}
	}
	
	//Recursive distribution. Relying on the fact that following distributions would affect teams' mean height and let undistributed fit within threshold
	if undistributedPlayers.count > 0 {
		
		//previous distribution attempt yielded some results,
		if undistributedPlayers.count < players.count {
			
			//trying new distribution with height threshold
			distribute(undistributedPlayers, withinInches: threshold)
			
		//Previous distribution didn't reduce undistributed players' count, thus dropping the threshold
		} else {
			
			//force distribution without threshold, but to a team with a minimal height deviation
			distribute(undistributedPlayers, withinInches: nil)
		}
	}
}

//There's probably a better way to obtain an array of array's indexes
func allTeamsIndexes(teams: [[[String: AnyObject]]]) -> [Int] {
	
	var result: [Int] = []
	
	for i in 0..<teams.count {
		
		result.append(i)
	}
	
	return result
}

func playersCountBySkill(team: [[String: AnyObject]], skilled: Bool?) -> Int {
	
	var result: Int = 0
	
	for player in team {
		
		if let skilled = skilled {
			
			//increment for specific type of player
			if player["Experience"] as! Bool == skilled {
				result += 1
			}
			
		} else {
			
			//increment for any type of player
			result += 1
		}
	}
	
	return result
}

func getPlayersMeanHeight(players: [[String: AnyObject]]) -> Double {
	
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

func mean(values: [Double]) -> Double {
	
	if values.count > 0 {
		
		var total = 0.0
		
		for value in values {
			
			total += value
		}
		
		return total / Double(values.count)
		
	} else {
		
		return 0.0
	}
}

//Auxilliary method to return an [Int] from given [Int: Double] where dictionary values are equal to given criteria
func fillArrayBy(criteria: Double, dict: [Int: Double]) -> [Int] {
	
	var result: [Int] = []
	
	for item in dict {
		
		if item.1 == criteria {
			
			result.append(item.0)
		}
	}
	
	return result
}


func getLeastPopulatedTeamsIndexesByType(teams: [[[String: AnyObject]]], teamsIndexes: [Int], skilled: Bool?) -> [Int] {
	
	var result: [Int] = []
	
	var playerCountByTeam: [Int: Int] = [:]
	
	for i in 0..<teamsIndexes.count {
		
		let skilledCount = playersCountBySkill(teams[teamsIndexes[i]], skilled: skilled)
		
		playerCountByTeam.updateValue(skilledCount, forKey: teamsIndexes[i])
	}
	
	let playerCounts = [Int](playerCountByTeam.values)
	
	let minCount = playerCounts.minElement()
	
	if let minCount = minCount {
		
		for item in playerCountByTeam {
			
			if item.1 == minCount {
				
				result.append(item.0)
			}
		}
	}
	
	return result
}

//a 'virtual' team with the candidate player added. Used to avaulate parameters after potential player's assignment to it.
func virtualTeam(player: [String: AnyObject], team: [[String: AnyObject]]) -> [[String: AnyObject]] {
	
	var virtualTeam = team
	virtualTeam.append(player)
	
	return virtualTeam
}

func getLeastHeightDeviationTeamsIndexes(league: [[String: AnyObject]], player: [String: AnyObject], teamsIndexes: [Int], threshold: Double?, teams: [[[String: AnyObject]]]) -> [Int] {
	
	var result: [Int] = []
	
	var heightDeviationByTeam: [Int: Double] = [:]
	
	for i in 0..<teamsIndexes.count {
		
		let vTeam = virtualTeam(player, team: teams[teamsIndexes[i]])
		
		let deviation = abs(getPlayersMeanHeight(league) - getPlayersMeanHeight(vTeam))
		
		heightDeviationByTeam.updateValue(deviation, forKey: teamsIndexes[i])
	}
	
	let deviations = [Double](heightDeviationByTeam.values)
	
	let minDeviation = deviations.minElement()
	
	if let minDeviation = minDeviation {
		
		if let threshold = threshold {
			
			if minDeviation <= threshold {
				
				//Threshold exists. Filling result with teams' indexes with minimum height deviation not exceeding threshold
				//In theory, there can be multiple teams with the same minimum height deviation, all of them go th the result array.
				//In most cases, it is going to be an array of a single element. In any case, we'll pick first ([0]-th) element.
				result = fillArrayBy(minDeviation, dict: heightDeviationByTeam)
				
			}
			
		} else {
			
			//threshold isn't defined, filling with teams' indexes with minimum height deviations.
			result = fillArrayBy(minDeviation, dict: heightDeviationByTeam)
		}
	}
	
	//The absence of minDeviation signals the inability to obtain minElement from deviations,
	//which can only be due to zero length of the array, which in turn can only be due to zero length of the 'teamsIndexes' function argument.
	
	return result
}


func getSuitableTeamsFor(player: [String: AnyObject], league: [[String: AnyObject]], teams: [[[String: AnyObject]]], withinInches threshold: Double?) -> [Int] {
	
	
	//To ensure guaranteed distribution, there must be at least 1 element. This is being achived with the threshold declared as optional, when distribution eventually recurse to the situation when threshold been dropped.
	//Excluding the first few steps, in general it's going to be an array of not more than 1 element
	
	let skilled = player["Experience"] as! Bool
	
	var teamsIndexes: [Int] = allTeamsIndexes(teams)
	
	if skilled {
		
		//1. Pick an array of teams' indexes with the least number of skilled players
		teamsIndexes = getLeastPopulatedTeamsIndexesByType(teams, teamsIndexes: teamsIndexes, skilled: true)
		
	}
	
	//2. From that array, pick an array of teams with the least number of total players
	teamsIndexes = getLeastPopulatedTeamsIndexesByType(teams, teamsIndexes: teamsIndexes, skilled: nil)
	
	//3. From that array, pick an array of teams with the least height deviaton (optionally less than threshold) from other teams
	//AFTER player possible distribution to the team.
	//This 'would-be' distribution probably won't affect the height deviation, but we don't take chances.
	teamsIndexes = getLeastHeightDeviationTeamsIndexes(league, player: player, teamsIndexes: teamsIndexes, threshold: threshold, teams: teams)
	
	return teamsIndexes
}

func letterTo(guardian: String, playerName: String, team: String, firstPracticeDateTime: String) -> String{
	
	let letter = "Dear \(guardian)!\r\rTo achieve the most even distribution of players, \(playerName) has been placed to \(team), and I am pleased to invite you to the team's first prictice on \(firstPracticeDateTime).\r\rYours sincerely, Soccer team coordinator.\r\r---------------------------------------------------------"
	
	return letter
}

func generateLetters(allTeams: [[String: AnyObject]]) {
	
	for team in allTeams {
		
		if let theTeam = team["Team"] as? [[String: AnyObject]],
			let teamName = team["Team Name"] as? String,
			let fstPracticeDateTime = team["First Team Practice"] as? String {
			
			for player in theTeam {
				
				if let guardian = player["Guardians"] as? String, let playerName = player["Name"] as? String {
					
					let letter = letterTo(guardian, playerName: playerName, team: teamName, firstPracticeDateTime: fstPracticeDateTime)
					
					print(letter)
				}
			}
		}
	}
}


distribute(soccerLeague, withinInches: 1.5)

//Deliberately not included in distribute function logic, due to strong typing of teams' names and practice dates.
let sharksTeam: [String: AnyObject] = ["Team Name": "Sharks", "First Team Practice": "March 17, 3pm", "Team": teams[0]]
let dragonsTeam: [String: AnyObject] = ["Team Name": "Dragons", "First Team Practice": "March 17, 1pm", "Team": teams[1]]
let raptorsTeam: [String: AnyObject] = ["Team Name": "Raptors", "First Team Practice": "March 18, 1pm", "Team": teams[2]]

let allTeams = [sharksTeam, dragonsTeam, raptorsTeam]

generateLetters(allTeams)

teams[0]
teams[1]
teams[2]

playersCountBySkill(teams[0], skilled: true)
playersCountBySkill(teams[1], skilled: true)
playersCountBySkill(teams[2], skilled: true)

playersCountBySkill(teams[0], skilled: false)
playersCountBySkill(teams[1], skilled: false)
playersCountBySkill(teams[2], skilled: false)

let leagueAvgHeight = getPlayersMeanHeight(soccerLeague)

let sharksAvgHeight = getPlayersMeanHeight(teams[0])
let dragonsAvgHeight = getPlayersMeanHeight(teams[1])
let raptorsAvgheight = getPlayersMeanHeight(teams[2])

let sharksHeightDiff = sharksAvgHeight - leagueAvgHeight
let dragonsHeightDiff = dragonsAvgHeight - leagueAvgHeight
let raptorsHeightDiff = raptorsAvgheight - leagueAvgHeight




