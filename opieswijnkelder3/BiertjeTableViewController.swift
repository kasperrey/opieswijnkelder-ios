//
//  BiertjeTableViewController.swift
//  opieswijnkelder3
//
//  Created by user226791 on 9/13/22.
//

import UIKit
import CoreData


protocol doorgeefcellDelegate: class {
    func doorgeef(_ sender: UITableViewCell)
}


class BiertjeTableViewController: UITableViewController {
    
    var biertjes = [Biertje]()
    weak var delegate: doorgeefcellDelegate?
    var cellen = [UITableViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = Biertje.fetchRequest() as NSFetchRequest<Biertje>
        
        let sort1 = NSSortDescriptor(key: "naam", ascending: true)
        fetchRequest.sortDescriptors = [sort1]
        
        do {
            biertjes = try context.fetch(fetchRequest)
        } catch let error {
            print("dit is de error \(error)")
        }
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return biertjes.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "biertjecelidentifier", for: indexPath)
        let bier = biertjes[indexPath.row]
        let naam = bier.naam ?? ""
        let aantal = String(bier.aantal)
        cell.textLabel?.text = naam
        cell.detailTextLabel?.text = aantal
        cellen.append(cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if biertjes.count > indexPath.row {
            let bier = biertjes[indexPath.row]
            context.delete(bier)
            biertjes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            do {
                try context.save()
            } catch let error {
                print("dit is de error \(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = cellen[indexPath.item]
        delegate?.doorgeef(cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if type(of:  segue.destination) == showviewcontroller.self {
            let navigationcontroller = segue.destination as! showviewcontroller
            delegate = navigationcontroller
        }
    }
}
