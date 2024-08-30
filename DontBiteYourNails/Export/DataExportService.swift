//
//  DataExporter.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 19/08/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import CoreData
import MessageUI
import Compression
import CryptoKit
import zlib

class DataExportService{ //}: MFMailComposeViewControllerDelegate {
    static let shared = DataExportService()
    static let encryptionService = EncryptionService()
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
   /*
    func exportAndSendData(_ sender: Any, alert : Alert) {
        if let exportedURL = exportData(alert : alert) {
            sendEmail(with: exportedURL)
        }
    }*/
    
 /*   func sendEmail(with attachmentURL: URL) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["sunekjakobsen@gmail.com"])
            mail.setSubject("Exported Data for Debugging")
            
            if let data = try? Data(contentsOf: attachmentURL) {
                mail.addAttachmentData(data, mimeType: "application/json", fileName: "exportedData.json")
            }

            present(mail, animated: true)
        } else {
            print("Email cannot be sent.")
        }
    }*/
    
    func createExportFile(alert: Alert, filename: String) -> URL? {
        deleteExistingFiles()
        do {
            let encoder = JSONEncoder()
            let exportableAlert = ExportableAlert(from: alert)
            let data = try encoder.encode(exportableAlert)
            print("Data: \(data)")
            let compressedData = compressData(data: data)!
            let encodedData = DataExportService.encryptionService.aesEncrypt(data: compressedData as Data)!
            print("encodedData: \(encodedData)")
            let tempDirectory = FileManager.default.temporaryDirectory
            let exportURL = tempDirectory.appendingPathComponent("\(filename).txt")
            
            try encodedData.write(to: exportURL)
            print("Returning Url: \(exportURL.absoluteURL)")
            return exportURL
            
        } catch {
            print("Error fetching or encoding data: \(error)")
            return nil
        }
    }
    
    func createExportFile(session: Session, filename: String) -> URL? {
        deleteExistingFiles()
        do {
            let encoder = JSONEncoder()
            let exportableSession = ExportableSession(from: session)
            let data = try encoder.encode(exportableSession)
            //let encodedData = try (data as NSData).compressed(using: .zlib)
            let compressedData = compressData(data: data)!
            
            let encodedData = DataExportService.encryptionService.aesEncrypt(data: compressedData as Data)!
            let tempDirectory = FileManager.default.temporaryDirectory
            let exportURL = tempDirectory.appendingPathComponent("\(filename).txt")
            
            try encodedData.write(to: exportURL)
            print("Returning Url: \(exportURL.absoluteURL)")
            

            return exportURL
            
        } catch {
            print("Error fetching or encoding data: \(error)")
            return nil
        }
    }
    
    
    func createExportFile(activeDate: ActiveDate, filename: String) -> URL? {
        deleteExistingFiles()
        do {
            let encoder = JSONEncoder()
            let exportableSession = ExportableActiveDate(from: activeDate)
            let data = try encoder.encode(exportableSession)
            let compressedData = compressData(data: data)!
            let encodedData = DataExportService.encryptionService.aesEncrypt(data: compressedData as Data)!
            
            let tempDirectory = FileManager.default.temporaryDirectory
            let exportURL = tempDirectory.appendingPathComponent("\(filename).txt")
            
            try encodedData.write(to: exportURL)
            print("Returning Url: \(exportURL.absoluteURL)")
            return exportURL
            
        } catch {
            print("Error fetching or encoding data: \(error)")
            return nil
        }
    }
    
    func compressData(data: Data) -> Data? {
        var compressedData = Data(count: data.count)
        var compressedSize: uLongf = uLongf(data.count)
        let result = data.withUnsafeBytes { (inputBytes: UnsafePointer<UInt8>) -> Int32 in
            return compressedData.withUnsafeMutableBytes { (outputBytes: UnsafeMutablePointer<UInt8>) -> Int32 in
                compress(outputBytes, &compressedSize, inputBytes, uLong(data.count))
            }
        }

        guard result == Z_OK else {
            print("Compression failed with result \(result)")
            return nil
        }
        
        compressedData.count = Int(compressedSize)
        return compressedData
    }

    
    func deleteExistingFiles() {
        let fileManager = FileManager.default

        do {
            let tempDirectory = NSTemporaryDirectory()
            let tempFiles = try fileManager.contentsOfDirectory(atPath: tempDirectory)
            
            for file in tempFiles {
                let fileURL = URL(fileURLWithPath: tempDirectory).appendingPathComponent(file)
                print("Deleting \(fileURL)")
                try fileManager.removeItem(at: fileURL)
            }
        } catch {
            print("Error while deleting files from temp directory: \(error)")
        }
    }
    
}

