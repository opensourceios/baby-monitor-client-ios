//
//  UserDefaults+Onboarding.swift
//  Baby Monitor

import Foundation

extension UserDefaults {

    private static var didShowOnboardingKey = "ONBOARDING_KEY"

    static var didShowOnboarding: Bool {
        get {
            return UserDefaults.standard.bool(forKey: didShowOnboardingKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: didShowOnboardingKey)
        }
    }
}
