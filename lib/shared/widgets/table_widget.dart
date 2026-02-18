import 'package:flutter/material.dart';
import 'package:hr_attendance/config/theme/app_color.dart';

class CustomDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final bool showSearch;

  const CustomDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.showSearch = true,
  });

  List<DataColumn> _styledColumns() {
    return columns.map((col) {
      return DataColumn(
        label: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: DefaultTextStyle(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            child: col.label,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showSearch) ...[
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 160,
              height: 38,
              child: TextField(
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColor.netral2,
                ),
                decoration: InputDecoration(
                  hintText: "Search...",
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: const Icon(Icons.search, size: 18),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        /// TABLE
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              color: Colors.white,
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 24,
                      headingRowColor:
                          MaterialStateProperty.all(AppColor.primary),
                      dataRowColor:
                          MaterialStateProperty.all(AppColor.netral1),
                      columns: _styledColumns(),
                      rows: rows,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
