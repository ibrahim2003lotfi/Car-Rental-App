import 'package:flutter/material.dart';
import 'package:cars/auth/auth_sevice.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final user = authService.value.currentUser;
  String carName = '';
  String brand = '';
  String? selectedYear;
  String fuelType = 'Gasoline';
  String transmission = 'Automatic';
  String price = '';
  String description = '';
  String location = '';
  double engineSize = 1.6;
  String mileage = '';

  
  final fuelTypes = ['Gasoline', 'Diesel', 'Hybrid', 'Electric'];
  final transmissionTypes = ['Automatic', 'Manual'];
  final years = List.generate(126, (index) => (2025 - index).toString());

  @override
  Widget build(BuildContext context) {
    final firstName = user?.displayName?.split(' ').first ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              
              _buildHeader(context, firstName),

              
              _buildViewAllCard(),

              
              _buildNewPostSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String firstName) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF111111), Color(0xFF333333)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$firstName's Posts",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Text(
            "Create and manage your car listings",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildViewAllCard() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/posts'),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: const Row(
            children: [
              Icon(Icons.list_alt, color: Colors.blue, size: 30),
              SizedBox(width: 15),
              Text(
                "View all your posts",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewPostSection() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add New Post",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          
          _buildInputField(
            "Car Name",
            "e.g. Corolla, Civic",
            (value) => carName = value,
          ),
          _buildInputField(
            "Brand",
            "e.g. Toyota, Honda",
            (value) => brand = value,
          ),

          _buildDropdown("Year", selectedYear, years, (value) {
            setState(() => selectedYear = value);
          }),

          _buildDropdown("Fuel Type", fuelType, fuelTypes, (value) {
            setState(() => fuelType = value!);
          }),

          _buildDropdown("Transmission", transmission, transmissionTypes, (
            value,
          ) {
            setState(() => transmission = value!);
          }),

          _buildSlider("Engine Size", engineSize, (value) {
            setState(() => engineSize = value);
          }),

          _buildInputField(
            "Mileage (km)",
            "e.g. 50000",
            (value) => mileage = value,
            keyboardType: TextInputType.number,
          ),
          _buildInputField(
            "Price per week (\$)",
            "e.g. 150",
            (value) => price = value,
            keyboardType: TextInputType.number,
          ),
          _buildInputField(
            "Location",
            "Where is the car located?",
            (value) => location = value,
          ),
          _buildInputField(
            "Description",
            "Tell us about the car...",
            (value) => description = value,
            maxLines: 3,
          ),

          
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Post Car",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    Function(String) onChanged, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[700])),
        const SizedBox(height: 5),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: (value) => onChanged(value),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[700])),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildSlider(String label, double value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ${value.toStringAsFixed(1)}L",
          style: TextStyle(color: Colors.grey[700]),
        ),
        Slider(
          value: value,
          min: 0.8,
          max: 6.0,
          divisions: 52,
          label: value.toStringAsFixed(1),
          onChanged: (newValue) {
            setState(() => onChanged(newValue));
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  void _submitForm() {
    
    if (carName.isEmpty || brand.isEmpty || selectedYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill required fields')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post created successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    
    setState(() {
      carName = '';
      brand = '';
      selectedYear = null;
      fuelType = 'Gasoline';
      transmission = 'Automatic';
      engineSize = 1.6;
      mileage = '';
      price = '';
      location = '';
      description = '';
    });
  }
}
