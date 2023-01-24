import shared
import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        NavigationView {
            listView()
                .navigationBarTitle("SpaceX Launches")
                .navigationBarItems(trailing:
                    Button("Reload") {
                        self.viewModel.loadLaunches(forceReload: true)
                    })
        }
    }

    private func listView() -> AnyView {
        switch viewModel.launches {
        case .loading:
            return AnyView(Text("Loading...").multilineTextAlignment(.center))
        case .result(let launches):
            return AnyView(List(launches) { launch in
                RocketLaunchRow(rocketLaunch: launch)
            })
        case .error(let description):
            return AnyView(Text(description).multilineTextAlignment(.center))
        }
    }
}

extension RocketLaunch_: Identifiable {}

struct RocketLaunchRow: View {
    var rocketLaunch: RocketLaunch_

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10.0) {
                Text("Launch name: \(rocketLaunch.missionName)")
                Text(launchText).foregroundColor(launchColor)
                Text("Launch year: \(String(rocketLaunch.launchYear))")
                Text("Launch details: \(rocketLaunch.details ?? "")")
            }
            Spacer()
        }
    }
}

extension RocketLaunchRow {
    private var launchText: String {
        if let isSuccess = rocketLaunch.launchSuccess {
            return isSuccess.boolValue ? "Successful" : "Unsuccessful"
        } else {
            return "No data"
        }
    }

    private var launchColor: Color {
        if let isSuccess = rocketLaunch.launchSuccess {
            return isSuccess.boolValue ? Color.green : Color.red
        } else {
            return Color.gray
        }
    }
}

extension ContentView {
    enum LoadableLaunches {
        case loading
        case result([RocketLaunch_])
        case error(String)
    }

    class ViewModel: ObservableObject {
        @Published var launches: LoadableLaunches = .loading

        let sdk: SpaceXSDK

        init(sdk: SpaceXSDK) {
            self.sdk = sdk
            loadLaunches(forceReload: false)
        }

        func loadLaunches(forceReload: Bool) {
            launches = .loading
            sdk.getLaunches(forceReload: forceReload, completionHandler: { data, error in
                if let data = data {
                    self.launches = .result(data)
                } else {
                    self.launches = .error(error?.localizedDescription ?? "error")
                }
            })
        }
    }
}
