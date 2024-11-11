import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchPg extends StatefulWidget {
  const SearchPg({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchPgState createState() => _SearchPgState();
}

class _SearchPgState extends State<SearchPg> {
  bool _isFiltering = false;
  bool isSearchEmpty = true;
  String searchText = "";
  bool isTypeChecked = false;
  bool isTypeIconChecked = false;
  bool isTasksChecked = false;
  bool isMeetingChecked = false;
  bool isJournalChecked = false;
  bool isPlanChecked = false;
  bool isDateChecked = false;

  DateTime? fromDate;
  DateTime? toDate;

  final TextEditingController _searchController = TextEditingController();

  void resetFilter() {
    setState(() {
      isSearchEmpty = true;
      searchText = "";
      isTypeChecked = false;
      isTasksChecked = false;
      isMeetingChecked = false;
      isJournalChecked = false;
      isPlanChecked = false;
      isDateChecked = false;
      fromDate = null;
      toDate = null;
      _searchController.clear();
    });
  }

  void _showCustomDatePicker(BuildContext context, bool isFromDate) {
    DateTime selectedDate =
        isFromDate ? (fromDate ?? DateTime.now()) : (toDate ?? DateTime.now());
    int selectedHour = selectedDate.hour;
    int selectedMinute = selectedDate.minute;
    DateTime minDate = DateTime(DateTime.now().year, 1, 1);

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Colors.white,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    if (isFromDate) {
                      fromDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedHour,
                        selectedMinute,
                      );
                    } else {
                      toDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedHour,
                        selectedMinute,
                      );
                    }
                  });
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check),
              ),
            ),
            SizedBox(
              height: 150,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CupertinoPicker(
                      backgroundColor: Colors.white,
                      scrollController: FixedExtentScrollController(
                        initialItem: selectedDate.difference(minDate).inDays,
                      ),
                      itemExtent: 30,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedDate = DateTime(DateTime.now().year)
                              .add(Duration(days: index));
                        });
                      },
                      children: List<Widget>.generate(
                        365,
                        (int index) {
                          DateTime dateToShow = DateTime(DateTime.now().year)
                              .add(Duration(days: index));
                          return Center(
                            child: Text(_getDateLabel(dateToShow)),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                          initialItem: selectedHour),
                      itemExtent: 30,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          selectedHour = value;
                        });
                      },
                      children: List<Widget>.generate(24, (int index) {
                        return Center(
                          child: Text(index.toString().padLeft(2, '0')),
                        );
                      }),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                          initialItem: selectedMinute),
                      itemExtent: 30,
                      onSelectedItemChanged: (value) {
                        setState(() {
                          selectedMinute = value;
                        });
                      },
                      children: List<Widget>.generate(60, (int index) {
                        return Center(
                          child: Text(index.toString().padLeft(2, '0')),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Search',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF2a65d2),
        leading: IconButton(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 35,
          ),
          onPressed: () {
            // Handle back button press
          },
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() {
              _isFiltering = !_isFiltering;
            }),
            padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 0),
            icon: const Icon(
              Icons.filter_alt_outlined,
              color: Colors.white,
              size: 33,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search...',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchText = value;
                                isSearchEmpty = value.isEmpty;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                    width: 8), // White space between TextField and close icon
                Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFaaaaaa),
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    onPressed: resetFilter,
                  ),
                ),
              ],
            ),
          ),
          if (_isFiltering)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: const Color(0xFFedecf2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[600] ?? Colors.grey)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCheckboxTile("Type", Icons.label, isTypeChecked,
                        (value) {
                      setState(() {
                        isTypeChecked = value!;
                      });
                    }),
                    _divd(),
                    _buildCheckboxTile(
                        "Tasks",
                        Icons.assignment_turned_in_sharp,
                        isTasksChecked, (value) {
                      setState(() {
                        isTasksChecked = value!;
                      });
                    }),
                    _divd(),
                    _buildCheckboxTile(
                        "Meeting / Reminder", Icons.event, isMeetingChecked,
                        (value) {
                      setState(() {
                        isMeetingChecked = value!;
                      });
                    }),
                    _divd(),
                    _buildCheckboxTile("Journal", Icons.label, isJournalChecked,
                        (value) {
                      setState(() {
                        isJournalChecked = value!;
                      });
                    }),
                    _divd(),
                    _buildCheckboxTile("Plan", Icons.label, isPlanChecked,
                        (value) {
                      setState(() {
                        isPlanChecked = value!;
                      });
                    }),
                    _divd(),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 2, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.calendar_today, size: 20),
                          _buildDateSelector("From", fromDate,
                              () => _showCustomDatePicker(context, true)),
                          _buildDateSelector("To", toDate,
                              () => _showCustomDatePicker(context, false)),
                          Checkbox(
                            value: isDateChecked,
                            onChanged: (value) {
                              setState(() {
                                isDateChecked = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    _divd(),
                    const SizedBox(
                      height: 5,
                    ),
                    _divd(),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Handle apply filter action here
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 26, vertical: 0),
                        backgroundColor: const Color(0xFFaaaaaa),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          const Icon(Icons.play_arrow, color: Colors.white, size: 50),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          Expanded(
            child: Center(
              child: isSearchEmpty
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 50,
                          color: Color.fromRGBO(224, 224, 224, 1),
                        ),
                        Text(
                          "No items found on search",
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        ),
                      ],
                    )
                  : ListView(
                      // Populate search results here if available
                      children: const [],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile(String title, IconData icon, bool isChecked,
      ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      value: isChecked,
      onChanged: onChanged,
      title: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 2),
          if (title == 'Type')
            Expanded(
              child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.label, size: 20),
                onPressed: () => {
                  setState(() {
                    isTypeIconChecked = !isTypeIconChecked;
                  })
                },
              ),
            )
        ],
      ),
      controlAffinity: ListTileControlAffinity.trailing,
      contentPadding: const EdgeInsets.fromLTRB(16, 2, 26, 0),
    );
  }

  Widget _buildDateSelector(String label, DateTime? date, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(width: 1.5),
        ),
      ),
      child: Text(
        date == null ? label : _getDateLabel(date),
        style: const TextStyle(color: Colors.black87, fontSize: 18),
      ),
    );
  }

  Widget _divd() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0), // Adjusts line length
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 54, 52, 52), // Line color
            width: 0.5, // Line thickness
          ),
        ),
      ),
    );
  }

  // Function to display 'Today'
  String _getDateLabel(DateTime date) {
    final today = DateTime.now();
    if (date.day == today.day &&
        date.month == today.month &&
        date.year == today.year) {
      return 'Today';
    }
    return DateFormat('EEE dd MMM').format(date);
  }
}
