import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/car_model.dart';
import '../../utils/form_validators.dart';
import '../bloc/car/car_bloc.dart';
import '../bloc/car/car_event.dart';
import '../bloc/car/car_state.dart';

/**
 * Created By: Bett Collins
 * User: devbett
 * Date: 27/10/2024
 * Time: 08:34
 * Project Name: IntelliJ IDEA
 * File Name: car_form_page


 */


class CarFormPage extends StatefulWidget {
  final CarModel? car;

  CarFormPage({this.car});

  @override
  _CarFormPageState createState() => _CarFormPageState();
}

class _CarFormPageState extends State<CarFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _makeController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _makeController = TextEditingController(text: widget.car?.make);
    _modelController = TextEditingController(text: widget.car?.model);
    _yearController = TextEditingController(text: widget.car?.year.toString());
    _priceController = TextEditingController(text: widget.car?.price.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.car == null ? 'Add Car' : 'Edit Car'),
      ),
      body: BlocListener<CarBloc, CarState>(
        listener: (context, state) {
          if (state is CarError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is CarLoaded) {
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _makeController,
                  decoration: InputDecoration(labelText: 'Make'),
                  validator: (value) => FormValidators.validateRequired(value, 'Make'),
                ),
                TextFormField(
                  controller: _modelController,
                  decoration: InputDecoration(labelText: 'Model'),
                  validator: (value) => FormValidators.validateRequired(value, 'Model'),
                ),
                TextFormField(
                  controller: _yearController,
                  decoration: InputDecoration(labelText: 'Year'),
                  keyboardType: TextInputType.number,
                  validator: FormValidators.validateYear,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: FormValidators.validatePrice,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final car = CarModel(
                        id: widget.car?.id ?? 0,
                        make: _makeController.text,
                        model: _modelController.text,
                        year: int.parse(_yearController.text),
                        price: double.parse(_priceController.text),
                      );

                      if (widget.car == null) {
                        context.read<CarBloc>().add(CreateCar(car));
                      } else {
                        context.read<CarBloc>().add(UpdateCar(car));
                      }
                    }
                  },
                  child: Text(widget.car == null ? 'Add Car' : 'Update Car'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}