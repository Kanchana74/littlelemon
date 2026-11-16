
import SwiftUI

struct OnboardingView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var showError = false
   
    var isFormValid: Bool {
        let validName = !firstName.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty

        let validLastName = !lastName.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty

        let cleanEmail = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let validEmail = cleanEmail.contains("@")
            && cleanEmail.split(separator: "@").count == 2
            && cleanEmail.split(separator: "@").last?
                .contains(".") == true

        return validName && validLastName && validEmail
    }

    var body: some View {
        VStack(spacing: 20) {

            Text("Little Lemon")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(
                    Color(red: 0.29, green: 0.37, blue: 0.34)
                )

            Text("Create your profile")
                .font(.title2)

            TextField("First name", text: $firstName)
                .textFieldStyle(.roundedBorder)
                .textContentType(.givenName)

            TextField("Last name", text: $lastName)
                .textFieldStyle(.roundedBorder)
                .textContentType(.familyName)

            TextField("Email address", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textContentType(.emailAddress)

            if showError {
                Text("Please enter your name and a valid email.")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button("Next") {
                if isFormValid {
                    UserDefaults.standard.set(
                        firstName.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ),
                        forKey: "firstName"
                    )

                    UserDefaults.standard.set(
                        lastName.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ),
                        forKey: "lastName"
                    )

                    UserDefaults.standard.set(
                        email.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ),
                        forKey: "email"
                    )

                    showError = false
                    isLoggedIn = true                } else {
                    showError = true
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.yellow)
            .foregroundColor(.black)
            .cornerRadius(12)

            Spacer()
        }
        .padding()
       
        }

    }



struct OnboardingSuccessView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 65))
                .foregroundColor(.green)

            Text("Profile saved!")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Welcome to Little Lemon!")
                .font(.title2)
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        OnboardingView()
    }
}

