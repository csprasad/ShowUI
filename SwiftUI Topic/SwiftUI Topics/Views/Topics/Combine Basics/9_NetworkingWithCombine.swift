//
//
//  9_NetworkingWithCombine.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `17/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
internal import Combine

// MARK: - LESSON 9: Networking with Combine
struct CBNetworkingVisual: View {
    @State private var selectedDemo = 0
    @State private var simulationState: SimState = .idle
    @State private var log: [LogEntry] = []
    @State private var retryAttempt = 0
    @State private var cancellables = Set<AnyCancellable>()

    enum SimState { case idle, loading, success, failure }
    struct LogEntry: Identifiable { let id = UUID(); let text: String; let color: Color }

    let demos = ["dataTaskPublisher", "Retry & decode", "Full pipeline"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Networking with Combine", systemImage: "network")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cbOrange)

                tabSelector(demos: demos, selected: $selectedDemo)

                switch selectedDemo {
                case 0: dataTaskView
                case 1: retryDecodeView
                default: fullPipelineView
                }
            }
        }
    }

    var dataTaskView: some View {
        VStack(spacing: 8) {
            // Pipeline anatomy
            VStack(spacing: 4) {
                pipelineStep(icon: "network", label: "URLSession.dataTaskPublisher(for: url)", color: .cbOrange,
                             detail: "Publisher<(data: Data, response: URLResponse), URLError>")
                pipelineArrow
                pipelineStep(icon: "exclamationmark.circle", label: ".tryMap { validateStatusCode($0.response) }", color: Color(hex: "#7C3AED"),
                             detail: "Throws if status code is not 200-299")
                pipelineArrow
                pipelineStep(icon: "doc.fill", label: ".map { $0.data }", color: Color(hex: "#0F766E"),
                             detail: "Extract just the Data from the tuple")
                pipelineArrow
                pipelineStep(icon: "curlybraces", label: ".decode(type: [Item].self, decoder: JSONDecoder())", color: Color(hex: "#1D4ED8"),
                             detail: "Decode JSON → Codable model. Failure becomes Error")
                pipelineArrow
                pipelineStep(icon: "arrow.up.to.line", label: ".receive(on: RunLoop.main)", color: .cbOrange,
                             detail: "Hop to main thread for UI update")
                pipelineArrow
                pipelineStep(icon: "tray.fill", label: ".sink / .assign(to: &$items)", color: Color.formGreen,
                             detail: "Final subscriber - update state")
            }
        }
    }

    var retryDecodeView: some View {
        VStack(spacing: 8) {
            // Simulate network
            Button(simulationState == .loading ? "Loading…" : "▶ Simulate network request") {
                guard simulationState != .loading else { return }
                simulateRequest()
            }
            .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
            .frame(maxWidth: .infinity).padding(.vertical, 10)
            .background(simulationState == .loading ? Color(.systemGray4) : Color.cbOrange)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .buttonStyle(PressableButtonStyle()).disabled(simulationState == .loading)

            // Status indicator
            if simulationState != .idle {
                HStack(spacing: 8) {
                    Image(systemName: stateIcon).font(.system(size: 18))
                        .foregroundStyle(stateColor)
                    Text(stateText).font(.system(size: 13, weight: .semibold)).foregroundStyle(stateColor)
                    Spacer()
                    if simulationState == .loading {
                        ProgressView().scaleEffect(0.8)
                    }
                }
                .padding(10)
                .background(stateColor.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .animation(.spring(response: 0.3), value: simulationState)
            }

            // Pipeline log
            VStack(alignment: .leading, spacing: 3) {
                ForEach(log) { entry in
                    HStack(spacing: 5) {
                        Circle().fill(entry.color).frame(width: 6, height: 6)
                        Text(entry.text).font(.system(size: 10)).foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 40, alignment: .topLeading)
            .padding(8).background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))

            PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: ".retry(3)\n    .mapError { AppError.network($0) }\n    .decode(type: Response.self, decoder: JSONDecoder())\n    .catch { _ in Just(Response.empty) }")
        }
    }

    var fullPipelineView: some View {
        VStack(spacing: 8) {
            PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: """
// Complete production-grade network pipeline
func fetchItems(page: Int) -> AnyPublisher<[Item], Never> {
    let url = URL(string: "https://api.example.com/items?page=\\(page)")!

    return URLSession.shared
        .dataTaskPublisher(for: url)
        .retry(3)                         // retry on network error
        .timeout(.seconds(10),            // fail after 10s
                 scheduler: DispatchQueue.global())
        .tryMap { output in
            guard let http = output.response as? HTTPURLResponse,
                  (200...299).contains(http.statusCode)
            else { throw AppError.badStatusCode }
            return output.data
        }
        .decode(type: ItemResponse.self,  // decode JSON
                decoder: JSONDecoder())
        .map(\\.items)                    // extract array
        .mapError { AppError.decode($0) } // unify errors
        .catch { error -> Just<[Item]> in
            logger.error("Fetch failed: \\(error)")
            return Just([])               // graceful fallback
        }
        .receive(on: RunLoop.main)        // main thread delivery
        .eraseToAnyPublisher()            // hide concrete type
}

// Usage
fetchItems(page: 1)
    .handleEvents(
        receiveSubscription: { _ in isLoading = true },
        receiveCompletion:   { _ in isLoading = false }
    )
    .assign(to: &$items)
""")
        }
    }

    var stateIcon: String {
        switch simulationState {
        case .loading: return "arrow.triangle.2.circlepath"
        case .success: return "checkmark.circle.fill"
        case .failure: return "xmark.circle.fill"
        case .idle: return "circle"
        }
    }
    var stateColor: Color {
        switch simulationState {
        case .loading: return .cbOrange
        case .success: return .formGreen
        case .failure: return .animCoral
        case .idle: return .secondary
        }
    }
    var stateText: String {
        switch simulationState {
        case .loading: return "Fetching…"
        case .success: return "✓ Decoded 5 items"
        case .failure: return "✗ Network error - caught"
        case .idle: return ""
        }
    }

    func simulateRequest() {
        simulationState = .loading; log = []
        let steps: [(Double, String, Color)] = [
            (0.2, "dataTaskPublisher started", .cbOrange),
            (0.5, ".retry(2) armed", Color(hex: "#7C3AED")),
            (0.8, "Response received: 200 OK, 1.2KB", Color(hex: "#0F766E")),
            (1.1, ".decode<[Item]> succeeded: 5 items", Color(hex: "#1D4ED8")),
            (1.4, ".receive(on: RunLoop.main) hop", .cbOrange),
            (1.7, "→ assign to $items ✓", Color.formGreen),
        ]
        for (delay, text, color) in steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation { log.append(LogEntry(text: text, color: color)) }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation { simulationState = .success }
        }
    }

    func pipelineStep(icon: String, label: String, color: Color, detail: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon).font(.system(size: 12)).foregroundStyle(color).frame(width: 16)
            VStack(alignment: .leading, spacing: 1) {
                Text(label).font(.system(size: 9, weight: .semibold, design: .monospaced)).foregroundStyle(color)
                Text(detail).font(.system(size: 8)).foregroundStyle(.secondary)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
        .padding(6).background(color.opacity(0.07)).clipShape(RoundedRectangle(cornerRadius: 6))
    }

    var pipelineArrow: some View {
        HStack { Spacer(minLength: 20); Image(systemName: "arrow.down").font(.system(size: 9)).foregroundStyle(.secondary); Spacer() }
    }

    func tabSelector(demos: [String], selected: Binding<Int>) -> some View {
        HStack(spacing: 8) {
            ForEach(demos.indices, id: \.self) { i in
                Button {
                    withAnimation(.spring(response: 0.3)) { selected.wrappedValue = i; log = []; simulationState = .idle }
                } label: {
                    Text(demos[i])
                        .font(.system(size: 11, weight: selected.wrappedValue == i ? .semibold : .regular))
                        .foregroundStyle(selected.wrappedValue == i ? Color.cbOrange : .secondary)
                        .frame(maxWidth: .infinity).padding(.vertical, 7)
                        .background(selected.wrappedValue == i ? Color.cbOrangeLight : Color(.systemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
    }
}

struct CBNetworkingExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Networking with Combine")
            Text("URLSession.dataTaskPublisher returns a Publisher<(Data, URLResponse), URLError>. Chain .retry, .tryMap for status code validation, .decode for JSON, .receive(on: RunLoop.main) for thread safety, and .catch for graceful error handling.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "URLSession.shared.dataTaskPublisher(for: url) - async network request as a publisher.", color: .cbOrange)
                StepRow(number: 2, text: ".retry(3) - retry on failure. Best for transient network errors.", color: .cbOrange)
                StepRow(number: 3, text: ".tryMap - validate HTTP status code. Throws on 4xx/5xx to surface real errors.", color: .cbOrange)
                StepRow(number: 4, text: ".decode(type: T.self, decoder: JSONDecoder()) - parse JSON to Codable model.", color: .cbOrange)
                StepRow(number: 5, text: ".eraseToAnyPublisher() - hide concrete publisher type in function return type.", color: .cbOrange)
                StepRow(number: 6, text: "AnyPublisher<Output, Failure> - the type-erased return type for network functions.", color: .cbOrange)
            }

            CodeBlock(code: """
func fetchUser(id: Int) -> AnyPublisher<User, AppError> {
    URLSession.shared
        .dataTaskPublisher(for: apiURL(for: id))
        .retry(2)
        .tryMap { data, response in
            guard let http = response as? HTTPURLResponse,
                  (200...299).contains(http.statusCode)
            else { throw AppError.badStatus }
            return data
        }
        .decode(type: User.self, decoder: JSONDecoder())
        .mapError { AppError.network($0) }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
}
""")
        }
    }
}
