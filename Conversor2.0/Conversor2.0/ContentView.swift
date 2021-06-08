//
//  ContentView.swift
//  Conversor
//
//  Created by gempe on 06/06/21.
//

import SwiftUI



extension View {
        func endEditing(_ force: Bool) {
            UIApplication.shared.windows.forEach { $0.endEditing(force)}
        }
}
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct ContentView: View {
    @State var lbUnit = "Temperatura"
    
    @State var tfValue = ""
    
    @State var btUnit1 = "Celsius"
    
    @State var btUnit2 = "Fahrenheit"
    
    @State var lbResultUnit = "Fahrenheit"
    
    @State var lbResult = "0"
    
    @State var opacityBt1 = 1.0
    
    @State var opacityBt2 = 0.5
    
    @State var dolarData : [DolarData] = []
    
    @State var dolarValue = 0.0
    
    
    func showNext() {
       switch lbUnit {
           case "Temperatura":
                NetworkManager.loadDolarValue(completion: { (data) in
                    self.dolarData = [data]
                    for item in dolarData{
                        if let dolarValueData = Double(item.USDBRL.high){
                            dolarValue = dolarValueData
        
                        }
                    }
                })
                lbUnit = "Peso"
                btUnit1 = "Quilograma"
                btUnit2 = "Libra"
           case "Peso":
                lbUnit = "Moeda"
                btUnit1 = "Real"
                btUnit2 = "Dólar"
           case "Moeda":
                lbUnit = "Distância"
                btUnit1 = "Quilômetro"
                btUnit2 = "Milha"
           default:
                lbUnit = "Temperatura"
                btUnit1 = "Celsius"
                btUnit2 = "Fahrenheit"
       }
    convert()
   }
       
    func convert() {
           
       switch lbUnit {
           case "Temperatura":
               calcTemperature()
           case "Peso":
               calcWeight()
           case "Moeda":
               calcCurrency()
           default:
               calcDistance()
       }
        let result = Double(lbResult)!
        lbResult = String(format: "%.2f", result)
   }
    
    func calcTemperature() {
        guard let temperature = Double(tfValue) else {return}
           if opacityBt1 == 1.0 {
               lbResultUnit = "Fahrenheit"
            lbResult = String(temperature * 1.8 + 32.0)
           } else {
               lbResultUnit = "Celsius"
               lbResult = String((temperature - 32.0) / 1.8)
           }
       }
       
       func calcWeight() {
        guard let weight = Double(tfValue) else {return}
           if opacityBt1 == 1.0 {
               lbResultUnit = "Libras"
               lbResult = String(weight / 2.2046)
           } else {
               lbResultUnit = "Quilogramas"
               lbResult = String(weight * 2.2046)
           }
       }
       func calcCurrency() {
        guard let currency = Double(tfValue) else {return}
           if opacityBt1 == 1.0 {
               lbResultUnit = "Dólar"
               lbResult = String(currency / dolarValue)
           } else {
               lbResultUnit = "Real"
               lbResult = String(currency * dolarValue)
               
           }
       }
           
       func calcDistance() {
        guard let distance = Double(tfValue) else {return}
           if opacityBt1 == 1.0 {
               lbResultUnit = "Milhas"
               lbResult = String(distance / 1.6)
           } else {
               lbResultUnit = "Quilometros"
               lbResult = String(distance * 1.6)
           }
       }
    
    
    var body: some View {

        
        GeometryReader{ view in
            VStack{
                VStack {
                    Spacer()
                    HStack{
                        Spacer()
                        Spacer()
                            
                        Text(lbUnit)
                            .font(Font.system(size: 25))
                            .fontWeight(.light)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding(.leading, 35.0)
                            .padding(.top, 25.0)
                            
                    Spacer()
                    Button(action: showNext) {
                            Text("＞")
                                .foregroundColor(.white)
                    }
                    .padding(.top, 25.0)
                    .padding(.trailing, 15.0)
                        Spacer()
                        
                    }
                    Spacer()
                    TextField("0", text: $tfValue)
                        .padding(.all, 20.0)
                        .font(Font.system(size: 100))
                        .frame(width: 300.0, alignment: .center)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.3)
                        .lineLimit(1)
                  
                    Spacer()
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            opacityBt1 = 1.0
                            opacityBt2 = 0.5
                            hideKeyboard()
                            convert()
                            
                    
                        })
                        {
                            Text(btUnit1)
                                    .foregroundColor(.white)
                                    .font(Font.system(size:20))
                                    .opacity(opacityBt1)
                        }
                        Spacer()
                        Button(action: {
                            opacityBt2 = 1.0
                            opacityBt1 = 0.5
                            hideKeyboard()
                            convert()
                            
                        }) {
                             Text(btUnit2)
                                .foregroundColor(.white)
                                .font(Font.system(size:20))
                                .opacity(opacityBt2)
                        }
                        Spacer()
                    }
                    .padding(.bottom, 30.0)
            
                }
                .frame(width: view.size.width, height: (view.size.height / 2) , alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color.blue)
                .ignoresSafeArea()
                
                VStack{
                    Spacer()
                    Text(lbResult)
                        .font(Font.system(size: 100))
                        .foregroundColor(Color.blue)
                        .padding(/*@START_MENU_TOKEN@*/[.leading, .bottom, .trailing], 20.0/*@END_MENU_TOKEN@*/)
                        .minimumScaleFactor(0.3)
                        .lineLimit(1)
                        
                    Text(lbResultUnit)
                        .font(Font.system(size:25))
                        .fontWeight(.light)
                        .foregroundColor(Color.blue)
                    Spacer()
                    Spacer()
            }
       
            }
        }
        .ignoresSafeArea()
        .ignoresSafeArea(.keyboard)
    }
    
}
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


