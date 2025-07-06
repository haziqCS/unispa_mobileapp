import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:unispa_mobileapp/components/button.dart';
import 'package:unispa_mobileapp/components/custom_appbar.dart';
import 'package:unispa_mobileapp/utils/config.dart';

import '../services/api_service.dart';
import '../utils/booking_service.dart'; // <-- Add this import

class BookingPage extends StatefulWidget {
  const BookingPage({super.key}); //Shorthand version

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final ApiService _apiService = ApiService();
  final BookingService _bookingService =
      BookingService(); // <-- BookingService instance

  final Map<String, List<Map<String, dynamic>>> _packageOptionsByName = {};
  int? _selectedOptionId;

  //Declaration
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;

  // Form inputs
  int _pax = 1;
  String? _selectedPackage;
  String _name = '';
  String _phone = '';
  String? _selectedPaymentMethod;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  List<String> _packages = [];
  final List<String> _paymentMethods = ['Card', 'Online Banking', 'Cash'];

  bool _isLoading = true;
  String? _errorMessage;

  // Submission state
  bool _isSubmitting = false;
  String? _submitError;

  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map?;
      if (args != null && args['package_name'] != null) {
        setState(() {
          _selectedPackage = args['package_name'];
        });
      }
    });
    _fetchPackages();
  }

  Future<void> _fetchPackages() async {
    try {
      final packagesMap = await _apiService.fetchPackages();
      print('Fetched packages map: $packagesMap');

      List<String> packageNames = [];
      _packageOptionsByName.clear();

      packagesMap.forEach((category, packagesList) {
        for (var package in packagesList) {
          String name = package['package_name'] as String;
          packageNames.add(name);

          // Save options list
          if (package['options'] != null) {
            _packageOptionsByName[name] = List<Map<String, dynamic>>.from(
              package['options'],
            );
          } else {
            _packageOptionsByName[name] = [];
          }
        }
      });

      setState(() {
        _packages = packageNames;
        _isLoading = false;
      });
    } catch (e) {
      print('ERROR fetching packages: $e');
      setState(() {
        _errorMessage = 'Failed to load packages';
        _isLoading = false;
      });
    }
  }

  bool get _isFormValid {
    return _dateSelected &&
        _selectedTime != null &&
        _selectedPackage != null &&
        _selectedOptionId != null &&
        _name.trim().isNotEmpty &&
        _phone.trim().isNotEmpty &&
        _selectedPaymentMethod != null &&
        _pax > 0;
  }

  Future<void> _handleMakeAppointment() async {
    if (!_isFormValid) return;

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      final packageId = _selectedOptionId!;
      if (packageId == null) throw Exception('Invalid package selected');
      if (_selectedTime == null) throw Exception('Please select a time slot');

      final hourStr = _selectedTime!.hour.toString().padLeft(2, '0');
      final minuteStr = _selectedTime!.minute.toString().padLeft(2, '0');
      final itemStartTime = '$hourStr:$minuteStr';

      final items = [
        {
          'package_id': packageId,
          'item_pax': _pax,
          'item_start_time': itemStartTime,
          'for_whom_name': _name,
        },
      ];

      final bookingDate = _currentDay.toIso8601String().substring(0, 10);

      final result = await _bookingService.createBooking(
        bookingDate: bookingDate,
        paymentMethod: _selectedPaymentMethod!,
        notes: null,
        items: items,
      );

      Navigator.of(context).pushNamed(
        'payment_page',
        arguments: {'booking': result['booking'], 'invoice': result['invoice']},
      );
    } catch (e) {
      setState(() {
        _submitError = 'Failed to create booking: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      appBar: CustomAppbar(
        appTitle: 'Appointment',
        icon: const FaIcon(Icons.arrow_back),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _tableCalendar(),

                        const SizedBox(height: 20),
                        const Text(
                          'Number of Pax:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: _pax.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter number of pax',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _pax = int.tryParse(value) ?? 1;
                            });
                          },
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          'Name:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your full name',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _name = value;
                            });
                          },
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          'Phone Number:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your phone number',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _phone = value;
                            });
                          },
                        ),

                        const SizedBox(height: 20),
                        const Text(
                          'Select Package:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedPackage,
                            hint: const Text('Choose a package'),
                            isExpanded: true,
                            underline: Container(),
                            items: _packages.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedPackage = value;

                                // Reset selected option to first option if exists
                                if (value != null &&
                                    _packageOptionsByName.containsKey(value) &&
                                    _packageOptionsByName[value]!.isNotEmpty) {
                                  _selectedOptionId =
                                      _packageOptionsByName[value]![0]['package_id']
                                          as int;
                                } else {
                                  _selectedOptionId = null;
                                }
                              });
                            },
                          ),
                        ),
                        if (_selectedPackage != null &&
                            _packageOptionsByName[_selectedPackage!] != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            margin: const EdgeInsets.only(top: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<int>(
                              value: _selectedOptionId,
                              hint: const Text('Select Duration & Price'),
                              isExpanded: true,
                              underline: Container(),
                              items: _packageOptionsByName[_selectedPackage!]!
                                  .map((option) {
                                    String duration =
                                        option['duration'] ??
                                        'Unknown Duration';
                                    String price =
                                        option['package_price'] != null
                                        ? double.tryParse(
                                                option['package_price']
                                                    .toString(),
                                              )?.toStringAsFixed(2) ??
                                              'N/A'
                                        : 'N/A';
                                    int optionId = option['package_id'] as int;

                                    return DropdownMenuItem<int>(
                                      value: optionId,
                                      child: Text('$duration - RM $price'),
                                    );
                                  })
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedOptionId = value;
                                });
                              },
                            ),
                          ),

                        const SizedBox(height: 25),
                        const Text(
                          'Select Therapy Time:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _isWeekend
                    ? SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 30,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Weekend is not available, please select another date',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: _isWeekend
                                    ? null
                                    : () async {
                                        final pickedTime = await showTimePicker(
                                          context: context,
                                          initialTime:
                                              _selectedTime ??
                                              TimeOfDay(hour: 9, minute: 0),
                                        );
                                        if (pickedTime != null) {
                                          setState(() {
                                            _selectedTime = pickedTime;
                                            _timeSelected = true;
                                          });
                                        }
                                      },
                                child: Text(
                                  _selectedTime != null
                                      ? 'Selected Time: ${_selectedTime!.format(context)}'
                                      : 'Select Therapy Time',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Payment Method:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          children: _paymentMethods.map((method) {
                            final isSelected = _selectedPaymentMethod == method;
                            return ChoiceChip(
                              label: Text(method),
                              selected: isSelected,
                              onSelected: (_) {
                                setState(() {
                                  _selectedPaymentMethod = method;
                                });
                              },
                              selectedColor: Config.primaryColor,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              backgroundColor: Colors.grey[200],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: _submitError != null
                        ? Text(
                            _submitError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const SizedBox.shrink(), // Empty widget when no error
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 40,
                    ),
                    child: Button(
                      width: double.infinity,
                      title: _isSubmitting
                          ? 'Submitting...'
                          : 'Make Appointment',
                      onPressed: _isFormValid && !_isSubmitting
                          ? _handleMakeAppointment
                          : null,
                      disable: !_isFormValid || _isSubmitting,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _tableCalendar() {
    return TableCalendar(
      focusedDay: _focusDay,
      firstDay: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      lastDay: DateTime(2026, 12, 31),
      calendarFormat: _format,
      currentDay: _currentDay,
      rowHeight: 48,
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Config.primaryColor,
          shape: BoxShape.circle,
        ),
      ),
      availableCalendarFormats: const {CalendarFormat.month: 'Month'},
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      onDaySelected: ((selectedDay, focusedDay) {
        setState(() {
          _currentDay = selectedDay;
          _focusDay = focusedDay;
          _dateSelected = true;

          if (selectedDay.weekday == 6 || selectedDay.weekday == 7) {
            _isWeekend = true;
            _timeSelected = false;
            _currentIndex = null;
          } else {
            _isWeekend = false;
          }
        });
      }),
    );
  }
}
