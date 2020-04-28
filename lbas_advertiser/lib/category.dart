import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lbas_advertiser/statusList.dart';

class Category extends StatelessWidget {
  final List<String> status = statusList;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: status.length,
        itemBuilder: (BuildContext context, int index){
          return Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: (){},
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: Text(status[index], style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),),
              ),
            )
          );
        },
      ),
    );
  }
}