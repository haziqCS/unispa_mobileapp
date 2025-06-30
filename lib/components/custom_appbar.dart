import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unispa_mobileapp/utils/config.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppbar({Key? key, this.appTitle, this.route, this.icon, this.actions})
    : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(60);

  final String? appTitle;
  final String? route;
  final FaIcon? icon;
  final List<Widget>? actions;

  @override
  State<CustomAppbar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white, //Follow app background colors
      elevation: 0,
      title: Text(
        widget.appTitle!,
        style: const TextStyle(fontSize: 20, color: Colors.black),
      ),
      leading: widget.icon != null
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Config.primaryColor,
              ),
              child: IconButton(
                onPressed: () {
                  if (widget.route != null) {
                    //If route is given, this icon button will navigate to that route
                    Navigator.of(context).pushNamed(widget.route!);
                  } else {
                    //Else, just simply pop back to previous page
                    Navigator.of(context).pop();
                  }
                },
                icon: widget.icon!,
                iconSize: 16,
                color: Colors.white,
              ),
            )
          : null,
      actions: widget.actions ?? null,
    );
  }
}
