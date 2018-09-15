//
//  MovieCell.swift
//  MovieViewer
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var overviewTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        ratingLabel.textColor = UIColor.black
        dateLabel.textColor = UIColor.gray
        overviewTextView.textColor = UIColor(red: 0.84, green: 0.74, blue: 0.70, alpha: 1.0)
        overviewTextView.backgroundColor = UIColor(red: 0.1, green: 0.07, blue: 0.02, alpha: 1.0)
        overviewTextView.isEditable = false
        overviewTextView.isSelectable = false
        titleLabel.textColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
