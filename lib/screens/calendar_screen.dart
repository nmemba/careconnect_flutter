import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../config/theme.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    // Get appointments for selected date
    final selectedDateAppointments = appProvider.appointments.where((apt) {
      return apt.date.year == _selectedDate.year &&
          apt.date.month == _selectedDate.month &&
          apt.date.day == _selectedDate.day;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.grayBg,
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(isLandscape ? 12 : 16),
          children: [
            // Month Navigation
            Card(
              child: Padding(
                padding: EdgeInsets.all(isLandscape ? 12 : 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        setState(() {
                          _focusedMonth = DateTime(
                            _focusedMonth.year,
                            _focusedMonth.month - 1,
                          );
                        });
                      },
                    ),
                    Text(
                      DateFormat('MMMM yyyy').format(_focusedMonth),
                      style: TextStyle(
                        fontSize: isLandscape ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        setState(() {
                          _focusedMonth = DateTime(
                            _focusedMonth.year,
                            _focusedMonth.month + 1,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: isLandscape ? 12 : 16),
            
            // Simple Month View
            Card(
              child: Padding(
                padding: EdgeInsets.all(isLandscape ? 12 : 16),
                child: _buildMonthGrid(appProvider, isLandscape),
              ),
            ),
            
            SizedBox(height: isLandscape ? 16 : 24),
            
            // Appointments for selected date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEEE, MMMM d').format(_selectedDate),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: isLandscape ? 8 : 12),
            
            if (selectedDateAppointments.isEmpty)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(isLandscape ? 16 : 20),
                  child: const Center(
                    child: Text(
                      'No appointments scheduled',
                      style: TextStyle(color: AppTheme.grayMedium),
                    ),
                  ),
                ),
              )
            else
              ...selectedDateAppointments.map((apt) {
                return Padding(
                  padding: EdgeInsets.only(bottom: isLandscape ? 8 : 12),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(isLandscape ? 12 : 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: isLandscape ? 40 : 48,
                                height: isLandscape ? 40 : 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                                ),
                                child: const Icon(
                                  Icons.event,
                                  color: Color(0xFFEA580C),
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: isLandscape ? 12 : 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      apt.title,
                                      style: TextStyle(
                                        fontSize: isLandscape ? 14 : 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      apt.time,
                                      style: TextStyle(
                                        fontSize: isLandscape ? 13 : 14,
                                        color: AppTheme.grayMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isLandscape ? 8 : 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: AppTheme.grayMedium,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                apt.location,
                                style: TextStyle(
                                  fontSize: isLandscape ? 12 : 13,
                                  color: AppTheme.grayMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline,
                                size: 16,
                                color: AppTheme.grayMedium,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                apt.provider,
                                style: TextStyle(
                                  fontSize: isLandscape ? 12 : 13,
                                  color: AppTheme.grayMedium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthGrid(AppProvider appProvider, bool isLandscape) {
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday

    final List<Widget> dayWidgets = [];

    // Add weekday headers
    const weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    for (final day in weekdays) {
      dayWidgets.add(
        Center(
          child: Text(
            day,
            style: TextStyle(
              fontSize: isLandscape ? 12 : 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.grayMedium,
            ),
          ),
        ),
      );
    }

    // Add empty cells for days before month starts
    for (int i = 0; i < startWeekday; i++) {
      dayWidgets.add(const SizedBox());
    }

    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      final isSelected = date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day;
      
      final hasAppointment = appProvider.appointments.any((apt) =>
          apt.date.year == date.year &&
          apt.date.month == date.month &&
          apt.date.day == date.day);

      dayWidgets.add(
        InkWell(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontSize: isLandscape ? 12 : 14,
                      color: isSelected ? Colors.white : AppTheme.grayDark,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                if (hasAppointment && !isSelected)
                  Positioned(
                    bottom: 4,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      childAspectRatio: 1,
      children: dayWidgets,
    );
  }
}
