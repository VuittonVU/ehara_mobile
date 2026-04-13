import 'package:flutter/material.dart';

class PembayaranSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;

  const PembayaranSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFBDBDBD),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(
                  Icons.search,
                  color: Color(0xFF666666),
                  size: 21,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF333333),
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Pencarian...',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9C9C9C),
                      ),
                    ).removeBorder,
                  ),
                ),
                const SizedBox(width: 6),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onFilterTap,
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(
              Icons.filter_alt_outlined,
              size: 32,
              color: Color(0xFF5A5A5A),
            ),
          ),
        ),
      ],
    );
  }
}

extension on InputDecoration {
  InputDecoration get removeBorder {
    return copyWith(
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      contentPadding: EdgeInsets.zero,
    );
  }
}