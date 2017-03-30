//
//  MovieCell.swift
//  MovieViewer
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var overviewTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        overviewTextView.textColor = UIColor.orange
        overviewTextView.backgroundColor = UIColor.black
        overviewTextView.isEditable = false
        overviewTextView.isSelectable = false
        titleLabel.textColor = UIColor.orange
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
