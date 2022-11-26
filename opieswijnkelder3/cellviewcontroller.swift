//
//  cellviewcontroller.swift
//  opieswijnkelder3
//
//  Created by user226791 on 9/17/22.
//

import Foundation
import UIKit
import CoreData


class showviewcontroller: UIViewController, doorgeefcellDelegate {
    
    @IBOutlet var aantal: UITextField!
    @IBOutlet var label: UILabel!
    var uitslag = 0
    var biertjes = [Biertje]()
    var cell: UITableViewCell?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func nummervan(_ zoek: String, _ lijst: [Biertje]) -> Int {
        if lijst.count != 0 {
            for x in 0...lijst.count - 1 {
                if lijst[x].naam == zoek {
                    return x
                }
            }
        }
        return -1
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Biertje.fetchRequest() as NSFetchRequest<Biertje>
        
        do {
            biertjes = try context.fetch(fetchRequest)
        } catch let error {
            print("dit is de error \(error)")
        }
        
        let biertje = biertjes[nummervan(cell?.textLabel?.text ?? "", biertjes)]
        biertje.aantal = Int16(aantal.text ?? "") ?? 1
        
        do {
            try context.save()
        } catch let error {
            print("dit is de error \(error)")
        }
        
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func min(_ sender: UIBarButtonItem) {
        uitslag = Int(aantal.text ?? "") ?? 1
        uitslag -= 1
        aantal.text? = String(uitslag)
    }
    
    @IBAction func plus(_ sender: UIBarButtonItem) {
        uitslag = Int(aantal.text ?? "") ?? 1
        uitslag += 1
        aantal.text? = String(uitslag)
    }
    
    func doorgeef(_ sender: UITableViewCell) {
        label.text = sender.textLabel?.text
        aantal.text = sender.detailTextLabel?.text
        cell = sender
    }
}
