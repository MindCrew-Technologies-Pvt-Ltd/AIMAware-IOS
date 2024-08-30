//
//  HabitView.swift
//  AImAware
//
//  Created by Suyog on 19/04/24.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//

import SwiftUI

struct HabitView: View {
    @State var firDatabase = DatabaseManager.shared
    @ObservedObject var introProgressTracker = IntroProgressTracker.shared
    @State var habbitArr = [HabbitModel]()
    @State private var isLoading = false
    @State var habitSelect : String
    @State var isHabitSelected = false
    @State var isCompleteAllData = false
    @EnvironmentObject var router: NavigationRouter
    
    var attributedString: AttributedString {
        var attributedString = AttributedString("Hand washing (coming soon)")
        
        // Find the range of "morning" in the attributed string
        if let range = attributedString.range(of: "Hand washing") {
            attributedString[range].foregroundColor = .gray
        }
        
        if let range1 = attributedString.range(of: "(coming soon)") {
            attributedString[range1].foregroundColor = Color("MainTextColor")
        }
        
        return attributedString
    }
    
    var body: some View {
        ZStack{
            VStack(){
                
                HStack() {
                    if router.navPath.count > 0{
                        Button(action: {
                            router.navigateBack()
                        }, label: {
                            Image("back")
                        })
                    }
                    
                    Text("What habit do you want to overcome?").font(.setCustom(fontStyle: .title, fontWeight: .medium))
                        .foregroundColor(Color("MainTextColor"))
                    Spacer()
                }
                //.padding(.leading, 21)
                .padding(.bottom, 16)
                /*Text("What habit do you want to overcome?")
                    .font(.setCustom(fontStyle: .title, fontWeight: .medium))
                    .foregroundColor(Color("MainTextColor"))
                    .multilineTextAlignment(.center)*/
                
                    
                ScrollView{
                    ForEach(habbitArr.indices, id: \.self) { index in
                        Button(action: {
                            if habbitArr[index].name ?? "" != "Hand washing"{
                                habitSelect = habbitArr[index].name ?? ""
                                isHabitSelected = true
                                UserDefaults.standard.setValue(habitSelect, forKey: "HabitSelect")
                                router.navigate(to: .stepToFollowView)
                            }
                            
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color("ListFadeColor"))
                                    .frame(height: 72)
                                HStack{
                                    /*Circle()
                                        .fill(Color("CircleBackColor"))
                                        .frame(width: 40,height: 40)*/
                                    //let imageName = ""
                                    switch habbitArr[index].name ?? "" {
                                      case "Nail biting":
                                        Image("nailBiting")
                                            .resizable()
                                            .frame(width: 40,height: 40)
                                            
                                      case "Skin picking":
                                        Image("skinPicking")
                                            .resizable()
                                            .frame(width: 40,height: 40)
                                            
                                      case "Hand washing":
                                        Image("handWash")
                                            .resizable()
                                            .frame(width: 40,height: 40)
                                            
                                      case "Hair pulling":
                                        Image("hairPulling")
                                            .resizable()
                                            .frame(width: 40,height: 40)
                                            
                                      default:
                                        Image("habitOther")
                                            .resizable()
                                            .frame(width: 40,height: 40)
                                    }
                                    
                                    if habbitArr[index].name ?? "" == "Hand washing"{
                                        Text(attributedString)
                                            .padding(.leading, 16)
                                            .padding(.vertical,25)
                                            .font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                                            //.foregroundColor(Color("MainTextColor"))
                                    }else{
                                        Text(habbitArr[index].name ?? "")
                                            .padding(.leading, 16)
                                            .padding(.vertical,25)
                                            .font(.setCustom(fontStyle: .callout, fontWeight: .medium))
                                            .foregroundColor(Color("MainTextColor"))
                                    }
                                    
                                    
                                    Spacer()
                                    Image("rightArrow")
                                        .padding(.trailing, 16)
                                }.padding(.leading,21)
                            }
                        })
                        
                        
                        /*.fullScreenCover(isPresented: $isHabitSelected, content: {
                            StepsToFollowUIView(habitSelect: $habitSelect).onTapGesture {
                                isHabitSelected = false
                            }
                        })*/
                        
                    }

                }
                //Spacer()
                
            }.padding()
            .navigationBarBackButtonHidden(true)
            .onAppear{
                //isLoading = true
                firDatabase.getAllHabits { habitData, status in
                    habbitArr = habitData
                    habbitArr.append(HabbitModel.init(name: "other"))
                    print(habbitArr)
                    //isLoading = false
                }
            }
            
            /*ActivityIndicatorView(text: "Loading...", isLoading: $isLoading)
            .frame(height: 20)
            .padding()*/
        }
    }
}

#Preview {
    HabitView( habitSelect: "")
}


//struct HabitView: UIViewRepresentable {
//    @Binding var clear:Bool
//    
//    func updateUIView(_ view: HabitView, context: Context) {
//        if clear {
//            canvas.drawing = PKDrawing()
//            self.clear = false // Issue
//        }
//    }
//}
