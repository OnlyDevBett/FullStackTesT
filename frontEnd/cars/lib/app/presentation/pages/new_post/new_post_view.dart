import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cars/app/core/models/post_model.dart';
import 'package:cars/app/env.dart';
import 'package:cars/app/presentation/pages/new_post/bloc/new_post_bloc.dart';
import 'package:cars/app/presentation/styles/app_style.dart';
import 'package:cars/app/presentation/styles/theme.dart';

import '../../../core/models/car_model.dart';

class NewPostScreen extends StatefulWidget {
  final String action;
  final CarModel carModel;
  const NewPostScreen(
      {super.key, required this.action, required this.carModel});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewPostBloc(),
      child: NewPostView(
        action: widget.action,
        postModel: widget.carModel,
      ),
    );
  }
}

class NewPostView extends StatefulWidget {
  final String action;
  final CarModel postModel;
  const NewPostView({super.key, required this.action, required this.postModel});

  @override
  State<NewPostView> createState() => _NewPostViewState();
}

class _NewPostViewState extends State<NewPostView> {
  final  _carNameController = TextEditingController();
  final  _carModelController = TextEditingController();
  final  _carPriceController = TextEditingController();


  final _nameFocusNode = FocusNode();
  final _modelFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  @override
  void initState() {
    context.read<NewPostBloc>().add(
          NewPostInitialEvent(
            action: widget.action,
            postModel: widget.postModel,
          ),
        );

    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        context.read<NewPostBloc>().add(PostTitleUnfocused());
      }
    });
    _modelFocusNode.addListener(() {
      if (!_modelFocusNode.hasFocus) {
        context.read<NewPostBloc>().add(PostTitleUnfocused());
      }
    });

    _priceFocusNode.addListener(() {
      if (!_priceFocusNode.hasFocus) {
        context.read<NewPostBloc>().add(PostTitleUnfocused());
      }
    });



    if (widget.action == 'create') {
      _carNameController.text = '';
      _carModelController.text = '';
      _carPriceController.text = '';
    } else if (widget.action == 'update') {
      _carNameController.text = widget.postModel.name!;
      _carModelController.text = widget.postModel.model!;
      _carPriceController.text = widget.postModel.price!.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _modelFocusNode.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewPostBloc, NewPostState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          kSnackBarError(context, state.toastMessage);
        } else if (state.status.isSuccess) {
          kSnackBarSuccess(context, state.toastMessage);
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('New Car'),
          ),
          body: AbsorbPointer(
            absorbing: state.status.isSubmitting ? true : false,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    TextFormField(
                      focusNode: _nameFocusNode,
                      controller: _carNameController,
                      decoration: InputDecoration(
                        labelText: 'Car Name',
                        errorText: state.name.displayError != null
                            ? 'Required - Please ensure the Car Name entered is valid'
                            : null,
                        labelStyle: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium?.fontSize,
                          fontFamily: 'medium',
                        ),
                        errorStyle: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium?.fontSize,
                          fontFamily: 'medium',
                        ),
                      ),
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelLarge?.fontSize,
                        fontFamily: 'medium',
                      ),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        context
                            .read<NewPostBloc>()
                            .add(PostTitleChanged(title: value));
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      focusNode: _modelFocusNode,
                      controller: _carModelController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Car Model',
                        errorText: state.model.displayError != null
                            ? 'Required - Please ensure the Car Model Description entered is valid'
                            : null,
                        labelStyle: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium?.fontSize,
                          fontFamily: 'medium',
                        ),
                        errorStyle: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium?.fontSize,
                          fontFamily: 'medium',
                        ),
                      ),
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelLarge?.fontSize,
                        fontFamily: 'medium',
                      ),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        context
                            .read<NewPostBloc>()
                            .add(PostDescriptionChanged(description: value));
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      focusNode: _priceFocusNode,
                      controller: _carPriceController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Car Price',
                        errorText: state.price.displayError != null
                            ? 'Required - Please ensure the Car Model Description entered is valid'
                            : null,
                        labelStyle: TextStyle(
                          fontSize:
                          Theme.of(context).textTheme.labelMedium?.fontSize,
                          fontFamily: 'medium',
                        ),
                        errorStyle: TextStyle(
                          fontSize:
                          Theme.of(context).textTheme.labelMedium?.fontSize,
                          fontFamily: 'medium',
                        ),
                      ),
                      style: TextStyle(
                        fontSize:
                        Theme.of(context).textTheme.labelLarge?.fontSize,
                        fontFamily: 'medium',
                      ),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        context
                            .read<NewPostBloc>()
                            .add(PostDescriptionChanged(description: value));
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.read<NewPostBloc>().add(PostFormSubmitted(
                                action: widget.action,
                                postModel: widget.postModel,
                              )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        textStyle: TextStyle(
                            fontFamily: 'semibold',
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.fontSize),
                      ),
                      label: const Text('Submit'),
                      icon: state.status.isSubmitting
                          ? Container(
                              width: 24,
                              height: 24,
                              padding: const EdgeInsets.all(2.0),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Icon(Icons.login_outlined),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
