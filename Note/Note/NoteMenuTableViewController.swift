//
//  NoteMenuTableViewController.swift
//  Note
//
//  Created by ZhengXin on 2017/12/4.
//  Copyright © 2017年 ZhengXin. All rights reserved.
//

import UIKit

class NoteMenuTableViewController: UITableViewController {

    //var notes = [NoteSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //notes = dataManager.currentNoteBook.notes
        self.tableView.rowHeight = (tableView.bounds.size.height - 70)/10
        
        self.tableView.reloadData()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        //self.revealViewController().rearViewRevealWidth =
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print(notes.count)
        return dataManager.notebooks[dataManager.currentIndex].notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)

        let noteItem = dataManager.notebooks[dataManager.currentIndex].notes[indexPath.row]
        
        cell.imageView?.image = noteItem.representImage
        cell.textLabel?.text = noteItem.title
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.black
        
        if(dataManager.currentSectionIndex == indexPath.row)
        {
            cell.layer.backgroundColor = UIColor.lightGray.cgColor
        }
        else{
            cell.layer.backgroundColor = UIColor.white.cgColor
        }
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        if let viewController = self.revealViewController().frontViewController.childViewControllers[0] as? MyNoteDetailViewController{
            print(indexPath.row)
            
            viewController.setSection(index: indexPath.row)
            dataManager.currentSectionIndex = indexPath.row
            self.revealViewController().revealToggle(animated: true)
            self.tableView.reloadData()
        }
        else{
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        tableView.reloadData()
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            let note = dataManager.notebooks[dataManager.currentIndex]
            let noteID = note.noteBookId
            let noteSectionID = note.notes[indexPath.row].noteSectionID
            coreDataManager.deleteData(noteBookID: noteID, noteSectionID: noteSectionID)
            dataManager.deleteNoteSection(NoteBookID: noteID, NoteSectionID: noteSectionID)
            self.tableView.reloadData()
            print("delete")
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
 
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
