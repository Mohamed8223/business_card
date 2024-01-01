# clinigram_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## usefull commands

A list of commands that can be usefull.

### build

flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

### run in web (chrome)

flutter run -d chrome

### deploy to cinigr test website

firebase deploy --only hosting:clinigr

## Add New words to Localization

* Please be aware that there are two steps that you will repeat depending on the number of languages present and I will explain this in each step

It requires three main steps:

- Add the text you want to translate to the map in intl_en.arb file in lib\features\translation\data\l10n\intl_en.arb like:
  *We want to add " About me : " We will add this line to map in intl_en.arb:
   "CurrentUserProfileView_about_me" : "About me :", -> first string is a key you can add any string to key but must string has _ if you want to add more than word ex: CurrentUserProfileView_about_me  right syntax but CurrentUserProfileView about me wrong 
   We always use this syntax -> "ClassName_any_word_that_expresses_value" : " Any value as you want, provided that it is in the same language as the file name ", 
   After adding the new word to intl_en.arb we will add to another files in lib\features\translation\data\l10n\ but the key must be same in all files. ex : intl_en.arb ->  "CurrentUserProfileView_about_me" : "About me :", intl_ar.arb -> "CurrentUserProfileView_about_me": ": نبذة عني ", etc...

- Add the text to messages_en.dart in  lib\features\translation\data\generated\intl\messages_en.dart like:
   "CurrentUserProfileView_about_me": -> same key
      MessageLookupByLibrary.simpleMessage("About me :"), -> same value

  - Repeat this step with the rest of the language files in the file like:
      "CurrentUserProfileView_about_me":
          MessageLookupByLibrary.simpleMessage(": نبذة عني "),

- Add getter function in S class in lib\features\translation\data\generated\l10n.dart like:
   String get CurrentUserProfileView_about_me {
    return Intl.message(
      'About me :',
      name: 'CurrentUserProfileView_about_me',
      desc: '',
      args: [],
    );
  }

  - Be aware that this step is not repeated, but rather you place the function in the class with the English value only, as shown in the example.
