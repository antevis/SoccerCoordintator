
import Foundation

var soccerLeague: [[String: AnyObject]] = []


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


let height = "Height"
let experienced = "Experience"
let threshold = 1.5

var sharks: [[String: AnyObject]] = []
var dragons: [[String: AnyObject]] = []
var raptors: [[String: AnyObject]] = []
var dolphins: [[String: AnyObject]] = []

var teams: [[[String: AnyObject]]] = [sharks, dragons, raptors]
//teams.append(dolphins)


func distribute(players: [[String: AnyObject]], withinInches threshold: Double?) {
	
	var undistributedPlayers: [[String: AnyObject]] = []
	
	for player in players {
		
		let teamIndexes = getSuitableTeamsFor(player, withinInches: threshold)
		
		if teamIndexes.count > 0 {
		
			teams[teamIndexes[0]].append(player)
			
		} else {
			
			undistributedPlayers.append(player)
		}
	}
	
	//Recursive distribution. Relying on the fact that following distributions would affect teams' avg height and let undistributed fit within threshold
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
func allTeamsIndexes() -> [Int] {
	
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
			if player[experienced] as! Bool == skilled {
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



func getLeastPopulatedTeamsIndexesByType(teamsIndexes: [Int], skilled: Bool?) -> [Int] {
	
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

//a 'virtual' team with the candidate player added. Used to avaulate parameters after potential player's distribution to it.
func virtualTeam(player: [String: AnyObject], team: [[String: AnyObject]]) -> [[String: AnyObject]] {
	
	var virtualTeam = team
	virtualTeam.append(player)
	
	return virtualTeam
}

func getLeastHeightDeviationTeamsIndexes(player: [String: AnyObject], teamsIndexes: [Int], threshold: Double?) -> [Int] {
	
	var result: [Int] = []
	
	var heightDeviationByTeam: [Int: Double] = [:]
	
	for i in 0..<teamsIndexes.count {
		
		let vTeam = virtualTeam(player, team: teams[teamsIndexes[i]])
		
		let deviation = abs(getPlayersMeanHeight(soccerLeague) - getPlayersMeanHeight(vTeam))
		
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


func fillArrayBy(criteria: Double, dict: [Int: Double]) -> [Int]{
	
	var result: [Int] = []
	
	for item in dict {
		
		if item.1 == criteria {
			
			result.append(item.0)
		}
	}
	
	return result
}



func getSuitableTeamsFor(player: [String: AnyObject], withinInches threshold: Double?) -> [Int] {
	
	//The idea is to get an array of indexes of teams with equal conditions where kid could be potentially distributed, and pick the first ([0]) element.
	//To ensure guaranteed distribution, there must be at least 1 element. This is being achived with the threshold declared as optional, when distribution eventually recurse to the situation when threshold been dropped.
	//Excluding the first few steps, in general it's going to be an array of not more than 1 element
	
	let skilled = player[experienced] as! Bool
	
	var teamsIndexes: [Int] = allTeamsIndexes()
	
	if skilled {
		
		//1. Pick an array of teams' indexes with the least number of skilled players
		teamsIndexes = getLeastPopulatedTeamsIndexesByType(teamsIndexes, skilled: true)
		
	}
	
	//2. From that array, pick an array of teams with the least number of total players
	teamsIndexes = getLeastPopulatedTeamsIndexesByType(teamsIndexes, skilled: nil)
	
	//3. From that array, pick an array of teams with the least height deviaton (optionally less than threshold) from other teams
	//AFTER player possible distribution to the team.
	//This 'would-be' distribution probably won't affect the height deviation, but we don't take chances.
	teamsIndexes = getLeastHeightDeviationTeamsIndexes(player, teamsIndexes: teamsIndexes, threshold: threshold)
	
	return teamsIndexes
}

distribute(soccerLeague, withinInches: 1.5)

sharks = teams[0]
dragons = teams[1]
raptors = teams[2]
//dolphins = teams[3]

playersCountBySkill(sharks, skilled: true)
playersCountBySkill(dragons, skilled: true)
playersCountBySkill(raptors, skilled: true)

playersCountBySkill(sharks, skilled: false)
playersCountBySkill(dragons, skilled: false)
playersCountBySkill(raptors, skilled: false)

let leagueAvgHeight = getPlayersMeanHeight(soccerLeague)

let sharksAvgHeight = getPlayersMeanHeight(sharks)
let dragonsAvgHeight = getPlayersMeanHeight(dragons)
let raptorsAvgheight = getPlayersMeanHeight(raptors)

let sharksHeightDiff = sharksAvgHeight - leagueAvgHeight
let dragonsHeightDiff = dragonsAvgHeight - leagueAvgHeight
let raptorsHeightDiff = raptorsAvgheight - leagueAvgHeight





