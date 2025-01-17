import 'package:flutter/material.dart';
import 'package:outsourced_pages/pages/components/sub_menu.dart';
import 'package:outsourced_pages/pages/components/top_menu.dart';
import 'package:outsourced_pages/utils/global_bloc.dart';
import 'package:outsourced_pages/utils/models/available_expert.dart';
import 'package:provider/provider.dart';

class CallTrackerDashboard extends StatefulWidget {
  final String token = 'tokenabc';
  static const routeName = '/experts';

  const CallTrackerDashboard({Key? key}) : super(key: key);

  @override
  _CallTrackerDashboardState createState() => _CallTrackerDashboardState();
}

class _CallTrackerDashboardState extends State<CallTrackerDashboard> {
  bool isAnySelected = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final GlobalBloc globalBloc =
        Provider.of<GlobalBloc>(context, listen: false);
    globalBloc.onUserLogin(widget.token);
  }

  // Update this based on checkbox changes
  void updateSelection(bool isSelected) {
    setState(() {
      isAnySelected = isSelected;
    });
  }

  Future<void> _showAddExpertDialog(BuildContext context, String orgId) async {
    String projectId = "projectxyz";

    TextEditingController nameController = TextEditingController();
    TextEditingController titleController = TextEditingController();
    TextEditingController companyController = TextEditingController();
    TextEditingController companyTypeController = TextEditingController();
    TextEditingController yearsAtCompanyController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController geographyController = TextEditingController();
    TextEditingController angleController = TextEditingController();
    TextEditingController statusController = TextEditingController();
    TextEditingController commentsController = TextEditingController();
    TextEditingController costController = TextEditingController();
    List<String> screeningQuestions = [];
    bool isSelected = false;
    bool favorite = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add New Expert'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(hintText: "Name"),
                    ),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(hintText: "Title"),
                    ),
                    TextField(
                      controller: companyController,
                      decoration: InputDecoration(hintText: "Company"),
                    ),
                    TextField(
                      controller: companyTypeController,
                      decoration: InputDecoration(hintText: "Company Type"),
                    ),
                    TextField(
                      controller: yearsAtCompanyController,
                      decoration: InputDecoration(hintText: "Years at Company"),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(hintText: "Description"),
                    ),
                    TextField(
                      controller: geographyController,
                      decoration: InputDecoration(hintText: "Geography"),
                    ),
                    TextField(
                      controller: angleController,
                      decoration: InputDecoration(hintText: "Angle"),
                    ),
                    TextField(
                      controller: statusController,
                      decoration: InputDecoration(hintText: "Status"),
                    ),
                    TextField(
                      controller: commentsController,
                      decoration: InputDecoration(hintText: "Comments"),
                    ),
                    TextField(
                      controller: costController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: "Cost"),
                    ),
                    // Additional inputs like Switches or Checkboxes for isSelected, favorite, etc., can be added here if needed.
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Add'),
                  onPressed: () {
                    AvailableExpert newExpert = AvailableExpert(
                      isSelected: isSelected,
                      favorite: favorite,
                      expertId:
                          '', // This should be generated or handled elsewhere
                      name: nameController.text,
                      organizationId: orgId,
                      projectId: projectId,
                      title: titleController.text,
                      company: companyController.text,
                      companyType: companyTypeController.text,
                      yearsAtCompany: yearsAtCompanyController.text,
                      description: descriptionController.text,
                      geography: geographyController.text,
                      angle: angleController.text,
                      status: statusController.text,
                      AIAssessment: 0,
                      comments: commentsController.text,
                      availability: 'Available',
                      expertNetworkName: '',
                      cost: double.parse(costController.text),
                      screeningQuestions: screeningQuestions,
                      addedExpertBy: '',
                      dateAddedExpert: DateTime.now(),
                    );
                    //make expert function
                    _loadData();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);

    return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(100), // Set the height of the app bar
            child: TopMenu()),
        body: Column(children: [
          SubMenu(
            onItemSelected: (String item) {
              print("Selected: $item"); // Example action
            },
            projectName: "Project name here later",
          ),
          Expanded(
              child: SingleChildScrollView(
            primary: false,
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 16.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          //ProgressSection(),
                          SizedBox(height: 16.0),
                          ExpertTable(),
                          ElevatedButton(
                            onPressed: () {
                              _showAddExpertDialog(context,
                                  globalBloc.currentUser.organizationId);
                            },
                            child: Text('Add Expert'), // Button text
                          ),
                          //if (Responsive.isMobile(context)) RoleTypes(),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ))
        ]));
  }
}

class ExpertTable extends StatefulWidget {
  @override
  _ExpertTableState createState() => _ExpertTableState();
}

class _ExpertTableState extends State<ExpertTable> {
  bool areAllSelected(List<AvailableExpert> experts) {
    return experts.every((expert) => expert.isSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalBloc>(builder: (context, globalBloc, child) {
      return Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expanded widget for the DataTable to take up most of the space
            Expanded(
              flex: 5, // Adjust the flex as needed to distribute space
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth:
                          800), // Adjust minWidth for your DataTable needs
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columnSpacing: 16.0,
                      showCheckboxColumn: false,
                      columns: [
                        DataColumn(label: Text("Favorite")),
                        DataColumn(label: Text("Name")),
                        DataColumn(label: Text("Title")),
                        DataColumn(label: Text("Company")),
                        DataColumn(label: Text("Years")),
                        DataColumn(label: Text("Geography")),
                        DataColumn(label: Text("Angle")),
                        DataColumn(label: Text("AI Match")),
                        DataColumn(label: Text("AI Analysis")),
                        DataColumn(label: Text("Comments from Network")),
                        DataColumn(label: Text("Availability")),
                      ],
                      rows: globalBloc.expertList
                          //.where((expert) => globalBloc.applyFilters(
                          //  expert)) // Ensure filtering logic is applied
                          .map<DataRow>((expert) => recentFileDataRow(
                              context, expert, globalBloc.toggleFavorite))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  DataRow recentFileDataRow(BuildContext context, AvailableExpert expert,
      void Function(AvailableExpert) toggleFavorite) {
    // Method to show the popup menu
    void _showPopupMenu(BuildContext context, AvailableExpert expert) async {
      final RenderBox overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox;
      final RelativeRect position = RelativeRect.fromRect(
        Rect.fromPoints(
          overlay.localToGlobal(Offset.zero), // Top left corner of the overlay
          overlay.localToGlobal(overlay.size
              .bottomRight(Offset.zero)), // Bottom right corner of the overlay
        ),
        Offset.zero & overlay.size,
      );

      final String? selectedItem = await showMenu<String>(
        context: context,
        position: position, // Show the menu in the center of the overlay
        items: [
          PopupMenuItem<String>(
            value: 'scheduleMeeting',
            child: Text('Schedule Meeting'),
          ),
          PopupMenuItem<String>(
            value: 'delete',
            child: Text('Delete'),
          ),
          // Add more options as needed
        ],
      );

      // Handling the selected action
      if (selectedItem != null) {
        switch (selectedItem) {
          case 'scheduleMeeting':
            break;
          case 'delete':
            print('Delete action on ${expert.name}');
            // Handle delete action
            break;
          // Handle other cases as necessary
        }
      }
    }

    return DataRow(
      onSelectChanged: (bool? selected) {
        if (selected ?? false) {
          // This is where you handle the row selection. For demonstration, we show the popup menu.
          _showPopupMenu(context, expert);
        }
      },
      cells: [
        DataCell(
          IconButton(
            icon: Icon(
              expert.favorite ? Icons.star : Icons.star_border,
              color: expert.favorite ? Colors.yellow : null,
            ),
            onPressed: () => toggleFavorite(expert),
          ),
        ),
        DataCell(
          InkWell(
            onTap: () {
              // Show popup menu on tap
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(100, 100, 100,
                    100), // You can adjust the position as needed
                items: [
                  PopupMenuItem<String>(
                    child: const Text('Edit'),
                    value: 'Edit',
                  ),
                  PopupMenuItem<String>(
                    child: const Text('Delete'),
                    value: 'Delete',
                  ),
                ],
              ).then((value) {
                // Handle your action based on the selected option
                if (value == 'Edit') {
                  print('Edit tapped');
                } else if (value == 'Delete') {
                  print('Delete tapped');
                }
              });
            },
            child: Text(expert.name),
          ),
        ),
        DataCell(Text(expert.title)),
        DataCell(Text(expert.company)),
        DataCell(Text('${expert.yearsAtCompany}')),
        DataCell(Text(expert.geography)),
        DataCell(Text(expert.angle)),
        DataCell(Text(expert.status)),
        DataCell(Text('${expert.AIAssessment}')),
        DataCell(Text(expert.comments)),
        DataCell(Text(expert.availability)),
      ],
    );
  }
}
