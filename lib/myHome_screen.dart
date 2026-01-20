// ignore_for_file: deprecated_member_use

import 'package:murgi_care/dissease_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'controller.dart';

class MyhomeScreen extends StatelessWidget {
  const MyhomeScreen({super.key});

  // --- Helper: Show Accuracy Disclaimer ---
  void _showDisclaimer(BuildContext context, bool isEnglish) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 10),
            Text(isEnglish ? "Disclaimer" : "সতর্কবার্তা"),
          ],
        ),
        content: Text(
          isEnglish
              ? "1. The model predictions may not be 100% accurate. Always consult a veterinarian for final diagnosis.\n\n"
                    "2. This app is strictly for Chicken droppings. Scanning any other animal's poop will result in invalid and inaccurate outcomes."
              : "১. মডেলের ফলাফল ১০০% নির্ভুল নাও হতে পারে। মুরগির সঠিক রোগ নির্ণয় এবং চিকিৎসার জন্য অবশ্যই ভেটেরিনারি চিকিৎসকের পরামর্শ নিন।\n\n"
                    "২. এই অ্যাপটি শুধুমাত্র মুরগির মলের জন্য তৈরি। অন্য কোনো প্রাণীর মল স্ক্যান করলে ফলাফল ভুল এবং অগ্রহণযোগ্য হবে।",
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isEnglish ? "OK" : "ঠিক আছে"),
          ),
        ],
      ),
    );
  }

  // --- Helper: Show About Us ---
  void _showAboutUs(BuildContext context, bool isEnglish) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(child: Text(isEnglish ? "About Us" : "আমাদের সম্পর্কে")),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.teal,
              backgroundImage: AssetImage("assets/techlogo.png"),
            ),
            const SizedBox(height: 15),
            Text(
              isEnglish ? "Developed By" : "ডেভেলপ করেছে",
              style: const TextStyle(color: Colors.black),
            ),
            const Text(
              "FutureDesh Tech Team",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isEnglish ? "Close" : "বন্ধ করুন"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        // --- ADDED: Leading Reset Button ---
        leading: Consumer<DiseaseProvider>(
          builder: (context, provider, child) {
            if (provider.image == null) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Colors.redAccent),
              onPressed: () => provider.reset(),
              tooltip: provider.isEnglish ? "Reset" : "রিসেট",
            );
          },
        ),
        title: const Text(
          'Chicken Disease Detector',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color.fromARGB(255, 8, 63, 9),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          Consumer<DiseaseProvider>(
            builder: (context, provider, child) {
              return TextButton(
                onPressed: () => provider.toggleLanguage(),
                child: Text(
                  provider.isEnglish ? "বাংলা" : "ENG",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade200, height: 1.0),
        ),
      ),
      body: Consumer<DiseaseProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- 1. Image Display Card ---
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: provider.image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_rounded,
                              size: 50,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              provider.isEnglish
                                  ? "No Image Selected"
                                  : "কোন ছবি নির্বাচন করা হয়নি",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(provider.image!, fit: BoxFit.cover),
                        ),
                ),
                const SizedBox(height: 32),

                // --- 2. Logic: Result Section ---
                if (provider.loading)
                  const Column(
                    children: [
                      CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.teal,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Analyzing...",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                else if (provider.outputs != null &&
                    provider.outputs!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildResultCard(
                        provider.outputs![0],
                        provider.isEnglish,
                      ),
                      const SizedBox(height: 24),
                      _buildDiseaseInfo(
                        provider.outputs![0]['label'],
                        provider.isEnglish,
                      ),
                    ],
                  )
                else
                  Center(
                    child: Text(
                      provider.isEnglish
                          ? "Select an image to check chickens health status"
                          : "মুরগির স্বাস্থ্য পরীক্ষা করতে একটি ছবি নির্বাচন করুন",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ),

                const SizedBox(height: 40),

                // --- 3. Primary Action Buttons ---
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.camera_alt_rounded,
                        label: provider.isEnglish ? "Camera" : "ক্যামেরা",
                        color: Colors.teal,
                        onTap: () => provider.pickImage(ImageSource.camera),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.photo_library_rounded,
                        label: provider.isEnglish ? "Gallery" : "গ্যালারি",
                        color: Colors.indigo,
                        onTap: () => provider.pickImage(ImageSource.gallery),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // --- 4. Footer Icons (Caution & About) ---
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFooterItem(
                      icon: Icons.report_problem_outlined,
                      label: provider.isEnglish ? "Caution" : "সতর্কতা",
                      color: Colors.orange,
                      onTap: () => _showDisclaimer(context, provider.isEnglish),
                    ),
                    _buildFooterItem(
                      icon: Icons.info_outline,
                      label: provider.isEnglish ? "About" : "তথ্য",
                      color: Colors.indigo,
                      onTap: () => _showAboutUs(context, provider.isEnglish),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Helper: Footer Menu Item ---
  Widget _buildFooterItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(Map output, bool isEnglish) {
    String rawLabel = output['label'].toString();
    String cleanId = _getCleanId(rawLabel);
    String formattedLabel = formatLabel(rawLabel, isEnglish);
    double confidence = (output['confidence'] as double) * 100;

    if (cleanId == 'others') {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amber),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.amber,
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              isEnglish ? "Invalid Image" : "সঠিক ছবি তুলুন",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              isEnglish
                  ? "This doesn't look like chicken droppings. Please provide a valid image."
                  : "এটি মুরগির মলের ছবি বলে মনে হচ্ছে না। দয়া করে সঠিক ছবি দিন।",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.brown),
            ),
          ],
        ),
      );
    }

    bool isHealthy = cleanId == 'healthy';
    Color themeColor = isHealthy ? Colors.green : Colors.redAccent;
    Color bgColor = isHealthy ? Colors.green.shade50 : Colors.red.shade50;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: themeColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            formattedLabel,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${isEnglish ? "Confidence" : "নিশ্চয়তা"}: ${confidence.toStringAsFixed(1)}%",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: themeColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseInfo(String rawLabel, bool isEnglish) {
    String id = _getCleanId(rawLabel);
    if (id == "healthy" || id == 'others') return const SizedBox.shrink();
    Map<String, String>? data = diseaseInfo[id];
    if (data == null) return const SizedBox.shrink();

    return Column(
      children: [
        _buildInfoTile(
          title: isEnglish ? "Symptoms" : "লক্ষণ",
          content: isEnglish ? data['symptoms_en']! : data['symptoms']!,
          icon: Icons.warning_amber_rounded,
          accentColor: Colors.orange,
        ),
        _buildInfoTile(
          title: isEnglish ? "Prevention" : "প্রতিরোধ",
          content: isEnglish ? data['prevention_en']! : data['prevention']!,
          icon: Icons.shield_outlined,
          accentColor: Colors.blue,
        ),
        _buildInfoTile(
          title: isEnglish ? "Treatment" : "প্রাথমিক চিকিৎসা",
          content: isEnglish ? data['treatment_en']! : data['treatment']!,
          icon: Icons.medical_services_outlined,
          accentColor: Colors.green,
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required String title,
    required String content,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: accentColor, width: 6)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: accentColor, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: accentColor.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 22),
      label: Text(label, style: const TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 2,
        shadowColor: color.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String _getCleanId(String label) {
    debugPrint(label);
    String clean = label.replaceAll(RegExp(r'[0-9]'), '').trim().toLowerCase();

    if (clean.contains('others')) return 'others';
    if (clean.contains('cocci')) return 'cocci';
    if (clean.contains('ncd')) return 'ncd';
    if (clean.contains('salmo')) return 'salmo';
    if (clean.contains('healthy')) return 'healthy';
    if (clean.contains('crd')) return 'crd';
    if (clean.contains('fowlpox')) return 'fowlpox';
    if (clean.contains('bumblefoot')) return 'bumblefoot';
    if (clean.contains('coryza')) return 'coryza';

    return clean;
  }

  String formatLabel(String label, bool isEnglish) {
    String clean = _getCleanId(label);
    debugPrint(clean);
    switch (clean) {
      case 'others':
        return isEnglish ? 'Invalid Image' : 'সঠিক ছবি নয়';
      case 'cocci':
        return isEnglish ? 'Coccidiosis' : 'রক্ত আমাশয়';
      case 'healthy':
        return isEnglish ? 'Healthy' : 'সুস্থ মুরগি';
      case 'ncd':
        return isEnglish ? 'Newcastle Disease' : 'রানীক্ষেত';
      case 'salmo':
        return isEnglish ? 'Salmonella' : 'সালমোনেলা';
      case 'crd':
        return isEnglish ? 'CRD' : 'সিআরডি (শ্বাসকষ্ট)';
      case 'fowlpox':
        return isEnglish ? 'Fowl Pox' : 'বসন্ত (পক্স)';
      case 'bumblefoot':
        return isEnglish ? 'Bumblefoot' : 'বাম্বলফুট';
      case 'coryza':
        return isEnglish ? 'Coryza' : 'কোরাইজা (সর্দি)';
      default:
        return clean.isNotEmpty
            ? '${clean[0].toUpperCase()}${clean.substring(1)}'
            : clean;
    }
  }
}
