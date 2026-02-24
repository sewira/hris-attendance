import 'package:flutter/material.dart';
import 'package:hr_attendance/config/theme/app_color.dart';

class CustomDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final List<double>? columnWidths;
  final bool showSearch;
  final double? height;

  const CustomDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.columnWidths,
    this.showSearch = true,
    this.height,
  });

  List<DataColumn> _styledColumns() {
    return columns.asMap().entries.map((entry) {
      final index = entry.key;
      final col = entry.value;

      return DataColumn(
        label: SizedBox(
          width: columnWidths != null && index < columnWidths!.length
              ? columnWidths![index]
              : null,
          child: Container(
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
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              color: Colors.white,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: Column(
                        children: [
                          DataTable(
                            columnSpacing: 24,
                            headingRowColor: MaterialStateProperty.all(
                              AppColor.primary,
                            ),
                            columns: _styledColumns(),
                            rows: const [],
                          ),

                          SizedBox(
                            height: constraints.maxHeight - 56,
                            child: SingleChildScrollView(
                              child: DataTable(
                                columnSpacing: 24,
                                headingRowHeight: 0,
                                dataRowMinHeight: 56,
                                dataRowMaxHeight: double.infinity,
                                dataRowColor: MaterialStateProperty.all(
                                  AppColor.netral1,
                                ),
                                columns: _styledColumns(),
                                rows: rows,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
