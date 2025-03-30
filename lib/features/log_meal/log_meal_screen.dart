import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Add this import
// TODO: Import necessary packages (e.g., image_picker, dio)

class LogMealScreen extends ConsumerStatefulWidget {
  const LogMealScreen({super.key});

  @override
  ConsumerState<LogMealScreen> createState() => _LogMealScreenState();
}

class _LogMealScreenState extends ConsumerState<LogMealScreen> {
  // State variables for photo, AI result, manual entry, meal type etc.
  // e.g., File? _selectedImage;
  // String? _aiResult;
  // bool _isManualEntryVisible = false;
  // MealType _selectedMealType = MealType.breakfast; // Enum MealType { breakfast, lunch, dinner, snack }

  // TODO: Implement methods for:
  // - Picking image (camera/gallery)
  // - Calling AI service (placeholder for now)
  // - Handling manual search/add
  // - Saving the meal

  @override
  Widget build(BuildContext context) {
    // TODO: Get theme colors
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    // Assuming light green is primary or secondary container color? Let's use primaryContainer for now.
    final Color headerColor = colorScheme.primaryContainer.withOpacity(0.3); // Light green header
    final Color primaryButtonColor = colorScheme.primary; // Green buttons

    return Scaffold(
      appBar: AppBar(
        backgroundColor: headerColor,
        title: const Text('Log a Meal'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Use go_router to pop
            if (context.canPop()) {
               context.pop();
            }
          },
        ),
        elevation: 0, // Keep it clean
      ),
      body: SingleChildScrollView( // To handle overflow on smaller screens
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Photo Scan Section ---
            _buildPhotoScanSection(primaryButtonColor),
            const SizedBox(height: 24),

            // --- Manual Entry Section ---
            _buildManualEntrySection(primaryButtonColor),
            const SizedBox(height: 24),

            // --- Meal Type Selector ---
            _buildMealTypeSelector(),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryButtonColor,
            foregroundColor: colorScheme.onPrimary,
            minimumSize: const Size(double.infinity, 50), // Full width, standard height
          ),
          // TODO: Disable button based on state (e.g., if no meal is added)
          onPressed: () {
            // TODO: Implement save logic
            print('Save Meal Pressed!');
            // Navigate back to dashboard using go_router
            if (context.canPop()) {
               context.pop(); 
            }
          },
          child: const Text('Save Meal'),
        ),
      ),
    );
  }

  // Helper method for Photo Scan UI
  Widget _buildPhotoScanSection(Color buttonColor) {
    // TODO: Add logic to display image, AI results, confirm/edit buttons based on state (_selectedImage, _aiResult)
    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.camera_alt),
          label: const Text('Take a Photo'),
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {
            // TODO: Implement take photo logic using image_picker
            print('Take Photo Pressed');
          },
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          icon: const Icon(Icons.photo_library),
          label: const Text('Or upload from gallery'),
          onPressed: () {
            // TODO: Implement upload from gallery logic using image_picker
            print('Upload from Gallery Pressed');
          },
        ),
        // TODO: Add conditional UI for image display, AI result, confirm/edit buttons
        // if (_selectedImage != null) ...[
        //   // Image display
        //   // AI result text
        //   // Loading indicator
        //   // Confirm/Edit buttons
        // ]
        // TODO: Add AI failure message conditionally
      ],
    );
  }

  // Helper method for Manual Entry UI
  Widget _buildManualEntrySection(Color buttonColor) {
     // TODO: Add state (_isManualEntryVisible) and toggle logic
    return Column(
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.edit),
          label: const Text('Enter Manually'),
          style: OutlinedButton.styleFrom(
             minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {
            // TODO: Toggle visibility of search bar etc.
             setState(() {
               // _isManualEntryVisible = !_isManualEntryVisible;
               print('Toggle Manual Entry'); // Placeholder
             });
          },
        ),
        // TODO: Add conditional UI based on _isManualEntryVisible
        // if (_isManualEntryVisible) ...[
        //    const SizedBox(height: 16),
        //    // Search bar (TextField with autocomplete)
        //    // Selected food display + quantity selector + Add button
        // ]
      ],
    );
  }

   // Helper method for Meal Type Selector
  Widget _buildMealTypeSelector() {
    // TODO: Implement using DropdownButton or ToggleButtons based on design preference
    // Example using ToggleButtons:
    // return ToggleButtons(
    //   children: <Widget>[Text('Breakfast'), Text('Lunch'), Text('Dinner'), Text('Snack')],
    //   onPressed: (int index) { setState(() { _selectedMealType = MealType.values[index]; }); },
    //   isSelected: MealType.values.map((type) => type == _selectedMealType).toList(),
    // );
    return Text('Meal Type Selector Placeholder'); // Placeholder
  }


}

// Placeholder for meal type enum
// enum MealType { breakfast, lunch, dinner, snack }

// TODO: Create models for AI result and FoodItem if needed
