import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/magic_bag_model.dart';

class CreateMagicBagScreen extends StatefulWidget {
  const CreateMagicBagScreen({super.key});

  @override
  State<CreateMagicBagScreen> createState() => _CreateMagicBagScreenState();
}

class _CreateMagicBagScreenState extends State<CreateMagicBagScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _discountedPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  
  FoodCategory _selectedCategory = FoodCategory.other;
  DateTime _pickupStartTime = DateTime.now().add(const Duration(hours: 2));
  DateTime _pickupEndTime = DateTime.now().add(const Duration(hours: 4));
  List<String> _foodItems = [];
  List<String> _allergens = [];
  bool _isLoading = false;

  final List<String> _categoryOptions = [
    'Bakery',
    'Restaurant',
    'Cafe',
    'Grocery',
    'Convenience',
    'Other',
  ];

  final List<String> _allergenOptions = [
    'Gluten',
    'Dairy',
    'Nuts',
    'Eggs',
    'Soy',
    'Fish',
    'Shellfish',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _originalPriceController.dispose();
    _discountedPriceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _createMagicBag() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Implement actual Magic Bag creation
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Magic Bag created successfully!'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _addFoodItem() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Food Item'),
        content: TextField(
          decoration: const InputDecoration(
            labelText: 'Food Item',
            hintText: 'e.g., Croissants, Bread, etc.',
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _foodItems.add(value);
              });
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final textField = context.findRenderObject() as RenderBox;
              // This is a simplified approach - in real app, you'd get the text field value properly
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Magic Bag'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Magic Bag Title',
                  hintText: 'e.g., Surprise Pastry Bag',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe what customers can expect...',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<FoodCategory>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
                items: FoodCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Prices
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _originalPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Original Price (\$)',
                        prefixText: '\$',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid price';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _discountedPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Discounted Price (\$)',
                        prefixText: '\$',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid price';
                        }
                        final original = double.tryParse(_originalPriceController.text);
                        final discounted = double.tryParse(value);
                        if (original != null && discounted != null && discounted >= original) {
                          return 'Must be less than original';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Quantity
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity Available',
                  hintText: 'Number of Magic Bags',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Food Items
              Text(
                'Food Items',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              if (_foodItems.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _foodItems.map((item) {
                    return Chip(
                      label: Text(item),
                      onDeleted: () {
                        setState(() {
                          _foodItems.remove(item);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
              ],
              ElevatedButton.icon(
                onPressed: _addFoodItem,
                icon: const Icon(Icons.add),
                label: const Text('Add Food Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  foregroundColor: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 24),

              // Pickup Time
              Text(
                'Pickup Time',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Start Time'),
                      subtitle: Text(
                        '${_pickupStartTime.hour.toString().padLeft(2, '0')}:${_pickupStartTime.minute.toString().padLeft(2, '0')}',
                      ),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_pickupStartTime),
                        );
                        if (time != null) {
                          setState(() {
                            _pickupStartTime = DateTime(
                              _pickupStartTime.year,
                              _pickupStartTime.month,
                              _pickupStartTime.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('End Time'),
                      subtitle: Text(
                        '${_pickupEndTime.hour.toString().padLeft(2, '0')}:${_pickupEndTime.minute.toString().padLeft(2, '0')}',
                      ),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_pickupEndTime),
                        );
                        if (time != null) {
                          setState(() {
                            _pickupEndTime = DateTime(
                              _pickupEndTime.year,
                              _pickupEndTime.month,
                              _pickupEndTime.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Allergens
              Text(
                'Allergens (Optional)',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _allergenOptions.map((allergen) {
                  final isSelected = _allergens.contains(allergen);
                  return FilterChip(
                    label: Text(allergen),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _allergens.add(allergen);
                        } else {
                          _allergens.remove(allergen);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Create Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createMagicBag,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Create Magic Bag',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 