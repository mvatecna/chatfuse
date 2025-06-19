import React, { useState } from "react";
import { StyleSheet, TouchableOpacity, View, TextInput } from "react-native";
import { Eye, EyeOff, Save, Trash2 } from "lucide-react-native";
import ThemedText from "./ThemedText";
import ThemedView from "./ThemedView";
import useThemeStore from "@/store/useThemeStore";
import colors from "@/constants/colors";
import { Provider } from "@/constants/providers";
import useApiKeyStore from "@/store/useApiKeyStore";
import * as Haptics from "expo-haptics";
import { Platform } from "react-native";

interface ApiKeyItemProps {
  provider: Provider;
}

export default function ApiKeyItem({ provider }: ApiKeyItemProps) {
  const { isDarkMode } = useThemeStore();
  const theme = isDarkMode ? colors.dark : colors.light;
  const { getApiKey, updateApiKey, deleteApiKey } = useApiKeyStore();

  const [apiKey, setApiKey] = useState(getApiKey(provider.id) || "");
  const [isEditing, setIsEditing] = useState(!getApiKey(provider.id));
  const [isVisible, setIsVisible] = useState(false);

  const handleSave = () => {
    if (apiKey.trim()) {
      updateApiKey(provider.id, apiKey.trim());
      if (Platform.OS !== "web") {
        Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success);
      }
    } else {
      deleteApiKey(provider.id);
    }
    setIsEditing(false);
    setIsVisible(false);
  };

  const handleDelete = () => {
    deleteApiKey(provider.id);
    setApiKey("");
    setIsEditing(true);
    if (Platform.OS !== "web") {
      Haptics.notificationAsync(Haptics.NotificationFeedbackType.Warning);
    }
  };

  const toggleVisibility = () => {
    setIsVisible(!isVisible);
  };

  return (
    <ThemedView style={styles.container} darkColor={theme.card} lightColor={theme.card}>
      <View style={styles.header}>
        <ThemedText variant="title">{provider.name}</ThemedText>

        {!isEditing && apiKey && (
          <View style={styles.actions}>
            <TouchableOpacity onPress={toggleVisibility} style={styles.actionButton}>
              {isVisible ? <EyeOff size={20} color={theme.subtext} /> : <Eye size={20} color={theme.subtext} />}
            </TouchableOpacity>

            <TouchableOpacity onPress={() => setIsEditing(true)} style={styles.actionButton}>
              <Save size={20} color={theme.primary} />
            </TouchableOpacity>

            <TouchableOpacity onPress={handleDelete} style={styles.actionButton}>
              <Trash2 size={20} color={theme.error} />
            </TouchableOpacity>
          </View>
        )}
      </View>

      {isEditing ? (
        <View style={styles.inputContainer}>
          <TextInput
            style={[styles.input, { color: theme.text, borderColor: theme.border }]}
            placeholder={provider.apiKeyPlaceholder}
            placeholderTextColor={theme.subtext}
            value={apiKey}
            onChangeText={setApiKey}
            autoCapitalize="none"
            autoCorrect={false}
          />

          <TouchableOpacity style={[styles.saveButton, { backgroundColor: theme.primary }]} onPress={handleSave}>
            <ThemedText style={{ color: "#fff", fontWeight: "bold" }}>Save</ThemedText>
          </TouchableOpacity>
        </View>
      ) : (
        <ThemedText style={styles.keyText}>
          {isVisible ? apiKey : apiKey ? "•".repeat(Math.min(apiKey.length, 20)) : "No API key set"}
        </ThemedText>
      )}
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: {
    borderRadius: 12,
    padding: 16,
    marginBottom: 16,
  },
  header: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    marginBottom: 12,
  },
  actions: {
    flexDirection: "row",
  },
  actionButton: {
    marginLeft: 12,
  },
  inputContainer: {
    flexDirection: "row",
  },
  input: {
    flex: 1,
    borderWidth: 1,
    borderRadius: 8,
    paddingHorizontal: 12,
    paddingVertical: 8,
    marginRight: 8,
  },
  saveButton: {
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 8,
    justifyContent: "center",
    alignItems: "center",
  },
  keyText: {
    fontFamily: Platform.OS === "ios" ? "Menlo" : "monospace",
  },
});
