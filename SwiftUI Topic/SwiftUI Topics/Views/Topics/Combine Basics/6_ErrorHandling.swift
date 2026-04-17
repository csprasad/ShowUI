//
//
//  6_ErrorHandling.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `17/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI
internal import Combine

// MARK: - LESSON 6: Error Handling
struct CBErrorHandlingVisual: View {
    @State private var selectedDemo  = 0
    @State private var retryCount    = 0
    @State private var catchResult   = ""
    @State private var mapErrorLog: [String] = []
    @State private var cancellables  = Set<AnyCancellable>()
    let demos = ["catch & retry", "mapError", "replaceError & assert"]

    enum SampleError: Error, LocalizedError {
        case serverDown, timeout, unauthorized
        var errorDescription: String? {
            switch self { case .serverDown: "Server down"; case .timeout: "Timeout"; case .unauthorized: "Unauthorized" }
        }
    }

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("Error handling", systemImage: "exclamationmark.triangle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.cbOrange)

                tabSelector(demos: demos, selected: $selectedDemo)

                switch selectedDemo {
                case 0: catchRetryView
                case 1: mapErrorView
                default: replaceAssertView
                }
            }
        }
    }

    var catchRetryView: some View {
        VStack(spacing: 8) {
            // retry simulator
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.clockwise").foregroundStyle(Color.cbOrange)
                    Text("retry(n) - resubscribe on failure, up to n times").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.cbOrange)
                }

                HStack(spacing: 10) {
                    VStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { i in
                            HStack(spacing: 6) {
                                Image(systemName: retryCount > i ? (retryCount > i ? "xmark.circle.fill" : "circle.dashed") : "circle.dashed")
                                    .foregroundStyle(retryCount > i ? Color.animCoral : Color(.systemGray3))
                                Text("Attempt \(i + 1)").font(.system(size: 11))
                                    .foregroundStyle(retryCount > i ? .primary : .secondary)
                            }
                        }
                        if retryCount >= 3 {
                            HStack(spacing: 6) {
                                Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.formGreen)
                                Text("Success on retry 3").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color.formGreen)
                            }
                        }
                    }

                    Button(retryCount >= 3 ? "↩ Reset" : "Simulate failure") {
                        if retryCount >= 3 { retryCount = 0 }
                        else {
                            withAnimation(.spring(response: 0.4)) { retryCount += 1 }
                        }
                    }
                    .font(.system(size: 12, weight: .semibold)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 9)
                    .background(retryCount >= 3 ? Color.formGreen : Color.animCoral)
                    .clipShape(RoundedRectangle(cornerRadius: 9))
                    .buttonStyle(PressableButtonStyle())
                }
            }
            .padding(8).background(Color.cbOrangeLight.opacity(0.4)).clipShape(RoundedRectangle(cornerRadius: 8))

            // catch
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "lifepreserver.fill").foregroundStyle(Color(hex: "#1D4ED8"))
                    Text("catch - swap error for a fallback publisher").font(.system(size: 11, weight: .semibold)).foregroundStyle(Color(hex: "#1D4ED8"))
                }
                ForEach(SampleError.allCases, id: \.localizedDescription) { err in
                    Button(err.localizedDescription) {
                        withAnimation { catchResult = "Caught: \(err.localizedDescription) → fallback value" }
                    }
                    .font(.system(size: 11)).foregroundStyle(Color(hex: "#1D4ED8"))
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(Color(hex: "#EFF6FF")).clipShape(Capsule())
                    .buttonStyle(PressableButtonStyle())
                }
                if !catchResult.isEmpty {
                    Text(catchResult).font(.system(size: 10)).foregroundStyle(Color.formGreen)
                        .padding(6).background(Color(hex: "#E1F5EE")).clipShape(RoundedRectangle(cornerRadius: 6))
                }
                PlainCodeBlock(fgColor: Color.cbOrange, bgColor: Color.cbOrangeLight, code: "publisher\n    .catch { error in\n        Just(\"fallback value\")  // swap for recovery publisher\n    }\n    .sink { value in ... }  // Failure type is now Never")
            }
            .padding(8).background(Color(hex: "#EFF6FF").opacity(0.6)).clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    var mapErrorView: some View {
        VStack(spacing: 8) {
            Text("mapError - convert error types across pipeline stages").font(.system(size: 11)).foregroundStyle(.secondary)

            VStack(spacing: 6) {
                errorFlowRow("URLError(.notConnectedToInternet)", color: Color(hex: "#E11D48"), arrow: true)
                Text(".mapError { URLError → AppError.network($0.localizedDescription) }")
                    .font(.system(size: 9, design: .monospaced)).foregroundStyle(Color(hex: "#0F766E"))
                    .padding(5).background(Color(hex: "#0F766E").opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 5))
                errorFlowRow("AppError.network(\"The Internet connection…\")", color: Color(hex: "#C2410C"), arrow: false)
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding(8).background(Color.cbOrangeLight).clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(spacing: 6) {
                ForEach([
                    ("mapError { AppError($0) }", "Convert error type to your domain error"),
                    ("tryCatch { … }", "catch that can itself throw - if throws, downstream gets new error"),
                    ("setFailureType(to:)", "Change Failure from Never to a typed error"),
                ], id: \.0) { code, desc in
                    HStack(alignment: .top, spacing: 6) {
                        Text(code).font(.system(size: 9, design: .monospaced)).foregroundStyle(Color.cbOrange).frame(width: 140, alignment: .leading)
                        Text(desc).font(.system(size: 9)).foregroundStyle(.secondary)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(6).background(Color.cbOrangeLight).clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
        }
    }

    var replaceAssertView: some View {
        VStack(spacing: 8) {
            operatorCard2("replaceError(with:)", color: .cbOrange,
                desc: "Absorbs any error and substitutes a default value. Stream completes normally with the default.",
                code: "apiPublisher\n    .replaceError(with: [])  // empty array on error\n    .assign(to: &$items)    // Failure is now Never")

            operatorCard2("assertNoFailure()", color: Color(hex: "#E11D48"),
                desc: "CRASHES in DEBUG if an error occurs. Use to assert a pipeline should never fail - validates assumptions during development.",
                code: "cachedPublisher\n    .assertNoFailure()  // if this fails → fatalError in debug\n    .sink { value in ... }")

            operatorCard2("catch + tryCatch", color: Color(hex: "#7C3AED"),
                desc: "catch provides a single recovery publisher. tryCatch can itself throw - if it does, the downstream receives the new error.",
                code: "publisher\n    .tryCatch { error -> AnyPublisher<T, Error> in\n        guard canRecover(error) else { throw AppError.fatal }\n        return recoveryPublisher()\n    }")
        }
    }

    var sampleCases: [SampleError] { [.serverDown, .timeout, .unauthorized] }

    func operatorCard2(_ name: String, color: Color, desc: String, code: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name).font(.system(size: 11, weight: .semibold, design: .monospaced)).foregroundStyle(color)
            Text(desc).font(.system(size: 10)).foregroundStyle(.secondary)
            Text(code).font(.system(size: 8, design: .monospaced)).foregroundStyle(color)
                .padding(6).background(color.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 5))
        }.frame(maxWidth: .infinity, alignment: .leading)
            .padding(8).background(Color.cbOrangeLight).clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func errorFlowRow(_ text: String, color: Color, arrow: Bool) -> some View {
        HStack(spacing: 6) {
            if arrow { Image(systemName: "arrow.down").font(.system(size: 10)).foregroundStyle(.secondary) }
            Text(text).font(.system(size: 9, design: .monospaced)).foregroundStyle(color)
                .padding(5).background(color.opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 5))
        }
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

extension CBErrorHandlingVisual.SampleError: CaseIterable {}

struct CBErrorHandlingExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: "Error handling in Combine")
            Text("Combine errors are typed - a Publisher<Output, Failure> can only fail with its specific Failure type. This forces explicit handling. catch swaps an error for a recovery publisher. retry resubscribes. replaceError provides a default.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: "catch { error in recoveryPublisher } - swap error stream for a fallback. Output type preserved, Failure becomes Never.", color: .cbOrange)
                StepRow(number: 2, text: "retry(3) - on failure, resubscribe up to 3 times. Useful for flaky network calls.", color: .cbOrange)
                StepRow(number: 3, text: "replaceError(with: defaultValue) - absorb error, emit default, complete. Failure type becomes Never.", color: .cbOrange)
                StepRow(number: 4, text: "mapError { AppError($0) } - convert error type. Required when chaining publishers with different Failure types.", color: .cbOrange)
                StepRow(number: 5, text: "assertNoFailure() - fatalError in DEBUG if an error occurs. Use to enforce invariants.", color: .cbOrange)
                StepRow(number: 6, text: "tryCatch - like catch but can itself throw, enabling conditional recovery logic.", color: .cbOrange)
            }

            CalloutBox(style: .warning, title: "retry can cause duplicate side effects", contentBody: "retry(n) resubscribes to the entire upstream pipeline - including any side effects (network calls, UI updates). For network requests this means re-firing the request n times. Combine with a delay or exponential backoff: retry(3).delay(for: .seconds(2), scheduler: RunLoop.main).")

            CodeBlock(code: """
// Complete error handling pipeline
URLSession.shared
    .dataTaskPublisher(for: url)
    .retry(3)                           // retry up to 3 times on failure
    .mapError { AppError.network($0) }  // convert URLError → AppError
    .map(\\.data)
    .decode(type: [Item].self, decoder: JSONDecoder())
    .catch { _ in Just([]) }            // fallback: empty array
    .receive(on: RunLoop.main)
    .assign(to: &$items)

// replaceError + Never
unreliablePublisher
    .replaceError(with: "default")  // Failure: Never after this
    .assign(to: \\MyModel.text, on: self)
""")
        }
    }
}
