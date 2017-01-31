//
//  CSV.swift
//  SwiftCSV
//
//  Created by naoty on 2014/06/09.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//
//  Edited:  Connor Reid on 12/11/2015
//

import Foundation

public class CSV {
    public var headers: [String] = []
    public var rows: [Dictionary<String, String>] = []
    public var aRows: [[String]] = []
    public var columns = Dictionary<String, [String]>()
    var delimiter = NSCharacterSet(charactersIn: ",")
    
    public init?(contentsOfFile file: String, delimiter: NSCharacterSet, encoding: UInt, error: NSErrorPointer) {
        let csvString : String
        do {
            csvString = try String(contentsOfFile: file);
            let csvStringToParse = csvString
            self.delimiter = delimiter
            
            let newline = NSCharacterSet.newlines
            var lines: [String] = []
            csvStringToParse.trimmingCharacters(in: newline).enumerateLines { line, stop in lines.append(line) }
            
            self.headers = self.parseHeaders(fromLines: lines)
            self.rows = self.parseRows(fromLines: lines)
            self.aRows = self.parseRowsArray(fromLines: lines)
            self.columns = self.parseColumns(fromLines: lines)
        }
        catch let error as NSError{
            print("Dis is da error: \(error)")
            csvString = ""
        }
        
    }
    
    public convenience init?(contentsOfFile file: String, error: NSErrorPointer) {
        let comma = NSCharacterSet(charactersIn: ",")
        self.init(contentsOfFile: file, delimiter: comma, encoding: String.Encoding.utf8.rawValue, error: error)
    }
    
    public convenience init?(contentsOfURL file: String, encoding: UInt, error: NSErrorPointer) {
        let comma = NSCharacterSet(charactersIn: ",")
        self.init(contentsOfFile: file, delimiter: comma, encoding: encoding, error: error)
    }
    
    func parseHeaders(fromLines lines: [String]) -> [String] {
        return lines[0].components(separatedBy: String(describing: self.delimiter))
    }
    
    func parseRows(fromLines lines: [String]) -> [Dictionary<String, String>] {
        var rows: [Dictionary<String, String>] = []
        
        for (lineNumber, line) in lines.enumerated() {
            if lineNumber == 0 {
                continue
            }
            
            var row = Dictionary<String, String>()
            let values = line.components(separatedBy: ",")
            for (index, header) in self.headers.enumerated() {
                if index < values.count {
                    row[header] = values[index]
                } else {
                    row[header] = ""
                }
            }
            rows.append(row)
        }
        
        return rows
    }
    
    func parseRowsArray(fromLines lines: [String]) -> [[String]] {
        var rows: [Dictionary<String, String>] = []
        var aRows: [[String]] = []
        
        for (lineNumber, line) in lines.enumerated() {
            if lineNumber == 0 {
                continue
            }
            
            var row = Dictionary<String, String>()
            var aRow = [String]()
            let values = line.components(separatedBy: ",")
            for (index, header) in self.headers.enumerated() {
                if index < values.count {
                    row[header] = values[index]
                    aRow.append(values[index])
                } else {
                    row[header] = ""
                    aRow.append("")
                }
            }
            rows.append(row)
            aRows.append(aRow)
        }
        
        return aRows
    }
    
    
    func parseColumns(fromLines lines: [String]) -> Dictionary<String, [String]> {
        var columns = Dictionary<String, [String]>()
        
        for header in self.headers {
            let column = self.rows.map { row in row[header] != nil ? row[header]! : "" }
            columns[header] = column
        }
        
        return columns
    }
    
    //  Save a string as a csv file
    func saveCSV(_ log: String, fName: String) {
        let file = "AccountDeets.csv" //this is the file. we will write to and read from it
        
        let text = log //just a text
        //print(log)
        
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first as NSString? {
            let path = dir.appendingPathComponent(file);
            print("Path for csv is \(path)")
            
            //writing
            do {
                try text.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {
                print("Um OK...  I don't want you to over react but...  someshitgotfuckedupwhiletryingtosavethatfile....K..bye...")
            }
            
        }
    }
    
}
