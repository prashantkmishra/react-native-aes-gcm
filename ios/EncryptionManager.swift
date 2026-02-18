//
//  EncryptionManager.swift
//  AesGcm
//
//  Created by Prashant Mishra on 18/02/26.
//

import CryptoSwift
import CryptoKit
import Foundation

@objc(EncryptionManager)
public class EncryptionManager: NSObject {
  let SALT_LENGTH = 16
  let IV_LENGTH = 12
  let encriptedPos =  28
  let remainingLengh = 0
  
  func getRandomNonce(length: Int) throws -> [UInt8] {
    var nonce = [UInt8](repeating: 0, count: length)
    let result = SecRandomCopyBytes(kSecRandomDefault, length, &nonce)
    guard result == errSecSuccess else {
      throw NSError(domain: "com.example", code: Int(result), userInfo: nil)
    }
    return nonce
  }
  
  func generateRandomSalt(length: Int) -> [UInt8] {
    var salt = [UInt8](repeating: 0, count: length)
    _ = SecRandomCopyBytes(kSecRandomDefault, length, &salt)
    return salt
  }
  
  @objc(decrypt:key:iterationCount:error:)
  public func decrypt(_ encryptedText: String,
                      key: String,
                      iterationCount: NSNumber,
                      error: NSErrorPointer) -> String? {
    
    do {
      let trimmedText = encryptedText.trimmingCharacters(in: .whitespacesAndNewlines)
      
      guard let encryptedData = Data(base64Encoded: trimmedText) else {
        throw NSError(domain: "Decryption",
                      code: -1,
                      userInfo: [NSLocalizedDescriptionKey: "Invalid Base64 input"])
      }
      guard encryptedData.count > (SALT_LENGTH + IV_LENGTH) else {
        throw NSError(domain: "Decryption",
                      code: -2,
                      userInfo: [NSLocalizedDescriptionKey: "Encrypted data too short"])
      }
      
      // Extract salt, IV, ciphertext(+tag if combined)
      let salt = encryptedData[..<SALT_LENGTH]
      let iv = encryptedData[SALT_LENGTH..<(SALT_LENGTH + IV_LENGTH)]
      let encrypted = encryptedData[(SALT_LENGTH + IV_LENGTH)...]
      
      let saltData: [UInt8] = Array(salt)
      let password: [UInt8] = Array(key.utf8)
      let encryptedArray: [UInt8] = Array(encrypted)
      let ivArray: [UInt8] = Array(iv)
      
      guard let secretKey = try? PKCS5.PBKDF2(
        password: password,
        salt: saltData,
        iterations: iterationCount.intValue,
        keyLength: 32,
        variant: .sha2(.sha512)
      ).calculate() else {
        throw NSError(domain: "Decryption",
                      code: -3,
                      userInfo: [NSLocalizedDescriptionKey: "Key derivation failed"])
      }
      
      let gcm = GCM(iv: ivArray, mode: .combined)
      let aes = try AES(key: secretKey, blockMode: gcm, padding: .noPadding)
      
      let decryptedBytes = try aes.decrypt(encryptedArray)
      
      let decryptedData = Data(decryptedBytes)
      
      guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
        throw NSError(domain: "Decryption",
                      code: -4,
                      userInfo: [NSLocalizedDescriptionKey: "UTF8 decoding failed"])
      }
      
      return decryptedString
      
    } catch let err {
      error?.pointee = err as NSError
      return nil
    }
  }
  
  @objc(encrypt:key:iterationCount:error:)
  public func encrypt(_ plainText: String,
                      key: String,
                      iterationCount: NSNumber,
                      error: NSErrorPointer) -> String? {
    
    do {
      print("encryptTextAesGcm JSON : \(plainText)")
      print("encryptTextAesGcm Key : \(key)")
      
      let salt = generateRandomSalt(length: SALT_LENGTH)
      let iv = try getRandomNonce(length: IV_LENGTH)
      
      let password: [UInt8] = Array(key.utf8)
      let plainTextArray: [UInt8] = Array(plainText.utf8)
      
      guard let secretKey = try? PKCS5.PBKDF2(
        password: password,
        salt: salt,
        iterations: iterationCount.intValue,
        keyLength: 32,
        variant: .sha2(.sha512)
      ).calculate() else {
        throw NSError(domain: "Encryption", code: -1,
                      userInfo: [NSLocalizedDescriptionKey: "Key derivation failed"])
      }
      
      let gcm = GCM(iv: iv, mode: .combined)
      let aes = try AES(key: secretKey, blockMode: gcm, padding: .noPadding)
      
      let encrypted = try aes.encrypt(plainTextArray)
      
      let cipherData = Data(salt + iv + encrypted)
      return cipherData.base64EncodedString()
      
    } catch let err {
      error?.pointee = err as NSError
      return nil
    }
  }
}

