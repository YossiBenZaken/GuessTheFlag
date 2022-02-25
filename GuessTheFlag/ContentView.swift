//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Yosef Ben Zaken on 23/02/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore: Bool = false
    @State private var showingEndGame: Bool = false
    @State private var scoreTitle: String = ""
    @State private var scoreMessage: String = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score: Int = 0
    @State private var angle = 0.0
    @State private var hiddenImage = false
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                VStack(spacing:15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            withAnimation {
                                angle += 360
                                hiddenImage.toggle()
                            }
                        } label: {
                                FlagImage(image: countries[number])
                                    .opacity(hiddenImage && number != correctAnswer ? 0.25 : 1)
                                    .rotation3DEffect(.degrees(angle), axis: (x: 0, y: number == correctAnswer ? 1 : -1, z: 0))
                                    .animation(.default, value: angle)

                            
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .font(.title.bold())
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(scoreMessage)
        }
        .alert("Finish!", isPresented: $showingEndGame) {
            Button("Reset Game", action: reset)
        } message: {
            Text("Your Score was \(score)")
        }
        
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            scoreMessage = "Your current score is: \(score)"
        } else {
            scoreTitle = "Wrong"
            scoreMessage = "Wrong! That's the flag of \(countries[number])"
        }
        if score == 8 {
            showingEndGame = true
        } else {
            showingScore = true
        }
    }
    func askQuestion() {
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
        if scoreTitle == "Wrong" {
            score = 0
        }
        hiddenImage.toggle()
    }
    func reset() {
        score = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}
extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct FlagImage: View {
    let image: String
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}
