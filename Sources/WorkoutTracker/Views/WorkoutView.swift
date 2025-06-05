//
//  WorkoutView.swift
//  WorkoutTracker
//
//  Created by Robert le Clus on 2025/06/04.
//
import SwiftUI

public struct WorkoutView: View {
	@State var isAnimated = false
	@State var workoutTimer = "00:00:00"
	public var body: some View {
		VStack {
			Text("Workout").font(.largeTitle)
			RunningManView(isAnimated: $isAnimated)
			Text(workoutTimer)
				.font(.largeTitle)
				.bold()
				.padding()
			Button {
				isAnimated = true
			} label: {
				Text("Start")
					.padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
					.frame(maxWidth: .infinity)
			}
			.background(.green)
			.foregroundColor(.white)
			.clipShape(RoundedRectangle(cornerRadius: 5))
			.font(.title)
			.padding(EdgeInsets(top:10, leading: 0, bottom: 0, trailing: 0))
			Button {
				isAnimated = false
			} label: {
				Text("Pause")
					.padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
					.frame(maxWidth: .infinity)
			}
			.background(.blue)
			.foregroundColor(.white)
			.clipShape(RoundedRectangle(cornerRadius: 5))
			.font(.title)
			.padding(EdgeInsets(top:10, leading: 0, bottom: 10, trailing: 0))
			Button {
				isAnimated = false
			} label: {
				Text("Stop")
					.padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
					.frame(maxWidth: .infinity)
			}
			.background(.red)
			.foregroundColor(.white)
			.clipShape(RoundedRectangle(cornerRadius: 5))
			.font(.title)
		}
	}
}
#Preview {
	WorkoutView()
}
