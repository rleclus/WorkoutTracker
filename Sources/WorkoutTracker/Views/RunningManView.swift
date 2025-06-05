//
//  RunningManView.swift
//  WorkoutTracker
//
//  Created by Robert le Clus on 2025/06/05.
//
import SwiftUI

struct RunningManView: View {
	@Binding var isAnimated: Bool
	var body: some View {
		ZStack {
			RunningManImageView(isAnimated: $isAnimated).overlay {
				Circle().stroke(.black, lineWidth: 10)
			}
		}
	}
}

#Preview {
	RunningManView(isAnimated: Binding.constant(true)).frame(width: 100)
}
