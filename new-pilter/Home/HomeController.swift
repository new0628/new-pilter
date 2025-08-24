//
//  ViewController.swift
//  new-pilter
//
//  Created by 이상원 on 7/1/25.
//

import UIKit
import FlexLayout
import PinLayout

class HomeController: UIViewController {
    private let homeView = HomeView()

    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarTitleView()
        setupActions()
        addDismissKeyboardGesture()
    }
    override func viewDidAppear(_ animated: Bool) {
        homeView.resetStep1Style()
        homeView.resetStep2Style()
        homeView.resetStep3Style()
        homeView.clearStep2TextField()
    }

    // MARK: - 네비게이션바는 stackView가 더 간단
    private func setupNavigationBarTitleView() {
        let titleLabel = UILabel()
        titleLabel.text = "Home"
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .black

        // gif 이미지 설정
        if let gifImage = UIImage.gif(name: "Home_anicon") {
            let animatedImageView = UIImageView(image: gifImage)
            animatedImageView.contentMode = .scaleAspectFit
            animatedImageView.translatesAutoresizingMaskIntoConstraints = false
            animatedImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            animatedImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true

            let stackView = UIStackView(arrangedSubviews: [titleLabel, animatedImageView])
            stackView.axis = .horizontal
            stackView.spacing = 8
            stackView.alignment = .center
            self.navigationItem.titleView = stackView
        }
        else {
            self.navigationItem.titleView = titleLabel
        }
    }

    // 각 버튼의 액션
    private func setupActions() {
        homeView.shootButton.addTarget(self, action: #selector(shootButtonTapped), for: .touchUpInside)
        homeView.getShapeButtons().forEach { button in
            button.addTarget(self, action: #selector(shapeButtonTapped(_:)), for: .touchUpInside)
        }
        homeView.skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        homeView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        homeView.accordionButton.addTarget(self, action: #selector(toggleAccordion), for: .touchUpInside)
    }

    // 화면 아무곳이나 터치시 키보드 내려가게
    private func addDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }


}

// setupAction 보충
extension HomeController {
    @objc private func shootButtonTapped() {
        print("촬영하기 버튼 탭")
        homeView.updateStep3Style()
        homeView.resetSelectedShapeButton()
        homeView.resetStep1Style()
        homeView.resetStep2Style()
        homeView.resetSkipAndSaveBtn()
        homeView.clearStep2TextField()
    }

    @objc private func shapeButtonTapped(_ sender: UIButton) {
        print("모양 버튼 탭: \(sender.accessibilityIdentifier ?? "")")
        homeView.updateSelectedShapeButton(sender)
        homeView.updateStep1Style()
    }

    @objc private func skipButtonTapped() {
        print("생략 버튼 탭")
        homeView.updateButtonStyles(isSaveButtonSelected: false)
        homeView.updateStep2Style()
        homeView.clearStep2TextField()
        homeView.setPillInfoFlag()
    }

    @objc private func saveButtonTapped() {
        print("저장 버튼 탭")
        homeView.updateButtonStyles(isSaveButtonSelected: true)
        homeView.updateStep2Style()
        homeView.setPillInfoFlag()
    }

    @objc private func toggleAccordion() {
        print("아코디언 토글")
        homeView.toggleAccordion()
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

