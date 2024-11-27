import 'package:asgard_rohit/model/map_marker.dart';
import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  final List<MarkerType> initialFilter;
  const FilterWidget({super.key, required this.initialFilter});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  final filters = [MarkerType.restaurant, MarkerType.cycle, MarkerType.shopping];
  List<MarkerType> selectedFilter = [];

  @override
  void initState() {
    selectedFilter = List.from(widget.initialFilter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(8),
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...filters.map((filter) {
              return CheckboxMenuButton(
                  value: selectedFilter.contains(filter),
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        selectedFilter.add(filter);
                      } else {
                        selectedFilter.remove(filter);
                      }
                    });
                  },
                  child: Text(filter.name));
            }),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, selectedFilter);
                  },
                  child: const Text('Apply')),
            )
          ],
        ),
      ),
    );
  }
}
