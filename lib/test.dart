import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class HorizontalExample extends StatefulWidget {
  const HorizontalExample({Key? key}) : super(key: key);

  @override
  State createState() => _HorizontalExample();
}

class InnerList {
  final String name;
  List<String> children;
  InnerList({required this.name, required this.children});
}

class _HorizontalExample extends State<HorizontalExample> {
  late List<InnerList> _lists;

  @override
  void initState() {
    super.initState();

    _lists = List.generate(9, (outerIndex) {
      return InnerList(
        name: outerIndex.toString(),
        children: List.generate(12, (innerIndex) => '$outerIndex.$innerIndex'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        iconTheme: IconThemeData(color:  Color.fromARGB(255,255, 255, 0),),

        backgroundColor:  Colors.black45,
        centerTitle: true,
        leading: IconButton(icon: Icon(
            Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) =>HomeScreen()));
            }
        ),
        title: Text('Tabs'),
      ),

      body: DragAndDropLists(
        children: List.generate(_lists.length, (index) => _buildList(index)),
        onItemReorder: _onItemReorder,
        onListReorder: _onListReorder,
        axis: Axis.horizontal,
        listWidth: MediaQuery.of(context).size.width,
        listDraggingWidth: 150,
        listDecoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: const BorderRadius.all(Radius.circular(7.0)),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black45,
              spreadRadius: 3.0,
              blurRadius: 6.0,
              offset: Offset(2, 3),
            ),
          ],
        ),
        listPadding: const EdgeInsets.all(8.0),
      ),
    );
  }

  _buildList(int outerIndex) {
    var innerList = _lists[outerIndex];
    return DragAndDropList(

      header: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              width: 900,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(7.0)),
                color: Colors.yellow,
              ),
              padding: const EdgeInsets.all(10),
              child: Text(
                'Header ${innerList.name}',
                style: TextStyle(color: Colors.black),

              ),
            ),
          ),
        ],
      ),
      footer: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(7.0)),
                color: Colors.yellow,
              ),
              padding: const EdgeInsets.all(10),
              child: Text(
                'Footer ${innerList.name}',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      leftSide: const VerticalDivider(
        color: Colors.yellow,
        width: 1.5,
        thickness: 1.5,
      ),
      rightSide: const VerticalDivider(
        color: Colors.yellow,
        width: 1.5,
        thickness: 1.5,
      ),
      children: List.generate(innerList.children.length,
              (index) => _buildItem(innerList.children[index])),
    );
  }

  _buildItem(String item) {
    return DragAndDropItem(
      child:Card(
        color: Color.fromARGB(255, 102, 116, 128),
        elevation: 2.0,
        child: ListTile(

          // leading: CircleAvatar(
          //   backgroundColor: getPriorityColor(this.noteList![position].priority!),
          //   child: getPriorityIcon(this.noteList![position].priority!),
          // ),

          title: Text("text"),

          subtitle: Text("23-3-2023"),

          trailing: GestureDetector(
            child: Icon(Icons.delete, color: Colors.grey,),
            onTap: () {
              // _delete(context, noteList![position]);
            },
          ),


          onTap: () {
            debugPrint("ListTile Tapped");
            // navigateToDetail(this.noteList![position],'Edit Client');
          },

        ),
      )
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _lists[oldListIndex].children.removeAt(oldItemIndex);
      _lists[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _lists.removeAt(oldListIndex);
      _lists.insert(newListIndex, movedList);
    });
  }
}


//Running Projects
//Bottom Line replace to home
//Expenses
//Sales Projections
//Next Projects
//Export
//logout