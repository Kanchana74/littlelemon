//
//  ProfileView.swift
//  Littlelemon
//
//  Created by Kanchana Panditha on 12/11/2026.
//
import SwiftUI
import PhotosUI
import CoreData

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss

    
    @AppStorage("isLoggedIn") private var isLoggedIn = false

   
    @AppStorage("firstName") private var savedFirstName = ""
    @AppStorage("lastName") private var savedLastName = ""
    @AppStorage("email") private var savedEmail = ""
    @AppStorage("phoneNumber") private var savedPhoneNumber = ""

   
    @AppStorage("orderStatuses") private var savedOrderStatuses = true
    @AppStorage("passwordChanges") private var savedPasswordChanges = true
    @AppStorage("specialOffers") private var savedSpecialOffers = true
    @AppStorage("newsletter") private var savedNewsletter = true

   
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phoneNumber = ""

    @State private var orderStatuses = true
    @State private var passwordChanges = true
    @State private var specialOffers = true
    @State private var newsletter = true

    @State private var showSaveConfirmation = false
    @State private var showLogoutConfirmation = false
    @State private var showValidationError = false
    @State private var showDiscardConfirmation = false
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var profileImage: UIImage?


    private var isValid: Bool {
        let name = firstName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let surname = lastName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let address = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        return !name.isEmpty
            && !surname.isEmpty
            && address.contains("@")
            && address.split(separator: "@").count == 2
            && address.split(separator: "@").last?
                .contains(".") == true
    }

    var body: some View {
        Form {

            Section("Personal Information") {

                HStack {
                    Spacer()

                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 85))
                        .foregroundColor(
                            Color(red: 0.29, green: 0.37, blue: 0.34)
                        )

                    Spacer()
                }

                TextField("First name", text: $firstName)
                    .textContentType(.givenName)

                TextField("Last name", text: $lastName)
                    .textContentType(.familyName)

                TextField("Email address", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                TextField("Phone number", text: $phoneNumber)
                    .keyboardType(.phonePad)
            }

            Section("Email Notifications") {
                Toggle("Order statuses", isOn: $orderStatuses)
                Toggle("Password changes", isOn: $passwordChanges)
                Toggle("Special offers", isOn: $specialOffers)
                Toggle("Newsletter", isOn: $newsletter)
            }

            Section {
                Button("Save Changes") {
                    if isValid {
                        saveChanges()
                        showValidationError = false
                        showSaveConfirmation = true
                    } else {
                        showValidationError = true
                    }
                }
                .frame(maxWidth: .infinity)
                .fontWeight(.bold)

                Button("Discard Changes") {
                    loadSavedData()
                    showValidationError = false
                    showDiscardConfirmation = true
                }
                .frame(maxWidth: .infinity)

                if showValidationError {
                    Text("Please enter a first name, last name and valid email.")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }

            Section {
                Button("Log Out", role: .destructive) {
                    showLogoutConfirmation = true
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Personal Information")
        .onAppear {
            loadSavedData()
        }
        .alert("Changes Saved", isPresented: $showSaveConfirmation) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your profile has been updated successfully.")
        }
        .confirmationDialog(
            "Are you sure you want to log out?",
            isPresented: $showLogoutConfirmation,
            titleVisibility: .visible
        ) {
            Button("Log Out", role: .destructive) {
                logout()
            }

            Button("Cancel", role: .cancel) {}
        }
    }

    
    private func loadSavedData() {
        firstName = savedFirstName
        lastName = savedLastName
        email = savedEmail
        phoneNumber = savedPhoneNumber

        orderStatuses = savedOrderStatuses
        passwordChanges = savedPasswordChanges
        specialOffers = savedSpecialOffers
        newsletter = savedNewsletter
    }

    
    private func saveChanges() {
        savedFirstName = firstName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        savedLastName = lastName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        savedEmail = email.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        savedPhoneNumber = phoneNumber

        savedOrderStatuses = orderStatuses
        savedPasswordChanges = passwordChanges
        savedSpecialOffers = specialOffers
        savedNewsletter = newsletter
    }

    private func logout() {
        print("LOGOUT BUTTON PRESSED")

        savedFirstName = ""
        savedLastName = ""
        savedEmail = ""
        savedPhoneNumber = ""

        isLoggedIn = false

        print("Login status after logout:", isLoggedIn)
    }
}

#Preview {
    RootView()
        .environment(
            \.managedObjectContext,
            PersistenceController.shared.container.viewContext
        )
}
