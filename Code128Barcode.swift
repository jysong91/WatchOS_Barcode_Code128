//
//  Code128Barcode.swift
//  Code128Barcode
//
//  2024 Jin Young Song <sjysong91@gmail.com>

import SwiftUI

struct Code128Barcode: View {
    let barcodeNumber: String
    
    private let startCodeB = "11010010000"
    private let stopCode = "1100011101011"
    
    private let codePatterns: [Character: String] = [
        " ": "11011001100", "!": "11001101100", "\"": "11001100110", "#": "10010011000",
        "$": "10010001100", "%": "10001001100", "&": "10011001000", "'": "10011000100",
        "(": "10001100100", ")": "11001001000", "*": "11001000100", "+": "11000100100",
        ",": "10110011100", "-": "10011011100", ".": "10011001110", "/": "10111001100",
        "0": "10011101100", "1": "10011100110", "2": "11001110010", "3": "11001011100",
        "4": "11001001110", "5": "11011100100", "6": "11001110100", "7": "11101101110",
        "8": "11101001100", "9": "11100101100", ":": "11100100110", ";": "11101100100",
        "<": "11100110100", "=": "11100110010", ">": "11011011000", "?": "11011000110",
        "@": "11000110110", "A": "10100011000", "B": "10001011000", "C": "10001000110",
        "D": "10110001000", "E": "10001101000", "F": "10001100010", "G": "11010001000",
        "H": "11000101000", "I": "11000100010", "J": "10110111000", "K": "10110001110",
        "L": "10001101110", "M": "10111011000", "N": "10111000110", "O": "10001110110",
        "P": "11101110110", "Q": "11010001110", "R": "11000101110", "S": "11011101000",
        "T": "11011100010", "U": "11011101110", "V": "11101011000", "W": "11101000110",
        "X": "11100010110", "Y": "11101101000", "Z": "11101100010", "[": "11100011010",
        "\\": "11101111010", "]": "11001000010", "^": "11110001010", "_": "10100110000",
        "`": "10100001100", "a": "10010110000", "b": "10010000110", "c": "10000101100",
        "d": "10000100110", "e": "10110010000", "f": "10110000100", "g": "10011010000",
        "h": "10011000010", "i": "10000110100", "j": "10000110010", "k": "11000010010",
        "l": "11001010000", "m": "11110111010", "n": "11000010100", "o": "10001111010",
        "p": "10100111100", "q": "10010111100", "r": "10010011110", "s": "10111100100",
        "t": "10011110100", "u": "10011110010", "v": "11110100100", "w": "11110010100",
        "x": "11110010010", "y": "11011011110", "z": "11011110110", "{": "11110110110",
        "|": "10101111000", "}": "10100011110", "~": "10001011110"
    ]
    
    private let conversionTable: [Int: String] = [
        0: " ", 1: "!", 2: "\"", 3: "#", 4: "$", 5: "%", 6: "&", 7: "'", 8: "(", 9: ")", 10: "*", 11: "+", 12: ",", 13: "-", 14: ".", 15: "/", 16: "0", 17: "1", 18: "2", 19: "3", 20: "4",
        21: "5", 22: "6", 23: "7", 24: "8", 25: "9", 26: ":", 27: ";", 28: "<", 29: "=", 30: ">", 31: "?", 32: "@", 33: "A", 34: "B", 35: "C", 36: "D", 37: "E", 38: "F", 39: "G", 40: "H",
        41: "I", 42: "J", 43: "K", 44: "L", 45: "M", 46: "N", 47: "O", 48: "P", 49: "Q", 50: "R", 51: "S", 52: "T", 53: "U", 54: "V", 55: "W", 56: "X", 57: "Y", 58: "Z", 59: "[",
        60: "\\", 61: "]", 62: "^", 63: "_", 64: "\u{00A1}", 65: "a", 66: "b", 67: "c", 68: "d", 69: "e", 70: "f", 71: "g", 72: "h", 73: "i", 74: "j", 75: "k", 76: "l", 77: "m",
        78: "n", 79: "o", 80: "p", 81: "q", 82: "r", 83: "s", 84: "t", 85: "u", 86: "v", 87: "w", 88: "x", 89: "y", 90: "z", 91: "{", 92: "|", 93: "}", 94: "~", 95: "\u{007F}",
        96: "\u{0080}", 97: "\u{0081}", 98: "\u{0082}", 99: "\u{0083}", 100: "\u{0084}", 101: "\u{0085}", 102: "\u{0086}", 103: "\u{0087}", 104: "\u{0088}", 105: "\u{0089}",
        106: "\u{008A}", 107: "\u{008B}", 108: "\u{008C}", 109: "\u{008D}", 110: "\u{008E}", 111: "\u{008F}", 112: "\u{0090}", 113: "\u{0091}", 114: "\u{0092}", 115: "\u{0093}",
        116: "\u{0094}", 117: "\u{0095}", 118: "\u{0096}", 119: "\u{0097}", 120: "\u{0098}", 121: "\u{0099}", 122: "\u{009A}", 123: "\u{009B}", 124: "\u{009C}", 125: "\u{009D}",
        126: "\u{009E}", 127: "\u{009F}"
    ]
    
    private var barWidth: CGFloat {
        var adjustedWidth: CGFloat = 0.75
        
        switch barcodeNumber.count {
            case ..<13:
                adjustedWidth = 0.85
                
            case 13..<17:
                adjustedWidth = 0.75
                
            case 17..<20:
                adjustedWidth = 0.65
                
            case 20...:
                adjustedWidth = 0.55
                
            default:
                break
        }
        
        return adjustedWidth
    }
    
    var body: some View {
        GeometryReader { geometry in
            if barcodeNumber != "" {
                HStack {
                    HStack(spacing: 0) {
                        // Start code B
                        renderBarPattern(pattern: startCodeB, barWidth: barWidth, height: geometry.size.height)
                        
                        // Data
                        ForEach(Array(self.barcodeNumber.enumerated()), id: \.offset) { index, char in
                            if let pattern = self.codePatterns[char] {
                                renderBarPattern(pattern: pattern, barWidth: barWidth, height: geometry.size.height)
                            }
                        }
                        
                        // Checksum
                        if let checksum = self.calculateChecksum(), let checksumPattern = self.codePatterns[Array(checksum)[0]] {
                            renderBarPattern(pattern: checksumPattern, barWidth: barWidth, height: geometry.size.height)
                        }
                        
                        // Stop code
                        renderBarPattern(pattern: stopCode, barWidth: barWidth, height: geometry.size.height)
                    }
                }.frame(maxWidth: .infinity) 
            }
        }
    }
    
    func calculateChecksum() -> String? {
        var checksum = 104
        
        for (index, char) in self.barcodeNumber.enumerated() {
            let asciiValue = Int(char.asciiValue ?? 0)
            checksum += (asciiValue - 32) * (index + 1)
        }
        
        let remainder = checksum % 103
        return conversionTable[remainder]
    }
    
    func renderBarPattern(pattern: String, barWidth: CGFloat, height: CGFloat) -> some View {
        ForEach(Array(pattern.enumerated()), id: \.offset) { index, bit in
            Rectangle()
                .fill(bit == "1" ? Color.black : Color.white)
                .frame(width: barWidth, height: height)
        }
    }
}
