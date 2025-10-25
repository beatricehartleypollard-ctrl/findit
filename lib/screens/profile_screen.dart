import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  final AppState appState;
  const ProfileScreen({super.key, required this.appState});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  String _selectedDiet = 'None';
  final Map<String, bool> _selected = {};

  final Map<String, List<String>> _categories = {
    'Fruits': [
      'Apple', 'Banana', 'Kiwi', 'Mango', 'Strawberry', 'Peach', 'Pear',
      'Pineapple', 'Melon', 'Cherry', 'Grapes', 'Apricot', 'Plum',
      'Lemon', 'Orange', 'Lime', 'Avocado', 'Pomegranate', 'Papaya',
      'Coconut', 'Date', 'Fig', 'Guava', 'Lychee', 'Raspberry', 'Blackberry'
    ],
    'Vegetables': [
      'Tomato', 'Celery', 'Onion', 'Garlic', 'Carrot', 'Cucumber',
      'Spinach', 'Broccoli', 'Cauliflower', 'Cabbage', 'Zucchini',
      'Pumpkin', 'Sweet Potato', 'Potato', 'Lettuce', 'Mushroom',
      'Eggplant', 'Beetroot', 'Corn', 'Peas', 'Capsicum', 'Leek', 'Radish'
    ],
    'Nuts & Seeds': [
      'Peanut', 'Almond', 'Cashew', 'Walnut', 'Hazelnut', 'Pistachio',
      'Brazil Nut', 'Pine Nut', 'Macadamia', 'Sesame', 'Sunflower Seed',
      'Pumpkin Seed', 'Chia', 'Flaxseed'
    ],
    'Dairy': [
      'Milk', 'Cheese', 'Yogurt', 'Butter', 'Cream', 'Whey', 'Casein',
      'Lactose', 'Goat Milk', 'Sheep Milk'
    ],
    'Seafood': [
      'Fish', 'Shrimp', 'Crab', 'Lobster', 'Oyster', 'Mussel', 'Squid',
      'Octopus', 'Salmon', 'Tuna', 'Anchovy', 'Cod', 'Sardine', 'Snapper',
      'Trout', 'Haddock', 'Scallop', 'Prawn', 'Clam'
    ],
    'Grains & Gluten': [
      'Wheat', 'Barley', 'Oats', 'Rye', 'Corn', 'Spelt', 'Kamut',
      'Durum', 'Semolina', 'Malt', 'Triticale', 'Buckwheat',
      'Millet', 'Rice', 'Sorghum'
    ],
    'Legumes': [
      'Soy', 'Lentil', 'Chickpea', 'Black Bean', 'Kidney Bean',
      'Navy Bean', 'Broad Bean', 'Lupin', 'Mung Bean', 'Pea Protein'
    ],
    'Additives': [
      'Sulfites', 'Aspartame', 'MSG', 'BHA', 'BHT', 'Tartrazine',
      'Carmine', 'Nitrates', 'Benzoate', 'Sodium Nitrite',
      'Propionate', 'Potassium Sorbate', 'Citric Acid',
      'Guar Gum', 'Xanthan Gum'
    ],
    'Spices & Herbs': [
      'Cinnamon', 'Clove', 'Nutmeg', 'Ginger', 'Turmeric', 'Pepper',
      'Coriander', 'Cumin', 'Mustard', 'Paprika', 'Chili', 'Basil',
      'Oregano', 'Rosemary', 'Thyme', 'Sage', 'Parsley', 'Mint'
    ],
    'Animal Products': [
      'Beef', 'Pork', 'Chicken', 'Lamb', 'Egg', 'Gelatin', 'Honey',
      'Duck', 'Turkey'
    ]
  };

  final List<String> _diets = [
    'None',
    'Vegetarian',
    'Vegan',
    'Pescatarian',
    'Gluten-Free',
    'Keto',
    'Paleo',
    'Low-Carb',
    'Dairy-Free'
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _nameCtrl.text = prefs.getString('user_name') ?? '';
    _selectedDiet = prefs.getString('user_diet') ?? 'None';
    final saved = prefs.getStringList('user_allergens') ?? [];
    setState(() {
      for (var cat in _categories.values) {
        for (var item in cat) {
          _selected[item] = saved.contains(item);
        }
      }
    });
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameCtrl.text);
    await prefs.setString('user_diet', _selectedDiet);
    final selectedAllergens =
        _selected.entries.where((e) => e.value).map((e) => e.key).toList();
    await prefs.setStringList('user_allergens', selectedAllergens);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );
    }
  }

  // ✅ Helper to toggle all items in a category
  void _toggleCategory(String category, bool selectAll) {
    setState(() {
      for (var item in _categories[category]!) {
        _selected[item] = selectAll;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.appState;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9fc7aa),
        title: Text(app.t('profile')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              labelText: app.t('your_name'),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),

          Text('Diet Preference',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedDiet,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: true,
              fillColor: const Color(0xFFF6F8F6),
            ),
            items: _diets
                .map((diet) => DropdownMenuItem(
                      value: diet,
                      child: Text(diet),
                    ))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedDiet = val);
            },
          ),

          const SizedBox(height: 20),
          Text(app.t('select_allergens'),
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),

          ..._categories.entries.map((cat) {
            bool allSelected = cat.value.every((item) => _selected[item] ?? false);
            bool noneSelected = cat.value.every((item) => !(_selected[item] ?? false));

            return ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(cat.key,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => _toggleCategory(cat.key, true),
                        child: const Text('Select All'),
                      ),
                      TextButton(
                        onPressed: () => _toggleCategory(cat.key, false),
                        child: const Text('Deselect All'),
                      ),
                    ],
                  )
                ],
              ),
              children: cat.value.map((item) {
                return CheckboxListTile(
                  title: Text(item),
                  value: _selected[item] ?? false,
                  onChanged: (v) => setState(() => _selected[item] = v ?? false),
                );
              }).toList(),
            );
          }),

          const SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9fc7aa),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: _saveProfile,
            child: Text(app.t('save')),
          ),
        ],
      ),
    );
  }
}
