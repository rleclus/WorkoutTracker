//
//  Workout.swift
//  WorkoutTracker
//
//  Created by Robert le Clus on 2025/06/05.
//

import Foundation

struct Workout {
  var start: Date
  var end: Date
  
  init(start: Date, end: Date) {
	self.start = start
	self.end = end
  }
  
  var duration: TimeInterval {
	return end.timeIntervalSince(start)
  }
  
  var totalEnergyBurned: Double {
	let caloriesPerHour: Double = 450
	let hours: Double = duration/3600
	let totalCalories = caloriesPerHour * hours
	return totalCalories
  }
}

