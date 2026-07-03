import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({Key? key}) : super(key: key);

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  
  String _selectedCategory = 'Cloud';
  DateTime _selectedDate = DateTime.now();
  File? _receiptImage;
  
  final List<String> _categories = [
    'Cloud',
    'Food',
    'Travel',
    'Subscriptions',
    'Rent',
    'General'
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (image != null) {
        setState(() {
          _receiptImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _submitData() {
    if (!_formKey.currentState!.validate()) return;

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    Provider.of<ExpenseProvider>(context, listen: false).addExpense(
      title: enteredTitle,
      amount: enteredAmount,
      category: _selectedCategory,
      date: _selectedDate,
      description: _descController.text,
      receiptPath: _receiptImage?.path,
    );

    // Show confirmation Toast/SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Expense added successfully!'),
        backgroundColor: AppTheme.incomeColor,
      ),
    );

    // Reset fields
    _titleController.clear();
    _amountController.clear();
    _descController.clear();
    setState(() {
      _receiptImage = null;
      _selectedDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TRACK EXPENSE',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Transaction Title',
                  prefixIcon: Icon(Icons.title, color: AppTheme.textSecondary),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),

              // Amount Field
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Amount (\$)',
                  prefixIcon: Icon(Icons.attach_money, color: AppTheme.textSecondary),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter an amount';
                  if (double.tryParse(v) == null) return 'Please enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_outlined, color: AppTheme.textSecondary),
                ),
                dropdownColor: AppTheme.cardBg,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Date Picker Button
              InkWell(
                onTap: _presentDatePicker,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: AppTheme.textSecondary),
                      const SizedBox(width: 16),
                      Text(
                        'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16),
                      ),
                      const Spacer(),
                      const Text('Choose', style: TextStyle(color: AppTheme.accentLight, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description Form Field
              TextFormField(
                controller: _descController,
                maxLines: 2,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Optional Description',
                  prefixIcon: Icon(Icons.description_outlined, color: AppTheme.textSecondary),
                ),
              ),
              const SizedBox(height: 20),

              // Receipt Image Picker UI
              InkWell(
                onTap: _pickImage,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.05), style: BorderStyle.values[1]), // Dashed effect simulator
                  ),
                  child: _receiptImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.camera_alt_outlined, color: AppTheme.textSecondary, size: 40),
                            SizedBox(height: 8),
                            Text('Attach Receipt Image', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(_receiptImage!, fit: BoxFit.cover),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: CircleAvatar(
                                  backgroundColor: Colors.black54,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.white, size: 18),
                                    onPressed: () {
                                      setState(() {
                                        _receiptImage = null;
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: AppTheme.accentGradient,
                ),
                child: ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text('Add Expense Entry'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
