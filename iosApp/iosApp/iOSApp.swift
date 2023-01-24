import shared
import SwiftUI

@main
struct iOSApp: App {
    let sdk = SpaceXSDK(databaseDriverFactory: DatabaseDriverFactory())

	var body: some Scene {
		WindowGroup {
            ContentView(viewModel: .init(sdk: sdk))
		}
	}
}
