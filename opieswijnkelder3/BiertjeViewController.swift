//
//  ViewController.swift
//  opieswijnkelder3
//
//  Created by user226791 on 9/7/22.
//

import UIKit
import CoreData


class BiertjeViewController: UIViewController {
    
    @IBOutlet var naam: UITextField!
    @IBOutlet var aantal: UITextField!
    var uitslag = 0
    
    var biertjes = [Biertje]()
    
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
        
    @IBAction func opslaanGetikt(_ sender: UIBarButtonItem) {
        let aantaltext = Int16(aantal.text ?? "1")
        let naamtext = naam.text ?? ""
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = Biertje.fetchRequest() as NSFetchRequest<Biertje>
        
        do {
            biertjes = try context.fetch(fetchRequest)
        } catch let error {
            print("dit is de error \(error)")
        }
        
        if self.nummervan(naamtext, biertjes) == -1 {
            let biertje = Biertje(context: context)
            biertje.aantal = aantaltext ?? Int16(1)
            biertje.naam = naamtext
            biertje.biertjeid = UUID().uuidString
        } else {
            biertjes[self.nummervan(naamtext, biertjes)].aantal += aantaltext ?? Int16(1)
            let biertje = biertjes[self.nummervan(naamtext, biertjes)]
        }
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
        uitslag = Int(aantal.text ?? "") ?? Int(1)
        uitslag -= 1
        aantal.text? = String(uitslag)
    }
    
    @IBAction func plus(_ sender: UIBarButtonItem) {
        uitslag = Int(aantal.text ?? "") ?? Int(1)
        uitslag += 1
        aantal.text? = String(uitslag)
    }
}

