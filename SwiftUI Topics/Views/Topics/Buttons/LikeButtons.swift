//
//  LikeButtons.swift
//  SwiftUI Topics
//
//  Created by codeAlligator on 19/01/26.
//


import SwiftUI

struct LikeButtons: View {
    @State private var SimpleLiked = false
    @State private var BounceLike = false
    @State private var scale: CGFloat = 1
    @State private var isBroken = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            HStack(alignment: .center, spacing: 30) {
                // MARK: - Simple
                Image(systemName: SimpleLiked ? "heart.fill" : "heart")
                    .font(.system(size: 50))
                    .foregroundColor(SimpleLiked ? .pink : .gray)
                    .scaleEffect(SimpleLiked ? 1.25 : 1.0)
                    .animation(.spring(response: 0.25, dampingFraction: 0.5), value: SimpleLiked)
                    .onTapGesture {
                        SimpleLiked.toggle()
                    }
                
                // MARK: - Bounce
                Image(systemName: BounceLike ? "heart.fill" : "heart")
                    .font(.system(size: 50))
                    .foregroundColor(BounceLike ? .pink : .gray)
                    .scaleEffect(scale)
                    .onTapGesture {
                        BounceLike.toggle()
                        
                        scale = 1.4
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.45)) {
                            scale = 1
                        }
                    }
                
                // MARK: - Burst
                LikeBurstButton()
            }
            HStack(alignment: .center, spacing: 30) {
                BrokenHeartButtonView()
            }
            
            VacuumLikeButton()
        }
        
    }
}

// MARK: - Like burst Button
private extension LikeButtons {
    
    // Burst Button
    private struct LikeBurstButton: View {
        @State private var BurstLike = false
        @State private var showBurst = false
        
        var body: some View {
            ZStack {
                if showBurst {
                    LikeBurst(color: .pink)
                }
                
                Image(systemName: BurstLike ? "heart.fill" : "heart")
                    .font(.system(size: 50))
                    .foregroundColor(BurstLike ? .pink : .gray)
            }
            .onTapGesture {
                BurstLike.toggle()
                showBurst = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    showBurst = false
                }
            }
        }
    }
    
    // Burst Effect
    private struct LikeBurst: View {
        let color: Color
        @State private var animate = false

        var body: some View {
            ZStack {
                ForEach(0..<8) { i in
                    Rectangle()
                        .fill(color)
                        .frame(width: 2, height: 10)
                        .offset(y: -34)
                        .rotationEffect(.degrees(Double(i) * 45))
                        .opacity(animate ? 0 : 1)
                }
            }
            .scaleEffect(animate ? 1.6 : 0.8)
            .animation(.easeOut(duration: 0.3), value: animate)
            .onAppear {
                animate = true
            }
        }
    }
}

// MARK: - Heart slash button
private extension LikeButtons {
    private struct BrokenHeartButtonView: View {
        @State private var isBroken = false
        
        var body: some View {
            Button(action: {
                withAnimation(.spring()) {
                    isBroken.toggle()
                }
            }) {
                Image(systemName: isBroken ? "heart.slash.fill" : "heart.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(isBroken ? .gray : .pink)
                    .scaleEffect(isBroken ? 0.8 : 1)
                    .rotationEffect(.degrees(isBroken ? 15 : 0))
            }
        }
    }
}

struct Particle {
    var angle: Double
    var radius: CGFloat
    var angularVelocity: Double
    var collapseSpeed: CGFloat
}

struct VacuumParticleEffect: View {
    let startTime = Date()
    let duration: Double = 1.6
    let particles: [Particle]

    var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSince(startTime)
            let progress = min(t / duration, 1)

            Canvas { context, size in
                guard progress < 1 else { return }

                let center = CGPoint(x: size.width / 2, y: size.height / 2)

                for p in particles {
                    let spin = p.angle + p.angularVelocity * t
                    let pull = max(1 - progress * p.collapseSpeed, 0)

                    let x = center.x + cos(spin) * p.radius * pull
                    let y = center.y + sin(spin) * p.radius * pull

                    let alpha = Double(pull)

                    context.fill(
                        Path(ellipseIn: CGRect(x: x, y: y, width: 4, height: 4)),
                        with: .color(.gray.opacity(alpha))
                    )
                }
            }
        }
    }
}

struct VacuumLikeButton: View {
    @State private var liked = false
    @State private var animate = false

    private let particles: [Particle] = (0..<20).map { _ in
        Particle(
            angle: Double.random(in: 0...(2 * .pi)),
            radius: CGFloat.random(in: 20...32),
            angularVelocity: Double.random(in: 6...10), // clockwise race
            collapseSpeed: CGFloat.random(in: 1.3...1.8)
        )
    }

    var body: some View {
        ZStack {
            if animate && !liked {
                VacuumParticleEffect(particles: particles)
                    .frame(width: 70, height: 70)
            }

            Image(systemName: liked ? "heart.fill" : "heart")
                .font(.system(size: 28))
                .foregroundStyle(liked ? .pink : .gray)
        }
        .frame(width: 70, height: 70)
        .contentShape(Rectangle())
        .onTapGesture {
            guard !liked else { return }

            animate = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                liked = true
                animate = false
            }
        }
    }
}


