import React from "react";
import { Text, TextProps } from "react-native";
import useThemeStore from "@/store/useThemeStore";
import colors from "@/constants/colors";

interface ThemedTextProps extends TextProps {
  variant?: "default" | "title" | "subtitle" | "small";
}

export default function ThemedText({ style, variant = "default", ...props }: ThemedTextProps) {
  const { isDarkMode } = useThemeStore();
  const theme = isDarkMode ? colors.dark : colors.light;

  let variantStyle = {};

  switch (variant) {
    case "title":
      variantStyle = { fontSize: 20, fontWeight: "bold" };
      break;
    case "subtitle":
      variantStyle = { fontSize: 16, color: theme.subtext };
      break;
    case "small":
      variantStyle = { fontSize: 12, color: theme.subtext };
      break;
    default:
      variantStyle = { fontSize: 14 };
  }

  return <Text style={[{ color: theme.text }, variantStyle, style]} {...props} />;
}
