//
//
//  CodeBlock.swift
//  SwiftUI Topics
//
/// Created by `C S Prasad` on `19/03/26`
///
/// ### Social
/// `Instagram` : ``@csprasad.ios`` • `X` : ``@csprasad_ios`` • `Github` : ``@csprasad``
///

import SwiftUI

// MARK: - Code Block
struct CodeBlock: View {
    let code: String
 
    private var lines: [String] {
        code.components(separatedBy: "\n")
    }
 
    var body: some View {
        VStack(spacing: 0) {
 
            // Title bar
            HStack(spacing: 6) {
                Circle().fill(Color(hex: "#FF5F57")).frame(width: 10, height: 10)
                Circle().fill(Color(hex: "#FFBD2E")).frame(width: 10, height: 10)
                Circle().fill(Color(hex: "#28CA41")).frame(width: 10, height: 10)
                Spacer()
                Text("swift")
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundStyle(Color(.tertiaryLabel))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.tertiarySystemBackground))
 
            Divider()
                .opacity(0.5)
 
            // Code area
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
 
                    // Line numbers
                    VStack(alignment: .trailing, spacing: 0) {
                        ForEach(lines.indices, id: \.self) { i in
                            Text("\(i + 1)")
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundStyle(Color(.tertiaryLabel))
                                .frame(height: 20)
                        }
                    }
                    .padding(.leading, 12)
                    .padding(.trailing, 10)
                    .padding(.vertical, 12)
 
                    // Divider between line numbers and code
                    Rectangle()
                        .fill(Color(.separator).opacity(0.3))
                        .frame(width: 0.5)
                        .padding(.vertical, 8)
 
                    // Code text
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(lines.indices, id: \.self) { i in
                            Text(attributedLine(lines[i]))
                                .font(.system(size: 12, design: .monospaced))
                                .frame(height: 20, alignment: .leading)
                        }
                    }
                    .padding(.leading, 12)
                    .padding(.trailing, 16)
                    .padding(.vertical, 12)
                }
            }
            .background(Color(.secondarySystemBackground))
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color(.separator).opacity(0.3), lineWidth: 0.5)
        )
    }
 
    // Basic Swift syntax colouring
    private func attributedLine(_ line: String) -> AttributedString {
        var result = AttributedString(line)
        result.foregroundColor = UIColor.label
 
        let keywords = ["let", "var", "func", "struct", "class", "actor", "enum",
                        "if", "else", "guard", "return", "for", "in", "try", "await",
                        "async", "throws", "private", "public", "static", "import",
                        "true", "false", "nil", "self", "some", "any"]
 
        // Comments - grey
        if let commentRange = line.range(of: "//") {
            let nsStart = line.distance(from: line.startIndex, to: commentRange.lowerBound)
            if let attrRange = Range(NSRange(location: nsStart, length: line.count - nsStart), in: result) {
                result[attrRange].foregroundColor = UIColor.systemGray
            }
        }
 
        // String literals - orange/amber
        let stringPattern = try? NSRegularExpression(pattern: #""[^"]*""#)
        let nsLine = line as NSString
        stringPattern?.enumerateMatches(in: line, range: NSRange(location: 0, length: nsLine.length)) { match, _, _ in
            guard let match, let range = Range(match.range, in: result) else { return }
            result[range].foregroundColor = UIColor.systemOrange
        }
 
        // Keywords - purple/indigo
        for keyword in keywords {
            let pattern = "\\b\(keyword)\\b"
            guard let regex = try? NSRegularExpression(pattern: pattern) else { continue }
            regex.enumerateMatches(in: line, range: NSRange(location: 0, length: nsLine.length)) { match, _, _ in
                guard let match, let range = Range(match.range, in: result) else { return }
                result[range].foregroundColor = UIColor.systemPurple
            }
        }
 
        // Type names starting with uppercase - blue
        let typePattern = try? NSRegularExpression(pattern: "\\b[A-Z][a-zA-Z0-9]*\\b")
        typePattern?.enumerateMatches(in: line, range: NSRange(location: 0, length: nsLine.length)) { match, _, _ in
            guard let match, let range = Range(match.range, in: result) else { return }
            result[range].foregroundColor = UIColor.systemBlue
        }
 
        // Modifiers starting with . - teal
        let dotPattern = try? NSRegularExpression(pattern: #"\.[a-zA-Z][a-zA-Z0-9]*"#)
        dotPattern?.enumerateMatches(in: line, range: NSRange(location: 0, length: nsLine.length)) { match, _, _ in
            guard let match, let range = Range(match.range, in: result) else { return }
            result[range].foregroundColor = UIColor.systemTeal
        }
 
        return result
    }
}
 
