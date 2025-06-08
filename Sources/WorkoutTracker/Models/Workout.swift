//
//  Workout.swift
//  WorkoutTracker
//
//  Created by Robert le Clus on 2025/06/05.
//

import Foundation

public struct Workout {
  var start: Date
  var end: Date
  
  public init(start: Date, end: Date) {
	self.start = start
	self.end = end
  }
  
  public var duration: TimeInterval {
	return end.timeIntervalSince(start)
  }
  
  public var totalEnergyBurned: Double {
	let caloriesPerHour: Double = 450
	let hours: Double = duration/3600
	let totalCalories = caloriesPerHour * hours
	return totalCalories
  }
}

