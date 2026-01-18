import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'controller.dart'; // Ensure this points to your DiseaseProvider file

class MyhomeScreen extends StatelessWidget {
  const MyhomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Soft background
      appBar: AppBar(
        title: const Text(
          'Chicken Disease Detector',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87, // Modern clean look
        elevation: 0,
      ),
      body: Consumer<DiseaseProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Image Display Card ---
                Container(
                  height: 320,
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
                              size: 60,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "No Image Selected",
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

                // --- Result Section ---
                if (provider.loading)
                  const Column(
                    children: [
                      CircularProgressIndicator(strokeWidth: 3),
                      SizedBox(height: 16),
                      Text(
                        "Analyzing...",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                else if (provider.outputs != null &&
                    provider.outputs!.isNotEmpty)
                  _buildResultCard(provider.outputs![0])
                else
                  const Center(
                    child: Text(
                      "Select an image to check health status",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ),

                const SizedBox(height: 40),

                // --- Action Buttons ---
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.camera_alt_rounded,
                        label: "Camera",
                        color: Colors.teal,
                        onTap: () => provider.pickImage(ImageSource.camera),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.photo_library_rounded,
                        label: "Gallery",
                        color: Colors.indigo,
                        onTap: () => provider.pickImage(ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Helper Widget: Beautiful Result Card ---
  Widget _buildResultCard(Map output) {
    String rawLabel = output['label'].toString();
    String formattedLabel = formatLabel(rawLabel);
    double confidence = (output['confidence'] as double) * 100;

    // Determine color based on "Healthy" vs Disease
    bool isHealthy =
        formattedLabel.toLowerCase().contains("healthy") ||
        formattedLabel.contains("সুস্থ");

    Color themeColor = isHealthy ? Colors.green : Colors.redAccent;
    Color bgColor = isHealthy ? Colors.green.shade50 : Colors.red.shade50;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themeColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            formattedLabel, // This shows the Bangla Name
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22, // Larger font for Bangla readability
              fontWeight: FontWeight.bold,
              color: themeColor,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Confidence: ${confidence.toStringAsFixed(1)}%",
              style: TextStyle(
                fontSize: 14,
                color: themeColor.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widget: Custom Button ---
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// --- The Bangla Label Logic ---
String formatLabel(String label) {
  // Remove numbers and extra spaces first
  String clean = label.replaceAll(RegExp(r'[0-9]'), '').trim().toLowerCase();

  switch (clean) {
    case 'cocci':
    case 'pcrcocci':
      return 'রক্ত আমাশয় (Coccidiosis)';

    case 'healthy':
    case 'pcrhealthy':
      return 'সুস্থ মুরগি (Healthy)';

    case 'ncd':
    case 'pcrncd':
      return 'রানীক্ষেত (Newcastle Disease)';

    case 'salmo':
    case 'pcrsalmo':
      return 'সালমোনেলা (Salmonella)';

    default:
      // Fallback: Just Capitalize the first letter if unknown
      return clean.isNotEmpty
          ? '${clean[0].toUpperCase()}${clean.substring(1)}'
          : clean;
  }
}
