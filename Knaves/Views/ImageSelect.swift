//
//  ImageSelect.swift
//  Knaves
//
//  Created by The Captain on 5/1/21.
//

import SwiftUI

struct ImageSelect: View {
    
    @State var image: Image?
    @State var pickerShowing = false
    @State private var inputImage: UIImage?
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
            
            Button("Select an image") {
                pickerShowing = true
            }
        }
        .sheet(isPresented: $pickerShowing, onDismiss: loadImage) {
            ImagePicker(image: $inputImage)
        }
    }
}

struct ImageSelect_Previews: PreviewProvider {
    static var previews: some View {
        ImageSelect()
    }
}
