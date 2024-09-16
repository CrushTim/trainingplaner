//get the Date out of datetime
DateTime getOnlyDate(DateTime dateTime) {
  return DateTime.utc(dateTime.year, dateTime.month, dateTime.day);
}

String getDateStringForDisplay(DateTime pickedDate) {
  return 'Date: ${pickedDate.day}.${pickedDate.month}.${pickedDate.year} ';
}

String getTimeStringForDisplay(DateTime pickedDate) {
  return '${pickedDate.hour}:${pickedDate.minute}';
}
