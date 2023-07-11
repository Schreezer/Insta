import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class aboutScreen extends StatelessWidget {
  const aboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Uri _url = Uri.parse('https://forms.gle/ecNUjxvLYwNFwo3r7');
    Future<void> _launchUrl() async {
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 238, 150, 62),
        title: const Text(
          "About",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.feedback_rounded),
            onPressed: _launchUrl,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: const [
            Text(
              "This is a beta version of a Decentralied version of Quora, currently called Bountier. In this app, users can ask questions and offer a bounty in the form of BNT tokens to get their questions answered. Users who participate in the beta testing will receive extra tokens on the final release based on their interaction and feedback.",
              style: TextStyle(fontSize: 16.0, height: 1.5),
            ),
            SizedBox(height: 20),
            Text(
              "How the app works:",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            Text(
              "1. When a user logs in with their phone number, they receive 100 tokens to spend.",
              style: TextStyle(fontSize: 16.0, height: 1.5),
            ),
            Text(
              "2. Users can ask questions and offer bounties on them.",
              style: TextStyle(fontSize: 16.0, height: 1.5),
            ),
            Text(
              "3. Other users can answer the questions and claim the bounty.",
              style: TextStyle(fontSize: 16.0, height: 1.5),
            ),
            Text(
              "4. Tokens are transferred from the question asker to the answerer.",
              style: TextStyle(fontSize: 16.0, height: 1.5),
            ),
            Text(
              "5. Users can withdraw and deposit tokens to their wallets. (Available on the final release)",
              style: TextStyle(fontSize: 16.0, height: 1.5),
            ),
            SizedBox(height: 20),
            Text(
              "Current Challenges:",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            Text(
              "1. Multiple accounts: Phone number verification is not the best way to verify user identity. Researching alternative methods.",
              style: TextStyle(fontSize: 16.0, height: 1.5),
            ),
            Text(
              "2. Inflation: Immediate token availability can lead to the devaluation of tokens. Exploring mechanisms to release tokens over time.",
              style: TextStyle(fontSize: 16.0, height: 1.5),
            ),
            Text(
              "3. Storage cost: Investigating options like DeSo for building a social network on top of it.",
              style: TextStyle(fontSize: 16.0, height: 1.5),
            ),
            Text(
              "4. Token availability: Considering a mechanism similar to Brave browser's BAT tokens, where tokens are not always in the user's hands but can be withdrawn on demand.",
              style: TextStyle(fontSize: 16.0, height: 1.5),
            ),
            Text(
              "5. User behavior: Some users may not be willing to ask questions if they have to provide a bounty. Observing user behavior to understand their preferences.",
              style: TextStyle(fontSize: 16.0, height: 1.5),
            ),
            Text(
              "6. Bounty release disputes: Introducing oracles to resolve disputes between question askers and answerers. Further research required on oracle selection process.",
              style: TextStyle(fontSize: 16.0, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
