import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final int unreadMessase;
  final Timestamp? timestamp;

  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
    required this.unreadMessase,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            // icon
            Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(width: 20.0),

            // user name
            Text(text),

            const Spacer(),
            _unreadMessageCount(context),
            _recentActTime(context),
          ],
        ),
      ),
    );
  }

  Widget _unreadMessageCount(BuildContext context) {
    return unreadMessase > 0
    ? Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Center(
          child: Text(
            unreadMessase.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.surface
            ),
          ),
        ),
      ),
    )
  : const SizedBox(height: 0.0, width: 0.0,);
  }

  Widget _recentActTime(BuildContext context) {
    return timestamp != null
    ? Text(
      formatTimestamp(timestamp!),
      style: TextStyle(
        color: unreadMessase > 0
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.tertiary,
        fontWeight: unreadMessase > 0
        ? FontWeight.w500
        : FontWeight.w300,
      ),
    )
    : Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Don\'t be shy:3',
          style: TextStyle(
            color:  Theme.of(context).colorScheme.tertiary,
            fontSize: 8.0,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          'TEXT MEE',
          style: TextStyle(
            color:  Theme.of(context).colorScheme.tertiary,
            fontSize: 7.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();

    bool isSameDay = DateFormat('yyyy-MM-dd').format(dateTime) == DateFormat('yyyy-MM-dd').format(now);
    bool isSameYear = dateTime.year == now.year;
    Duration difference = now.difference(dateTime);

    if (isSameDay) {
      // Within the current day → Show time (12-hour format, lowercase am/pm)
      return DateFormat('h:mm a').format(dateTime).toLowerCase();
    } 
    else if (difference.inDays < 7) {
      // Within a week → Show day of the week ('EEE')
      return DateFormat('EEE').format(dateTime); 
    } 
    else if (isSameYear) {
      // Within the current year → Show date ('dd MMM')
      return DateFormat('dd MMM').format(dateTime);
    } 
    else {
      // Older than a year → Show full date ('dd MMM yyyy')
      return DateFormat('dd MMM yyyy').format(dateTime);
    }
  }
}