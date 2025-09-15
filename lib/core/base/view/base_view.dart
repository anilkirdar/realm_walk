import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../views/_main/viewmodel/main_viewmodel.dart';
import '../../init/print_dev.dart';
import '../state/base_state.dart';

class BaseView<T extends Store> extends StatefulWidget {
  const BaseView({
    super.key,
    required this.viewModel,
    required this.viewName,
    required this.onPageBuilder,
    required this.onModelReady,
    this.onDispose,
    this.shouldMainViewModelInit = true,
  });
  final T viewModel;
  final String viewName;
  final Widget Function(BuildContext context, T value) onPageBuilder;
  final Function(T model) onModelReady;
  final Function(T model)? onDispose;
  final bool shouldMainViewModelInit;

  @override
  State<BaseView<T>> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends Store> extends BaseState<BaseView<T>>
    with WidgetsBindingObserver {
  late T model;

  MainViewModel? mainViewModel;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    model = widget.viewModel;
    widget.onModelReady(model);
    PrintDev.instance.initState(widget.viewName);

    /// Note: not sure why it is here
    mainViewModel = context.read<MainViewModel>();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.shouldMainViewModelInit) {
      mainViewModel = context.read<MainViewModel>();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    PrintDev.instance.dispose(widget.viewName);

    if (widget.onDispose != null) widget.onDispose!(model);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        PrintDev.instance.debug('BUILD: ${widget.viewName}');
        return widget.onPageBuilder(context, model);
      },
    );
  }
}
