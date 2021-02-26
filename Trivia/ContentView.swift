//
//  ContentView.swift
//  Trivia
//
//  Created by Andreas Marsh on 2/22/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var triviaInfo = GetData()
    var body: some View {
        NavigationView {
            List(triviaInfo.trivia) { trivia in
                NavigationLink(destination:
                                ScrollView {
                                    ZStack {
                                        LinearGradient(gradient: Gradient(colors: [Color.init(red: 235/255, green: 64/255, blue: 52/255, opacity: 0.75), Color.init(red: 70/255, green: 52/255, blue: 235/255, opacity: 0.65)]), startPoint: .leading, endPoint: .trailing)
                                            .cornerRadius(50)
                                        VStack {
                                            Text(trivia.answer)
                                                .foregroundColor(.white)
                                                .font(.system(.largeTitle, design: .rounded))
                                                .fontWeight(.bold)
                                                .padding(5)
                                            Spacer()
                                        }
                                    }
                                })
                {
                    ZStack (alignment: .leading){
                        LinearGradient(gradient: Gradient(colors: [Color.init(red: 235/255, green: 64/255, blue: 52/255, opacity: 0.75), Color.init(red: 70/255, green: 52/255, blue: 235/255, opacity: 0.65)]), startPoint: .leading, endPoint: .trailing)
                            .ignoresSafeArea()
                            .cornerRadius(10)
                        HStack (alignment: .center) {
                            Text(trivia.question)
                                .font(.title)
                                .padding(5)
                        }
                    }
                }
            }
            .navigationBarTitle("Trivia Mania 🎮")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

public class GetData: ObservableObject {
    
    @Published var trivia = [DataLayout]()
    init() {
        load()
    }
    
    func load() {
        let dataUrl = URL(string: "https://jservice.io/api/random?count=10")!
        let decoder = JSONDecoder()
        URLSession.shared.dataTask(with: dataUrl) {(data,response,error) in
            do {
                if let d = data {
                    let decodedLists = try decoder.decode([DataLayout].self, from: d)
                    DispatchQueue.main.async {
                        self.trivia = decodedLists
                    }
                } else {
                    print("No Data")
                }
            } catch {
                print ("Error")
            }
        }.resume()
    }
}

struct DataLayout: Codable, Identifiable {
    public var id: Int
    public var answer: String
    public var question: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case answer = "answer"
        case question = "question"
    }
}
