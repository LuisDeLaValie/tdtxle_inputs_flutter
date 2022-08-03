part of 'select_imput.dart';

/// Item primcipal del buscador
class SelectItem<T> extends ListTile {
  final T value;
  final String search;
  @override
  final Widget title;
  @override
  final Widget? subtitle;
  @override
  final Widget? trailing;
  @override
  final Widget? leading;

  const SelectItem({
    Key? key,
    required this.value,
    required this.search,
    required this.title,
    this.subtitle,
    this.trailing,
    this.leading,
  }) : super(
          key: key,
          title: title,
          subtitle: subtitle,
          leading: leading,
          trailing: trailing,
        );
  const SelectItem._({
    Key? key,
    required this.value,
    required this.search,
    required this.title,
    this.subtitle,
    this.trailing,
    this.leading,
    Function()? onTap,
  }) : super(
          key: key,
          title: title,
          subtitle: subtitle,
          leading: leading,
          trailing: trailing,
          onTap: onTap,
        );

  SelectItem<T> copyWith({
    T? value,
    String? search,
    Widget? title,
    Widget? subtitle,
    Widget? trailing,
    Widget? leading,
    void Function()? onTap,
  }) {
    return SelectItem<T>._(
      value: value ?? this.value,
      search: search ?? this.search,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      trailing: trailing ?? this.trailing,
      leading: leading ?? this.leading,
      onTap: onTap ?? this.onTap,
    );
  }
}
