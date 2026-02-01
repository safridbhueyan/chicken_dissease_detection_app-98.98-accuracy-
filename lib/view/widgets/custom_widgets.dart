import 'package:appcare_flutter/appcare_flutter.dart';
import 'package:flutter/material.dart';

class CustomWidgets {
  static void showDisclaimer(BuildContext context, bool isEnglish) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: Colors.teal),
            const SizedBox(width: 10),
            Text(isEnglish ? "Scanning Guide" : "স্ক্যানিং নির্দেশিকা"),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEnglish
                    ? "For best results, follow these instructions based on the condition:"
                    : "সঠিক ফলাফলের জন্য নিচের নিয়মগুলো অনুসরণ করুন:",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              // Call static helper
              _bulletPoint(
                isEnglish
                    ? "Fowl Pox: Take a clear, close-up photo of the chicken's face, comb, or eyes."
                    : "ফাউল পক্স (বসন্ত): মুরগির মুখ, ঝুটি বা চোখের পরিষ্কার ছবি তুলুন।",
                Icons.face_retouching_natural,
              ),
              _bulletPoint(
                isEnglish
                    ? "Bumblefoot: Take a clear photo of the bottom of the chicken's feet."
                    : "বাম্বলফুট: মুরগির পায়ের নিচের পাতার পরিষ্কার ছবি তুলুন।",
                Icons.pets,
              ),
              _bulletPoint(
                isEnglish
                    ? "Other Diseases: Take a clear photo of the chicken droppings (poop)."
                    : "অন্যান্য রোগ: মুরগির মলের পরিষ্কার ছবি তুলুন।",
                Icons.analytics_rounded,
              ),
              const Divider(height: 30),
              Text(
                isEnglish
                    ? "Note: Predictions are not 100% accurate. Consult a vet for final diagnosis."
                    : "দ্রষ্টব্য: ফলাফল ১০০% নির্ভুল নাও হতে পারে। চূড়ান্ত সিদ্ধান্তের জন্য ডাক্তারের পরামর্শ নিন।",
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isEnglish ? "I Understand" : "বুঝেছি"),
          ),
        ],
      ),
    );
  }

  // Static helper for bullet points
  static Widget _bulletPoint(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.teal),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  static Widget buildInvalidCard(bool isEnglish) {
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

  static Widget buildInfoTile({
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

  static Widget buildActionButton({
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // --- Helper: Show About Us ---
  static void showAboutUs(BuildContext context, bool isEnglish) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Header with Gradient ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal, Colors.indigo],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage("assets/techlogo.png"),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isEnglish ? "About Us" : "আমাদের সম্পর্কে",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // --- Content ---
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      isEnglish ? "Developed By" : "ডেভেলপ করেছে",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Futuredesh Tech Team",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- NEW: App Version Display ---
                    FutureBuilder<AppBaseInfo>(
                      future: AppCare().getAppBaseInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            "v${snapshot.data!.version} (${snapshot.data!.buildNumber})",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }
                        return const SizedBox(height: 13); // Placeholder height
                      },
                    ),

                    const SizedBox(height: 24),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          isEnglish ? "Close" : "বন্ধ করুন",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildFooterItem({
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

  //app care

  static Future<void> handleAppUpdate(BuildContext context) async {
    final appCare = AppCare();

    try {
      // 1. Check for updates
      final updateInfo = await appCare.checkForUpdate();

      if (updateInfo.updateAvailable) {
        // 2. Show a custom dialog or use the native flow
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("New Update Available!"),
            content: Text(
              "A new version (${updateInfo.remoteVersion}) of MurgiCare is available on the Play Store. Please update for better AI accuracy.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Later"),
              ),
              ElevatedButton(
                onPressed: () {
                  // 3. Start the native update flow
                  appCare.startUpdate();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text("Update Now"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint("Update check failed: $e");
    }
  }
}
