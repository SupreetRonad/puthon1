import 'package:flutter/material.dart';
import 'package:puthon/Screens/Admin/adminControlButtons.dart';
import 'package:puthon/Screens/User/userControlButtons.dart';

class ItemCard extends StatelessWidget {
  final item, order;
  ItemCard({this.item, this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Card(
        shadowColor: Colors.white38,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: item["inMenu"] ? Colors.white : Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Icon(
                        Icons.radio_button_checked,
                        color: item["veg"] ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          item["itemName"],
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * .05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                        child: Text(
                          "Rs. " + item["price"],
                          style:const TextStyle(
                              fontSize: 17,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: EdgeInsets.fromLTRB(45, 0, 0, 10),
                    child: Text(
                      item["ingredients"],
                      maxLines: 2,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(35, 0, 0, 5),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      "-  " + item["moreInfo"],
                      maxLines: 2,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width - 28,
                    child: Container(
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 45,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(color: Colors.amber)),
                            child: Text(
                              item["category"],
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber),
                            ),
                          ),
                          const Spacer(),
                          order
                              ? UserControlButtons(
                                  itemName: item['itemName'],
                                  price: item['price'],
                                  veg: item['veg'],
                                )
                              : AdminControlButtons(
                                  item: item,
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
