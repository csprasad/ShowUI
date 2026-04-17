//
//
//  12_CBReal-WorldPatterns.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `17/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
internal import Combine

// MARK: - LESSON 12: Real-World Patterns
struct CBRealWorldVisual: View {
    @State private var selectedDemo   = 0
    @State private var searchText     = ""
    @State private var searchResults: [String] = []
    @State private var isSearching    = false
    @State private var cancellables   = Set<AnyCancellable>()
    @State private var searchSubject  = PassthroughSubject<String, Never>()

    @State private var username   = ""
    @State private var email      = ""
    @State private var password   = ""
    @State private var isFormValid = false

    let demos = ["Search debounce", "Form validation", "Cancellation & leaks"]
    let allItems = ["Apple", "Apricot", "Avocado", "Banana", "Blueberry", "Cherry", "Date",
                    "Elderberry", "Fig", "Grape", "Guava", "Kiwi", "Lemon", "Lime", "Mango"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Real-world patterns", systemImage: "building.columns.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cbOrange)

                tabSelector(demos: demos, selected: $selectedDemo)

                switch selectedDemo {
                case 0: searchView
                case 1: formValidationView
                default: cancellationView
                }
            }
        }
        .onAppear { setupSearch() }
    }

    var searchView: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                TextField("Search fruits…", text: $searchText)
                    .textFieldStyle(.plain).font(.system(size: 13))
                    .autocorrectionDisabled().textInputAutocapitalization(.never)
                    .onChange(of: searchText) { _, v in searchSubject.send(v) }
                if isSearching { ProgressView().scaleEffect(0.75) }
                if !searchText.isEmpty {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill").foregroundStyle(Color(.systemGray3))
                    }.buttonStyle(PressableButtonStyle())
                }
            }
            .padding(.horizontal, 12).padding(.vertical, 9)
            .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))

            // Results
            if !searchResults.isEmpty {
                ForEach(searchResults, id: \.self) { item in
                    HStack(spacing: 8) {
                        Image(systemName: "leaf.fill").foregroundStyle(Color.formGreen).font(.system(size: 12))
                        Text(item).font(.system(size: 13))
                        Spacer()
                    }
                    .padding(.horizontal, 10).padding(.vertical, 7)
                    .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 8))
                }
            } else if !searchText.isEmpty && !isSearching {
                Text("No results for \"\(searchText)\"").font(.system(size: 12)).foregroundStyle(.secondary)
            }

            HStack(spacing: 6) {
                Image(systemName: "info.circle.fill").foregroundStyle(Color.cbOrange).font(.system(size: 11))
                Text("debounce 300ms + removeDuplicates - try typing quickly vs slowly")
                    .font(.system(size: 11)).foregroundStyle(.secondary)
            }
            .padding(7).background(Color.cbOrangeLight).clipShape(RoundedRectangle(cornerRadius: 7))
        }
    }

    var formValidationView: some View {
        VStack(spacing: 8) {
            // Fields
            VStack(spacing: 8) {
                validatedField(icon: "person.fill", placeholder: "Username (min 3)", text: $username,
                               isValid: username.count >= 3 || username.isEmpty)
                validatedField(icon: "envelope.fill", placeholder: "Email", text: $email,
                               isValid: email.contains("@") || email.isEmpty)
                validatedField(icon: "lock.fill", placeholder: "Password (min 8)", text: $password,
                               isValid: password.count >= 8 || password.isEmpty, isSecure: true)
            }
            .onChange(of: username) { _, _ in validateForm() }
            .onChange(of: email)    { _, _ in validateForm() }
            .onChange(of: password) { _, _ in validateForm() }

            // Submit button
            Button("Create Account") { }
                .font(.system(size: 14, weight: .semibold)).foregroundStyle(.white)
                .frame(maxWidth: .infinity).padding(.vertical, 12)
                .background(isFormValid ? Color.cbOrange : Color(.systemGray4))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .buttonStyle(PressableButtonStyle())
                .disabled(!isFormValid)
                .animation(.spring(response: 0.3), value: isFormValid)

            PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: "// combineLatest - form valid when ALL fields pass\nPublishers.CombineLatest3($username, $email, $password)\n    .map { u, e, p in\n        u.count >= 3 && e.contains(\"@\") && p.count >= 8\n    }\n    .assign(to: &$isFormValid)")
        }
    }

    var cancellationView: some View {
        VStack(spacing: 8) {
            ForEach([
                ("✓ Store in Set<AnyCancellable>", Color.formGreen,
                 "var bag = Set<AnyCancellable>()\npublisher.sink { }.store(in: &bag)\n// Cancelled when object deinits"),
                ("✓ assign(to: &$prop)", Color.formGreen,
                 "publisher.assign(to: &$title)\n// No retain cycle, no stored token needed"),
                ("✗ Discard token", Color.animCoral,
                 "// BAD: subscription immediately cancelled\n_ = publisher.sink { print($0) }  // silence!\npublisher.sink { print($0) }       // also cancelled!"),
                ("⚠ assign(to:on:self) retain cycle", Color.animAmber,
                 "// BAD in class: strong ref to self\npublisher.assign(to: \\.x, on: self)\n// Use assign(to: &$x) instead"),
            ], id: \.0) { title, color, code in
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(.system(size: 10, weight: .semibold)).foregroundStyle(color)
                    Text(code).font(.system(size: 8, design: .monospaced)).foregroundStyle(color)
                        .padding(5).background(color.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 5))
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8).background(Color(.systemFill).opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 8))
            }

            PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: "// Cancel manually\nlet token = publisher.sink { ... }\ntoken.cancel()  // stop receiving now\n\n// withLatestFrom pattern (Combine lacks it - simulate):\nlet combined = buttonTaps.withLatestFrom(currentState)")
        }
    }
    
    func setupSearch() {
        searchSubject
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .handleEvents(receiveOutput: { q in
                if !q.isEmpty { isSearching = true }
            })
            .map { query -> [String] in
                guard !query.isEmpty else { return [] }
                return allItems.filter { $0.localizedCaseInsensitiveContains(query) }
            }
            .handleEvents(receiveOutput: { _ in isSearching = false })
            .sink { results in
                self.searchResults = results
            }
            .store(in: &cancellables)
    }

    func validateForm() {
        let usernameValid = username.count >= 3
        let emailValid    = email.contains("@") && email.contains(".")
        let passwordValid = password.count >= 8
        withAnimation { isFormValid = usernameValid && emailValid && passwordValid }
    }

    func validatedField(icon: String, placeholder: String, text: Binding<String>, isValid: Bool, isSecure: Bool = false) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon).foregroundStyle(.secondary).frame(width: 16)
            if isSecure {
                SecureField(placeholder, text: text).font(.system(size: 13))
            } else {
                TextField(placeholder, text: text).font(.system(size: 13))
                    .autocorrectionDisabled().textInputAutocapitalization(.never)
            }
            if !text.wrappedValue.isEmpty {
                Image(systemName: isValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(isValid ? Color.formGreen : Color.animCoral)
                    .font(.system(size: 14))
                    .animation(.spring(response: 0.2), value: isValid)
            }
        }
        .padding(.horizontal, 12).padding(.vertical, 10)
        .background(Color(.systemFill)).clipShape(RoundedRectangle(cornerRadius: 10))
    }

    func tabSelector(demos: [String], selected: Binding<Int>) -> some View {
        HStack(spacing: 8) {
            ForEach(demos.indices, id: \.self) { i in
                Button {
                    withAnimation(.spring(response: 0.3)) { selected.wrappedValue = i }
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

struct CBRealWorldExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Real-world Combine patterns")
            Text("The most useful patterns: search with debounce+removeDuplicates+flatMap, form validation with combineLatest, and cancellation management. These three patterns cover 80% of real-world Combine usage in iOS apps.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "Search: $searchText.debounce().removeDuplicates().filter{count>=2}.flatMap{search($0)}.assign(to:)", color: .cbOrange)
                StepRow(number: 2, text: "Form: Publishers.CombineLatest3($f1,$f2,$f3).map{all valid}.assign(to: &$isValid)", color: .cbOrange)
                StepRow(number: 3, text: "Cancellation: .store(in: &bag) - bag lives on object. Deinit → all cancelled.", color: .cbOrange)
                StepRow(number: 4, text: "Retain cycle: assign(to:on:self) holds strong reference. Prefer assign(to: &$prop).", color: .cbOrange)
                StepRow(number: 5, text: "Combine vs async/await: use Combine for complex multi-publisher logic. Use async/await for sequential async calls.", color: .cbOrange)
            }

            CalloutBox(style: .info, title: "Combine vs async/await (iOS 15+)", contentBody: "async/await is better for: sequential async operations, simple network calls, task cancellation. Combine is better for: combining multiple publishers (combineLatest, merge), debounce/throttle, complex operator chains, @Published bindings. Both coexist via AsyncPublisher and publishers with .values.")

            CodeBlock(code: """
// Search pipeline - complete production pattern
class SearchViewModel: ObservableObject {
    @Published var query   = ""
    @Published var results = [Item]()
    @Published var isLoading = false
    private var bag = Set<AnyCancellable>()

    init() {
        $query
            .debounce(for: .milliseconds(350), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { $0.count >= 2 }
            .handleEvents(receiveOutput: { _ in self.isLoading = true })
            .flatMap { [weak self] q -> AnyPublisher<[Item], Never> in
                guard let self else { return Just([]).eraseToAnyPublisher() }
                return self.search(q)
                    .catch { _ in Just([]) }
                    .eraseToAnyPublisher()
            }
            .receive(on: RunLoop.main)
            .handleEvents(receiveOutput: { _ in self.isLoading = false })
            .assign(to: &$results)
    }
}

// Bridge to async/await
let values = publisher.values  // AsyncPublisher
for await value in values { ... }
""")
        }
    }
}

