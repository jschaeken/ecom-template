import 'package:flutter/material.dart';

class TextDisplay extends StatelessWidget {
  const TextDisplay({
    super.key,
    required this.text,
    this.color,
  });

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style:
            Theme.of(context).textTheme.displayMedium!.copyWith(color: color));
  }
}

class TextMassive extends StatelessWidget {
  const TextMassive({
    super.key,
    required this.text,
    this.color,
  });

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: Theme.of(context).textTheme.displayLarge!.copyWith(
              color: color ?? Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ));
  }
}

class TextHeadline extends StatelessWidget {
  const TextHeadline({
    super.key,
    required this.text,
    this.color,
  });

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(color: color, fontSize: 18));
  }
}

class TextSubHeadline extends StatelessWidget {
  const TextSubHeadline({
    super.key,
    required this.text,
    this.color,
    this.fontWeight = FontWeight.bold,
    this.maxLines,
    this.decoration,
  });

  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
          color: color,
          fontWeight: fontWeight,
          fontSize: 15,
          decoration: decoration),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class TextBody extends StatelessWidget {
  const TextBody({
    super.key,
    required this.text,
    this.color,
    this.fontWeight,
    this.decoration,
    this.maxLines,
    this.margin,
    this.textAlign,
  });

  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final TextDecoration? decoration;
  final int? maxLines;
  final EdgeInsetsGeometry? margin;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Text(
        text,
        maxLines: maxLines,
        textAlign: textAlign,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: color,
              fontWeight: fontWeight,
              decoration: decoration,
              fontSize: 15,
            ),
      ),
    );
  }
}
