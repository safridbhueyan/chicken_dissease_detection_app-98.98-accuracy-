import 'package:chicken_dissease/dissease_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'controller.dart';

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
        foregroundColor: Colors.black87,
        elevation: 0,
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

                // --- 2. Logic: Loading / Result / Instructions ---
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
                      // Result Header Card
                      _buildResultCard(provider.outputs![0]),

                      const SizedBox(height: 24),

                      // Detailed Information Sections
                      _buildDiseaseInfo(provider.outputs![0]['label']),
                    ],
                  )
                else
                  const Center(
                    child: Text(
                      "Select an image to check health status",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ),

                const SizedBox(height: 40),

                // --- 3. Action Buttons ---
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

  // --- Helper: Beautiful Result Card ---
  Widget _buildResultCard(Map output) {
    String rawLabel = output['label'].toString();
    String formattedLabel = formatLabel(rawLabel);
    double confidence = (output['confidence'] as double) * 100;

    // Determine color based on "Healthy"
    bool isHealthy =
        formattedLabel.toLowerCase().contains("healthy") ||
        formattedLabel.contains("সুস্থ");

    Color themeColor = isHealthy ? Colors.green : Colors.redAccent;
    Color bgColor = isHealthy ? Colors.green.shade50 : Colors.red.shade50;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: themeColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              "Confidence: ${confidence.toStringAsFixed(1)}%",
              style: TextStyle(
                fontSize: 14,
                color: themeColor.withOpacity(0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper: Disease Info Section ---
  Widget _buildDiseaseInfo(String rawLabel) {
    String id = _getCleanId(rawLabel);

    Map<String, String>? data = diseaseInfo[id];

    // If no data or healthy, hide this section
    if (data == null) return const SizedBox.shrink();

    return Column(
      children: [
        _buildInfoTile(
          title: "লক্ষণ (Symptoms)",
          content: data['symptoms']!,
          icon: Icons.warning_amber_rounded,
          accentColor: Colors.orange,
        ),
        _buildInfoTile(
          title: "প্রতিরোধ (Prevention)",
          content: data['prevention']!,
          icon: Icons.shield_outlined,
          accentColor: Colors.blue,
        ),
        _buildInfoTile(
          title: "প্রাথমিক চিকিৎসা (Treatment)",
          content: data['treatment']!,
          icon: Icons.medical_services_outlined,
          accentColor: Colors.green,
        ),
      ],
    );
  }

  // --- Helper: Single Info Tile ---
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
                  height: 1.6, // Better readability for Bangla
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper: Action Button ---
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
    // 1. Remove numbers and spaces (e.g., "3 pcrcocci" -> "pcrcocci")
    String clean = label.replaceAll(RegExp(r'[0-9]'), '').trim().toLowerCase();

    // 2. Map your specific labels to the database keys
    if (clean.contains('cocci')) {
      return 'cocci'; // Covers "cocci" and "pcrcocci"
    }
    if (clean.contains('ncd')) return 'ncd'; // Covers "ncd" and "pcrncd"
    if (clean.contains('salmo')) {
      return 'salmo'; // Covers "salmo" and "pcrsalmo"
    }
    if (clean.contains('healthy')) {
      return 'healthy'; // Covers "healthy" and "pcrhealthy"
    }

    return clean;
  }

  // --- LOGIC: Format Label for Header ---
  String formatLabel(String label) {
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
        return clean.isNotEmpty
            ? '${clean[0].toUpperCase()}${clean.substring(1)}'
            : clean;
    }
  }
}
