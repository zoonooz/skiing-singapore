//
//  Ski.swift
//
//
//  Created by Amornchai Kanokpullwad on 3/31/2559 BE.
//
//

import Foundation

// MARK:- Util function to get positions

func top(map: [[String]], _ x: Int, _ y: Int) -> (x: Int, y: Int)? {
    return x == 0 ? nil : (x - 1, y)
}

func bot(map: [[String]], _ x: Int, _ y: Int) -> (x: Int, y: Int)? {
    return x >= map.count - 1 ? nil : (x + 1, y)
}

func left(map: [[String]], _ x: Int, _ y: Int) -> (x: Int, y: Int)? {
    return y == 0 ? nil : (x, y - 1)
}

func right(map: [[String]], _ x: Int, _ y: Int) -> (x: Int, y: Int)? {
    return y >= map[x].count - 1 ? nil : (x, y + 1)
}

/*
 * Return the arrow according to conditions and order of direction [Top, Right, Bottom, Left]
 */
func findInputOutput(value: String, _ directions: [String?],
                     _ arrows: [String], _ condition: (Int, Int) -> Bool) -> String
{
    var string = ""
    for (i, d) in directions.enumerate() {
        if let v = Int(value) {
            let canIn = d.map{ Int($0) }?.map{ condition(v, $0) } ?? false
            if canIn {
                string += arrows[i]
            }
        }
    }
    return string
}

// MARK:-

/**
 * Input file to array 2 dimensions
 */
func fileToTheMap(path: String) -> [[String]] {
    var map: [[String]] = []
    if let content = try? NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) {
        content.enumerateLinesUsingBlock { line, stop in
            let row = line.componentsSeparatedByString(" ")
            map.append(row)
        }
    }
    map.removeFirst()
    return map
}

/*
 * Find way in-out of every node
 * change string of node to be in this format "in1,in2,out1,out2,length,last" if there is a way in
 * Keep the number only if no way in
 * using these char →,←,↑,↓ to indicate the way in and out
 */
func mapToPaths(theMap: [[String]]) -> [[String]] {
    var paths = theMap
    for (i, row) in theMap.enumerate() {
        for (j, item) in row.enumerate() {
            let t = top(theMap, i, j).map { theMap[$0.x][$0.y] }
            let r = right(theMap, i, j).map { theMap[$0.x][$0.y] }
            let b = bot(theMap, i, j).map { theMap[$0.x][$0.y] }
            let l = left(theMap, i, j).map { theMap[$0.x][$0.y] }
            let directions = [
                t, r, b, l
            ]
            let input = findInputOutput(item, directions, ["↓", "←", "↑", "→"]) { $0 < $1 }
            let output = findInputOutput(item, directions, ["↑", "→", "↓", "←"]) { $0 > $1 }

            if input.characters.count > 0 {
                var length = "?" // dont know yet
                var last = "?" // dont know yet
                if output.characters.count == 0 {
                    length = "1"
                    last = "\(item)"
                }
                paths[i][j] = "\(input),\(output),\(length),\(last)"
            }
        }
    }
    return paths
}

/*
 * Recursive to find best path for every number node
 * then find the steepest & longest and return
 */
func pathsToBest(thePaths: [[String]]) -> (length: Int, size: Int) {
    var finalMap = thePaths
    var nodeTravelled = 0

    func max(data: [(l: Int, ls: Int)]) -> (l: Int, ls: Int) {
        var mx: (l: Int, ls: Int) = (0, 0)
        for d in data {
            if d.l > mx.l { mx = d } else if (d.l == mx.l) { if d.ls < mx.ls { mx = d } }
        }
        return mx
    }

    func travelPaths(i: Int, _ j: Int) -> (l: Int, ls: Int) {
        nodeTravelled += 1
        let t = top(finalMap, i, j)
        let r = right(finalMap, i, j)
        let b = bot(finalMap, i, j)
        let l = left(finalMap, i, j)
        let directions = [(t,"↑"), (r,"→"), (b,"↓"), (l,"←")]
            .filter { d in
                if let pos = d.0 {
                    return finalMap[pos.x][pos.y].componentsSeparatedByString(",")[0].containsString(d.1)
                }
                return false
            }.map { (d, _) -> (l: Int, ls: Int) in
                let direction = d!
                let x = direction.x
                let y = direction.y
                let data = finalMap[x][y].componentsSeparatedByString(",")
                if data[2] == "?" {
                    let best = travelPaths(x, y)
                    finalMap[x][y] = "\(data[0]),\(data[1]),\(best.l),\(best.ls)"
                    return best
                }
                return (l: Int(data[2])!, ls: Int(data[3])!)
            }

        let bestPath = max(directions)
        let last = bestPath.ls
        let length = bestPath.l + 1

        return (l: length, ls: last)
    }

    var drop = 0
    var length = 0
    var availableNum = 0

    for (i, row) in thePaths.enumerate() {
        for (j, item) in row.enumerate() {
            // start only when it is number
            if let num = Int(item) {
                availableNum += 1
                let resultForNum = travelPaths(i, j)
                if resultForNum.l > length {
                    length = resultForNum.l
                    drop = num - resultForNum.ls
                } else if (resultForNum.l == length) {
                    let newDrop = num - resultForNum.ls
                    if newDrop > drop { drop = newDrop }
                }
            }
        }
    }

    print("nodes travelled:\(nodeTravelled)")
    print("number for start:\(availableNum)")
    return (length: length, size: drop)
}

let startTime = NSDate()
print(pathsToBest(mapToPaths(fileToTheMap("map2.txt"))))
print("time used \(abs(startTime.timeIntervalSinceNow))")
