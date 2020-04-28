import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {
  final String status;
  final double fontSize = 15.0;
  const StatusBar({this.status, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return statusBar(status);
  }

  Container statusBar(String status){
    if(status=="Pending"){
      return Container(
        decoration: new BoxDecoration(
          color: Color.fromRGBO(184, 160, 108, 1),
          border: Border.all(color: Colors.black12, width: 2.0)
        ),          
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Text(
          status,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }else if(status=="Approved"){
      return Container(
        decoration: new BoxDecoration(
          color: Color.fromRGBO(252, 218, 71, 1),
          border: Border.all(color: Colors.black12, width: 2.0)
        ),          
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Text(
          status,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }else if(status=="Declined"){
      return Container(
        decoration: new BoxDecoration(
          color: Color.fromRGBO(255, 69, 48, 1),
          border: Border.all(color: Colors.black12, width: 2.0)
        ),          
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Text(
          status,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }else if(status=="Posting"){
      return Container(
        decoration: new BoxDecoration(
          color: Color.fromRGBO(133, 255, 10, 1),
          border: Border.all(color: Colors.black12, width: 2.0)
        ),          
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Text(
          status,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }else if(status=="Blocked"){
      return Container(
        decoration: new BoxDecoration(
          color: Color.fromRGBO(41, 41, 41, 1),
          border: Border.all(color: Colors.black12, width: 2.0)
        ),          
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Text(
          status,
          style: TextStyle(
            color: Colors.white70,
            fontSize: fontSize,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }else if(status=="Expired"){
      return Container(
        decoration: new BoxDecoration(
          color: Color.fromRGBO(156, 156, 156, 1),
          border: Border.all(color: Colors.black12, width: 2.0)
        ),          
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Text(
          status,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }else if(status=="Cancelled"){
      return Container(
        decoration: new BoxDecoration(
          color: Color.fromRGBO(156, 156, 156, 1),
          border: Border.all(color: Colors.black12, width: 2.0)
        ),          
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Text(
          status,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }else if(status=="Deleted"){
      return Container(
        decoration: new BoxDecoration(
          color: Color.fromRGBO(255, 69, 48, 1),
          border: Border.all(color: Colors.black12, width: 2.0)
        ),          
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Text(
          status,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }else{
      return Container(height: 15.0, width: 20.0);
    }
  }
}