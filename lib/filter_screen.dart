import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String _selectedSort = r'$-$$ Price Lower to Higher';
  int? _selectedRating;
  double _minPrice = 90;
  double _maxPrice = 350;
  final Set<String> _selectedFacilities = <String>{};

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ),
                const Text(
                  'Filter',
                  style: TextStyle(
                    color: Color(0xFF1A75FF),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedSort = r'$-$$ Price Lower to Higher';
                      _selectedRating = null;
                      _minPrice = 90;
                      _maxPrice = 350;
                    });
                  },
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedSort,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                          value: r'$-$$ Price Lower to Higher',
                          child: Text(r'$-$$ Price Lower to Higher'),
                        ),
                        DropdownMenuItem(
                          value: r'$$-$$$ Price Higher to Lower',
                          child: Text(r'$$-$$$ Price Higher to Lower'),
                        ),
                        DropdownMenuItem(
                          value: 'Rating: High to Low',
                          child: Text('Rating: High to Low'),
                        ),
                        DropdownMenuItem(
                          value: 'Rating: Low to High',
                          child: Text('Rating: Low to High'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedSort = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Ratings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      final rating = index + 1;
                      final isSelected = _selectedRating == rating;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedRating = isSelected ? null : rating;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF1A75FF)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: isSelected ? 0 : 1,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$rating',
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.amber,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Price Ranges',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
                    min: 0,
                    max: 500,
                    divisions: 50,
                    activeColor: const Color(0xFF1A75FF),
                    inactiveColor: Colors.grey[300]!,
                    onChanged: (values) {
                      setState(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                    },
                  ),
                  Center(
                    child: Text(
                      '\$${_minPrice.toInt()}-\$${_maxPrice.toInt()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A75FF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Facilities',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildFacilityChip('Wi‑Fi'),
                      _buildFacilityChip('Pool'),
                      _buildFacilityChip('Gym'),
                      _buildFacilityChip('Spa'),
                      _buildFacilityChip('Restaurant'),
                      _buildFacilityChip('Parking'),
                      _buildFacilityChip('Bar'),
                      _buildFacilityChip('Pool bar'),
                      _buildFacilityChip('Beachfront'),
                      _buildFacilityChip('Kids club'),
                      _buildFacilityChip('Live music'),
                      _buildFacilityChip('Cinema room'),
                      _buildFacilityChip('Water park'),
                      _buildFacilityChip('Casino'),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A75FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Filters applied'),
                    ),
                  );
                },
                child: const Text(
                  'APPLY',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityChip(String label) {
    final bool isSelected = _selectedFacilities.contains(label);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedFacilities.remove(label);
          } else {
            _selectedFacilities.add(label);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A75FF) : Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF1A75FF) : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              ),
            if (isSelected) const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

