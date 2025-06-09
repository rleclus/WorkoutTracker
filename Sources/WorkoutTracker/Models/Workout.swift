//
//  Workout.swift
//  WorkoutTracker
//
//  Created by Robert le Clus on 2025/06/05.
//

import Foundation

public struct Workout: Sendable {
	public let start: Date
	public let end: Date
	public let stepCount: Int
	public let calories: Double
	public init(start: Date, end: Date, stepCount: Int, calories: Double) {
		self.start = start
		self.end = end
		self.stepCount = stepCount
		self.calories = calories
	}
}
