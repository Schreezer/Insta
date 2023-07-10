import "package:flutter/material.dart";

class testScreen extends StatefulWidget {
  const testScreen({super.key});

  @override
  State<testScreen> createState() => _testScreenState();
}

class _testScreenState extends State<testScreen> with TickerProviderStateMixin{
  late final TabController _tabController;
  @override
   void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
   void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Hello"),
            Text("we are Testing"),
            TabBar(
              indicatorColor: Colors.blue,
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.cloud_outlined),
            ),
            Tab(
              icon: Icon(Icons.beach_access_sharp),
            ),
            Tab(
              icon: Icon(Icons.brightness_5_sharp),
            ),
          ],
        ),
        SizedBox(
          height: 200.0,
          child: TabBarView(
            controller: _tabController,
            children: const <Widget>[
              Center(
                child: Text("It's cloudy here"),
              ),
              Center(
                child: Text("It's rainy here"),
              ),
              Center(
                child: Text("It's sunny here"),
              ),
            ],
          ),
        ),
        

          ],
        )
      ),);
  }
}