import React, { useState } from "react";
import { StyleSheet, View, TouchableOpacity } from "react-native";
import { useRouter } from "expo-router";
import ThemedView from "@/components/ThemedView";
import ThemedText from "@/components/ThemedText";
import ProviderSelector from "@/components/ProviderSelector";
import ModelSelector from "@/components/ModelSelector";
import useChatStore from "@/store/useChatStore";
import useApiKeyStore from "@/store/useApiKeyStore";
import useThemeStore from "@/store/useThemeStore";
import colors from "@/constants/colors";
import providers from "@/constants/providers";

export default function NewChatScreen() {
  const router = useRouter();
  const { createChat } = useChatStore();
  const { getApiKey } = useApiKeyStore();
  const { isDarkMode } = useThemeStore();
  const theme = isDarkMode ? colors.dark : colors.light;

  const [selectedProviderId, setSelectedProviderId] = useState(providers[0].id);
  const provider = providers.find((p) => p.id === selectedProviderId) || providers[0];
  const [selectedModelId, setSelectedModelId] = useState(provider.models[0].id);

  const handleProviderChange = (providerId: string) => {
    setSelectedProviderId(providerId);
    const newProvider = providers.find((p) => p.id === providerId) || providers[0];
    setSelectedModelId(newProvider.models[0].id);
  };

  const handleModelChange = (modelId: string) => {
    setSelectedModelId(modelId);
  };

  const handleCreateChat = () => {
    const chatId = createChat(selectedModelId, selectedProviderId);
    router.push(`/chat/${chatId}`);
  };

  const hasApiKey = !!getApiKey(selectedProviderId);

  return (
    <ThemedView style={styles.container}>
      <View style={styles.content}>
        <ThemedText variant="title" style={styles.title}>
          Start a new chat
        </ThemedText>

        <ThemedText variant="subtitle" style={styles.subtitle}>
          Choose an AI provider and model
        </ThemedText>

        <View style={styles.selectors}>
          <ThemedText style={styles.label}>Provider</ThemedText>
          <ProviderSelector selectedProviderId={selectedProviderId} onSelect={handleProviderChange} />

          <ThemedText style={[styles.label, styles.modelLabel]}>Model</ThemedText>
          <ModelSelector providerId={selectedProviderId} selectedModelId={selectedModelId} onSelect={handleModelChange} />
        </View>

        {!hasApiKey && (
          <ThemedView style={styles.warningContainer} darkColor={isDarkMode ? "#2C2718" : "#FFF8E1"} lightColor="#FFF8E1">
            <ThemedText style={{ color: theme.warning }}>No API key found for {provider.name}. You can add it in Settings.</ThemedText>
          </ThemedView>
        )}
      </View>

      <View style={styles.footer}>
        <TouchableOpacity style={[styles.button, styles.cancelButton, { borderColor: theme.border }]} onPress={() => router.back()}>
          <ThemedText>Cancel</ThemedText>
        </TouchableOpacity>

        <TouchableOpacity style={[styles.button, styles.createButton, { backgroundColor: theme.primary }]} onPress={handleCreateChat}>
          <ThemedText style={{ color: "#fff", fontWeight: "bold" }}>Create Chat</ThemedText>
        </TouchableOpacity>
      </View>
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
  },
  content: {
    flex: 1,
  },
  title: {
    marginBottom: 8,
  },
  subtitle: {
    marginBottom: 24,
  },
  selectors: {
    marginBottom: 24,
  },
  label: {
    fontWeight: "500",
    marginBottom: 8,
  },
  modelLabel: {
    marginTop: 16,
  },
  warningContainer: {
    padding: 16,
    borderRadius: 8,
    marginTop: 16,
  },
  footer: {
    flexDirection: "row",
    justifyContent: "space-between",
    paddingTop: 16,
  },
  button: {
    flex: 1,
    paddingVertical: 12,
    borderRadius: 8,
    alignItems: "center",
    justifyContent: "center",
  },
  cancelButton: {
    marginRight: 8,
    borderWidth: 1,
  },
  createButton: {
    marginLeft: 8,
  },
});
