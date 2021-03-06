//
//  OldBaseOnboardingView.swift
//  Baby Monitor
//

import UIKit

class OldBaseOnboardingView: BaseView {
    
    var titleLeadingAnchor: NSLayoutXAxisAnchor {
        return titleLabel.leadingAnchor
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.customFont(withSize: .body, weight: .bold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.customFont(withSize: .small, weight: .regular)
        label.alpha = 0.5
        label.numberOfLines = 0
        return label
    }()
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "back"))
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override init() {
        super.init()
        setup()
    }
    
    func changeStyleToBluish() {
        titleLabel.textColor = .babyMonitorNonTranslucentWhite
        descriptionLabel.textColor = .babyMonitorNonTranslucentWhite
        backgroundImageView.image = #imageLiteral(resourceName: "onboarding-bluish-background")
    }
    
    func updateTitle(_ text: String) {
        titleLabel.text = text
    }
    
    func updateDescription(_ text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10

        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        descriptionLabel.attributedText = attributedString
    }
    
    private func setup() {
        [backgroundImageView, titleLabel, descriptionLabel].forEach {
            addSubview($0)
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        backgroundImageView.addConstraints { $0.equalEdges() }
        titleLabel.addConstraints {[
            $0.equal(.safeAreaTop, constant: frame.height * 0.13),
            $0.equal(.leading, constant: 24),
            $0.equal(.trailing)
            ]
        }
        descriptionLabel.addConstraints {[
            $0.equalTo(titleLabel, .leading, .leading),
            $0.equal(.trailing),
            $0.equalTo(titleLabel, .top, .bottom, constant: 24)
            ]
        }
    }
}
