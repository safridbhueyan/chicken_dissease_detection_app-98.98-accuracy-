// --- Disease Information Data (Refined, Precise & Bilingual) ---
final Map<String, Map<String, String>> diseaseInfo = {
  'cocci': {
    'name': 'রক্ত আমাশয় (Coccidiosis)',
    'name_en': 'Coccidiosis',
    'symptoms':
        '• মলের সাথে তাজা রক্ত বা কফি রঙের পায়খানা\n• পালক উস্কোখুস্কো ও শরীর দুর্বল\n• মুরগি দলবেঁধে ঝিমায়',
    'symptoms_en':
        '• Fresh blood or coffee-colored droppings\n• Ruffled feathers and physical weakness\n• Chickens huddling together',
    'prevention': '• লিটার সম্পূর্ণ শুকনো রাখা\n• খামারের আর্দ্রতা কমানো',
    'prevention_en': '• Keep litter completely dry\n• Reduce farm humidity',
    'treatment':
        '• চিকিৎসকের পরামর্শে টল্ট্রাজুরিল বা এমপ্রোলিয়াম ব্যবহার করুন।',
    'treatment_en': '• Use Toltrazuril or Amprolium as advised by a vet.',
  },
  'ncd': {
    'name': 'রানীক্ষেত (Newcastle Disease)',
    'name_en': 'Newcastle Disease (NCD)',
    'symptoms':
        '• চুনের মতো বা সবুজাভ পাতলা পায়খানা\n• ঘাড় বাঁকা হয়ে যাওয়া\n• হাঁ করে শ্বাস নেওয়া',
    'symptoms_en':
        '• Whitish or greenish watery diarrhea\n• Twisted neck or tremors\n• Gasping for air',
    'prevention': '• সঠিক বয়সে বিসিআরডিভি (BCRDV) ও আরডিভি (RDV) টিকা প্রদান।',
    'prevention_en': '• Timely BCRDV and RDV vaccinations.',
    'treatment':
        '• ভাইরাসের সরাসরি চিকিৎসা নেই; সেকেন্ডারি ইনফেকশন রোধে এন্টিবায়োটিক দিন।',
    'treatment_en':
        '• No viral treatment; use antibiotics for secondary infections.',
  },
  'salmo': {
    'name': 'সালমোনেলা (Salmonella)',
    'name_en': 'Salmonella',
    'symptoms':
        '• সাদা রঙের আঠালো বা চুনা পায়খানা\n• পায়খানার রাস্তা মলে বন্ধ হয়ে যাওয়া\n• জয়েন্ট ফুলে যাওয়া',
    'symptoms_en':
        '• White sticky or chalky droppings\n• Vent pasting\n• Swollen joints',
    'prevention':
        '• সুস্থ প্যারেন্টস স্টক থেকে বাচ্চা সংগ্রহ ও বিশুদ্ধ পানি নিশ্চিত করা।',
    'prevention_en':
        '• Source chicks from healthy stock and ensure pure water.',
    'treatment':
        '• চিকিৎসকের পরামর্শে এনরোফ্লক্সাসিন বা এমোক্সিসিলিন ব্যবহার করুন।',
    'treatment_en': '• Use Enrofloxacin or Amoxicillin as per vet advice.',
  },
  'crd': {
    'name': 'সিআরডি (Chronic Respiratory Disease)',
    'name_en': 'CRD',
    'symptoms':
        '• নাক দিয়ে পানি পড়া ও হাঁচি\n• রাতে ঘর শান্ত হলে ঘড়ঘড় শব্দ শোনা যাওয়া\n• চোখ ফুলে যাওয়া',
    'symptoms_en':
        '• Nasal discharge and sneezing\n• Rales or rattling sound at night\n• Swollen eyes',
    'prevention':
        '• ঘরে এমোনিয়া গ্যাস জমতে না দেওয়া\n• পর্যাপ্ত বাতাস চলাচলের ব্যবস্থা রাখা।',
    'prevention_en':
        '• Prevent ammonia gas buildup\n• Ensure proper ventilation.',
    'treatment':
        '• টাইলোসিন বা টিয়ামুলিন জাতীয় ওষুধ চিকিৎসকের পরামর্শে ব্যবহার করুন।',
    'treatment_en': '• Use Tylosin or Tiamulin as per veterinarian advice.',
  },
  'fowlpox': {
    'name': 'বসন্ত (Fowl Pox)',
    'name_en': 'Fowl Pox',
    'symptoms':
        '• পালকহীন চামড়া, ঝুঁটি বা কানের লতিতে গুটি ওঠা\n• চোখের পাতা ফুলে যাওয়া\n• খাওয়ার রুচি কমে যাওয়া',
    'symptoms_en':
        '• Scabby lesions on comb, wattles, and skin\n• Swollen eyelids\n• Loss of appetite',
    'prevention': '• মশা নিয়ন্ত্রণ করা এবং পক্স ভ্যাকসিন প্রদান করা।',
    'prevention_en': '• Control mosquitoes and provide Pox vaccine.',
    'treatment':
        '• গুটিগুলোতে পটাশ বা আয়োডিন মিশ্রণ লাগানো যেতে পারে। পুষ্টিকর খাবার দিন।',
    'treatment_en':
        '• Apply iodine on lesions; provide nutritious feed and supportive care.',
  },
  'bumblefoot': {
    'name': 'বাম্বলফুট (Bumblefoot)',
    'name_en': 'Bumblefoot',
    'symptoms':
        '• পায়ের তলায় কালো ক্ষত বা ফোড়া\n• পা ফুলে যাওয়া ও মুরগির খোঁড়ানো\n• মুরগি হাঁটতে কষ্ট পাওয়া',
    'symptoms_en':
        '• Black scab or abscess on the footpad\n• Swollen feet and limping\n• Difficulty in walking',
    'prevention':
        '• মেঝেতে ধারালো কিছু রাখা যাবে না\n• লিটার পরিষ্কার ও নরম রাখা।',
    'prevention_en':
        '• Remove sharp objects from the floor\n• Keep litter clean and soft.',
    'treatment':
        '• ক্ষত পরিষ্কার করে সার্জারি বা এন্টিসেপটিক ব্যবহার প্রয়োজন হতে পারে।',
    'treatment_en':
        '• May require wound cleaning, antiseptic, or minor surgery by a vet.',
  },
  'coryza': {
    'name': 'কোরাইজা (Infectious Coryza)',
    'name_en': 'Infectious Coryza',
    'symptoms':
        '• মুখ ও চোখ মারাত্মকভাবে ফুলে যাওয়া\n• নাক দিয়ে দুর্গন্ধযুক্ত সর্দি বের হওয়া\n• চোখ বন্ধ হয়ে যাওয়া',
    'symptoms_en':
        '• Severe facial swelling and edema\n• Foul-smelling nasal discharge\n• Eyes may be swollen shut',
    'prevention': '• আক্রান্ত মুরগি দ্রুত সরানো ও বায়োসিকিউরিটি মেনে চলা।',
    'prevention_en':
        '• Immediate isolation of sick birds and strict biosecurity.',
    'treatment': '• এরিথ্রোমাইসিন বা সালফোনামাইড জাতীয় ওষুধ ব্যবহার করা হয়।',
    'treatment_en':
        '• Erythromycin or Sulfonamides are typically used under vet guidance.',
  },
  'healthy': {
    'name': 'সুস্থ মুরগি (Healthy)',
    'name_en': 'Healthy Chicken',
    'symptoms': '• চোখ উজ্জ্বল ও চনমনে ভাব\n• স্বাভাবিক খাবার ও পানি গ্রহণ।',
    'symptoms_en':
        '• Bright eyes and active behavior\n• Normal feed and water consumption.',
    'prevention': '• নিয়মিত সুষম খাবার ও সঠিক সময়ে সব টিকা প্রদান।',
    'prevention_en': '• Provide balanced feed and complete all vaccinations.',
    'treatment': '• চিকিৎসার প্রয়োজন নেই, নিয়মিত যত্ন নিন।',
    'treatment_en': '• No treatment required; maintain regular care.',
  },
  'others': {
    'name': 'সঠিক ছবি নয় (Invalid Image)',
    'name_en': 'Invalid Image',
    'symptoms': 'আপলোড করা ছবিটি মুরগির মলের ছবি নয়।',
    'symptoms_en': 'The uploaded image is not recognized as chicken droppings.',
    'prevention': 'দয়া করে পরিষ্কার আলোতে সঠিক ছবি তুলুন।',
    'prevention_en': 'Please take a clear photo in adequate lighting.',
    'treatment': 'শুধুমাত্র মুরগির মল স্ক্যান করুন।',
    'treatment_en': 'Only scan chicken droppings.',
  },
};
