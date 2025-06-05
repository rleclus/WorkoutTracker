//
//  SwiftUIView.swift
//  WorkoutTracker
//
//  Created by Robert le Clus on 2025/06/05.
//

import SwiftUI

struct PackageImage: View {
	let name: String
	init(name: String) {
		self.name = name
	}
	
    var body: some View {
		if let uiImage = UIImage(named: name, in: .module, compatibleWith: nil) {
			Image(uiImage: uiImage)
		} else {
			Text("No Image")
		}
    }
}

#Preview {
	PackageImage(name:"running_frame_1")
}
