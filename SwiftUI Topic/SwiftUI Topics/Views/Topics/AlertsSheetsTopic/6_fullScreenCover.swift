//
//
//  6_fullScreenCover.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `09/04/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - LESSON 6: fullScreenCover
struct FullScreenCoverVisual: View {
    @State private var showCover     = false
    @State private var showSheet     = false
    @State private var selectedDemo  = 0
    let demos = ["vs .sheet", "Onboarding", "Camera style"]

    var body: some View {
        VisualCard {
            VStack(alignment: .leading, spacing: 16) {
                Label("fullScreenCover", systemImage: "rectangle.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.asRed)

                HStack(spacing: 8) {
                    ForEach(demos.indices, id: \.self) { i in
                        Button {
                            withAnimation(.spring(response: 0.3)) { selectedDemo = i }
                        } label: {
                            Text(demos[i])
                                .font(.system(size: 11, weight: selectedDemo == i ? .semibold : .regular))
                                .foregroundStyle(selectedDemo == i ? Color.asRed : .secondary)
                                .frame(maxWidth: .infinity).padding(.vertical, 7)
                                .background(selectedDemo == i ? Color.asRedLight : Color(.systemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }

                switch selectedDemo {
                case 0:
                    // Comparison diagram
                    VStack(spacing: 10) {
                        HStack(spacing: 10) {
                            comparisonCard(
                                title: ".sheet",
                                icon: "rectangle.bottomhalf.inset.filled",
                                color: .navBlue,
                                points: ["Slides up partially", "Background visible", "Swipe to dismiss", "Use for secondary content"]
                            )
                            comparisonCard(
                                title: ".fullScreenCover",
                                icon: "rectangle.fill",
                                color: .asRed,
                                points: ["Covers entire screen", "Background hidden", "Must provide close button", "Use for onboarding/camera"]
                            )
                        }
                        HStack(spacing: 8) {
                            Button {
                                showSheet = true
                            } label: {
                                Text(".sheet")
                                    .font(.system(size: 13, weight: .semibold)).foregroundStyle(Color.navBlue)
                                    .frame(maxWidth: .infinity).padding(.vertical, 10)
                                    .background(Color(hex: "#EAF0FE")).clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(PressableButtonStyle())
                            .sheet(isPresented: $showSheet) {
                                VStack(spacing: 10) {
                                    Text(".sheet").font(.system(size: 18, weight: .bold))
                                    Text("Background still visible behind").font(.system(size: 12)).foregroundStyle(.secondary)
                                    Button("Close") { showSheet = false }.buttonStyle(.borderedProminent).tint(.navBlue)
                                }.padding().presentationDetents([.medium])
                            }

                            Button {
                                showCover = true
                            } label: {
                                Text(".fullScreenCover")
                                    .font(.system(size: 13, weight: .semibold)).foregroundStyle(.white)
                                    .frame(maxWidth: .infinity).padding(.vertical, 10)
                                    .background(Color.asRed).clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(PressableButtonStyle())
                            .fullScreenCover(isPresented: $showCover) {
                                fullCoverContent(title: "fullScreenCover", subtitle: "Covers everything - no swipe to dismiss")
                            }
                        }
                    }

                case 1:
                    // Onboarding style
                    Button {
                        showCover = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "hand.wave.fill").font(.system(size: 20)).foregroundStyle(.white)
                            Text("Start onboarding").font(.system(size: 14, weight: .semibold)).foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity).padding(.vertical, 12)
                        .background(LinearGradient(colors: [Color.asRed, Color(hex: "#EF4444")], startPoint: .leading, endPoint: .trailing))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(PressableButtonStyle())
                    .fullScreenCover(isPresented: $showCover) {
                        ZStack {
                            LinearGradient(colors: [Color.asRed, Color(hex: "#7F1D1D")], startPoint: .topLeading, endPoint: .bottomTrailing)
                                .ignoresSafeArea()
                            VStack(spacing: 24) {
                                Image(systemName: "sparkles").font(.system(size: 56)).foregroundStyle(.white.opacity(0.9))
                                Text("Welcome!").font(.system(size: 30, weight: .bold)).foregroundStyle(.white)
                                Text("This is a fullScreenCover used for onboarding. The entire screen is replaced.")
                                    .font(.system(size: 15)).foregroundStyle(.white.opacity(0.8)).multilineTextAlignment(.center).padding(.horizontal, 32)
                                Button {
                                    showCover = false
                                } label: {
                                    Text("Get started")
                                        .font(.system(size: 16, weight: .semibold)).foregroundStyle(Color.asRed)
                                        .padding(.horizontal, 36).padding(.vertical, 14)
                                        .background(.white).clipShape(Capsule())
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }
                    }

                default:
                    // Camera style
                    Button {
                        showCover = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "camera.fill").font(.system(size: 16)).foregroundStyle(.white)
                            Text("Open camera").font(.system(size: 14, weight: .semibold)).foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity).padding(.vertical, 12)
                        .background(Color(.systemGray)).clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(PressableButtonStyle())
                    .fullScreenCover(isPresented: $showCover) {
                        ZStack {
                            Color.black.ignoresSafeArea()
                            VStack {
                                HStack {
                                    Button {
                                        showCover = false
                                    } label: {
                                        Text("Cancel").foregroundStyle(.white).font(.system(size: 16))
                                    }
                                    .buttonStyle(PressableButtonStyle())
                                    Spacer()
                                    Text("Camera").font(.system(size: 16, weight: .semibold)).foregroundStyle(.white)
                                    Spacer()
                                    Text("Cancel").foregroundStyle(.clear)
                                }
                                .padding(.horizontal, 20).padding(.top, 10)
                                Spacer()
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemGray6).opacity(0.15))
                                    .frame(maxWidth: .infinity).frame(height: 200)
                                    .overlay(Image(systemName: "viewfinder").font(.system(size: 60)).foregroundStyle(.white.opacity(0.3)))
                                    .padding(.horizontal, 20)
                                Spacer()
                                Circle().fill(Color.white).frame(width: 60, height: 60)
                                    .overlay(Circle().stroke(.white.opacity(0.5), lineWidth: 4).frame(width: 70, height: 70))
                                    .padding(.bottom, 30)
                            }
                        }
                    }
                }
            }
        }
    }

    func fullCoverContent(title: String, subtitle: String) -> some View {
        VStack(spacing: 14) {
            Image(systemName: "rectangle.fill").font(.system(size: 52)).foregroundStyle(Color.asRed)
            Text(title).font(.system(size: 22, weight: .bold))
            Text(subtitle).font(.system(size: 14)).foregroundStyle(.secondary).multilineTextAlignment(.center).padding(.horizontal, 32)
            Button {
                showCover = false
            } label: {
                Text("Close").font(.system(size: 16, weight: .semibold)).foregroundStyle(.white)
                    .padding(.horizontal, 32).padding(.vertical, 13).background(Color.asRed).clipShape(Capsule())
            }
            .buttonStyle(PressableButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }

    func comparisonCard(title: String, icon: String, color: Color, points: [String]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 14)).foregroundStyle(color)
                Text(title).font(.system(size: 12, weight: .semibold)).foregroundStyle(color)
            }
            ForEach(points, id: \.self) { pt in
                HStack(alignment: .top, spacing: 4) {
                    Text("·").foregroundStyle(.secondary)
                    Text(pt).font(.system(size: 10)).foregroundStyle(.secondary)
                }
            }
        }
        .padding(10).background(color.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

struct FullScreenCoverExplanation: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(text: ".fullScreenCover")
            Text(".fullScreenCover presents a view that covers the entire screen - status bar, navigation bar, everything. Unlike .sheet, there's no swipe-to-dismiss. You must provide an explicit close button.")
                .font(.system(size: 15)).foregroundStyle(.secondary).lineSpacing(4)

            VStack(spacing: 12) {
                StepRow(number: 1, text: ".fullScreenCover(isPresented: $bool) - same API as .sheet but covers the whole screen.", color: .asRed)
                StepRow(number: 2, text: "No swipe-to-dismiss - always add a visible Cancel/Done/Close button.", color: .asRed)
                StepRow(number: 3, text: "@Environment(\\.dismiss) inside the cover - dismiss() closes it programmatically.", color: .asRed)
                StepRow(number: 4, text: "Use for: onboarding flows, login/signup, camera, media player, any full-takeover experience.", color: .asRed)
                StepRow(number: 5, text: ".fullScreenCover also supports item: binding - same pattern as .sheet.", color: .asRed)
            }

            CalloutBox(style: .danger, title: "Always provide a way to close", contentBody: "Unlike .sheet, users cannot swipe down to dismiss a fullScreenCover. If you don't add a close button, users are trapped. App Review will reject apps with inaccessible full screen covers.")

            CodeBlock(code: """
.fullScreenCover(isPresented: $showOnboarding) {
    OnboardingFlow()
}

struct OnboardingFlow: View {
    @Environment(\\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            // Onboarding pages...
            Button("Get started") { dismiss() }
        }
    }
}

// Camera-style
.fullScreenCover(isPresented: $showCamera) {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack {
            HStack {
                Button("Cancel") { showCamera = false }
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding()
            CameraViewfinder()
        }
    }
}
""")
        }
    }
}

