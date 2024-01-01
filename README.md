# Password Keeper

Multi-platform mobile app in Flutter, a password manager hidden in a calculator

## Reflections on Password Security

In the digital era, password security has become an essential element in protecting our identity and personal information. Password Keeper fits into this context, aiming to provoke deeper reflections on our relationship with digital security.

## The Strength of Passwords

Passwords are our first line of defense against unauthorized access. They reflect our digital identity, and how we manage them can have a significant impact on our online life. Password Keeper aspires to promote responsible and conscious use of passwords.

## The Meaning of Cryptography

Cryptography, often understood merely as a technology, has a deeper meaning. It represents trust and the protection of our digital communications. At the core of Password Keeper, cryptography is a tool to ensure that your privacy is secure.

## Control of Your Information

Taking control of your information is an act of digital responsibility. Password Keeper offers an opportunity to explore your digital security, promoting transparency and total control over your passwords.

## An Appeal to Digital Education

This project is an appeal to digital education and security awareness. Our hope is that Password Keeper is not just a tool but also a means to spark conversations on how we can better protect ourselves and others in the digital world.

## How to Customize Your Version

Make your version unique by customizing key parameters in the `encryption.dart` file:

**Initialization Vector (IV):**

static final iv = encrypt.IV.fromUtf8("IVIVIVIVIVIVIVIV");  // <-- Customize the Initialization Vector with an 16-character string

**Filename:**

static const filename ='data.calc';                 // <-- Customize the dataSave filename

**Salt:**

static const salt = 'SALT';                         // <-- Customize the salt

Feel free to hide your password manager in the app of your choice based on this project. Only by doing so can we be true custodians of our keys.

## Tutorial: Setting Up Password Keeper

1. **Customize the Initialization Vector, Data Save Filename, and Salt in the `encryption.dart` file.**

2. **Compile the app and install it on your device.**

3. **Open the app and set up a master password.**

4. **Use the expression string from the calculator as your password and press '=' to confirm and access the password manager.**

This simple tutorial helps you personalize and secure your Password Keeper instance. Remember, your expression in the calculator is the key to unlocking your password manager.

## Download Password Keeper APK (Test Version)

If you'd like to test the app without compiling the code, you can download a precompiled APK file. Please note that this version might not be the latest, and we recommend creating your own version with personalized encryption keys for optimal security.

[Download Password Keeper APK (Test Version)](https://github.com/adrianobellia/pwd_keeper/raw/5e193e279340d22d6e3b871e92cd393b7da68a68/APK/pwd_keeper.apk)

## How to Contribute

If you find this project helpful and would like to support my work, you can contribute by making a donation. Your contributions help in maintaining and improving this project, as well as in the creation of more projects like this.

https://paypal.me/AdrianoBellia

Thank you for your support!