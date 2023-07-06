import "package:flutter/material.dart";
import "package:instagram/utils/colors.dart";
 
class aboutScreen extends StatelessWidget {
  const aboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 238, 150, 62),
              title: const Text(
                "About",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              centerTitle: true,
            ),
            body:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(children: const [
                Text("This is an application that i look forward to build on web 3, currently this is built entirely on web 2 using google firebase tools, which will allow users to exchange tokens for helping out each other, not only this will be helpful to the users, but this will also help users build a community.", style: TextStyle(fontSize: 16.0, height: 1.5)),
                SizedBox(height: 20,),
                Text("Some information on how the application works: ", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
                Text("Whenever any user logs in to this application with their phone number, they are given 100 tokens they can spend, the users can ask questions and put bounty on them, if they are in need of a tool, they can put a bounty on that too, and if any other user helps them out, they can claim the bounty, and the tokens are transferred from the user who asked the question to the user who answered the question, this way the users can help each other out.", style: TextStyle(fontSize: 16.0, height: 1.5)),
                SizedBox(height: 10,),
                Text("This will help people who are in need of help, and also the people who are helping out as they get rewarded with the tokens.", style: TextStyle(fontSize: 16.0, height: 1.5)),
                SizedBox(height: 10,),
                Text("Tokens will be ERC20 of course, and the users will be able to withdraw them to their wallets, and also deposit them to their account.", style: TextStyle(fontSize: 16.0, height: 1.5)),
                SizedBox(height: 10,),
                Text("This is a very basic implementation, and i will be adding more features to this application, and also i will be adding more info to this page, so stay tuned!", style: TextStyle(fontSize: 16.0, height: 1.5)),
                SizedBox(height: 20,),
                Text("Problems to be addressed: ", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600)),
                Text("1.  Multiple accounts, phone number verification is not bad, but still it is not the best way to verify the identity of the users. I was considering using some of the help of WorldCoin, but i will need to study about it more.", style: TextStyle(fontSize: 16.0, height: 1.5)),
                SizedBox(height: 10,),
                Text("2.  Inflation, If the tokens are available immediately upon the account creation, the high selling pressure will not allow the value of the tokens to hold. I was thinking that it can be solved by building some sort of a mechanism by which the tokens are released to the users over time, but i will need to study about it more.", style: TextStyle(fontSize: 16.0, height: 1.5)),
                SizedBox(height: 10,),
                Text("3. Then the obvious problem comes in, who is gonna pay for the storage? I was considering using DeSo for the same as it will allow me to build a social network on top of it, but i will need to study about it more.", style: TextStyle(fontSize: 16.0, height: 1.5)),
                SizedBox(height: 10,),
                Text("4. I was also considering it to be kept something as how Brave browser does regarding the BAT tokens, as the tokens are not at all times in the hands of the users, but they can withdraw on demand when they wish to and it all becomes partially decentralised. This also requires more study.", style: TextStyle(fontSize: 16.0, height: 1.5)),
                SizedBox(height: 10,),
                Text("5. Another problem was that many users will be not willing to ask the questions, as they will need to put the bounty, but instead just be sitting there looking for the questions to come and look forward to collect the bounty. I was thinking that it wont be a problem since, if they know the answer, thats well and good, but i think, the people who legitimately need any help will still ask the quesitons, not sure how the public will behave, so it remains to be seen.", style: TextStyle(fontSize: 16.0, height: 1.5)),
                SizedBox(height: 10,),
                Text("6. What if the questioner refuses to release the bounty, even if the answer was helpful, for that i was considering bringing in oracles, the person who asked the question, can raise the issue with the oracles, this will cost 20% of the bounty in question to be paid by the issue raiser, and the oracles will decide if the bounty should be released or not, if the oracles decide that the bounty should be released, and the issue raiser will get the bounty that he paid to raise the issue, and if the oracles decide that the bounty should not be released, but i will need to study about it more as how how will the oracles will be selected.", style: TextStyle(fontSize: 16.0, height: 1.5)),
              ],),
            ),
    );
  }
}
