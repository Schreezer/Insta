import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget{
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout ({
    Key?key, 
    required this.webScreenLayout, 
    required this.mobileScreenLayout,
    }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  @override
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) => addData());
}
  addData() async{
    UserProvider userProvider = Provider.of(context, listen:false);
    await userProvider.refreshUser(false);
  
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints){
        if(constraints.maxWidth>webScreenSize){
          return widget.webScreenLayout;
        }
        return widget.mobileScreenLayout;
      },
    );

  }
}