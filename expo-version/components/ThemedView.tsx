import React from "react";
import { View, ViewProps } from "react-native";
import useThemeStore from "@/store/useThemeStore";
import colors from "@/constants/colors";

interface ThemedViewProps extends ViewProps {
  darkColor?: string;
  lightColor?: string;
}

export default function ThemedView({ style, darkColor, lightColor, ...props }: ThemedViewProps) {
  const { isDarkMode } = useThemeStore();
  const theme = isDarkMode ? colors.dark : colors.light;

  const backgroundColor = isDarkMode ? darkColor || theme.background : lightColor || theme.background;

  return <View style={[{ backgroundColor }, style]} {...props} />;
}
