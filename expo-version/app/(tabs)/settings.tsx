import React from "react";
import { StyleSheet, ScrollView, Switch, View, TouchableOpacity } from "react-native";
import { Moon, Sun, Key } from "lucide-react-native";
import ThemedView from "@/components/ThemedView";
import ThemedText from "@/components/ThemedText";
import ApiKeyItem from "@/components/ApiKeyItem";
import useThemeStore from "@/store/useThemeStore";
import colors from "@/constants/colors";
import providers from "@/constants/providers";

export default function SettingsScreen() {
  const { isDarkMode, toggleTheme } = useThemeStore();
  const theme = isDarkMode ? colors.dark : colors.light;

  return (
    <ThemedView style={styles.container}>
      <ScrollView contentContainerStyle={styles.content}>
        <View style={styles.section}>
          <ThemedText variant="title" style={styles.sectionTitle}>
            Appearance
          </ThemedText>

          <ThemedView style={styles.settingItem} darkColor={theme.card} lightColor={theme.card}>
            <View style={styles.settingContent}>
              {isDarkMode ? <Moon size={20} color={theme.text} /> : <Sun size={20} color={theme.text} />}
              <ThemedText style={styles.settingText}>Dark Mode</ThemedText>
            </View>

            <Switch
              value={isDarkMode}
              onValueChange={toggleTheme}
              trackColor={{ false: "#767577", true: theme.primary }}
              thumbColor="#f4f3f4"
            />
          </ThemedView>
        </View>

        <View style={styles.section}>
          <ThemedText variant="title" style={styles.sectionTitle}>
            API Keys
          </ThemedText>

          <ThemedText variant="subtitle" style={styles.apiKeysDescription}>
            Add your API keys to use different AI providers. Your keys are stored securely on your device.
          </ThemedText>

          {providers.map((provider) => (
            <ApiKeyItem key={provider.id} provider={provider} />
          ))}
        </View>

        <View style={styles.section}>
          <ThemedText variant="title" style={styles.sectionTitle}>
            About
          </ThemedText>

          <ThemedView style={styles.aboutContainer} darkColor={theme.card} lightColor={theme.card}>
            <ThemedText style={styles.appName}>ChatFuse</ThemedText>
            <ThemedText variant="subtitle">Version 1.0.0</ThemedText>
            <ThemedText variant="small" style={styles.copyright}>
              © 2025 ChatFuse. All rights reserved.
            </ThemedText>
          </ThemedView>
        </View>
      </ScrollView>
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  content: {
    padding: 16,
  },
  section: {
    marginBottom: 24,
  },
  sectionTitle: {
    marginBottom: 12,
  },
  settingItem: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderRadius: 12,
  },
  settingContent: {
    flexDirection: "row",
    alignItems: "center",
  },
  settingText: {
    marginLeft: 12,
  },
  apiKeysDescription: {
    marginBottom: 16,
  },
  aboutContainer: {
    padding: 16,
    borderRadius: 12,
    alignItems: "center",
  },
  appName: {
    fontSize: 24,
    fontWeight: "bold",
    marginBottom: 4,
  },
  copyright: {
    marginTop: 8,
  },
});
