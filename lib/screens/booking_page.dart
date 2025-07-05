import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:unispa_mobileapp/components/button.dart';
import 'package:unispa_mobileapp/components/custom_appbar.dart';
import 'package:unispa_mobileapp/utils/config.dart';

import '../services/api_service.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key}); //Shorthand version

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final ApiService _apiService = ApiService();

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
  final List<String> _paymentMethods = ['Touch n Go', 'QR Payment', 'FPX'];

  bool _isLoading = true;
  String? _errorMessage;

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

      List<String> packageNames = [];
      packagesMap.forEach((category, packagesList) {
        for (var package in packagesList) {
          packageNames.add(package['package_name'] as String);
        }
      });

      setState(() {
        _packages = packageNames;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load packages';
        _isLoading = false;
      });
    }
  }

  bool get _isFormValid {
    return _dateSelected &&
        _timeSelected &&
        _selectedPackage != null &&
        _name.trim().isNotEmpty &&
        _phone.trim().isNotEmpty &&
        _selectedPaymentMethod != null &&
        _pax > 0;
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
                    : SliverGrid(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                _currentIndex = index;
                                _timeSelected = true;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _currentIndex == index
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                color: _currentIndex == index
                                    ? Config.primaryColor
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _currentIndex == index
                                      ? Colors.white
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }, childCount: 8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 1.5,
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
                      vertical: 40,
                    ),
                    child: Button(
                      width: double.infinity,
                      title: 'Make Appointment',
                      onPressed: _isFormValid
                          ? () {
                              Navigator.of(
                                context,
                              ).pushNamed('payment_page');
                            }
                          : null,
                      disable: !_isFormValid,
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
