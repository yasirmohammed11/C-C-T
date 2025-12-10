// عنوان الـ API الذي تم إتاحته من تطبيق Flask
// سيتم تحديثه لاحقًا بعنوان ثابت عند النشر
const String kBaseUrl = 'https://yasirmhammed.pythonanywhere.com'; 

// الألوان المستخدمة في التطبيق (يمكن استخلاصها من ملف CSS لاحقًا)
// بما أننا لا نملك ملف CSS الأصلي، سنستخدم ألوان فلاتر الافتراضية حاليًا
// وسنعتمد على ملف main.dart الذي يحدد primarySwatch: Colors.blue

import 'package:flutter/material.dart';

// الألوان المستخلصة من ملف style.css
const Color kPrimaryColor = Color(0xFF667EEA); // #667eea
const Color kSecondaryColor = Color(0xFF764BA2); // #764ba2
const Color kDarkColor = Color(0xFF2C3E50); // #2c3e50
const Color kTextColor = Color(0xFF333333); // #333
const Color kLightGrayColor = Color(0xFFF8F9FA); // #f8f9fa
const Color kSuccessColor = Color(0xFF4CAF50); // #4caf50
const Color kErrorColor = Color(0xFFF44336); // #f44336
const Color kWarningColor = Color(0xFFFFF3CD); // #fff3cd
const Color kWarningBorderColor = Color(0xFFFFC107); // #ffc107
const Color kLogoutColor = Color(0xFFE74C3C); // #e74c3c
