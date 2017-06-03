//
//  MessageStaetView.swift
//  JojoDataSources
//
//  Created by Yousef Hamza on 5/22/17.
//  Copyright © 2017 yousefhamza. All rights reserved.
//

import UIKit
import SnapKit

protocol MessageStateDelegate {
    func retry()
}

class MessageStateView: UIView {
    let messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment  = .center
        return label
    }()

    let retryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        button.backgroundColor = UIColor(red:0.31, green:0.41, blue:0.36, alpha:1.0)
        return button
    }()

    var delegate: MessageStateDelegate?

    init(withMessage message: String, messageImage: UIImage?, delegate: MessageStateDelegate) {
        self.delegate = delegate
        messageLabel.text = message
        messageImageView.image = messageImage

        super.init(frame: .zero)

        addSubview(messageImageView)
        addSubview(messageLabel)
        addSubview(retryButton)

        layout()

        retryButton.addTarget(self, action: #selector(retryButtonPressed), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {
        messageLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
            make.left.greaterThanOrEqualTo(self).offset(30)
            make.right.lessThanOrEqualTo(self).offset(-30)
        }

        messageImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.bottom.equalTo(messageLabel.snp.top).offset(10)
            make.top.greaterThanOrEqualTo(self).offset(10)
        }

        retryButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(messageLabel.snp.bottom).offset(10)
            make.bottom.lessThanOrEqualTo(self).offset(-30)
        }
    }

    func retryButtonPressed() {
        delegate?.retry()
    }
}
