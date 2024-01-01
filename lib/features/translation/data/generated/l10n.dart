import 'package:intl/intl.dart';
import 'intl/messages_all.dart';
import 'package:flutter/material.dart';

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  static S? _current;

  S();

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S(); // Pass the locale to the S instance
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  Future<S> withLocale(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S(); // Pass the locale to the S instance
      S._current = instance;
      return instance;
    });
  }

  /// `Operation successful`
  String get CategoriesManageView_successMessage {
    return Intl.message(
      'Operation successful',
      name: 'CategoriesManageView_successMessage',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred. Please try again.`
  String get CategoriesManageView_errorMessage {
    return Intl.message(
      'An error occurred. Please try again.',
      name: 'CategoriesManageView_errorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Categories list is empty!`
  String get CategoriesManageView_emptyCategoriesList {
    return Intl.message(
      'Categories list is empty!',
      name: 'CategoriesManageView_emptyCategoriesList',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get CategoriesManageView_addButton {
    return Intl.message(
      'Add',
      name: 'CategoriesManageView_addButton',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get CategoriesManageView_categoriesTitle {
    return Intl.message(
      'Categories',
      name: 'CategoriesManageView_categoriesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Operation successful`
  String get CitiesManageView_successMessage {
    return Intl.message(
      'Operation successful',
      name: 'CitiesManageView_successMessage',
      desc: '',
      args: [],
    );
  }

  /// `Cities list is empty!`
  String get CitiesManageView_emptyCitiesList {
    return Intl.message(
      'Cities list is empty!',
      name: 'CitiesManageView_emptyCitiesList',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get CitiesManageView_addButton {
    return Intl.message(
      'Add',
      name: 'CitiesManageView_addButton',
      desc: '',
      args: [],
    );
  }

  /// `Cities`
  String get CitiesManageView_citiesTitle {
    return Intl.message(
      'Cities',
      name: 'CitiesManageView_citiesTitle',
      desc: '',
      args: [],
    );
  }

  /// `There are no doctors`
  String get DoctorsManageView_emptyDoctorsList {
    return Intl.message(
      'There are no doctors',
      name: 'DoctorsManageView_emptyDoctorsList',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your doctor information?`
  String get DoctorsManageView_ask_to_delete {
    return Intl.message(
      'Are you sure you want to delete your doctor information?',
      name: 'DoctorsManageView_ask_to_delete',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get DoctorsManageView_yes {
    return Intl.message(
      'Yes',
      name: 'DoctorsManageView_yes',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get DoctorsManageView_no {
    return Intl.message(
      'Cancel',
      name: 'DoctorsManageView_no',
      desc: '',
      args: [],
    );
  }

  /// `Doctors`
  String get DoctorsManageView_doctorsTitle {
    return Intl.message(
      'Doctors',
      name: 'DoctorsManageView_doctorsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Management`
  String get AdminManageView_appBarTitle {
    return Intl.message(
      'Management',
      name: 'AdminManageView_appBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Cities`
  String get AdminManageView_citiesText {
    return Intl.message(
      'Cities',
      name: 'AdminManageView_citiesText',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get AdminManageView_categoriesText {
    return Intl.message(
      'Categories',
      name: 'AdminManageView_categoriesText',
      desc: '',
      args: [],
    );
  }

  /// `Doctors`
  String get AdminManageView_doctorsText {
    return Intl.message(
      'Doctors',
      name: 'AdminManageView_doctorsText',
      desc: '',
      args: [],
    );
  }

  /// `Posts`
  String get AdminManageView_postText {
    return Intl.message(
      'Posts',
      name: 'AdminManageView_postText',
      desc: '',
      args: [],
    );
  }

  /// `Add Main Category`
  String get CategoryAddDialog_addCategoryTitle {
    return Intl.message(
      'Add Main Category',
      name: 'CategoryAddDialog_addCategoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add Subcategory`
  String get CategoryAddDialog_addSubcategoryTitle {
    return Intl.message(
      'Add Subcategory',
      name: 'CategoryAddDialog_addSubcategoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit Category`
  String get CategoryAddDialog_editCategoryTitle {
    return Intl.message(
      'Edit Category',
      name: 'CategoryAddDialog_editCategoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit Subcategory`
  String get CategoryAddDialog_editSubcategoryTitle {
    return Intl.message(
      'Edit Subcategory',
      name: 'CategoryAddDialog_editSubcategoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Service`
  String get CategoryAddDialog_serviceText {
    return Intl.message(
      'Service',
      name: 'CategoryAddDialog_serviceText',
      desc: '',
      args: [],
    );
  }

  /// `Specialist`
  String get CategoryAddDialog_addSubCategoryText {
    return Intl.message(
      'Specialist',
      name: 'CategoryAddDialog_addSubCategoryText',
      desc: '',
      args: [],
    );
  }

  /// `Image`
  String get CategoryAddDialog_imageText {
    return Intl.message(
      'Image',
      name: 'CategoryAddDialog_imageText',
      desc: '',
      args: [],
    );
  }

  /// `Visible`
  String get CategoryAddDialog_visibleText {
    return Intl.message(
      'Visible',
      name: 'CategoryAddDialog_visibleText',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get CategoryAddDialog_nameHintText {
    return Intl.message(
      'Name',
      name: 'CategoryAddDialog_nameHintText',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get CategoryAddDialog_saveButtonText {
    return Intl.message(
      'Save',
      name: 'CategoryAddDialog_saveButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Please add an image`
  String get CategoryAddDialog_pleaseAddImageText {
    return Intl.message(
      'Please add an image',
      name: 'CategoryAddDialog_pleaseAddImageText',
      desc: '',
      args: [],
    );
  }

  /// `Edit City`
  String get CityAddEditDialog_editCityTitle {
    return Intl.message(
      'Edit City',
      name: 'CityAddEditDialog_editCityTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add City`
  String get CityAddEditDialog_addCityTitle {
    return Intl.message(
      'Add City',
      name: 'CityAddEditDialog_addCityTitle',
      desc: '',
      args: [],
    );
  }

  /// `City Name`
  String get CityAddEditDialog_cityNameHintText {
    return Intl.message(
      'City Name',
      name: 'CityAddEditDialog_cityNameHintText',
      desc: '',
      args: [],
    );
  }

  /// `Location coordinates on the map`
  String get CityAddEditDialog_coordinatesHintText {
    return Intl.message(
      'Location coordinates on the map',
      name: 'CityAddEditDialog_coordinatesHintText',
      desc: '',
      args: [],
    );
  }

  /// `Visible`
  String get CityAddEditDialog_visibleText {
    return Intl.message(
      'Visible',
      name: 'CityAddEditDialog_visibleText',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get CityAddEditDialog_saveButtonText {
    return Intl.message(
      'Save',
      name: 'CityAddEditDialog_saveButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Specialist`
  String get MainCategoryType_specialist {
    return Intl.message(
      'Specialist',
      name: 'MainCategoryType_specialist',
      desc: '',
      args: [],
    );
  }

  /// `Code sent successfully`
  String get LoginView_verify_message {
    return Intl.message(
      'Code sent successfully',
      name: 'LoginView_verify_message',
      desc: '',
      args: [],
    );
  }

  /// `Logged in`
  String get LoginView_verify_login_message {
    return Intl.message(
      'Logged in',
      name: 'LoginView_verify_login_message',
      desc: '',
      args: [],
    );
  }

  /// `Or`
  String get LoginView_or {
    return Intl.message(
      'Or',
      name: 'LoginView_or',
      desc: '',
      args: [],
    );
  }

  /// `Do not have an account?`
  String get LoginView_register_ask {
    return Intl.message(
      'Do not have an account?',
      name: 'LoginView_register_ask',
      desc: '',
      args: [],
    );
  }

  /// `Registered`
  String get LoginView_sighup {
    return Intl.message(
      'Registered',
      name: 'LoginView_sighup',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get LoginView_login {
    return Intl.message(
      'Login',
      name: 'LoginView_login',
      desc: '',
      args: [],
    );
  }

  /// `Create a new account`
  String get LoginView_new_account_ask {
    return Intl.message(
      'Create a new account',
      name: 'LoginView_new_account_ask',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the App`
  String get AccountTypeView_welcome_message {
    return Intl.message(
      'Welcome to the App',
      name: 'AccountTypeView_welcome_message',
      desc: '',
      args: [],
    );
  }

  /// `Get started by creating an account`
  String get AccountTypeView_get_started {
    return Intl.message(
      'Get started by creating an account',
      name: 'AccountTypeView_get_started',
      desc: '',
      args: [],
    );
  }

  /// `Choose your account type to complete the registration process`
  String get AccountTypeView_choose_account_type {
    return Intl.message(
      'Choose your account type to complete the registration process',
      name: 'AccountTypeView_choose_account_type',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get AccountTypeView_next {
    return Intl.message(
      'Next',
      name: 'AccountTypeView_next',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get AccountTypeView_already_have_account {
    return Intl.message(
      'Already have an account?',
      name: 'AccountTypeView_already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get AccountTypeView_login_button {
    return Intl.message(
      'Log in',
      name: 'AccountTypeView_login_button',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get ChangePasswordView_appBarTitle {
    return Intl.message(
      'Change Password',
      name: 'ChangePasswordView_appBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Old Password`
  String get ChangePasswordView_oldPasswordHint {
    return Intl.message(
      'Old Password',
      name: 'ChangePasswordView_oldPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get ChangePasswordView_newPasswordHint {
    return Intl.message(
      'New Password',
      name: 'ChangePasswordView_newPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get ChangePasswordView_confirmPasswordHint {
    return Intl.message(
      'Confirm Password',
      name: 'ChangePasswordView_confirmPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get ChangePasswordView_confirmButtonLabel {
    return Intl.message(
      'Confirm',
      name: 'ChangePasswordView_confirmButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get ForgetPasswordView_title {
    return Intl.message(
      'Forgot Password?',
      name: 'ForgetPasswordView_title',
      desc: '',
      args: [],
    );
  }

  /// `Please reset your password using your mobile number`
  String get ForgetPasswordView_resetPasswordText {
    return Intl.message(
      'Please reset your password using your mobile number',
      name: 'ForgetPasswordView_resetPasswordText',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Number`
  String get ForgetPasswordView_mobileNumberHint {
    return Intl.message(
      'Mobile Number',
      name: 'ForgetPasswordView_mobileNumberHint',
      desc: '',
      args: [],
    );
  }

  /// `Send Code`
  String get ForgetPasswordView_sendCodeButton {
    return Intl.message(
      'Send Code',
      name: 'ForgetPasswordView_sendCodeButton',
      desc: '',
      args: [],
    );
  }

  /// `Verify Your Mobile Number`
  String get otp_title {
    return Intl.message(
      'Verify Your Mobile Number',
      name: 'otp_title',
      desc: '',
      args: [],
    );
  }

  /// `We have sent a text message with a verification code`
  String get otp_verificationMessage {
    return Intl.message(
      'We have sent a text message with a verification code',
      name: 'otp_verificationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Code`
  String get otp_confirmCodeButton {
    return Intl.message(
      'Confirm Code',
      name: 'otp_confirmCodeButton',
      desc: '',
      args: [],
    );
  }

  /// `Did not receive a message?`
  String get otp_resendMessage {
    return Intl.message(
      'Did not receive a message?',
      name: 'otp_resendMessage',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get otp_resendButton {
    return Intl.message(
      'Resend',
      name: 'otp_resendButton',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get ResetPasswordView_title {
    return Intl.message(
      'New Password',
      name: 'ResetPasswordView_title',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get ResetPasswordView_passwordHint {
    return Intl.message(
      'Password',
      name: 'ResetPasswordView_passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get ResetPasswordView_confirmPasswordHint {
    return Intl.message(
      'Confirm Password',
      name: 'ResetPasswordView_confirmPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get ResetPasswordView_confirmButtonLabel {
    return Intl.message(
      'Confirm',
      name: 'ResetPasswordView_confirmButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `The code has been sent successfully`
  String get UserSignUpView_codeMessage {
    return Intl.message(
      'The code has been sent successfully',
      name: 'UserSignUpView_codeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Create a New Account`
  String get UserSignUpView_createAccountTitle {
    return Intl.message(
      'Create a New Account',
      name: 'UserSignUpView_createAccountTitle',
      desc: '',
      args: [],
    );
  }

  /// `Doctor`
  String get UserSignUpView_userTypeDoctor {
    return Intl.message(
      'Doctor',
      name: 'UserSignUpView_userTypeDoctor',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get UserSignUpView_userTypeUser {
    return Intl.message(
      'User',
      name: 'UserSignUpView_userTypeUser',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get UserSignUpView_nextButtonLabel {
    return Intl.message(
      'Next',
      name: 'UserSignUpView_nextButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Or`
  String get UserSignUpView_orText {
    return Intl.message(
      'Or',
      name: 'UserSignUpView_orText',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get AccountTypeSelector_user {
    return Intl.message(
      'User',
      name: 'AccountTypeSelector_user',
      desc: '',
      args: [],
    );
  }

  /// `Doctor`
  String get AccountTypeSelector_doctor {
    return Intl.message(
      'Doctor',
      name: 'AccountTypeSelector_doctor',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get AccountTypeSelector_next {
    return Intl.message(
      'Next',
      name: 'AccountTypeSelector_next',
      desc: '',
      args: [],
    );
  }

  /// `No messages`
  String get ChatView_noMessagesText {
    return Intl.message(
      'No messages',
      name: 'ChatView_noMessagesText',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get ChatsListView_appBarTitle {
    return Intl.message(
      'Chats',
      name: 'ChatsListView_appBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `No chats`
  String get ChatsListView_noChatsText {
    return Intl.message(
      'No chats',
      name: 'ChatsListView_noChatsText',
      desc: '',
      args: [],
    );
  }

  /// `Search in chats`
  String get ChatsListView_searchPlaceholder {
    return Intl.message(
      'Search in chats',
      name: 'ChatsListView_searchPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Preview`
  String get ChatAttatchmentPreview_appBarTitle {
    return Intl.message(
      'Preview',
      name: 'ChatAttatchmentPreview_appBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Image`
  String get ChatAttatchmentPreview_imagePreview {
    return Intl.message(
      'Image',
      name: 'ChatAttatchmentPreview_imagePreview',
      desc: '',
      args: [],
    );
  }

  /// `PDF File`
  String get ChatAttatchmentPreview_pdfIconText {
    return Intl.message(
      'PDF File',
      name: 'ChatAttatchmentPreview_pdfIconText',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get ChatAttatchmentPreview_confirmButton {
    return Intl.message(
      'Send',
      name: 'ChatAttatchmentPreview_confirmButton',
      desc: '',
      args: [],
    );
  }

  /// `Type a message`
  String get ChatInputField_textFieldHint {
    return Intl.message(
      'Type a message',
      name: 'ChatInputField_textFieldHint',
      desc: '',
      args: [],
    );
  }

  /// `File size exceeds 2MB`
  String get ChatInputField_attachmentSizeExceeded {
    return Intl.message(
      'File size exceeds 2MB',
      name: 'ChatInputField_attachmentSizeExceeded',
      desc: '',
      args: [],
    );
  }

  /// `Attach File`
  String get ChatInputField_attachFileButton {
    return Intl.message(
      'Attach File',
      name: 'ChatInputField_attachFileButton',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get ChatInputField_sendButton {
    return Intl.message(
      'Send',
      name: 'ChatInputField_sendButton',
      desc: '',
      args: [],
    );
  }

  /// `📷 Image`
  String get ChatItemCard_lastMessageImage {
    return Intl.message(
      '📷 Image',
      name: 'ChatItemCard_lastMessageImage',
      desc: '',
      args: [],
    );
  }

  /// `📑 PDF File`
  String get ChatItemCard_lastMessagePDF {
    return Intl.message(
      '📑 PDF File',
      name: 'ChatItemCard_lastMessagePDF',
      desc: '',
      args: [],
    );
  }

  /// `sent succesfully`
  String get AddConsultationView_message {
    return Intl.message(
      'sent succesfully',
      name: 'AddConsultationView_message',
      desc: '',
      args: [],
    );
  }

  /// `Consultations`
  String get AddConsultationView_consult {
    return Intl.message(
      'Consultations',
      name: 'AddConsultationView_consult',
      desc: '',
      args: [],
    );
  }

  /// `Talk to the doctor now`
  String get AddConsultationView_title {
    return Intl.message(
      'Talk to the doctor now',
      name: 'AddConsultationView_title',
      desc: '',
      args: [],
    );
  }

  /// `Tell the doctor about your question or inquiry so they can contact you now`
  String get AddConsultationView_description {
    return Intl.message(
      'Tell the doctor about your question or inquiry so they can contact you now',
      name: 'AddConsultationView_description',
      desc: '',
      args: [],
    );
  }

  /// `Your inquiry in brief`
  String get AddConsultationView_shortDescription {
    return Intl.message(
      'Your inquiry in brief',
      name: 'AddConsultationView_shortDescription',
      desc: '',
      args: [],
    );
  }

  /// `City Name`
  String get AddConsultationView_placeholder {
    return Intl.message(
      'City Name',
      name: 'AddConsultationView_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Coordinates on the map`
  String get AddConsultationView_coordinatesPlaceholder {
    return Intl.message(
      'Coordinates on the map',
      name: 'AddConsultationView_coordinatesPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Visible`
  String get AddConsultationView_visibleText {
    return Intl.message(
      'Visible',
      name: 'AddConsultationView_visibleText',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get AddConsultationView_saveButtonText {
    return Intl.message(
      'Save',
      name: 'AddConsultationView_saveButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Add File`
  String get AddConsultationView_addImageButtonText {
    return Intl.message(
      'Add File',
      name: 'AddConsultationView_addImageButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Supported formats: PNG, PDF, JPG`
  String get AddConsultationView_supportedFormatsText {
    return Intl.message(
      'Supported formats: PNG, PDF, JPG',
      name: 'AddConsultationView_supportedFormatsText',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get AddConsultationView_sendButtonText {
    return Intl.message(
      'Send',
      name: 'AddConsultationView_sendButtonText',
      desc: '',
      args: [],
    );
  }

  /// `All Consultations`
  String get ConsultationView_title {
    return Intl.message(
      'All Consultations',
      name: 'ConsultationView_title',
      desc: '',
      args: [],
    );
  }

  /// `No active consultations available`
  String get ConsultationView_noActiveConsultations {
    return Intl.message(
      'No active consultations available',
      name: 'ConsultationView_noActiveConsultations',
      desc: '',
      args: [],
    );
  }

  /// `Consultation: `
  String get ConsultationCard_consultationTitle {
    return Intl.message(
      'Consultation: ',
      name: 'ConsultationCard_consultationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Attached File: `
  String get ConsultationCard_attachmentLabel {
    return Intl.message(
      'Attached File: ',
      name: 'ConsultationCard_attachmentLabel',
      desc: '',
      args: [],
    );
  }

  /// `Patient:`
  String get ConsultationCard_patientLabel {
    return Intl.message(
      'Patient:',
      name: 'ConsultationCard_patientLabel',
      desc: '',
      args: [],
    );
  }

  /// `Doctor:`
  String get ConsultationCard_doctorLabel {
    return Intl.message(
      'Doctor:',
      name: 'ConsultationCard_doctorLabel',
      desc: '',
      args: [],
    );
  }

  /// `Awaiting Transfer`
  String get ConsultationCard_awaitingTransfer {
    return Intl.message(
      'Awaiting Transfer',
      name: 'ConsultationCard_awaitingTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Delete account`
  String get DeleteUserAccount_delete_account {
    return Intl.message(
      'Delete account',
      name: 'DeleteUserAccount_delete_account',
      desc: '',
      args: [],
    );
  }

  /// `What happens if you permanently delete your Clinicate account?`
  String get DeleteUserAccount_consequences {
    return Intl.message(
      'What happens if you permanently delete your Clinicate account?',
      name: 'DeleteUserAccount_consequences',
      desc: '',
      args: [],
    );
  }

  /// `Your profile, photos, posts, videos, and everything else you added will be permanently deleted.`
  String get DeleteUserAccount_consequences_description {
    return Intl.message(
      'Your profile, photos, posts, videos, and everything else you added will be permanently deleted.',
      name: 'DeleteUserAccount_consequences_description',
      desc: '',
      args: [],
    );
  }

  /// `You will not be able to recover anything you added.`
  String get DeleteUserAccount_youCant_add {
    return Intl.message(
      'You will not be able to recover anything you added.',
      name: 'DeleteUserAccount_youCant_add',
      desc: '',
      args: [],
    );
  }

  /// `You will no longer be able to see your previous consultations.`
  String get DeleteUserAccount_youCant_see {
    return Intl.message(
      'You will no longer be able to see your previous consultations.',
      name: 'DeleteUserAccount_youCant_see',
      desc: '',
      args: [],
    );
  }

  /// `You may keep some information, such as messages you have sent to doctors, visible to them after you delete your account. Copies of messages you have sent are stored in their inboxes.`
  String get DeleteUserAccount_youCan_see_message {
    return Intl.message(
      'You may keep some information, such as messages you have sent to doctors, visible to them after you delete your account. Copies of messages you have sent are stored in their inboxes.',
      name: 'DeleteUserAccount_youCan_see_message',
      desc: '',
      args: [],
    );
  }

  /// `Account deletion process:`
  String get DeleteUserAccount_delete_account_process {
    return Intl.message(
      'Account deletion process:',
      name: 'DeleteUserAccount_delete_account_process',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account permanently? This will result in you permanently losing access to all information and data stored on your current account and cannot be restored again.`
  String get DeleteUserAccount_delete_account_message {
    return Intl.message(
      'Are you sure you want to delete your account permanently? This will result in you permanently losing access to all information and data stored on your current account and cannot be restored again.',
      name: 'DeleteUserAccount_delete_account_message',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get DeleteUserAccount_delete_account_cancelation {
    return Intl.message(
      'Cancel',
      name: 'DeleteUserAccount_delete_account_cancelation',
      desc: '',
      args: [],
    );
  }

  /// `Doctors`
  String get DoctorsListSelector_doctorsTitle {
    return Intl.message(
      'Doctors',
      name: 'DoctorsListSelector_doctorsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get DoctorsListSelector_confirmButton {
    return Intl.message(
      'Confirm',
      name: 'DoctorsListSelector_confirmButton',
      desc: '',
      args: [],
    );
  }

  /// `Clinic Information`
  String get ClicnkInfoView_Clinic_Information {
    return Intl.message(
      'Clinic Information',
      name: 'ClicnkInfoView_Clinic_Information',
      desc: '',
      args: [],
    );
  }

  ///Clinic type
  String get ClicnkInfoView_Clinic_type {
    return Intl.message(
      'Clinic type',
      name: 'ClicnkInfoView_Clinic_type',
      desc: '',
      args: [],
    );
  }

  /// `Add Clinic`
  String get ClicnkInfoView_Add_Clinic {
    return Intl.message(
      'Add Clinic',
      name: 'ClicnkInfoView_Add_Clinic',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get ClicnkInfoView_Save {
    return Intl.message(
      'Save',
      name: 'ClicnkInfoView_Save',
      desc: '',
      args: [],
    );
  }

  /// `Clinic Name`
  String get ClicnkInfoView_Clinic_Name {
    return Intl.message(
      'Clinic Name',
      name: 'ClicnkInfoView_Clinic_Name',
      desc: '',
      args: [],
    );
  }

  /// `Location Coordinates on Map`
  String get ClicnkInfoView_Location_Coordinates_on_Map {
    return Intl.message(
      'Location Coordinates on Map',
      name: 'ClicnkInfoView_Location_Coordinates_on_Map',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get ClicnkInfoView_Add {
    return Intl.message(
      'Add',
      name: 'ClicnkInfoView_Add',
      desc: '',
      args: [],
    );
  }

  /// `Agreements`
  String get DoctorAgreementsView_Agreements {
    return Intl.message(
      'Agreements',
      name: 'DoctorAgreementsView_Agreements',
      desc: '',
      args: [],
    );
  }

  /// `Clalit`
  String get DoctorAgreementsView_Clalit {
    return Intl.message(
      'Clalit',
      name: 'DoctorAgreementsView_Clalit',
      desc: '',
      args: [],
    );
  }

  /// `Meuhedit`
  String get DoctorAgreementsView_Meuhedit {
    return Intl.message(
      'Meuhedit',
      name: 'DoctorAgreementsView_Meuhedit',
      desc: '',
      args: [],
    );
  }

  /// `Leumit`
  String get DoctorAgreementsView_Leumit {
    return Intl.message(
      'Leumit',
      name: 'DoctorAgreementsView_Leumit',
      desc: '',
      args: [],
    );
  }

  /// `Maccabi`
  String get DoctorAgreementsView_Maccabi {
    return Intl.message(
      'Maccabi',
      name: 'DoctorAgreementsView_Maccabi',
      desc: '',
      args: [],
    );
  }

  /// `No agreements available for this type.`
  String get DoctorAgreementsView_No_agreements_available_for_this_type {
    return Intl.message(
      'No agreements available for this type.',
      name: 'DoctorAgreementsView_No_agreements_available_for_this_type',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get DoctorAgreementsView_Continue {
    return Intl.message(
      'Continue',
      name: 'DoctorAgreementsView_Continue',
      desc: '',
      args: [],
    );
  }

  String get AddRate_ratings {
    return Intl.message(
      'Ratings',
      name: 'AddRate_ratings',
      desc: '',
      args: [],
    );
  }

  String get AddRate_show_all {
    return Intl.message(
      'Show All',
      name: 'AddRate_show_all',
      desc: '',
      args: [],
    );
  }

  String get AddRate_add_rate {
    return Intl.message(
      'Add Rating',
      name: 'AddRate_add_rate',
      desc: '',
      args: [],
    );
  }

  String get DoctorAgreementsWithInsuranceView_Agreements_Migdal {
    return Intl.message(
      'Migdal',
      name: 'DoctorAgreementsWithInsuranceView_Agreements_Migdal',
      desc: '',
      args: [],
    );
  }

  String get DoctorAgreementsWithInsuranceView_Agreements_Phoenix {
    return Intl.message(
      'Phoenix',
      name: 'DoctorAgreementsWithInsuranceView_Agreements_Phoenix',
      desc: '',
      args: [],
    );
  }

  String get DoctorAgreementsWithInsuranceView_Agreements_Harel {
    return Intl.message(
      'Harel',
      name: 'DoctorAgreementsWithInsuranceView_Agreements_Harel',
      desc: '',
      args: [],
    );
  }

  String get DoctorAgreementsWithInsuranceView_Agreements_Menora {
    return Intl.message(
      'Menora',
      name: 'DoctorAgreementsWithInsuranceView_Agreements_Menora',
      desc: '',
      args: [],
    );
  }

  String get DoctorAgreementsWithInsuranceView_Agreements_Clal {
    return Intl.message(
      'Clal',
      name: 'DoctorAgreementsWithInsuranceView_Agreements_Clal',
      desc: '',
      args: [],
    );
  }

  String get DoctorAgreementsWithInsuranceView_Agreements_Dikla {
    return Intl.message(
      'Dikla',
      name: 'DoctorAgreementsWithInsuranceView_Agreements_Dikla',
      desc: '',
      args: [],
    );
  }

  String get DoctorAgreementsWithInsuranceView_Agreements_Ayalon {
    return Intl.message(
      'Ayalon',
      name: 'DoctorAgreementsWithInsuranceView_Agreements_Ayalon',
      desc: '',
      args: [],
    );
  }

  String get DoctorAgreementsWithInsuranceView_Agreements_IDI_Insurance {
    return Intl.message(
      'IDI',
      name: 'DoctorAgreementsWithInsuranceView_Agreements_IDI_Insurance',
      desc: '',
      args: [],
    );
  }

  String get DoctorAgreementsWithInsuranceView_Agreements_Ilanot {
    return Intl.message(
      'Ilanot',
      name: 'DoctorAgreementsWithInsuranceView_Agreements_Ilanot',
      desc: '',
      args: [],
    );
  }

  String get DoctorAgreementsWithInsuranceView_Agreements_Eliahu {
    return Intl.message(
      'Eliahu',
      name: 'DoctorAgreementsWithInsuranceView_Agreements_Eliahu',
      desc: '',
      args: [],
    );
  }

  String get DoctorAgreementsWithInsuranceView_Agreements_Shirbit {
    return Intl.message(
      'Shirbit',
      name: 'DoctorAgreementsWithInsuranceView_Agreements_Shirbit',
      desc: '',
      args: [],
    );
  }

  /// `Personal Information`
  String get DoctorInfoStepper_Personal_Information {
    return Intl.message(
      'Personal Information',
      name: 'DoctorInfoStepper_Personal_Information',
      desc: '',
      args: [],
    );
  }

  /// `Profession`
  String get DoctorInfoStepper_Profession {
    return Intl.message(
      'Profession',
      name: 'DoctorInfoStepper_Profession',
      desc: '',
      args: [],
    );
  }

  /// `Services`
  String get DoctorInfoStepper_Services {
    return Intl.message(
      'Services',
      name: 'DoctorInfoStepper_Services',
      desc: '',
      args: [],
    );
  }

  /// `Specializations`
  String get DoctorInfoStepper_Specializations {
    return Intl.message(
      'Specializations',
      name: 'DoctorInfoStepper_Specializations',
      desc: '',
      args: [],
    );
  }

  /// `Agreements`
  String get DoctorInfoStepper_Agreements {
    return Intl.message(
      'Agreements',
      name: 'DoctorInfoStepper_Agreements',
      desc: '',
      args: [],
    );
  }

  /// `Insurance`
  String get DoctorInfoStepper_Insurance {
    return Intl.message(
      'Insurance',
      name: 'DoctorInfoStepper_Insurance',
      desc: '',
      args: [],
    );
  }

  /// `Clinic Information`
  String get DoctorInfoStepper_Clinic_Information {
    return Intl.message(
      'Clinic Information',
      name: 'DoctorInfoStepper_Clinic_Information',
      desc: '',
      args: [],
    );
  }

  /// `Operation completed successfully`
  String get DoctorInfoStepper_Operation_completed_successfully {
    return Intl.message(
      'Operation completed successfully',
      name: 'DoctorInfoStepper_Operation_completed_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Profession`
  String get DoctorJobView_Profession {
    return Intl.message(
      'Profession',
      name: 'DoctorJobView_Profession',
      desc: '',
      args: [],
    );
  }

  /// `Dentist`
  String get DoctorJobView_Dentist {
    return Intl.message(
      'Dentist',
      name: 'DoctorJobView_Dentist',
      desc: '',
      args: [],
    );
  }

  /// `Cosmetic Surgeon`
  String get DoctorJobView_Cosmetic_Surgeon {
    return Intl.message(
      'Cosmetic Doctor',
      name: 'DoctorJobView_Cosmetic_Surgeon',
      desc: '',
      args: [],
    );
  }

  /// `Cosmetic Surgeon and Dentist`
  String get DoctorJobView_Cosmetic_Surgeon_and_Dentist {
    return Intl.message(
      'Cosmetic and Dentist Doctor',
      name: 'DoctorJobView_Cosmetic_Surgeon_and_Dentist',
      desc: '',
      args: [],
    );
  }

  String get ClinicJobView_Cosmetic_Surgeon {
    return Intl.message(
      'Cosmetic Clinic',
      name: 'ClinicJobView_Cosmetic_Surgeon',
      desc: '',
      args: [],
    );
  }

  String get ClinicJobView_Cosmetic_Surgeon_and_Dentist {
    return Intl.message(
      'Cosmetic and Dentist Clinic',
      name: 'ClinicJobView_Cosmetic_Surgeon_and_Dentist',
      desc: '',
      args: [],
    );
  }

  String get ClinicJobView_Dentist {
    return Intl.message(
      'Dentist Clinic',
      name: 'ClinicJobView_Dentist',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get DoctorJobView_Continue {
    return Intl.message(
      'Continue',
      name: 'DoctorJobView_Continue',
      desc: '',
      args: [],
    );
  }

  /// `Personal Information`
  String get DoctorPersonalInfo_Personal_Information {
    return Intl.message(
      'Personal Information',
      name: 'DoctorPersonalInfo_Personal_Information',
      desc: '',
      args: [],
    );
  }

  /// `Arabic Name`
  String get DoctorPersonalInfo_Arabic_Name {
    return Intl.message(
      'Arabic Name',
      name: 'DoctorPersonalInfo_Arabic_Name',
      desc: '',
      args: [],
    );
  }

  /// `English Name`
  String get DoctorPersonalInfo_English_Name {
    return Intl.message(
      'English Name',
      name: 'DoctorPersonalInfo_English_Name',
      desc: '',
      args: [],
    );
  }

  /// `Hebrew Name`
  String get DoctorPersonalInfo_Hebrew_Name {
    return Intl.message(
      'Hebrew Name',
      name: 'DoctorPersonalInfo_Hebrew_Name',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get DoctorPersonalInfo_Email {
    return Intl.message(
      'Email',
      name: 'DoctorPersonalInfo_Email',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get DoctorPersonalInfo_Continue {
    return Intl.message(
      'Continue',
      name: 'DoctorPersonalInfo_Continue',
      desc: '',
      args: [],
    );
  }

  /// `Services`
  String get DoctorServicesView_Services {
    return Intl.message(
      'Services',
      name: 'DoctorServicesView_Services',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get DoctorServicesView_Continue {
    return Intl.message(
      'Continue',
      name: 'DoctorServicesView_Continue',
      desc: '',
      args: [],
    );
  }

  /// `Specializations`
  String get DoctorSpecialistView_Specializations {
    return Intl.message(
      'Specializations',
      name: 'DoctorSpecialistView_Specializations',
      desc: '',
      args: [],
    );
  }

  /// `I am not a specialist`
  String get DoctorSpecialistView_I_am_not_a_specialist {
    return Intl.message(
      'I am not a specialist',
      name: 'DoctorSpecialistView_I_am_not_a_specialist',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get DoctorSpecialistView_Continue {
    return Intl.message(
      'Continue',
      name: 'DoctorSpecialistView_Continue',
      desc: '',
      args: [],
    );
  }

  /// `Doctors`
  String get DoctorsListSelector_Doctors {
    return Intl.message(
      'Doctors',
      name: 'DoctorsListSelector_Doctors',
      desc: '',
      args: [],
    );
  }

  /// `DoctorsListSelector_PreRegisterdDoctors'
  String get DoctorsListSelector_PreRegisterdDoctors {
    return Intl.message(
      'Pre Registered Doctors',
      name: 'DoctorsListSelector_PreRegisterdDoctors',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get DoctorsListSelector_Confirm {
    return Intl.message(
      'Confirm',
      name: 'DoctorsListSelector_Confirm',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get HomeView_appBarTitle {
    return Intl.message(
      'Welcome',
      name: 'HomeView_appBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get NotificationsView_appBarTitle {
    return Intl.message(
      'Notifications',
      name: 'NotificationsView_appBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `You have no notifications`
  String get NotificationsView_noNotificationsText {
    return Intl.message(
      'You have no notifications',
      name: 'NotificationsView_noNotificationsText',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get NotificationsView_errorText {
    return Intl.message(
      'An error occurred',
      name: 'NotificationsView_errorText',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get NotificationsView_tryAgainText {
    return Intl.message(
      'Try Again',
      name: 'NotificationsView_tryAgainText',
      desc: '',
      args: [],
    );
  }

  /// `New Post`
  String get NewPostView_appBarTitle {
    return Intl.message(
      'New Post',
      name: 'NewPostView_appBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Publish`
  String get NewPostView_publishButtonText {
    return Intl.message(
      'Publish',
      name: 'NewPostView_publishButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Write an explanatory description`
  String get NewPostView_addDescriptionHint {
    return Intl.message(
      'Write an explanatory description',
      name: 'NewPostView_addDescriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `Upload an Image`
  String get NewPostView_loadImageButtonText {
    return Intl.message(
      'Upload an Image',
      name: 'NewPostView_loadImageButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Supported formats: PNG, GIF, JPG. Images are usually 400x300 or 800x600.`
  String get NewPostView_loadImageFormatText {
    return Intl.message(
      'Supported formats: PNG, GIF, JPG. Images are usually 400x300 or 800x600.',
      name: 'NewPostView_loadImageFormatText',
      desc: '',
      args: [],
    );
  }

  /// `You can not upload more images`
  String get NewPostView_loadImageMaxText {
    return Intl.message(
      'You can not upload more images',
      name: 'NewPostView_loadImageMaxText',
      desc: '',
      args: [],
    );
  }

  /// `Image size must be less than 10MB`
  String get NewPostView_loadImageSizeText {
    return Intl.message(
      'Image size must be less than 10MB',
      name: 'NewPostView_loadImageSizeText',
      desc: '',
      args: [],
    );
  }

  /// `Remove Image`
  String get NewPostView_cancelImageTooltip {
    return Intl.message(
      'Remove Image',
      name: 'NewPostView_cancelImageTooltip',
      desc: '',
      args: [],
    );
  }

  /// `You can not add more than 3 images`
  String get NewPostView_imageCountLimitText {
    return Intl.message(
      'You can not add more than 3 images',
      name: 'NewPostView_imageCountLimitText',
      desc: '',
      args: [],
    );
  }

  /// `Please add data`
  String get NewPostView_errorSnackbarText {
    return Intl.message(
      'Please add data',
      name: 'NewPostView_errorSnackbarText',
      desc: '',
      args: [],
    );
  }

  /// `Published successfully`
  String get NewPostView_successSnackbarText {
    return Intl.message(
      'Published successfully',
      name: 'NewPostView_successSnackbarText',
      desc: '',
      args: [],
    );
  }

  /// `Upload Image`
  String get NewPostView_uploadIconText {
    return Intl.message(
      'Upload Image',
      name: 'NewPostView_uploadIconText',
      desc: '',
      args: [],
    );
  }

  /// `Image size must be less than 10MB`
  String get NewPostView_imageSizeExceedsLimitText {
    return Intl.message(
      'Image size must be less than 10MB',
      name: 'NewPostView_imageSizeExceedsLimitText',
      desc: '',
      args: [],
    );
  }

  /// `You can not add more than 3 images`
  String get NewPostView_imageLimitExceededText {
    return Intl.message(
      'You can not add more than 3 images',
      name: 'NewPostView_imageLimitExceededText',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get CommentsWidget_commentsTitle {
    return Intl.message(
      'Comments',
      name: 'CommentsWidget_commentsTitle',
      desc: '',
      args: [],
    );
  }

  /// `No comments available`
  String get CommentsWidget_noCommentsText {
    return Intl.message(
      'No comments available',
      name: 'CommentsWidget_noCommentsText',
      desc: '',
      args: [],
    );
  }

  /// `Add a comment...`
  String get CommentsWidget_addCommentHint {
    return Intl.message(
      'Add a comment...',
      name: 'CommentsWidget_addCommentHint',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get CommentsWidget_sendButton {
    return Intl.message(
      'Send',
      name: 'CommentsWidget_sendButton',
      desc: '',
      args: [],
    );
  }

  /// `View More`
  String get PostWidget_viewMore {
    return Intl.message(
      'View More',
      name: 'PostWidget_viewMore',
      desc: '',
      args: [],
    );
  }

  /// `View Less`
  String get PostWidget_viewLess {
    return Intl.message(
      'View Less',
      name: 'PostWidget_viewLess',
      desc: '',
      args: [],
    );
  }

  /// `Show All Comments`
  String get PostWidget_showAllComments {
    return Intl.message(
      'Show All Comments',
      name: 'PostWidget_showAllComments',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get CurrentUserProfileView_profileTitle {
    return Intl.message(
      'Profile',
      name: 'CurrentUserProfileView_profileTitle',
      desc: '',
      args: [],
    );
  }

  /// `More Options`
  String get CurrentUserProfileView_moreOptions {
    return Intl.message(
      'More Options',
      name: 'CurrentUserProfileView_moreOptions',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get CurrentUserProfileView_editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'CurrentUserProfileView_editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Followers`
  String get CurrentUserProfileView_followers {
    return Intl.message(
      'Followers',
      name: 'CurrentUserProfileView_followers',
      desc: '',
      args: [],
    );
  }

  /// `Followings`
  String get CurrentUserProfileView_followings {
    return Intl.message(
      'Followings',
      name: 'CurrentUserProfileView_followings',
      desc: '',
      args: [],
    );
  }

  String get CurrentUserProfileView_about_me {
    return Intl.message(
      'About me',
      name: 'CurrentUserProfileView_about_me',
      desc: '',
      args: [],
    );
  }

  String get CurrentUserProfileView_Specialties {
    return Intl.message(
      'Specialties',
      name: 'CurrentUserProfileView_Specialties',
      desc: '',
      args: [],
    );
  }

  String get CurrentUserProfileView_Services {
    return Intl.message(
      'Services',
      name: 'CurrentUserProfileView_Services',
      desc: '',
      args: [],
    );
  }

  String get CurrentUserProfileView_Agreements_with_health {
    return Intl.message(
      'Agreements with health funds',
      name: 'CurrentUserProfileView_Agreements_with_health',
      desc: '',
      args: [],
    );
  }

  String get CurrentUserProfileView_Agreements_with_insurance {
    return Intl.message(
      'Agreements with insurance companies',
      name: 'CurrentUserProfileView_Agreements_with_insurance',
      desc: '',
      args: [],
    );
  }

  String get CurrentUserProfileView_Years_of_Experience {
    return Intl.message(
      'Years of Experience',
      name: 'CurrentUserProfileView_Years_of_Experience',
      desc: '',
      args: [],
    );
  }

  /// `Followers`
  String get FollowingsFollowersListView_Followers {
    return Intl.message(
      'Followers',
      name: 'FollowingsFollowersListView_Followers',
      desc: '',
      args: [],
    );
  }

  /// `Following`
  String get FollowingsFollowersListView_Following {
    return Intl.message(
      'Following',
      name: 'FollowingsFollowersListView_Following',
      desc: '',
      args: [],
    );
  }

  /// `Unfollow`
  String get FollowingsFollowersListView_Unfollow {
    return Intl.message(
      'Unfollow',
      name: 'FollowingsFollowersListView_Unfollow',
      desc: '',
      args: [],
    );
  }

  /// `Follow`
  String get FollowingsFollowersListView_Follow {
    return Intl.message(
      'Follow',
      name: 'FollowingsFollowersListView_Follow',
      desc: '',
      args: [],
    );
  }

  /// `You`
  String get FollowingsFollowersListView_You {
    return Intl.message(
      'You',
      name: 'FollowingsFollowersListView_You',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get OtherUserProfileView_Profile {
    return Intl.message(
      'Profile',
      name: 'OtherUserProfileView_Profile',
      desc: '',
      args: [],
    );
  }

  /// `Followers`
  String get OtherUserProfileView_Followers {
    return Intl.message(
      'Followers',
      name: 'OtherUserProfileView_Followers',
      desc: '',
      args: [],
    );
  }

  /// `Following`
  String get OtherUserProfileView_Following {
    return Intl.message(
      'Following',
      name: 'OtherUserProfileView_Following',
      desc: '',
      args: [],
    );
  }

  /// `Follow`
  String get OtherUserProfileView_Follow {
    return Intl.message(
      'Follow',
      name: 'OtherUserProfileView_Follow',
      desc: '',
      args: [],
    );
  }

  /// `Unfollow`
  String get OtherUserProfileView_Unfollow {
    return Intl.message(
      'Unfollow',
      name: 'OtherUserProfileView_Unfollow',
      desc: '',
      args: [],
    );
  }

  /// `Messaging`
  String get OtherUserProfileView_Message {
    return Intl.message(
      'Messaging',
      name: 'OtherUserProfileView_Message',
      desc: '',
      args: [],
    );
  }

  String get OtherUserProfileView_user_contacts {
    return Intl.message(
      'Doctor contact information',
      name: 'OtherUserProfileView_user_contacts',
      desc: '',
      args: [],
    );
  }

  /// `Complete Profile`
  String get UpdateProfileView_Complete_Profile {
    return Intl.message(
      'Complete Profile',
      name: 'UpdateProfileView_Complete_Profile',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get UpdateProfileView_Edit_Profile {
    return Intl.message(
      'Edit Profile',
      name: 'UpdateProfileView_Edit_Profile',
      desc: '',
      args: [],
    );
  }

  /// `The data has been updated successfully`
  String get UpdateProfileView_Updated_message {
    return Intl.message(
      'The data has been updated successfully',
      name: 'UpdateProfileView_Updated_message',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get UpdateProfileView_Name {
    return Intl.message(
      'Name',
      name: 'UpdateProfileView_Name',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get UpdateProfileView_Email {
    return Intl.message(
      'Email',
      name: 'UpdateProfileView_Email',
      desc: '',
      args: [],
    );
  }

  /// `Please select a city`
  String get UpdateProfileView_chose_city {
    return Intl.message(
      'Please select a city',
      name: 'UpdateProfileView_chose_city',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'UpdateProfileView_Clinic Name' key

  /// `Save`
  String get UpdateProfileView_Save {
    return Intl.message(
      'Save',
      name: 'UpdateProfileView_Save',
      desc: '',
      args: [],
    );
  }

  /// `Account Type`
  String get AccountTypeRadioSelector_Account_Type {
    return Intl.message(
      'Account Type',
      name: 'AccountTypeRadioSelector_Account_Type',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get AccountTypeRadioSelector_User {
    return Intl.message(
      'User',
      name: 'AccountTypeRadioSelector_User',
      desc: '',
      args: [],
    );
  }

  /// `Doctor`
  String get AccountTypeRadioSelector_Doctor {
    return Intl.message(
      'Doctor',
      name: 'AccountTypeRadioSelector_Doctor',
      desc: '',
      args: [],
    );
  }

  /// `Select Main Category`
  String get CategorySection_Select_Main_Category {
    return Intl.message(
      'Select Main Category',
      name: 'CategorySection_Select_Main_Category',
      desc: '',
      args: [],
    );
  }

  /// `First, select a main category`
  String get CategorySection_First_select_a_main_category {
    return Intl.message(
      'First, select a main category',
      name: 'CategorySection_First_select_a_main_category',
      desc: '',
      args: [],
    );
  }

  /// `Select Specialization`
  String get SelectCategorySection_Specialization {
    return Intl.message(
      'Select Specialization',
      name: 'SelectCategorySection_Specialization',
      desc: '',
      args: [],
    );
  }

  /// `The city`
  String get CityDropDown_your_city {
    return Intl.message(
      'City',
      name: 'CityDropDown_your_city',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get GenderSelector_gender {
    return Intl.message(
      'Gender',
      name: 'GenderSelector_gender',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get GenderSelector_female {
    return Intl.message(
      'Female',
      name: 'GenderSelector_female',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get GenderSelector_male {
    return Intl.message(
      'Male',
      name: 'GenderSelector_male',
      desc: '',
      args: [],
    );
  }

  /// `Delete the Account`
  String get ProfileBottomSheet_delete_Account {
    return Intl.message(
      'Delete the Account',
      name: 'ProfileBottomSheet_delete_Account',
      desc: '',
      args: [],
    );
  }

  /// `My Consultations`
  String get ProfileBottomSheet_My_Consultations {
    return Intl.message(
      'My Consultations',
      name: 'ProfileBottomSheet_My_Consultations',
      desc: '',
      args: [],
    );
  }

  /// `Share the App`
  String get ProfileBottomSheet_Share_the_App {
    return Intl.message(
      'Share the App',
      name: 'ProfileBottomSheet_Share_the_App',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get ProfileBottomSheet_Privacy_Policy {
    return Intl.message(
      'Privacy Policy',
      name: 'ProfileBottomSheet_Privacy_Policy',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get ProfileBottomSheet_About_Us {
    return Intl.message(
      'About Us',
      name: 'ProfileBottomSheet_About_Us',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get ProfileBottomSheet_Logout {
    return Intl.message(
      'Logout',
      name: 'ProfileBottomSheet_Logout',
      desc: '',
      args: [],
    );
  }

  /// `Search Results`
  String get CustomSearchResultsView_Search_Results {
    return Intl.message(
      'Search Results',
      name: 'CustomSearchResultsView_Search_Results',
      desc: '',
      args: [],
    );
  }

  /// `Posts`
  String get CustomSearchResultsView_Posts {
    return Intl.message(
      'Posts',
      name: 'CustomSearchResultsView_Posts',
      desc: '',
      args: [],
    );
  }

  /// `Doctors`
  String get CustomSearchResultsView_Doctors {
    return Intl.message(
      'Doctors',
      name: 'CustomSearchResultsView_Doctors',
      desc: '',
      args: [],
    );
  }

  /// `No matching search results`
  String get CustomSearchResultsView_No_matching_search_results {
    return Intl.message(
      'No matching search results',
      name: 'CustomSearchResultsView_No_matching_search_results',
      desc: '',
      args: [],
    );
  }

  /// `Custom Search`
  String get CustomSearchView_Custom_Search {
    return Intl.message(
      'Custom Search',
      name: 'CustomSearchView_Custom_Search',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get CustomSearchView_Search {
    return Intl.message(
      'Search',
      name: 'CustomSearchView_Search',
      desc: '',
      args: [],
    );
  }

  /// `Specialisation`
  String get CategoriesChipsList_Specialisation {
    return Intl.message(
      'Specialisation',
      name: 'CategoriesChipsList_Specialisation',
      desc: '',
      args: [],
    );
  }

  /// `Your Interests`
  String get CategoriesChipsList_Your_Interests {
    return Intl.message(
      'Your Interests',
      name: 'CategoriesChipsList_Your_Interests',
      desc: '',
      args: [],
    );
  }

  /// `Region`
  String get CitiesChipsList_Region {
    return Intl.message(
      'Region',
      name: 'CitiesChipsList_Region',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get SettingsView_Settings {
    return Intl.message(
      'Settings',
      name: 'SettingsView_Settings',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get SettingsView_Change_Password {
    return Intl.message(
      'Change Password',
      name: 'SettingsView_Change_Password',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get SettingsView_Change_Language {
    return Intl.message(
      'Change Language',
      name: 'SettingsView_Change_Language',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get Language {
    return Intl.message(
      'Language',
      name: 'Language',
      desc: '',
      args: [],
    );
  }

  /// `Delete My Account`
  String get SettingsView_Delete_My_Account {
    return Intl.message(
      'Delete My Account',
      name: 'SettingsView_Delete_My_Account',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred, try again`
  String get ContextExtensions_error_message {
    return Intl.message(
      'An error occurred, try again',
      name: 'ContextExtensions_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get DateTimeExtensions_yesterday {
    return Intl.message(
      'Yesterday',
      name: 'DateTimeExtensions_yesterday',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get DateTimeExtensions_today {
    return Intl.message(
      'Today',
      name: 'DateTimeExtensions_today',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get ValidationMixin_This_field_is_required {
    return Intl.message(
      'This field is required',
      name: 'ValidationMixin_This_field_is_required',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email address`
  String get ValidationMixin_Invalid_email_address {
    return Intl.message(
      'Invalid email address',
      name: 'ValidationMixin_Invalid_email_address',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters long`
  String get ValidationMixin_Password_must_be_at_least_6_characters_long {
    return Intl.message(
      'Password must be at least 6 characters long',
      name: 'ValidationMixin_Password_must_be_at_least_6_characters_long',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password must be at least 6 characters long`
  String get ValidationMixin_Password_Confirm_must_be_at_least_6_characters {
    return Intl.message(
      'Confirm password must be at least 6 characters long',
      name: 'ValidationMixin_Password_Confirm_must_be_at_least_6_characters',
      desc: '',
      args: [],
    );
  }

  /// `Password must be less than 18 characters`
  String get ValidationMixin_Password_must_be_less_than_18_characters {
    return Intl.message(
      'Password must be less than 18 characters',
      name: 'ValidationMixin_Password_must_be_less_than_18_characters',
      desc: '',
      args: [],
    );
  }

  /// `Name must be at least 8 characters long`
  String get ValidationMixin_Name_must_be_at_least_8_characters_long {
    return Intl.message(
      'Name must be at least 8 characters long',
      name: 'ValidationMixin_Name_must_be_at_least_8_characters_long',
      desc: '',
      args: [],
    );
  }

  /// `Name must not exceed 20 characters`
  String get ValidationMixin_Name_must_not_exceed_20_characters {
    return Intl.message(
      'Name must not exceed 20 characters',
      name: 'ValidationMixin_Name_must_not_exceed_20_characters',
      desc: '',
      args: [],
    );
  }

  /// `Name must be at least 4 characters long`
  String get ValidationMixin_Name_must_be_at_least_4_characters_long {
    return Intl.message(
      'Name must be at least 4 characters long',
      name: 'ValidationMixin_Name_must_be_at_least_4_characters_long',
      desc: '',
      args: [],
    );
  }

  /// `The phone number must be 9 numbers`
  String get ValidationMixin_the_PhoneNum_9 {
    return Intl.message(
      'The phone number must be 9 numbers',
      name: 'ValidationMixin_the_PhoneNum_9',
      desc: '',
      args: [],
    );
  }

  /// `Password does not match`
  String get ValidationMixin_Password_does_not_match {
    return Intl.message(
      'Password does not match',
      name: 'ValidationMixin_Password_does_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Invalid location data`
  String get ValidationMixin_Invalid_location_data {
    return Intl.message(
      'Invalid location data',
      name: 'ValidationMixin_Invalid_location_data',
      desc: '',
      args: [],
    );
  }

  /// `who are we`
  String get AboutUsView_who_are_we {
    return Intl.message(
      'who are we',
      name: 'AboutUsView_who_are_we',
      desc: '',
      args: [],
    );
  }

  /// `Be Well\nWe are Here`
  String get IntroductionView_Be_Well_We_Here {
    return Intl.message(
      'Be Well\nWe are Here',
      name: 'IntroductionView_Be_Well_We_Here',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to the Community`
  String get IntroductionView_Welcome_to_the_Community {
    return Intl.message(
      'Welcome to the Community',
      name: 'IntroductionView_Welcome_to_the_Community',
      desc: '',
      args: [],
    );
  }

  /// `Join Us`
  String get IntroductionView_Join_Us {
    return Intl.message(
      'Join Us',
      name: 'IntroductionView_Join_Us',
      desc: '',
      args: [],
    );
  }

  /// `privacy policy`
  String get PrivacyPolicyView_privacy_policy {
    return Intl.message(
      'privacy policy',
      name: 'PrivacyPolicyView_privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Agree`
  String get Agree {
    return Intl.message(
      'Agree',
      name: 'Agree',
      desc: '',
      args: [],
    );
  }

  /// `And'
  String get And {
    return Intl.message(
      'And',
      name: 'And',
      desc: '',
      args: [],
    );
  }

  /// `AgreeToAdds'
  String get AgreeToAdds {
    return Intl.message(
      'I agree to receive ads',
      name: 'AgreeToAdds',
      desc: '',
      args: [],
    );
  }

  /// Terms_and_conditions
  String get Terms_and_conditions {
    return Intl.message(
      'Terms and conditions',
      name: 'Terms_and_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for filling out the initial information. We will \ncontact you as soon as possible upon approval \nto join our family app.`
  String get SoonView_welcome_message {
    return Intl.message(
      'Thank you for filling out the initial information. We will \ncontact you as soon as possible upon approval \nto join our family app.',
      name: 'SoonView_welcome_message',
      desc: '',
      args: [],
    );
  }

  /// `View file`
  String get AttatechmentViewerView_View_file {
    return Intl.message(
      'View file',
      name: 'AttatechmentViewerView_View_file',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get ClinigramSearchTextField_search {
    return Intl.message(
      'Search',
      name: 'ClinigramSearchTextField_search',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while fetching data`
  String get CustomErrorWidget_error_message {
    return Intl.message(
      'An error occurred while fetching data',
      name: 'CustomErrorWidget_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get CustomErrorWidget_try_again {
    return Intl.message(
      'Try Again',
      name: 'CustomErrorWidget_try_again',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get PhoneTextField_phone_num {
    return Intl.message(
      'Phone number',
      name: 'PhoneTextField_phone_num',
      desc: '',
      args: [],
    );
  }

  /// `Visible`
  String get VisibiltyToggle_Visible {
    return Intl.message(
      'Visible',
      name: 'VisibiltyToggle_Visible',
      desc: '',
      args: [],
    );
  }

  /// `Not Visible`
  String get VisibiltyToggle_Not_Visible {
    return Intl.message(
      'Not Visible',
      name: 'VisibiltyToggle_Not_Visible',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get Online {
    return Intl.message(
      'Online',
      name: 'Online',
      desc: '',
      args: [],
    );
  }

  /// Nearby Clinics
  String get Nearby_Clinics {
    return Intl.message(
      'Nearby Clinics',
      name: 'nearbyClinics',
      desc: '',
      args: [],
    );
  }

  /// Urgent
  String get Urgent {
    return Intl.message(
      'Urgent',
      name: 'Urgent',
      desc: '',
      args: [],
    );
  }

  String get Select_language {
    return Intl.message(
      'Select the language',
      name: 'Select_language',
      desc: '',
      args: [],
    );
  }

  String get Lets_start {
    return Intl.message(
      'Let\'s start',
      name: 'Lets_start',
      desc: '',
      args: [],
    );
  }

  String get I_own_clinic {
    return Intl.message(
      'I own a clinic',
      name: 'I_own_clinic',
      desc: '',
      args: [],
    );
  }

  String get I_do_not_own_clinic {
    return Intl.message(
      'I do not own a clinic',
      name: 'I_do_not_own_clinic',
      desc: '',
      args: [],
    );
  }

  String get Do_you_own_clinic {
    return Intl.message(
      'Do you own a clinic?',
      name: 'Do_you_own_clinic',
      desc: '',
      args: [],
    );
  }

  String get Select_clinic_type_to_show_relevant_services {
    return Intl.message(
      'Select clinic type to show relevant services',
      name: 'Select_clinic_type_to_show_relevant_services',
      desc: '',
      args: [],
    );
  }

  String get Select_clinic_type_to_show_relevant_specialities {
    return Intl.message(
      'Select clinic type to show relevant specialities',
      name: 'Select_clinic_type_to_show_relevant_specialities',
      desc: '',
      args: [],
    );
  }

  String
      get This_page_is_for_doctors_only_Please_fill_in_your_professional_details_on_this_page {
    return Intl.message(
      'This page is for doctors only. Please fill in your professional details on this page',
      name:
          'This_page_is_for_doctors_only_Please_fill_in_your_professional_details_on_this_page',
      desc: '',
      args: [],
    );
  }

  String get Are_you_a_doctor {
    return Intl.message(
      'Are you a doctor?',
      name: 'Are_you_a_doctor',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'he'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
