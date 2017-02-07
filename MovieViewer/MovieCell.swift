//
//  MovieCell.swift
//  MovieViewer
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
