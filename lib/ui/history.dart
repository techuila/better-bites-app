import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  // create a gallery of images using the card widget and divide them by date (today, yesterday, last week, last month and last 3 months, etc..)
  // the images should be shown before each title, after clicking the image, it should redirect to the afterscan page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: ListView(
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Image.asset('assets/images/food1.jpg'),
                  onTap: () {
                    //Navigator.push(
                    //  context,
                    //  MaterialPageRoute(
                    //    builder: (context) => AfterScanPage(),
                    //  ),
                    //);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
