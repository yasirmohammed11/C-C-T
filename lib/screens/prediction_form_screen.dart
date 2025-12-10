import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cervical_cancer_flutter_app/services/auth_service.dart';
import 'package:cervical_cancer_flutter_app/services/prediction_service.dart';

class PredictionFormScreen extends StatefulWidget {
  const PredictionFormScreen({super.key});

  @override
  State<PredictionFormScreen> createState() => _PredictionFormScreenState();
}

class _PredictionFormScreenState extends State<PredictionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  bool _isLoading = false;
  String? _predictionResult;
  double? _predictionProbability;

  // قائمة الميزات المطلوبة من app.py
  final List<Map<String, dynamic>> _features = [
    {'key': 'Age', 'label': 'العمر (سنة)', 'type': 'number', 'required': true},
    {'key': 'Number of sexual partners', 'label': 'عدد الشركاء الجنسيين', 'type': 'number', 'required': true},
    {'key': 'First sexual intercourse', 'label': 'سن أول علاقة جنسية (سنة)', 'type': 'number', 'required': true},
    {'key': 'Num of pregnancies', 'label': 'عدد الحمل', 'type': 'number', 'required': true},
    {'key': 'Smokes', 'label': 'هل تدخن؟', 'type': 'select', 'options': {'0': 'لا', '1': 'نعم'}, 'required': true},
    {'key': 'Smokes (years)', 'label': 'سنوات التدخين', 'type': 'number', 'required': false},
    {'key': 'Smokes (packs/year)', 'label': 'عدد علب السجائر في السنة', 'type': 'number', 'required': false},
    {'key': 'Hormonal Contraceptives', 'label': 'موانع الحمل الهرمونية', 'type': 'select', 'options': {'0': 'لا', '1': 'نعم'}, 'required': true},
    {'key': 'Hormonal Contraceptives (years)', 'label': 'سنوات استخدام موانع الحمل الهرمونية', 'type': 'number', 'required': false},
    {'key': 'IUD', 'label': 'استخدام اللولب', 'type': 'select', 'options': {'0': 'لا', '1': 'نعم'}, 'required': true},
    {'key': 'IUD (years)', 'label': 'سنوات استخدام اللولب', 'type': 'number', 'required': false},
    {'key': 'STDs', 'label': 'وجود أمراض معدية جنسياً', 'type': 'select', 'options': {'0': 'لا', '1': 'نعم'}, 'required': true},
    {'key': 'STDs (number)', 'label': 'عدد الأمراض المعدية الجنسية', 'type': 'number', 'required': false},
    // ... (إضافة باقي الميزات بنفس الطريقة)
    {'key': 'STDs:HPV', 'label': 'فيروس الورم الحليمي (HPV)', 'type': 'select', 'options': {'0': 'لا', '1': 'نعم'}, 'required': false},
    {'key': 'hpv_genotype', 'label': 'نوع فيروس الورم (16, 18, إلخ)', 'type': 'text', 'required': false},
    {'key': 'cervical_smear_result', 'label': 'نتيجة مسحة عنق الرحم', 'type': 'select', 'options': {'Normal': 'طبيعي', 'Abnormal': 'غير طبيعي', 'CIN1': 'CIN1', 'CIN2': 'CIN2', 'CIN3': 'CIN3'}, 'required': false},
    {'key': 'Hinselmann', 'label': 'اختبار Hinselmann', 'type': 'select', 'options': {'0': 'سلبي', '1': 'إيجابي'}, 'required': false},
    {'key': 'Schiller', 'label': 'اختبار Schiller', 'type': 'select', 'options': {'0': 'سلبي', '1': 'إيجابي'}, 'required': false},
    {'key': 'Cytology', 'label': 'فحص الخلايا', 'type': 'select', 'options': {'0': 'سلبي', '1': 'إيجابي'}, 'required': false},
    {'key': 'Biopsy', 'label': 'الخزعة', 'type': 'select', 'options': {'0': 'سلبي', '1': 'إيجابي'}, 'required': false},
    {'key': 'abnormal_bleeding', 'label': 'نزيف غير طبيعي', 'type': 'checkbox', 'required': false},
    {'key': 'abnormal_discharge', 'label': 'إفرازات غير طبيعية', 'type': 'checkbox', 'required': false},
    {'key': 'pelvic_pain', 'label': 'ألم في الحوض', 'type': 'checkbox', 'required': false},
    {'key': 'post_coital_bleeding', 'label': 'نزيف بعد العلاقة الجنسية', 'type': 'checkbox', 'required': false},
    {'key': 'chronic_inflammation', 'label': 'التهاب مزمن', 'type': 'checkbox', 'required': false},
    {'key': 'p16_ki67_level', 'label': 'مستوى المؤشر p16/ki-67', 'type': 'number', 'required': false},
    {'key': 'p16_ki67_status', 'label': 'حالة p16/ki-67', 'type': 'select', 'options': {'Positive': 'إيجابي', 'Negative': 'سلبي'}, 'required': false},
    {'key': 'inflammation_level', 'label': 'درجة الالتهاب', 'type': 'select', 'options': {'Mild': 'خفيف', 'Moderate': 'متوسط', 'Severe': 'شديد'}, 'required': false},
    {'key': 'genetic_mutations', 'label': 'وجود طفرات جينية', 'type': 'checkbox', 'required': false},
  ];

  @override
  void initState() {
    super.initState();
    // تهيئة البيانات الافتراضية
    for (var feature in _features) {
      if (feature['type'] == 'number') {
        _formData[feature['key']] = '';
      } else if (feature['type'] == 'select') {
        _formData[feature['key']] = null;
      } else if (feature['type'] == 'checkbox') {
        _formData[feature['key']] = false;
      } else {
        _formData[feature['key']] = '';
      }
    }
  }

  Widget _buildFormGroup(Map<String, dynamic> feature) {
    final key = feature['key'];
    final label = feature['label'];
    final type = feature['type'];
    final required = feature['required'];

    if (type == 'number') {
      return TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return 'الرجاء إدخال $label';
          }
          if (value != null && value.isNotEmpty && double.tryParse(value) == null) {
            return 'الرجاء إدخال رقم صحيح';
          }
          return null;
        },
        onChanged: (value) {
          _formData[key] = value;
        },
      );
    } else if (type == 'select') {
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        value: _formData[key],
        items: feature['options'].entries.map<DropdownMenuItem<String>>((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _formData[key] = newValue;
          });
        },
        validator: (value) {
          if (required && value == null) {
            return 'الرجاء اختيار $label';
          }
          return null;
        },
      );
    } else if (type == 'checkbox') {
      return CheckboxListTile(
        title: Text(label),
        value: _formData[key] ?? false,
        onChanged: (bool? newValue) {
          setState(() {
            _formData[key] = newValue;
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
      );
    } else if (type == 'text') {
      return TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          _formData[key] = value;
        },
      );
    }
    return const SizedBox.shrink();
  }

  Future<void> _submitPrediction() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
        _predictionResult = null;
        _predictionProbability = null;
      });

      final authService = Provider.of<AuthService>(context, listen: false);
      final predictionService = PredictionService();

      // تحويل البيانات إلى التنسيق المطلوب للـ API
      final Map<String, dynamic> dataToSend = {};
      dataToSend['user_id'] = authService.userId;

      for (var feature in _features) {
        final key = feature['key'];
        final type = feature['type'];
        dynamic value = _formData[key];

        if (value != null) {
          if (type == 'number') {
            dataToSend[key] = double.tryParse(value.toString()) ?? 0.0;
          } else if (type == 'select') {
            // للقيم الرقمية في الـ API (0/1)
            if (feature['options'].keys.contains('0') || feature['options'].keys.contains('1')) {
              dataToSend[key] = int.tryParse(value.toString()) ?? 0;
            } else {
              dataToSend[key] = value;
            }
          } else if (type == 'checkbox') {
            dataToSend[key] = value ? 1 : 0;
          } else {
            dataToSend[key] = value;
          }
        }
      }

      final result = await predictionService.predict(dataToSend);

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        setState(() {
          _predictionResult = result['result_text'];
          _predictionProbability = result['probability'];
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['error'] ?? 'فشل التنبؤ')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'نموذج التنبؤ الذكي',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'أدخل بيانات المريضة للحصول على تقييم احتمالية الإصابة بسرطان الرحم',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Divider(height: 32),

            // عرض النتيجة
            if (_predictionResult != null)
              Card(
                color: _predictionResult!.contains('إيجابي') ? Colors.red.shade100 : Colors.green.shade100,
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نتيجة التنبؤ:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _predictionResult!.contains('إيجابي') ? Colors.red.shade900 : Colors.green.shade900),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _predictionResult!,
                        style: const TextStyle(fontSize: 16),
                      ),
                      if (_predictionProbability != null)
                        Text(
                          'احتمالية: ${(_predictionProbability! * 100).toStringAsFixed(2)}%',
                          style: const TextStyle(fontSize: 16),
                        ),
                    ],
                  ),
                ),
              ),

            // البيانات الأساسية
            FormSectionHeader(title: 'البيانات الأساسية', icon: Icons.person),
            ..._features.sublist(0, 4).map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildFormGroup(f),
                )),
            const Divider(height: 32),

            // عادات التدخين
            FormSectionHeader(title: 'عادات التدخين', icon: Icons.smoking_rooms),
            ..._features.sublist(4, 7).map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildFormGroup(f),
                )),
            const Divider(height: 32),

            // موانع الحمل
            FormSectionHeader(title: 'موانع الحمل', icon: Icons.medical_services),
            ..._features.sublist(7, 11).map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildFormGroup(f),
                )),
            const Divider(height: 32),

            // الأمراض المعدية الجنسية
            FormSectionHeader(title: 'الأمراض المعدية الجنسية', icon: Icons.warning),
            ..._features.sublist(11, 14).map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildFormGroup(f),
                )),
            // HPV Genotype
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildFormGroup(_features.firstWhere((f) => f['key'] == 'hpv_genotype')),
            ),
            const Divider(height: 32),

            // نتائج الفحوصات السابقة
            FormSectionHeader(title: 'نتائج الفحوصات السابقة', icon: Icons.science),
            ..._features.where((f) => ['cervical_smear_result', 'Hinselmann', 'Schiller', 'Cytology', 'Biopsy'].contains(f['key'])).map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildFormGroup(f),
                )),
            const Divider(height: 32),

            // الأعراض الحالية
            FormSectionHeader(title: 'الأعراض الحالية', icon: Icons.sick),
            ..._features.where((f) => ['abnormal_bleeding', 'abnormal_discharge', 'pelvic_pain', 'post_coital_bleeding'].contains(f['key'])).map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _buildFormGroup(f),
                )),
            const Divider(height: 32),

            // المؤشرات الحيوية والطفرات الجينية
            FormSectionHeader(title: 'المؤشرات الحيوية والطفرات الجينية', icon: Icons.dna),
            ..._features.where((f) => ['chronic_inflammation', 'p16_ki67_level', 'p16_ki67_status', 'inflammation_level', 'genetic_mutations'].contains(f['key'])).map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
         const SizedBox(height: 30),

            // زر التنبؤ
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      text: 'تنبؤ',
                      onPressed: _submitPrediction,
                      isPrimary: true,
                    ),
            ), SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
