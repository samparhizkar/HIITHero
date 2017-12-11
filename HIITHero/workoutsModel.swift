//
//  workoutsModel.swift
//  sweatTimer
//
//  Created by Sam Parhizkar on 2017-12-01.
//  Copyright © 2017 Sam Parhizkar. All rights reserved.
//

import Foundation
struct  workoutsModel {
    
    struct workoutData: Codable {
        var suggestedWorkoutNames: [String]
        var selectedWorkoutIndices: [String]
    }
    let workoutsURL = Bundle.main.url(forResource:"WorkoutsProperty List", withExtension: "plist") // location of plist file
    var workouts: workoutData?
    
    mutating func readWorkouts()-> workoutData {
        
        do {
            let data = try Data(contentsOf: workoutsURL!)
            
            let decoder = PropertyListDecoder()
            workouts = try decoder.decode(workoutData.self, from: data)
        } catch {
            // Handle error
            print(error)
        }
        return workouts!
        
    }
    func writeWorkouts (SuggestedMoves:[String], selectionOfMoves: [String]){
        let someworkouts = workoutData(suggestedWorkoutNames: SuggestedMoves, selectedWorkoutIndices: selectionOfMoves)
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        do {
            let data = try encoder.encode(someworkouts)
            try data.write(to: workoutsURL!)
        } catch {
            // Handle error
            print(error)
        }
    }
}
