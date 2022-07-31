//
//  ContentView.swift
//  Pinch
//
//  Created by Natalie Choo on 7/22/22.
//

import SwiftUI


struct ContentView: View {
    //MARK: - PROPERTIES
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    
    func resetImage() {
        return withAnimation(.spring()) {
    
        imageScale = 1
        imageOffset = .zero
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                //MARK: - PAGE ITEM
                Image("magazine-front-cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.linear(duration: 1), value: isAnimating)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                //MARK: DOUBLE TAP
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1 {
                            withAnimation(.spring()) { imageScale = 5
                            }
                        }
                        else {
                            withAnimation(.spring()) {
                                resetImage()
                            }
                        }
                    })
                //MARK: DRAG
                    .gesture(
                    DragGesture()
                        .onChanged { value in
                            withAnimation(.linear(duration:1)) {
                                imageOffset = value.translation
                            }
                        }
                        .onEnded { _ in
                            if imageScale <= 1 {
                                resetImage()
                            }
                        }
                    )
                //MARK: MAGNIFICATION
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)) {
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = value
                                    }
                                    else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                            .onEnded { _ in
                                if imageScale > 5 {
                                    imageScale = 5
                                }
                                else if imageScale <= 1 {
                                    resetImage()
                                }
                            }
                    )
                
            }//ZSTACK
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                isAnimating = true
            })
            //MARK: INFO PANEL
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                , alignment: .top
            )
            .overlay(
                Group {
                    HStack {
                        //SCALE DOWN
                        Button {
                            withAnimation(.spring()) {
                                if imageScale > 1 {
                                    imageScale -= 1
                                    
                                    if imageScale <= 1 {
                                        resetImage()
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        
                        //RESET
                        Button {
                            resetImage()
                            //reset image already has withAnimation(.spring())
                            
                        } label: {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        
                        //SCALE UP
                        Button {
                            withAnimation(.spring()) {
                                if imageScale < 5 {
                                    imageScale += 1
                                    
                                    if imageScale >= 5 {
                                        resetImage()
                                    }
                                }
                            }
                        } label: {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }
                    }
                }
                .padding(.bottom, 30)
                ,alignment: .bottom
            )
        }//NavVIEW
        .navigationViewStyle(.stack)

        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.portrait)
    }
}
