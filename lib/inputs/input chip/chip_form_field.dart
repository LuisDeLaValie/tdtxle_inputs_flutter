part of 'chip_imput.dart';

class ChipFormField<T> extends FormField<ChipListCallback<T>> {
  /// The decoration to show around the field.
  ///
  /// By default, draws a horizontal line under the text field but can be configured to show an icon, label, hint text, and error text.
  ///
  /// Specify null to remove the decoration entirely (including the extra padding introduced by the decoration to save space for the labels).
  final InputDecoration? decoration;

  final Function(ChipListCallback<T>? val)? onChanged;
  final Function(ChipListCallback<T>? val)? onSubmitted;

  /// The style to be applied to the chip's label.
  ///
  /// If null, the value of the [ChipTheme]'s [ChipThemeData.labelStyle] is used.
  //
  /// This only has an effect on widgets that respect the [DefaultTextStyle],
  /// such as [Text].
  ///
  /// If [TextStyle.color] is a [MaterialStateProperty<Color>], [MaterialStateProperty.resolve]
  /// is used for the following [MaterialState]s:
  ///
  ///  * [MaterialState.disabled].
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.pressed].
  final TextStyle? chipLabelStyle;

  /// Color to be used for the unselected, enabled chip's background.
  ///
  /// The default is light grey.
  final Color? chipBackgroundColor;

  /// The [Color] for the delete icon chip's. The default is based on the ambient [Icon ThemeData.color].
  final Color? chipDeleteIconColor;

  final List<ChipItem<T>>? listaBase;

  ChipFormField({
    this.decoration,
    this.onChanged,
    this.onSubmitted,
    this.chipLabelStyle,
    this.chipBackgroundColor,
    this.listaBase,
    this.chipDeleteIconColor,
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.enabled = true,
    super.autovalidateMode,
    super.restorationId,
  }) : super(
          builder: (field) {
            final state = field as _ChipFormFieldState<T>;

            return ChipField<T>(
              chipBackgroundColor: chipBackgroundColor,
              chipDeleteIconColor: chipDeleteIconColor,
              chipLabelStyle: chipLabelStyle,
              decoration: decoration,
              initValue: initialValue,
              listaBase: listaBase,
              onChanged: state.didChange,
              onSubmitted: state.onSubmitted,
            );
          },
        );

  @override
  FormFieldState<ChipListCallback<T>> createState() => _ChipFormFieldState();
}

class _ChipFormFieldState<T> extends FormFieldState<ChipListCallback<T>> {
  @override
  ChipFormField<T> get widget => super.widget as ChipFormField<T>;

  void onSubmitted(List<ChipItem<T>>? value) {
    widget.onSubmitted?.call(value);
    super.didChange(value);
    // widget.onChanged?.call(value);
  }

  @override
  void didChange(List<ChipItem<T>>? value) {
    super.didChange(value);
    widget.onChanged?.call(value);
  }
}

class ChipDialog<T> extends StatefulWidget {
  final InputDecoration? decoration;
  final List<ChipItem> data;
  final Chip Function(ChipItem<T>? vlue) chipBuilder;
  final Chip Function(ChipItem<T>? vlue)? selectChipBuilder;
  final void Function(List<T> val) onChanged;

  const ChipDialog({
    super.key,
    this.decoration,
    required this.data,
    required this.chipBuilder,
    this.selectChipBuilder,
    required this.onChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ChipDialogState createState() => _ChipDialogState();
}

class _ChipDialogState extends State<ChipDialog> {
  String _value = "";
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        showDialog<List<ChipItem>>(
          context: context,
          builder: (contex) {
            return _ChipDialog(
              data: widget.data,
              chipBuilder: widget.chipBuilder,
              selectChipBuilder: widget.selectChipBuilder ?? widget.chipBuilder,
            );
          },
        ).then((value) {
          if (value != null) {
            var values = value.map((e) => e.value).toList();
            var tex = value.map((e) => e.tex).toList();
            widget.onChanged(values);
            setState(() {
              _value = tex.join(',');
            });
          }
        });
      },
      child: InputDecorator(
        decoration: widget.decoration ?? const InputDecoration(),
        child: _value.isNotEmpty
            ? Text(
                _value,
                overflow: TextOverflow.ellipsis,
              )
            : null,
      ),
    );
  }
}

class _ChipDialog extends StatefulWidget {
  final List<ChipItem> data;
  final Chip Function(ChipItem? theme) chipBuilder;
  final Chip Function(ChipItem? vlue) selectChipBuilder;

  const _ChipDialog({
    super.key,
    required this.data,
    required this.chipBuilder,
    required this.selectChipBuilder,
  });

  @override
  State<_ChipDialog> createState() => __ChipDialogState();
}

class __ChipDialogState extends State<_ChipDialog> {
  List<int> activos = [];
  List<ChipItem> data = [];

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(onChanged: (value) {
            setState(() {
              data = widget.data
                  .where((element) =>
                      element.tex.toLowerCase().contains(value.toLowerCase()))
                  .toList();
            });
          }),
          const Divider(height: 10),
          SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: Wrap(
                children: generarData(),
              ),
            ),
          )
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(widget.data
                .where((element) => activos.contains(element.hashCode))
                .toList());
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }

  List<Widget> generarData() {
    return data
        .map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
            child: GestureDetector(
              onTap: () {
                if (activos.contains(e.hashCode)) {
                  activos.remove(e.hashCode);
                } else {
                  activos.add(e.hashCode);
                }
                setState(() {});
              },
              child: activos.contains(e.hashCode)
                  ? widget.selectChipBuilder(e)
                  : widget.chipBuilder(e),
            ),
          ),
        )
        .toList();
  }
}
