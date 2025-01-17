//
//  RegisterViewController.swift
//  neostore
//
//  Created by Neosoft on 28/10/24.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstnametextfield: UITextField!
    @IBOutlet weak var lastnametextfield: UITextField!
    @IBOutlet weak var emailtextfield: UITextField!
    @IBOutlet weak var passwordtextfield: UITextField!
    @IBOutlet weak var confirmpasswordtextfield: UITextField!
    @IBOutlet weak var termstext: UILabel!
    @IBOutlet weak var malebtn: UIButton!
    @IBOutlet weak var femalebtn: UIButton!
    @IBOutlet weak var phonetextfield: UITextField!
    @IBOutlet weak var termsbtn: UIButton!
    
    var isCheckboxSelected = false
    var selectedGender: String = Constants.Male
    private lazy var viewModel = RegisterViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationUI()
        
        viewModel.onSuccess = { [weak self] in
            self?.showAlert1(title: AlertConstants.Success, message: AlertConstants.RegistrationSuccess)
          }
          
          viewModel.onFailure = { [weak self] errorMessage in
              self?.showAlert1(title: AlertConstants.Error, message: "\(AlertConstants.RegistrationFail) \(errorMessage)")
          }
        firstnametextfield.text = "Mayur"
        lastnametextfield.text = "Patil"
        emailtextfield.text = "Mayur321@gmail.com"
        passwordtextfield.text = "Mayur@321"
        confirmpasswordtextfield.text = "Mayur@321"
        phonetextfield.text = "1234567891"
    }
    
    func navigationUI() {
        
        self.navigationController?.navigationBar.tintColor = .white
        self.title = NavigationTitleConst.Register
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 23)
        ]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }




    
  
    

   
    private func setupUI() {
        configureRadioButtonImages()
        configureCheckboxButton()
        setGender(selectedGender: Constants.Male)
        setupTextFields()
        setUnderlineForTermsText()
        hidekeyboard()
    }

    private func configureRadioButtonImages() {
        malebtn.setImage(UIImage(named: Constants.UnselectedRadioButton), for: .normal)
        malebtn.setImage(UIImage(named: Constants.SelectedRadioButton), for: .selected)
        femalebtn.setImage(UIImage(named: Constants.UnselectedRadioButton), for: .normal)
        femalebtn.setImage(UIImage(named: Constants.SelectedRadioButton), for: .selected)
    }

    
    private func configureCheckboxButton() {
        termsbtn.setImage(UIImage(named: Constants.UncheckedIcon), for: .normal)
    }

    
    private func setGender(selectedGender: String) {
        if selectedGender == Constants.Male {
            malebtn.isSelected = true
            femalebtn.isSelected = false
        } else if selectedGender == Constants.Female {
            malebtn.isSelected = false
            femalebtn.isSelected = true
        }
    }

  
    private func setupTextFields() {
        firstnametextfield.setIcon(UIImage(named: Constants.Usernameicon) ?? UIImage())
        lastnametextfield.setIcon(UIImage(named: Constants.Usernameicon) ?? UIImage())
        emailtextfield.setIcon(UIImage(named: Constants.EmailIcon) ?? UIImage())
        passwordtextfield.setIcon(UIImage(named: Constants.PasswordIcon) ?? UIImage())
        confirmpasswordtextfield.setIcon(UIImage(named: Constants.PasswordIcon) ?? UIImage())
        phonetextfield.setIcon(UIImage(named: Constants.PhoneIcon) ?? UIImage())
    }

   
    private func setUnderlineForTermsText() {
        let text = "I agree to the "
        let attributedText = NSMutableAttributedString(string: text)
        let underline = NSMutableAttributedString(
            string: "terms and conditions",
            attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        )
        attributedText.append(underline)
        termstext.attributedText = attributedText
    }

   
    
    private func validateFields() -> Bool {
        return firstnametextfield.validate(for: .firstName) &&
               lastnametextfield.validate(for: .lastName) &&
               emailtextfield.validate(for: .email) &&
               passwordtextfield.validate(for: .password) &&
               confirmpasswordtextfield.validate(for: .confirmPassword, passwordToMatch: passwordtextfield.text) &&
               phonetextfield.validate(for: .mobileNumber) &&
               isCheckboxSelected
    }

   
    @IBAction func femaleButtonTapped(_ sender: Any) {
        selectedGender = Constants.Female
        setGender(selectedGender: Constants.Female)
    }

    @IBAction func termsButtonTapped(_ sender: Any) {
        isCheckboxSelected.toggle()
        let imageName = isCheckboxSelected ? Constants.CheckedIcon : Constants.UncheckedIcon
        termsbtn.setImage(UIImage(named: imageName), for: .normal)
    }

    @IBAction func maleButtonTapped(_ sender: Any) {
        selectedGender = Constants.Male
        setGender(selectedGender: Constants.Male)
    }

    @IBAction func registerButtonTapped(_ sender: Any) {
        guard validateFields() else {
            showAlert1(title: AlertConstants.Error, message: "Please fill out all fields correctly.")
                    return
                }
                
                let registrationData = RegistrationData(
                    gender: selectedGender,
                    password: passwordtextfield.text,
                    confirm_password: confirmpasswordtextfield.text,
                    last_name: lastnametextfield.text,
                    email: emailtextfield.text,
                    phone_no: phonetextfield.text,
                    first_name: firstnametextfield.text
                )
        
        viewModel.registerUser(with: registrationData)
    }
}
