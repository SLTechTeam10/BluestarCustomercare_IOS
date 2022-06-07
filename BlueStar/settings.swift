//
//  settings.swift
//  BlueStar
//
//  Created by tarun.kapil on 25/07/16.
//  Copyright © 2016 BlueStar. All rights reserved.
//

import Foundation

// Mark: API URLs
//let serverURL = "http://203.76.134.156/bluestar/api/"
//let FAQsURL = "http://203.76.134.156/EnhancedTheme/themes/html/Enhanced/css/images/faq_lp/faqLp.html"

//Dev Server
    let serverURL = "http://service1.bluestarindia.com/bluestar/api/"
//    let mizeURL = "https://api.m-ize.com/bluestarccapp-dev/ccapp/"
//    let x_api_key = "pHxplITlsE8JM675VcdVa2NqaQxD5hId8yjlN9K5"

// UAT Server
    let mizeURL = "https://api.sandbox.mizecx.com/bluestarccapp-uat/ccapp/"
    let x_api_key = "O0kegiioVi7KfPQNhoaDN1VNo7ZKCrRv5ONM1s9P"

// Production Server
//    let mizeURL = "https://api.mizecx.com/bluestar/ccapp/"
//    let x_api_key = "FOsJwXorrKt7GSz1it7a2UdjZWWqGfV1OODbppkh"

//old Production
//let serverURL = "http://service.bluestarindia.com/bluestarcust/api/"

//new production not working
//let serverURL = "http://service.bluestarindia.com/bluestar"

//let serverURL = "http://203.76.134.156/bluestar/api/"

let FAQsURL = "http://service.bluestarindia.com/EnhancedTheme/themes/html/Enhanced/css/images/faq_lp_ios/faqLp.html"


/*
let requestOTPURL = serverURL + "requestotp"
let verifyOTPURL = serverURL + "verifyotp"
let productListURL = serverURL + "product"
let ticketHistoryURL = serverURL + "ticketLatestStatus"
let followTicketURL = serverURL + "statustracking"
let cancelTicketURL = serverURL + "cancelticket"
//let forceUpdateURL = mizeURL + "forceUpgrade"
//let forceUpdateURLTest = "https://s3-ap-southeast-1.amazonaws.com/bslapps/customercare/ios/versioninfo.json"
*/

enum TitleSelect: String {
    case MS = "Ms."
    case MR = "Mr."
    case MISS = "M/s."
    case DR = "Dr."
}

enum GenderSelect: String {
    case MALE = "Male"
    case FEMALE = "Female"
    case OTHER = "Other"
    case NODISCLOSE = "Rather not say"
}

enum AgeGroupSelect: String {
    case YOUNG = "Less than 18"
    case TEEN = "18 - 24"
    case TWEENTY = "25 - 34"
    case THIRTY = "35 - 44"
    case FOURTY = "45 - 54"
    case FIFTY = "55 & Above"
}
enum ResConfigSelect: String {
    case ONEBHK = "1 BHK"
    case TWOBHK = "2 BHK"
    case THREEBHK = "3 BHK"
    case FOURBHK = "4 BHK and Above"
}

let notificationHistoryURL = serverURL + "notificationhistory"
let getCustomerAddressesURL = serverURL + "getcustomeraddresses"
let generateTicketURL = serverURL + "ticket"
let registerDeviceTokenURL = serverURL + "push/notification"
let iBaseURL = serverURL + "ibase/getaddresses"
let forceUpdateURL = "https://appstore.bluestarindia.com/customercare/ios/versioninfo.json"

// SHANKAR : SAME API ON BOTH SERVER WHICH SHOULD WE USE
let registerUserURL = serverURL + "userregister"
let feedbackURL = serverURL + "submitfeedback"


let generateTicketURLMize = mizeURL + "generateTicket"
let equipmentListURLMize = mizeURL + "equipmentDetails"
let requestOTPURLMize = mizeURL + "requestOtp"
let verifyOTPURLMize = mizeURL + "verifyOtp"
let registerUserURLMize = mizeURL + "userRegister"
let productListURLMize = mizeURL + "productFamilyList"
let feedbackURLMize = mizeURL + "submitFeedback"
let cancelTicketURLMize = mizeURL + "cancelTicket"
let ticketHistoryURLMize = mizeURL + "ticketLatestStatus"
let getAllAddressURLMize = mizeURL + "address"

// Mark: API Response Data Keys
let KEY_Status = "status"
let KEY_LastSynced = "lastsyncresponse"
let KEY_AuthKey = "authKey"
let KEY_Message = "message"
let KEY_ErrorMessage = "errorMessage"
let KEY_User = "user"
let KEY_Address = "addresses"
let KEY_Products = "products"
let KEY_Equipment = "equipments"
let KEY_TicketNumber = "ticketNumber"
let KEY_ProductName = "productName"
let KEY_ProgressStatus = "progressStatus"
let KEY_ProductId = "productId"
let KEY_UpdatedOn = "lastUpdatedDate"
//let KEY_Updates = "updatedOn"
let KEY_IsAlreadyGenerated = "isAlreadyGenerated"
let KEY_ModelNo = "model"
let KEY_SerialNo = "serialNumber"
//let KEY_Tickets = "tickets"
let KEY_Tickets = "ticket"
let KEY_Notifications = "notifications"
let KEY_CurrentVersion = "currentversion"

// Mark: Constants
let platform = "IOS"
let oKey = "OK"

let fontQuicksandBookLightRegular = "QuicksandLight-Regular"
let fontQuicksandBookRegular = "QuicksandBook-Regular"
let fontQuicksandBookObliqueRegular = "QuicksandBookOblique-Regular"
let fontQuicksandBookBoldRegular = "QuicksandBold-Regular"


// Mark: Message Titles
let messageTitle = "Message"
let errorTitle = "Error"
let noInternetTitle = "No Internet Connection"
let invalidCountryTitle = "Invalid Country"
let invalidMobileNumberTitle = "Invalid mobile number"
let invalidTitle = "Invalid Title"
let invalidFirstNameTitle = "Invalid First Name"
let invalidLastNameTitle = "Invalid Last Name"
let invalidAddressTitle = "Invalid Address"
let invalidEmailTitle = "Invalid Email ID"
let invalidAddressTitleMinChar = "Address should contain minimum 10 characters"
let invalidAnswerTitle = "Invalid Answer"
let invaidDateTitle = "Invalid Time"
let ticketCancelErrorTitle = "Invalid Reason"
let ticketCancelSelectTitle = "select one option"
let invalidCompanyNameTitle = "Invalid Company Name"
let invalidGenderTitle = "Invalid Gender"
let invalidAgeGroupTitle = "Invalid Age Bracket"
let invalidResidentialConfigurationTitle = "Invalid Residential Configuration"

let invalidAddressSelection = "Please select customer id for address or add new address."

let invalidPinTitle = "Invalid Pin"
let invalidQuestionTitle = "Invalid Question"
let invalidOTPTitle = "Invalid OTP"
let invalidRatingTitle = "Invalid Rating"
let primaryAddressTitle = "Primary Address"
let securityQuestionTitle = "Security Question"
let pinTittle = "Pin"
let addressTitle = "Address"
let iBaseTitle = "Customer ID"
let productListTitle = "Product"

let invalidAlternateNumberTitle = "Invalid alternate number"
let invalidPincodeTitle = "Invalid Pincode"
let invalidLocalityTitle = "Invalid Locality"
let invalidCityTitle = "Invalid City"
let invalidStateTitle = "Invalid State"


// Mark: Messages
let parsingFailMessage = "Unable to parse data from server."
let errorMessage = "There was some error. Please try again."
let noInternetMessage = "Please check your internet connection."
let invalidCountryMessage = "Please choose a Country."
let invalidMobileNumberMessage = "Please enter your 10-digit Mobile Number."
let invalidTitleMessage = "Please select Title."
let invalidGenderMessage = "Please select Gender."
let invalidAgeGroupMessage = "Please select your age bracket."
let invalidResidentialMessage = "Please select BHK - Bedroom Hall Kitchen."
let invalidFirstNameMessage = "Please enter your First Name."
let invalidNameMessage = "Please enter alphabets only."
let invalidLastNameMessage = "Please enter your Last Name."
let invalidAddressMessage = "Please enter your Address."
let invalidEmailMessage = "Please enter a valid Email ID."
let invalidAnswerMessage = "Please enter a answer to Security Question."
let invalidPinMessage = "Please enter a 4 digit Pin."
let invalidQuestionMessage = "Please select a Security Question."
let invalidOTPMessage = "Please enter the correct 6-digit OTP."
let regenerateOTPMessage = "Please enter the correct 6-digit OTP."
let OTPSentMessage = "OTP has been sent to your mobile number."
let enterCorrectPinMessage = "Please enter correct Pin."
let enterCorrectAnswerMessage = "Please enter correct answer."
let invalidRatingMessage = "How was our Customer Service?"
let primaryAddressMessage = "You cannot delete the primary address."
let onePrimaryAddressMessage = "There should be at least one primary address."
let securityQuestionInfoMessage = "Info for security question."
let pinInfoMessage = "Info for Pin"
let iBaseInfoMessage = "Please enter customer ID to retrieve your address."
let addressInfoMessage = "This address is set as your primary address."
let address2InfoMessage = "This address is set as your secondary address."
let invalidAlternateNumberMessage = "Please enter an alternate 10-digit Mobile Number."
let invalidPincodeMessage = "Please enter valid 6 digit Pincode."
let invalidLocalityMessage = "Please enter Locality."
let invalidCityMessage = "Please enter your City."
let invalidStateMessage = "Please select your State."
let ticketGenerateConfirmationMessage = "Do you want to register a complaint?"
let whatWentWrongSelectionMessage = "Please select atleast one option from what went wrong."
let unRegisterProductMessage = "You cannot un register this product."
let invalidDateMessage = "\"To time\" must be minimum 1 hour greater than \"From Time\"."
let invalidTimeMessage = "To time can not be lesser then from time"
let logOutMessage = "Do you want to logout?"
let ticketCancelMessage = "Please enter reason for cancellation"
let ticketCancelSelectMessage = "Please select one option"
let invalidCompanyNameMessage = "Please enter your Company Name."

// Mark: Images
let IMG_Welcome = "Welcome"
let IMG_Country = "Country"
let IMG_DownArrow = "DownArrow"
let IMG_Mobile = "Mobile"
let IMG_Info = "Info"
let IMG_User = "User"
let IMG_Address = "Address"
let IMG_iBaseCode = "i_base_code"
let IMG_ProductList = "product_list"
let IMG_Email = "Email"
let IMG_PreferredTime = "PreferredTime"
let IMG_SecurityQuestion = "SecurityQuestion"
let IMG_Answer = "Answer"
let IMG_Pin = "Pin"
let IMG_Notifications = "Notifications"
let IMG_ThreeBar = "ThreeBar"
let IMG_SlideMenuUser = "SlideMenuUser"
let IMG_MyAccount = "MyAccount"
let IMG_History = "History"
let IMG_SafetyTips = "SafetyTips"
let IMG_FAQ = "FAQ"
let IMG_Logout = "Logout"
let IMG_Video = "img_video"
let IMG_CrossButton = "CrossButton"
let IMG_Back = "Back"
let IMG_FAQTriangle = "FAQTriangle"
let IMG_Tick = "Tick"
let IMG_DeleteDisabled = "DeleteDisabled"
let IMG_DeleteEnabled = "DeleteEnabled"
let IMG_EditEnabled = "EditEnabled"
let IMG_Call = "call"
let IMG_Edit_Products = "edit_products"
let IMG_Ticket_Status = "ticket_status"

let placeholderImage = UIImage(named:"placeholder")
let App_Theme_Color_HexCode = 0x246cb0
// Mark: Data Dictionaries
let securityQuestions = [["id":"0", "question":"Security Question"], ["id":"1", "question":"What is your Last Name?"], ["id":"2", "question":"What is your Pet's Name?"], ["id":"3", "question":"What is your First Car Make and Model?"]]

let countries: [String] = ["Choose Country", "India (+91)"]

var titles: [String] = [TitleSelect.MS.rawValue, TitleSelect.MR.rawValue, TitleSelect.MISS.rawValue, TitleSelect.DR.rawValue]
var genders: [String] = [GenderSelect.MALE.rawValue, GenderSelect.FEMALE.rawValue, GenderSelect.OTHER.rawValue,GenderSelect.NODISCLOSE.rawValue]
var ageGroups: [String] = [AgeGroupSelect.TEEN.rawValue, AgeGroupSelect.TWEENTY.rawValue, AgeGroupSelect.THIRTY.rawValue, AgeGroupSelect.FOURTY.rawValue, AgeGroupSelect.FIFTY.rawValue]
var resConfigs: [String] = [ResConfigSelect.ONEBHK.rawValue, ResConfigSelect.TWOBHK.rawValue, ResConfigSelect.THREEBHK.rawValue, ResConfigSelect.FOURBHK.rawValue]

let states: [String] = ["Andaman and Nicobar Islands", "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chandigarh", "Chhattisgarh", "Dadra and Nagar Haveli", "Daman and Diu", "Delhi", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jammu and Kashmir", "Jharkhand", "Karnataka", "Kerala", "Lakshadweep", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Orissa", "Puducherry", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Tripura", "Uttar Pradesh","West Bengal", "Uttarakhand", "Telangana"]

let statesCode: [String] = ["AN","AP","AR","AS","BR","CH","CT","DN","DD","DL","GA","GJ","HR","HP","JK","JH","KA","KL","LD","MP","MH","MN","ML","MZ","NL","OR","PY","PB","RJ","SK","TN","TR","UP","WB","UT","TS"]


//let sidebarMenuArray = [["icon":IMG_MyAccount, "label":"My Account"], ["icon":IMG_History, "label":"History"], ["icon":IMG_Notifications, "label":"Notifications"], ["icon":IMG_SafetyTips, "label":"Safety Tips"], ["icon":IMG_FAQ, "label":"FAQs"]]
//let sidebarMenuArray = [["icon":IMG_MyAccount, "label":"My Account"], ["icon":IMG_History, "label":"Ticket Status"], ["icon":IMG_Notifications, "label":"Notifications"], ["icon":IMG_SafetyTips, "label":"Safety Tips"], ["icon":IMG_FAQ, "label":"FAQs"], ["icon":IMG_Logout, "label":"Logout"]]

let sidebarMenuArray = [["icon":IMG_MyAccount, "label":"My Account"], ["icon":"myEquipments", "label":"My Equipment"], ["icon":IMG_History, "label":"Ticket Status"],["icon":IMG_FAQ, "label":"FAQs"],["icon":IMG_Video, "label":"Training Videos"],["icon":"privacy_policy", "label":"Privacy Policy"],["icon":"terms_of_use", "label":"Terms of Use"],["icon":"contact_us", "label":"Contact Us"],["icon":"about_us", "label":"About"],["icon":IMG_Logout, "label":"Logout"]]

let FAQData = [["question":"Should one buy a Split AC or a Window AC?", "answer":"Should one buy a Split AC or a Window AC?What is the right AC tonnage for my room?Should one buy a Split AC or a Window AC?\n\nWhat is the right AC tonnage for my room?Should one buy a Split AC or a Window AC?Should one buy a Split AC or a Window AC?\n\nShould one buy a Split AC or a Window AC?What is the right AC tonnage for my room?"], ["question":"What is the right AC tonnage for my room?", "answer":"2016-08-03 05:56:46 GMT"], ["question":"How does one know if the AC being considered is energy efficient?", "answer":"Should one buy a Split AC or a AC?What is the right AC tonnage for my room?Should one buy a Split AC or a Window AC?\n\nWhat is the right AC tonnage for my room?Should one buy a Split AC or a Window AC?Should one buy a Split AC or a Window AC?"], ["question":"Why does a higher star AC cost more? How to calculate the payback period?", "answer":"2016-08-02 08:56:46 GMT"], ["question":"What is an Inverter AC?", "answer":"2016-08-01 08:56:46 GMT"], ["question":"What are some other useful points to keep in mind whilst purchasing an AC?", "answer":"2016-07-31 08:56:46 GMT"], ["question":"What is the ideal location for installing a Window AC?", "answer":"2016-07-30 08:56:46 GMT"], ["question":"To what distance will a Window AC or Split AC throw air?", "answer":"2016-07-29 08:56:46 GMT"], ["question":"Does one need a 3-phase electricity supply to install an AC in the house?", "answer":"2016-07-29 08:56:46 GMT"], ["question":"Do I have to necessarily buy a voltage stabilisers when I buy an AC?", "answer":"2016-07-28 08:56:46 GMT"], ["question":"How can one maximise the AC output in the room?", "answer":"2016-07-28 08:56:46 GMT"], ["question":"How often should the filters be cleaned?", "answer":"2016-07-28 08:56:46 GMT"], ["question":"Can I use perfumes with my airconditioner?", "answer":"2016-07-28 08:56:46 GMT"]]

let feedbackData = [["ticketNumber":"B1608260012", "date":"2016-09-06 08:56:46 GMT"]]

let SafetyTipData = [["tip":"This is Safety Tip 1", "detail":"Should one buy a Split AC or a Window AC?What is the right AC tonnage for my room?Should one buy a Split AC or a Window AC?\n\nWhat is the right AC tonnage for my room?Should one buy a Split AC or a Window AC?Should one buy a Split AC or a Window AC?\n\nShould one buy a Split AC or a Window AC?What is the right AC tonnage for my room?"], ["tip":"This is Safety Tip 2", "detail":"2016-08-03 05:56:46 GMT"], ["tip":"This is Safety Tip 3", "detail":"Should one buy a Split AC or a AC?What is the right AC tonnage for my room?Should one buy a Split AC or a Window AC?\n\nWhat is the right AC tonnage for my room?Should one buy a Split AC or a Window AC?Should one buy a Split AC or a Window AC?"], ["tip":"This is Safety Tip 4", "detail":"2016-08-02 08:56:46 GMT"], ["tip":"This is Safety Tip 5", "detail":"2016-08-01 08:56:46 GMT"], ["tip":"This is Safety Tip 6", "detail":"2016-07-31 08:56:46 GMT"], ["tip":"This is Safety Tip 7", "detail":"2016-07-30 08:56:46 GMT"], ["tip":"This is Safety Tip 8", "detail":"2016-07-29 08:56:46 GMT"], ["tip":"This is Safety Tip 9", "detail":"2016-07-29 08:56:46 GMT"], ["tip":"This is Safety Tip 10", "detail":"2016-07-28 08:56:46 GMT"], ["tip":"This is Safety Tip 11", "detail":"2016-07-28 08:56:46 GMT"], ["tip":"This is Safety Tip 12", "detail":"2016-07-28 08:56:46 GMT"], ["tip":"This is Safety Tip 13", "detail":"2016-07-28 08:56:46 GMT"]]

let productsData = ["1033":["productName": "AC - Room Air Conditioner", "productDisplayName": "Air conditioner-Window/Split", "displayOnHomeScreen": "yes"], "1175":["productName": "Air Compressor", "productDisplayName": "Air Compressor", "displayOnHomeScreen": "no"], "1000":["productName": "Air Handling Units", "productDisplayName": "Air Handling Units", "displayOnHomeScreen": "no"], "1003":["productName": "Air Washer", "productDisplayName": "Air Washer", "displayOnHomeScreen": "no"], "1008":["productName": "BMS-Building Management System", "productDisplayName": "BMS-Building Management System", "displayOnHomeScreen": "yes"], "1004":["productName": "BacComber", "productDisplayName": "BacComber", "displayOnHomeScreen": "no"], "1006":["productName": "Bottled Water Dispensers", "productDisplayName": "Water Dispenser", "displayOnHomeScreen": "yes"], "1029":["productName": "Bulk Milk Cooler", "productDisplayName": "Bulk Milk Cooler", "displayOnHomeScreen": "no"], "1009":["productName": "Chiller", "productDisplayName": "Chiller", "displayOnHomeScreen": "yes"], "1010":["productName": "Cold Room", "productDisplayName": "Cold Room", "displayOnHomeScreen": "yes"], "1011":["productName": "Condensing Units", "productDisplayName": "Condensing Units", "displayOnHomeScreen": "no"], "1012":["productName": "Cooling Tower", "productDisplayName": "Cooling Tower", "displayOnHomeScreen": "no"], "1013":["productName": "Deep Freezer - Chest Freezer", "productDisplayName": "Deep Freezer", "displayOnHomeScreen": "yes"], "1014":["productName": "Dehumidifier", "productDisplayName": "Dehumidifier", "displayOnHomeScreen": "no"], "1017":["productName": "Ducted Package", "productDisplayName": "Ducted Package", "displayOnHomeScreen": "yes"], "1018":["productName": "Ducted Split", "productDisplayName": "Package AC", "displayOnHomeScreen": "yes"], "1174":["productName": "Electrostatic Air Cleaner", "productDisplayName": "Electrostatic Air Cleaner", "displayOnHomeScreen": "no"], "1020":["productName": "Fan Coil Units", "productDisplayName": "Fan Coil Units", "displayOnHomeScreen": "no"], "1021":["productName": "Fans", "productDisplayName": "Fans", "displayOnHomeScreen": "no"], "1173":["productName": "Heat Exchanger", "productDisplayName": "Heat Exchanger", "displayOnHomeScreen": "no"], "1023":["productName": "Heat Recovery Wheel", "productDisplayName": "Heat Recovery Wheel", "displayOnHomeScreen": "no"], "1025":["productName": "Hot Water Generator", "productDisplayName": "Hot Water Generator", "displayOnHomeScreen": "no"], "1028":["productName": "Ice Cuber Machine", "productDisplayName": "Ice Cube Machine", "displayOnHomeScreen": "no"], "1187":["productName": "Manpower", "productDisplayName": "Manpower", "displayOnHomeScreen": "no"], "1172":["productName": "Motor", "productDisplayName": "Motor", "displayOnHomeScreen": "no"], "1030":["productName": "PCPA", "productDisplayName": "PCPA", "displayOnHomeScreen": "no"], "1031":["productName": "Pumps", "productDisplayName": "Pumps", "displayOnHomeScreen": "no"], "1037":["productName": "TFA- Treated Fresh Air Unit", "productDisplayName": "TFA- Treated Fresh Air Unit", "displayOnHomeScreen": "no"], "1047":["productName": "Tools", "productDisplayName": "Tools", "displayOnHomeScreen": "no"], "1038":["productName": "UVC - Ultra Violet C-Band Emitters", "productDisplayName": "UVC - Ultra Violet C-Band Emitters", "displayOnHomeScreen": "no"], "1040":["productName": "VAV - Variable Air Volume", "productDisplayName": "VAV - Variable Air Volume", "displayOnHomeScreen": "no"], "1042":["productName": "VRF - Variable Refregerent Flow", "productDisplayName": "VRF - Variable Refregerent Flow", "displayOnHomeScreen": "yes"], "1041":["productName": "Variable Frequency Drives", "productDisplayName": "Variable Frequency Drives", "displayOnHomeScreen": "no"], "1207":["productName": "Water Purifier", "productDisplayName": "Water Purifier", "displayOnHomeScreen": "no"], "1046":["productName": "Watercoolers", "productDisplayName": "Water Cooler", "displayOnHomeScreen": "yes"]]

let statusWorkCompleted = "Work Completed"
let statusClosed = "Closed"
let statusCallCancelled = "Call cancelled"
let statusAppointmentFixedForWorkCompletion = "Appointment fixed for work completion"
let statusCallOnHoldObligationDispute = "Call on hold-Obligation disputelet"
let statusCallOnHoldAwaitingCustomerClearance = "Call on hold-Awaiting customer clearance"
let statusCallAttendedPendingForMaterial = "Call Attended-Pending for Material"
let statusWorkStartedAtSite = "Work started at site"
let statusWorkInProcess = "Work In Process"


let statusQueued = "Queued"
let statusDispatched = "Dispatched"
let DispatchAccepted = "Dispatch Accepted"
let statusQueuedDispatchRejected = "Queued - Dispatch Rejected"
let statusResponseScheduled = "Response Scheduled"
let statusCallAssignedToServiceProvider = "call assigned to service provider"


//M-ize Server Status
let statusDispatchedMize = "Dispatched"
let statusDispatchRejectedMize = "Dispatch Rejected"
let statusMaterialPendingMize = "Material Pending"
let statusQueuedMize = "Queued"
let statusWorkStartedMize = "Work Started"
let statusAllocatedMize = "Allocated"
let statusDispatchAcceptedMize = "Dispatch Accepted"
let statusInWorkMize = "In Work"







