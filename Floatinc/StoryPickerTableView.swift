//
//  StoryPickerTableView.swift
//  Floatinc
//
//  Created by Vedant Khattar on 2016-07-30.
//  Copyright © 2016 Vedant Khattar. All rights reserved.
//

import UIKit

class StoryPickerTableView : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Will get this value when segging to storyPicker
    var storyTagStore : StoryTagStore!
    var storyRowSelected = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func rowSelected() -> Int {
        return self.storyRowSelected
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storyTagStore.storyTagListCount()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .Top)
        let defaultCell = self.tableView.cellForRowAtIndexPath(indexPath) as! StoryPickerTableViewCell
        defaultCell.pickerButton.setImage(UIImage(named: "selectedPicker"), forState: .Normal)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "StoryPickerTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StoryPickerTableViewCell
        
        cell.storyNameLabel.text = storyTagStore.storyTagList[indexPath.row].storyName
        
        if indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
            cell.layer.borderWidth = 0.0
            return cell
        }
        else {
            cell.layer.borderColor = UIColor.lightGrayColor().CGColor
            cell.layer.borderWidth = 0.05
            cell.layer.cornerRadius = 4.0
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selecting row number: \(indexPath.row)")
        if storyRowSelected != indexPath.row {
            
            //resetting previous selected row
            let previousIndexPath = NSIndexPath(forRow: storyRowSelected, inSection: 0)
            let previousPickedCell = tableView.cellForRowAtIndexPath(previousIndexPath) as! StoryPickerTableViewCell
            previousPickedCell.pickerButton.setImage((UIImage(named: "emptyPicker")), forState: .Normal)
        
            //updating image of new picked cell
            let pickedCell = tableView.cellForRowAtIndexPath(indexPath) as! StoryPickerTableViewCell
            pickedCell.pickerButton.setImage(UIImage(named: "selectedPicker"), forState: .Normal)
            
            //updated selected story row
            self.storyRowSelected = indexPath.row
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.view.layer.masksToBounds =  false
        self.view.layer.shadowColor = UIColor.redColor().CGColor
        self.view.layer.shadowOffset = CGSizeMake(0, 10.0)
        self.view.layer.shadowOpacity = 1
        self.view.layer.shadowRadius = 8.0
    }
}
