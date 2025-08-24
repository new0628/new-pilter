////
////  HomeView.swift
////  new-pilter
////
////  Created by 이상원 on 7/8/25.
////
//
import UIKit

// MARK: - HomeView (UI를 모두 담당)
class HomeView: UIView {

    private let rootFlexContainer = UIView()
    private let scrollView = UIScrollView()
    private let whiteContainerView = UIView()

    // UI 요소
    // Home 페이지
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let pillImageView = UIImageView()

    // Step 1
    private let step1NumberLabel = UILabel()
    private let step1Label = UILabel()

    // Shape 버튼
    private var shapeButtons: [UIButton] = []
    private var selectedButton: UIButton?

    // Step 2
    private let step2NumberLabel = UILabel()
    private let step2Label = UILabel()
    private let step2InfoLabel = UILabel()
    let accordionButton = UIButton(type: .system)
    private let accordionFlexView = UIView()
    private let frontLabel = UILabel()
    let frontTextField = UITextField()
    private let backLabel = UILabel()
    let backTextField = UITextField()
    let skipButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)

    // Step 3
    private let step3NumberLabel = UILabel()
    private let step3Label = UILabel()
    let shootButton = UIButton(type: .system)

    // 다음 페이지로 보낼 정보들
    private var frontText: String? // 식별정보 앞내용
    private var backText: String? // 식별정보 뒷내용
    private var shapeType: String? // 모양
    
    private var isShapeTypeFlag: Bool = false // 알약 타입을 눌러야 다음으로 넘어감
    private var isPillInfoFlag: Bool = false // 식별정보 생략, 저장 상태
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(hexCode: "#DEDEEB")
        //backgroundColor = UIColor.black
        
        // whiteContainerView의 layer 속성 설정
        whiteContainerView.backgroundColor = .white
        whiteContainerView.layer.cornerRadius = 32
        whiteContainerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        accordionFlexView.isHidden = true
        setupComponentProperties()
        setupShapeButtons()
        setupHierarchy()
        setupLayoutWithFlexLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init error")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.pin.all(pin.safeArea)
        rootFlexContainer.pin.top().horizontally()
        rootFlexContainer.flex.layout(mode: .adjustHeight)
        scrollView.contentSize = rootFlexContainer.frame.size
    }


    // MARK: - UI Setup

    private func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(rootFlexContainer)
    }

    private func setupComponentProperties() {
        // Home description
        titleLabel.text = " Pillter"
        titleLabel.font = UIFont(name: "ConcertOne-Regular", size: 50)
        titleLabel.textColor = UIColor(hexCode: "#22212E")

        descriptionLabel.text = """
           ①  알약 타입은 반드시 선택해주세요.
        
           ②  식별 정보 = 정확도 향상!
        
           ③  촬영 버튼 클릭!
        """
        descriptionLabel.font = UIFont(name: "SOYO Maple Bold", size: 12)
        descriptionLabel.textColor = UIColor(hexCode: "#22212E")
        descriptionLabel.numberOfLines = 0

        pillImageView.image = UIImage(named: "pill")
        pillImageView.contentMode = .scaleAspectFit

        // step 1
        step1NumberLabel.text = "1"
        step1NumberLabel.textColor = .white
        step1NumberLabel.textAlignment = .center
        step1NumberLabel.backgroundColor = UIColor(hexCode: "#00459C")
        step1NumberLabel.layer.cornerRadius = 14
        step1NumberLabel.clipsToBounds = true

        step1Label.text = "알약 타입을 선택해주세요."
        step1Label.textColor = UIColor(hexCode: "#00459C")
        step1Label.font = UIFont(name: "SOYO Maple Bold", size: 15)

        // step 2
        step2NumberLabel.text = "2"
        step2NumberLabel.textColor = UIColor(hexCode: "#00459C")
        step2NumberLabel.textAlignment = .center
        step2NumberLabel.font = UIFont(name: "SourceSansPro-SemiBold", size: 18)

        step2Label.text = "식별 정보를 입력해주세요."
        step2Label.textColor = UIColor(hexCode: "#00459C")
        step2Label.font = UIFont(name: "SOYO Maple Bold", size: 15)
        
        step2InfoLabel.text = "영어, 숫자만 입력해주시고 모든글자를 붙여서 입력해주세요."
        step2InfoLabel.font = UIFont(name: "SOYO Maple Bold", size: 14)
        step2InfoLabel.textColor = UIColor(hexCode: "#777777")
        step2InfoLabel.numberOfLines = 1
        step2InfoLabel.adjustsFontSizeToFitWidth = true // 텍스트 길면 폰트를 줄여서라도 1줄로 맞춤
        step2InfoLabel.minimumScaleFactor = 0.5

        let chevronDownImage = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysOriginal)
        accordionButton.setImage(chevronDownImage, for: .normal)
        accordionButton.configuration = nil
        accordionButton.semanticContentAttribute = .forceLeftToRight
        //accordionButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: -5, bottom: 4, right: 0)
        accordionButton.setTitle("식별 정보(없는 경우 x를 입력해주세요)", for: .normal)
        accordionButton.setTitleColor(.black, for: .normal)
        accordionButton.contentHorizontalAlignment = .left
        accordionButton.titleLabel?.font = UIFont(name: "SOYO Maple Bold", size: 15)

        frontLabel.text = "식별 정보 앞"
        frontLabel.font = UIFont.systemFont(ofSize: 14)
        frontTextField.borderStyle = .roundedRect
        frontTextField.placeholder = "User Text"

        backLabel.text = "식별 정보 뒤"
        backLabel.font = UIFont.systemFont(ofSize: 14)
        backTextField.borderStyle = .roundedRect
        backTextField.placeholder = "User Text"

        skipButton.setTitle("생략", for: .normal)
        skipButton.setTitleColor(UIColor(hexCode: "#00459C"), for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        skipButton.layer.cornerRadius = 5
        skipButton.layer.borderWidth = 1
        skipButton.layer.borderColor = UIColor(hexCode: "#00459C").cgColor
        
        saveButton.setTitle("저장", for: .normal)
        saveButton.setTitleColor(UIColor(hexCode: "#00459C"), for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        saveButton.layer.cornerRadius = 5
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor(hexCode: "#00459C").cgColor

        accordionFlexView.isHidden = true

        step3NumberLabel.text = "3"
        step3NumberLabel.textColor = UIColor(hexCode: "#00459C")
        step3NumberLabel.textAlignment = .center
        step3NumberLabel.font = UIFont(name: "SourceSansPro-SemiBold", size: 18)

        // step 3
        step3Label.text = "촬영하기"
        step3Label.textColor = UIColor(hexCode: "#00459C")
        step3Label.font = UIFont(name: "SOYO Maple Bold", size: 15)

        shootButton.setTitle("촬영하기", for: .normal)
        shootButton.setTitleColor(.white, for: .normal)
        shootButton.backgroundColor = UIColor(hexCode: "#00459C")
        shootButton.layer.cornerRadius = 8
        shootButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }

    private func setupShapeButtons() {
        let shapes = [
            ("원형", "CirclePill"), ("타원형", "OvalPill"), ("삼각형", "TrianglePill"),
            ("사각형", "SquarePill"), ("오각형", "PentagonPill"), ("육각형", "HexagonPill")
        ]
        
        shapes.forEach { title, imageName in
            let button = createShapeButton(with: title, imageName: imageName)
            button.accessibilityIdentifier = title
            shapeButtons.append(button)
        }
    }

    private func createShapeButton(with title: String, imageName: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor(hexCode: "#E5E5E5").cgColor
        button.backgroundColor = .white

        let imageView = UIImageView(image: UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = UIColor(hexCode: "#444444")

        let label = UILabel()
        label.text = title
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)

        button.flex.width(104).height(75).alignItems(.center).justifyContent(.center).define { flex in
            flex.addItem(imageView).size(25)
            flex.addItem(label).marginTop(5)
        }
        return button
    }
    
    
    private func setupLayoutWithFlexLayout() {
        rootFlexContainer.flex.define { flex in
            
            // Home Description FlexLayout에 추가
            flex.addItem().direction(.row).padding(0, 10, 0, 10).alignItems(.start).define { flex in
                flex.addItem().grow(1).shrink(1).define { flex in
                    flex.addItem(titleLabel)
                    flex.addItem(descriptionLabel).marginTop(5).marginLeft(10).marginRight(10)
                }
                flex.addItem(pillImageView).size(140).marginLeft(10)
            }

            // Step1~3 FlexLayout에 추가
            flex.addItem(whiteContainerView)
                .padding(30, 20, 60, 20)
                .marginTop(20)
                .define { flex in
                    // Step 1
                    flex.addItem().define { flex in
                        flex.addItem().direction(.row).alignItems(.center).define { flex in
                            flex.addItem(step1NumberLabel).size(28)
                            flex.addItem(step1Label).marginLeft(10)
                        }
                        flex.addItem().height(18).width(2).backgroundColor(UIColor(hexCode: "#0067C5")).marginLeft(13).marginTop(4)
                    }

                    // Shape buttons
                    flex.addItem().direction(.column).marginTop(15).define { flex in
                        flex.addItem().direction(.row).justifyContent(.spaceBetween).define { flex in
                            flex.addItem(shapeButtons[0])
                            flex.addItem(shapeButtons[1])
                            flex.addItem(shapeButtons[2])
                        }
                        flex.addItem().direction(.row).justifyContent(.spaceBetween).marginTop(15).define { flex in
                            flex.addItem(shapeButtons[3])
                            flex.addItem(shapeButtons[4])
                            flex.addItem(shapeButtons[5])
                        }
                    }

                    // Step 2
                    flex.addItem().alignItems(.stretch).marginTop(30).define { flex in
                        flex.addItem().define { flex in
                            flex.addItem().direction(.row).alignItems(.center).define { flex in
                                flex.addItem().size(28).justifyContent(.center).alignItems(.center)
                                    .cornerRadius(14).border(2, UIColor(hexCode: "#00459C")).define { flex in
                                    flex.addItem(step2NumberLabel)
                                }
                                flex.addItem(step2Label).marginLeft(10)
                            }
                            flex.addItem().height(18).width(2).backgroundColor(UIColor(hexCode: "#0067C5")).marginTop(10).marginLeft(13)
                        }
                        
                        flex.addItem(step2InfoLabel).marginVertical(15).marginHorizontal(10)

                        flex.addItem().height(1).backgroundColor(UIColor(hexCode: "#CAD0D6"))
                        flex.addItem(accordionButton).height(40).marginVertical(5)
                       
                        // 아코디언 뷰. 초기에는 숨김.
                        flex.addItem(accordionFlexView).isIncludedInLayout(false).marginHorizontal(10).paddingBottom(10).define { flex in
                            flex.addItem(frontLabel).marginTop(10)
                            flex.addItem(frontTextField).height(35).marginTop(10)
                            flex.addItem(backLabel).marginTop(10)
                            flex.addItem(backTextField).height(35).marginTop(10)
                            flex.addItem().direction(.row).justifyContent(.center).marginTop(10).define { flex in
                                flex.addItem(skipButton).grow(1).height(30)
                                flex.addItem(saveButton).grow(1).height(30).marginLeft(10)
                            }
                        }
                        
                        flex.addItem().height(1).backgroundColor(UIColor(hexCode: "#CAD0D6"))
                    }

                    // Step 3
                    flex.addItem().marginTop(30).define { flex in
                        flex.addItem().direction(.row).alignItems(.center).define { flex in
                            flex.addItem().size(28).justifyContent(.center).alignItems(.center)
                                .cornerRadius(14).border(2, UIColor(hexCode: "#00459C")).define { flex in
                                flex.addItem(step3NumberLabel)
                            }
                            flex.addItem(step3Label).marginLeft(10)
                        }
                        flex.addItem().height(18).width(2).backgroundColor(UIColor(hexCode: "#0067C5")).marginLeft(13).marginTop(4)
                    }

                    flex.addItem(shootButton).height(50).marginTop(30)
                }
        }
    }

    // MARK: - 알약 타입 버튼 스타일

    private func resetButtonStyle(_ button: UIButton) {
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor(hexCode: "#E5E5E5").cgColor
        button.layer.shadowOpacity = 0
    }

    private func applySelectedStyle(to button: UIButton) {
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(red: 32/255, green: 142/255, blue: 210/255, alpha: 0.78).cgColor
        button.layer.shadowColor = UIColor(red: 32/255, green: 142/255, blue: 210/255, alpha: 0.58).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
    }
}

// MARK: - UI 업데이트 관련 함수
extension HomeView {

    func getShapeButtons() -> [UIButton] {
        return shapeButtons
    }

    func updateSelectedShapeButton(_ sender: UIButton) {
        if let previousButton = selectedButton, previousButton != sender {
            resetButtonStyle(previousButton)
        }
        applySelectedStyle(to: sender)
        selectedButton = sender
        
        setShapeTypeFlag()
    }
    
    // MARK: - Step 1~3 스타일
    func updateStep1Style() {
        step1NumberLabel.text = "✔︎"
    }
    func resetStep1Style() {
        step1NumberLabel.text = "1"
        resetShapeTypeFlag()
    }

    func updateStep2Style() {
        let step2CircleView = step2NumberLabel.superview!
        step2CircleView.flex.backgroundColor(UIColor(hexCode: "#00459C")).markDirty()
        step2NumberLabel.text = "✔︎"
        step2NumberLabel.textColor = .white
        rootFlexContainer.flex.markDirty()
        setNeedsLayout()
    }
    func resetStep2Style() {
        step2NumberLabel.text = "2"
        resetPillInfoFlag()
    }
    
    func updateStep3Style() {
        let step3CircleView = step3NumberLabel.superview!
        step3CircleView.flex.backgroundColor(UIColor(hexCode: "#00459C")).markDirty()
        step3NumberLabel.text = "✔︎"
        step3NumberLabel.textColor = .white
        rootFlexContainer.flex.markDirty()
        setNeedsLayout()
    }
    func resetStep3Style() {
        step3NumberLabel.text = "3"
    }
    // MARK: , -

    func toggleAccordion() {
        let isHidden = accordionFlexView.isHidden

        // 아이콘 변경
        let imageName = isHidden ? "chevron.up" : "chevron.down"
        accordionButton.setImage(UIImage(systemName: imageName), for: .normal)

        // FlexLayout 업데이트 및 애니메이션
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.accordionFlexView.flex.isIncludedInLayout(isHidden)
                self.accordionFlexView.isHidden = !isHidden
                self.rootFlexContainer.flex.layout(mode: .adjustHeight)
                self.scrollView.contentSize = self.rootFlexContainer.frame.size
                self.rootFlexContainer.layoutIfNeeded()
            },
//            completion: { _ in
//                  
//            }
        )
    }
    
    // 저장, 스킵 버튼 업데이트
    func updateButtonStyles(isSaveButtonSelected: Bool) {
        if isSaveButtonSelected {
            saveButton.setTitleColor(.white, for: .normal)
            saveButton.backgroundColor = UIColor(hexCode: "#00459C")
            skipButton.setTitleColor(UIColor(hexCode: "#00459C"), for: .normal)
            skipButton.backgroundColor = .white
        }
        else {
            saveButton.setTitleColor(UIColor(hexCode: "#00459C"), for: .normal)
            saveButton.backgroundColor = .white
            skipButton.setTitleColor(.white, for: .normal)
            skipButton.backgroundColor = UIColor(hexCode: "#00459C")
        }
    }
    // 저장, 스킵버튼 둘다 초기화
    func resetSkipAndSaveBtn() {
        skipButton.setTitleColor(UIColor(hexCode: "#00459C"), for: .normal)
        skipButton.backgroundColor = .white
        saveButton.setTitleColor(UIColor(hexCode: "#00459C"), for: .normal)
        saveButton.backgroundColor = .white
    }

    // 선택된 알약 모양 버튼 리셋
    func resetSelectedShapeButton() {
        if let button = selectedButton {
            resetButtonStyle(button)
            selectedButton = nil
        }
    }

    // 식별정보 앞뒤 빈칸처리
    func clearStep2TextField() {
        frontTextField.text = ""
        backTextField.text = ""
    }
    
    
    //shapeType 버튼 눌렸을때
    private func setShapeTypeFlag() {
        guard !isShapeTypeFlag else {
            print("이미 isShapeTyoeFlag는 true")
            return
        }
        isShapeTypeFlag = true
        print("isShapeTypeFlag = \(isShapeTypeFlag)")
    }
    // 화면 이동되었다가 돌아올때
    func resetShapeTypeFlag() {
        guard isShapeTypeFlag else {
            print("이미 isShapeTyoeFlag는 false")
            return
        }
        isShapeTypeFlag = false
        print("isShapeTypeFlag = \(isShapeTypeFlag)")
    }
    // pillinfo 저장, 생략 버튼 눌렸을때
    func setPillInfoFlag() {
        guard !isPillInfoFlag else {
            print("이미 isPillInfoFlag는 true")
            return
        }
        isPillInfoFlag = true
        print("isPillInfoFlag = \(isPillInfoFlag)")
    }
    // 화면 이동되거나 돌아올때
    func resetPillInfoFlag() {
        guard isPillInfoFlag else {
            print("이미 isPillInfoFlag는 false")
            return
        }
        isPillInfoFlag = false
        print("isPillInfoFlag = \(isPillInfoFlag)")
    }
}
