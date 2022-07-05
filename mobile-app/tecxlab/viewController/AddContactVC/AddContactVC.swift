//
//  AddContactVC.swift
//  tecxlab
//
//  Created by bhavin joshi on 04/09/21.
//

import UIKit

class AddContactVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    @IBOutlet weak var txtEmailAddress : UITextField!
    @IBOutlet weak var txtPhoneNumber : UITextField!
    @IBOutlet weak var txtFullName : UITextField!
    @IBOutlet weak var txtGroup : UITextField!
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var btnAddProfile : UIButton!
    
    var contactDetailata : ContactDetailVM!
    
    var pickerImage : UIImagePickerController = UIImagePickerController()
    var image : UIImage!
    var isEditProfile = false
    var dictContactDetail = ContactDetailModel()
    var updated = 0
    var arrGroup = NSMutableArray()
    var myPickerView : UIPickerView!
    var strProfile = String()
    
    private var AddEvent : AddEditContactVM!
    private var EditEvent : AddEditContactVM!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrGroup = ["Family","Friend","Visitor"]
        self.pickerImage.delegate = self
        self.txtGroup.delegate = self
        if self.isEditProfile{
            self.DisplayData()
        }
        self.navigationbarButtons()
        if self.isEditProfile{
            self.navigationItem.title = "Edit Contact"
        }
        else{
            self.navigationItem.title = "Add Contact"
        }
        // Do any additional setup after loading the view.
    }
    
    func navigationbarButtons(){
        let addbtn = UIBarButtonItem(image: UIImage(named: "back_arrow"), style: .plain, target: self, action: #selector(AddContactClick))
        navigationItem.leftBarButtonItems = [addbtn]
    }
    
    @objc func AddContactClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func DisplayData(){
        self.txtFullName.text = self.contactDetailata.contactDetailData.body?.fullname ?? ""
        self.txtEmailAddress.text = self.contactDetailata.contactDetailData.body?.emailID ?? ""
        self.txtPhoneNumber.text = self.contactDetailata.contactDetailData.body?.phone ?? ""
        self.txtGroup.text = self.contactDetailata.contactDetailData.body?.group ?? ""
        self.imgProfile.sd_setImage(with: URL(string:self.contactDetailata.contactDetailData.body?.img ?? ""), placeholderImage: UIImage(named: "user_placeholder"))
        DispatchQueue.main.async(execute: {
            self.image = self.imgProfile.image
            self.strProfile = self.ConvertImageToBase64String(img: self.image)
        })
    }
    
    func pickUp(textfiled : UITextField){
        // UIPickerView
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor.white
        textfiled.inputView = self.myPickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textfiled.inputAccessoryView = toolBar
        
    }
    
    
    @objc func doneClick() {
        if self.updated == 1{
            self.updated = 0
        }
        else{
            
            self.updated = 0
            if self.arrGroup.count > 0{
                self.txtGroup.text = self.arrGroup.object(at: 0) as? String ?? ""
            }
        }
        self.view.endEditing(true)
    }
    
    @objc func cancelClick() {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtGroup{
            self.pickUp(textfiled: self.txtGroup)
        }
    }
    
    
    @IBAction func btnSubmitClick (_ sender:Any){
        if self.txtFullName.text ?? "" == "" {
            Utils.popDialog(controller: self, title: "", message: "Enter Full Name")
            return
        }
        else if self.txtEmailAddress.text ?? "" == ""{
            Utils.popDialog(controller: self, title: "", message: "Enter Emial Address")
            return
        }
        else if !Utils().isValidEmailAddress(emailAddressString: self.txtEmailAddress.text ?? ""){
            Utils.popDialog(controller: self, title: "", message: "Please enter valid email address.")
            return
        }
        else if self.txtPhoneNumber.text ?? "" == ""{
            Utils.popDialog(controller: self, title: "", message: "Enter Phone Number")
            return
        }
        else if self.txtGroup.text ?? "" == ""{
            Utils.popDialog(controller: self, title: "", message: "Select Group")
            return
        }
        else{
            if self.isEditProfile{
                self.editProfile()
            }
            else{
                self.AddContact()
            }
        }
    }
    
    
    func ConvertImageToBase64String(img: UIImage) -> String {
        SHOW_CUSTOM_LOADER()
        let imageData:NSData = image.jpegData(compressionQuality: 0.50)! as NSData
        print(imageData)
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        HIDE_CUSTOM_LOADER()
        return imgString
    }
    
    
    func AddContact(){
        SHOW_CUSTOM_LOADER()
        let dictAddProfile = NSMutableDictionary()
        dictAddProfile.setValue(self.txtFullName.text ?? "", forKey: "fullname")
        dictAddProfile.setValue(self.txtEmailAddress.text ?? "", forKey: "emailId")
        dictAddProfile.setValue(self.txtPhoneNumber.text ?? "", forKey: "phone")
        dictAddProfile.setValue(self.txtGroup.text ?? "", forKey: "group")
        dictAddProfile.setValue(self.strProfile, forKey: "face")
        
        self.AddEvent = AddEditContactVM(AddFaceParam: dictAddProfile as! [String : Any])
        self.AddEvent.bindAddFaceDetailViewModelController = {
            if self.AddEvent.AddFaceDetail.statusCode == 200 || self.AddEvent.AddFaceDetail.statusCode == 201{
                DispatchQueue.main.async {
                    HIDE_CUSTOM_LOADER()
                    Utils.popDialog(controller: self, title: self.navigationItem.title ?? "", message: "Success")
                }
                
            }
            else{
                DispatchQueue.main.async {
                    HIDE_CUSTOM_LOADER()
                    Utils.popOnDialog(controller: self, title: self.navigationItem.title ?? "", message: "Something went wrong")
                }
            }
            
        }
    }
    
    func editProfile(){
        SHOW_CUSTOM_LOADER()
        let dictEditProfile = NSMutableDictionary()
        dictEditProfile.setValue(self.contactDetailata.contactDetailData.body?.fullname ?? "", forKey: "previous_name")
        dictEditProfile.setValue(self.txtFullName.text ?? "", forKey: "fullname")
        dictEditProfile.setValue(self.txtEmailAddress.text ?? "", forKey: "emailId")
        dictEditProfile.setValue(self.txtPhoneNumber.text ?? "", forKey: "phone")
        dictEditProfile.setValue(self.txtGroup.text ?? "", forKey: "group")
        dictEditProfile.setValue(self.strProfile, forKey: "face")
        
        self.AddEvent = AddEditContactVM(EditFaceParam: dictEditProfile as! [String : Any])
        self.AddEvent.bindEditFaceDetailViewModelController = {
            if self.AddEvent.EditFaceDetail.statusCode == 200 || self.AddEvent.EditFaceDetail.statusCode == 201{
                DispatchQueue.main.async {
                    HIDE_CUSTOM_LOADER()
                    Utils.popDialog(controller: self, title: self.navigationItem.title ?? "", message: "Success")
                }
                
            }
            else{
                DispatchQueue.main.async {
                    HIDE_CUSTOM_LOADER()
                    Utils.popOnDialog(controller: self, title: self.navigationItem.title ?? "", message: "Something went wrong")
                }
            }
        }
        
    }
    
    
    @IBAction func btnaddophoto(_ sender: Any) {
        self.popImagePicker()
    }
    func popImagePicker(){
        
        let actionSheet = UIAlertController(title: "Select image from", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "From gallery", style: .default, handler: { action in
            let pickerView = UIImagePickerController()
            pickerView.allowsEditing = true
            pickerView.delegate = self
            pickerView.sourceType = .photoLibrary
            self.present(pickerView, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "From camera", style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let pickerView = UIImagePickerController()
                pickerView.allowsEditing = true
                pickerView.delegate = self
                pickerView.sourceType = .camera
                self.present(pickerView, animated: true)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // Cancel button tappped.
            self.dismiss(animated: true) {
            }
        }))
        // Present action sheet.
        present(actionSheet, animated: true)
    }
    
    func openGallery()
    {
        pickerImage.allowsEditing = false
        pickerImage.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(pickerImage, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            pickerImage.allowsEditing = false
            pickerImage.sourceType = UIImagePickerController.SourceType.camera
            pickerImage.cameraCaptureMode = .photo
            present(pickerImage, animated: true, completion: nil)
        } else {
            Utils.popDialog(controller: self, title: "Camera Not Found", message: "This device has no Camera")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        self.image = selectedImage
        self.imgProfile.image = selectedImage
        self.strProfile = self.ConvertImageToBase64String(img: self.image)
        
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension AddContactVC : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrGroup.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  self.arrGroup.object(at: row) as? String ?? ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.arrGroup.count <= row{
            return
        }
        self.txtGroup.text = self.arrGroup.object(at: row) as? String ?? ""
        self.updated = 1
    }
}
