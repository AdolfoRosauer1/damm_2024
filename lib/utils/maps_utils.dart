import 'package:url_launcher/url_launcher.dart';

Future<void> openMap(double latitude, double longitude) async {
  final url = Uri(
    scheme: 'https',
    host: "www.google.com",
    path: '/maps/search/',
    query: 'api=1&query=$latitude,$longitude'
  );
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  } 
  
}