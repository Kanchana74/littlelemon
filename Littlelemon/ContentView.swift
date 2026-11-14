import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                Text("Little Lemon")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.29, green: 0.37, blue: 0.34))

                Text("Welcome to Little Lemon!")
                    .font(.title2)

                Text("Discover delicious Mediterranean food.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                NavigationLink("Get Started") {
                    OnboardingView()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.96, green: 0.81, blue: 0.08))
                .foregroundColor(.black)
                .cornerRadius(12)
                .padding(.horizontal, 40)

                Spacer()
            }
            .padding(.top, 80)
        }
    }
}

#Preview {
    ContentView()
}

