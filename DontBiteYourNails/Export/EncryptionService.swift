//
//  EncryptionService.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 20/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import CommonCrypto

class EncryptionService {
    let key = "rpRVdyTIOVOzpQ7y".data(using: .utf8)!
    
    func generateRandomIV(for cryptoAlgorithm: CCAlgorithm) -> Data? {
        let length = kCCBlockSizeAES128
        var randomBytes = [UInt8](repeating: 0, count: length)
        let status = SecRandomCopyBytes(kSecRandomDefault, length, &randomBytes)
        return (status == errSecSuccess) ? Data(randomBytes) : nil
    }
    
    func aesEncrypt(data: Data) -> Data? {
        let iv = generateRandomIV(for: CCAlgorithm(kCCAlgorithmAES))!
        let clearLength = size_t(data.count + kCCBlockSizeAES128)
        var encryptedBytes = [UInt8](repeating: 0, count: clearLength)
        let keyBytes: [UInt8] = Array(self.key)
        let ivBytes: [UInt8] = Array(iv)
        let dataBytes: [UInt8] = Array(data)
        let keyLength = size_t(kCCKeySizeAES128)
        let options = CCOptions(kCCOptionPKCS7Padding)
        var numBytesEncrypted: size_t = 0

        let cryptStatus = CCCrypt(CCOperation(kCCEncrypt),
                                  CCAlgorithm(kCCAlgorithmAES),
                                  options,
                                  keyBytes,
                                  keyLength,
                                  ivBytes,
                                  dataBytes,
                                  data.count,
                                  &encryptedBytes,
                                  clearLength,
                                  &numBytesEncrypted)

        if cryptStatus == CCCryptorStatus(kCCSuccess) {
            let encryptedData = Data(encryptedBytes[0..<numBytesEncrypted])
            return iv + encryptedData
        } else {
            return nil
        }
    }

}
