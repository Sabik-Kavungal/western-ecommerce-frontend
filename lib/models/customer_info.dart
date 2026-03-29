class CustomerInfo {
  final String name;
  final String address;
  final String city;
  final String district;
  final String state;
  final String pincode;
  final String contactNo;
  final String courierService; // DTDC or INDIA POST

  CustomerInfo({
    required this.name,
    required this.address,
    required this.city,
    required this.district,
    required this.state,
    required this.pincode,
    required this.contactNo,
    this.courierService = 'DTDC',
  });
}
