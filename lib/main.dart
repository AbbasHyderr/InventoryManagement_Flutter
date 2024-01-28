import 'package:flutter/material.dart';
import 'package:octdaily/ProductModel.dart';
import 'package:octdaily/utils.dart';
import 'package:octdaily/ProductServices.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProductInventoryPage(),
    );
  }
}

class ProductInventoryPage extends StatefulWidget {
  const ProductInventoryPage({super.key});

  @override
  State<ProductInventoryPage> createState() => _ProductInventoryPageState();
}

class _ProductInventoryPageState extends State<ProductInventoryPage> {
  // Creating an instance of ProductServices class
  final ProductServices productServices = ProductServices();

// Text editing controllers for various input fields
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController productIdController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

// List to hold the fetched data from the server
  List<Product>? myData = [];

  bool sort = true;

  int sortColumnIndex = 0;

// List to hold the filtered data
  List<Product>? filterData = [];

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // Fetching data from the server when the widget is created
    fetchData();
    super.initState();
  }

// Asynchronous function to fetch data from the server
  Future<void> fetchData() async {
    try {
      // Fetching all products using the productServices instance
      myData = await productServices.fetchAllProducts(context);
      // Copying the fetched data to the filterData list for filtering purposes
      filterData = List.from(myData!);
      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

// Function to add a new product
  void addProduct(context) {
    // Calling the addProduct method of productServices to add a new product
    productServices.addProduct(
      context: context,
      name: nameController.text,
      price: double.parse(priceController.text),
      quantity: int.parse(quantityController.text),
      productId: productIdController.text,
      id: idController.text,
    );

  }

// Function to handle column sorting
  void onsortColum(int columnIndex, bool ascending) {
    // Updating the sorting configuration based on the selected column and sorting order
    setState(() {
      sortColumnIndex = columnIndex;
      sort = ascending;
    });

    // Sorting the data based on the selected column and sorting order
    if (columnIndex == 0) {
      // Sorting by product ID
      if (ascending) {
        myData!.sort((a, b) => a.id.compareTo(b.id));
      } else {
        myData!.sort((a, b) => b.id.compareTo(a.id));
      }
    } else if (columnIndex == 1) {
      // Sorting by product name
      if (ascending) {
        myData!.sort((a, b) => a.name.compareTo(b.name));
      } else {
        myData!.sort((a, b) => b.name.compareTo(a.name));
      }
    } else if (columnIndex == 2) {
      // Sorting by product ID
      if (ascending) {
        myData!.sort((a, b) => a.productId.compareTo(b.productId));
      } else {
        myData!.sort((a, b) => b.productId.compareTo(a.productId));
      }
    } else if (columnIndex == 3) {
      // Sorting by product price
      if (ascending) {
        myData!.sort((a, b) => a.price.compareTo(b.price));
      } else {
        myData!.sort((a, b) => b.price.compareTo(a.price));
      }
    } else if (columnIndex == 4) {
      // Sorting by product quantity
      if (ascending) {
        myData!.sort((a, b) => a.quantity.compareTo(b.quantity));
      } else {
        myData!.sort((a, b) => b.quantity.compareTo(a.quantity));
      }
    }
  }

  // Function to show an alert dialog for adding or updating a product
  Future<void> _showAlertDialog(
      String type,
      dynamic entry,
      BuildContext context,
      ) async {
    // Creating a global key for the form to handle form validation
    final formKey = GlobalKey<FormState>();

    // If the operation is an 'Update', pre-fill the form fields with the existing product data
    if (type == 'Update') {
      idController.text = entry.id.toString();
      nameController.text = entry.name.toString();
      productIdController.text = entry.productId.toString();
      priceController.text = entry.price.toString();
      quantityController.text = entry.quantity.toString();
    }

    // Displaying an AlertDialog
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        // Building the AlertDialog with a title, content, and actions
        return AlertDialog(
          title: Text('$type Product'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: idController,
                      decoration: const InputDecoration(labelText: 'ID'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: productIdController,
                      decoration: const InputDecoration(labelText: 'Product ID'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: quantityController,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            // Cancel button to close the dialog
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // Button to perform the specified operation (e.g., 'Update' or 'Add')
            TextButton(
              child: Text(type),
              onPressed: () {
                // Validating the form before performing the operation
                if (formKey.currentState!.validate()) {
                  // Calling the addProduct method to add or update the product
                  addProduct(context);
                  fetchData();


                }
                // Closing the dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Product Inventory Management System')),
      ),
      body: // SizedBox containing a PaginatedDataTable to display product information
      SizedBox(
        width: double.infinity,
        child: PaginatedDataTable(
          // Setting up sorting configuration for the DataTable
          sortColumnIndex: sortColumnIndex,
          sortAscending: sort,
          showFirstLastButtons: true,
          actions: [
            ElevatedButton(
              onPressed: () {
                // Opening an alert dialog for adding a new product
                _showAlertDialog('Add', null, context);
              },
              child: const Text("ADD"),
            )
          ],
          // Header section containing a search input field
          header: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            // Search input field to filter data based on product name
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
    hintText: "Search by Name",
    prefixIcon: Icon(Icons.search),


              ),
              onChanged: (value) {
                setState(() {
                  // Filtering data based on the entered search value
                  if (value.isEmpty) {
                    myData = filterData!;
                  } else {
                    myData = myData!
                        .where((element) => element.name
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                        .toList();
                  }
                });
              },
            ),
          ),
          // Data source for the DataTable, using RowSource
          source: RowSource(
            myData: myData,
            count: myData!.length,
            context: context,
          ),
          // Number of rows per page in the DataTable
          rowsPerPage: 4,
          // Columns configuration for the DataTable
          columns: [
            // DataColumn for displaying row numbers
            DataColumn(
              label: const Text('No'),
              onSort: (columnIndex, ascending) {
                // Sorting the DataTable when the 'No' column header is clicked
                onsortColum(columnIndex, ascending);
              },
            ),
            // DataColumn for displaying product names
            DataColumn(
              label: const Text('Product Name'),
              onSort: (columnIndex, ascending) {
                // Sorting the DataTable when the 'Product Name' column header is clicked
                onsortColum(columnIndex, ascending);
              },
            ),
            // DataColumn for displaying product IDs
            DataColumn(
              label: const Text('Product ID'),
              onSort: (columnIndex, ascending) {
                // Sorting the DataTable when the 'Product ID' column header is clicked
                onsortColum(columnIndex, ascending);
              },
            ),
            // DataColumn for displaying product prices
            DataColumn(
              label: const Text('Price \$'),
              onSort: (columnIndex, ascending) {
                // Sorting the DataTable when the 'Price \$' column header is clicked
                onsortColum(columnIndex, ascending);
              },
            ),
            // DataColumn for displaying available quantities
            DataColumn(
              label: const Text('Quantity Available'),
              onSort: (columnIndex, ascending) {
                // Sorting the DataTable when the 'Quantity Available' column header is clicked
                onsortColum(columnIndex, ascending);
              },
            ),
            // DataColumn for displaying actions (e.g., edit/delete buttons)
            const DataColumn(label: Text('Actions')),
          ],
        ),
      ),

    );
  }
}

class RowSource extends DataTableSource {
  List<Product>? myData;
  final int count;
  BuildContext context;
  RowSource({
    required this.myData,
    required this.count,
    required this.context,
  });
  final ProductServices productServices = ProductServices();

  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController productIdController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  void updateProduct(context) {
    try {
      productServices.updateProduct(
        context: context,
        id: idController.text,
        name: nameController.text,
        price: double.parse(priceController.text),
        quantity: int.parse(quantityController.text),
        productId: productIdController.text,
      );
      // fetchData(); // Refresh the product list after updating
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
  void delete(id, context) {
    try {
      productServices.deleteProduct(
        context: context,
        id: id,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> _showAlertDialog(
      String type, dynamic entry, BuildContext context) async {
    final formKey = GlobalKey<FormState>();

    if (type == 'Update') {
      idController.text = entry.id.toString();
      nameController.text = entry.name.toString();
      productIdController.text = entry.productId.toString();
      priceController.text = entry.price.toString();
      quantityController.text = entry.quantity.toString();
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$type Product'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: idController,
                      decoration: const InputDecoration(labelText: 'ID'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: productIdController,
                      decoration:
                      const InputDecoration(labelText: 'Product ID'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: quantityController,
                      decoration:
                      const InputDecoration(labelText: 'Quantity'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(type),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  updateProduct(context);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  // Helper function to create a DataRow for a given product data

  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(myData![index], context, _showAlertDialog, delete);
    } else {
      return null;
    }
  }

  bool get isRowCountApproximate => false;

  int get rowCount => count;

  int get selectedRowCount => 0;
}

DataRow recentFileDataRow(var data, BuildContext context, Function _showAlertDialog, Function delete) {
  return DataRow(
    cells: [
      DataCell(
        Text(
          data.id,
          textAlign: TextAlign.center,
        ),
      ),
      DataCell(
        Text(
          data.name,
          textAlign: TextAlign.center,
        ),
      ),
      DataCell(
        Text(
          data.productId,
          textAlign: TextAlign.center,
        ),
      ),
      DataCell(
        Text(
          data.price.toString(),
          textAlign: TextAlign.center,
        ),
      ),
      DataCell(
        Text(
          data.quantity.toString(),
          textAlign: TextAlign.center,
        ),
      ),
      DataCell(
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                _showAlertDialog('Update', data, context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Implement delete functionality
                delete(data.id, context);
              },
            ),
          ],
        ),
      ),
    ],
  );
}
