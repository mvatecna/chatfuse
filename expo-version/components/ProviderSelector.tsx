import React, { useState } from "react";
import { StyleSheet, TouchableOpacity, View, FlatList, Image } from "react-native";
import { ChevronDown } from "lucide-react-native";
import ThemedText from "./ThemedText";
import ThemedView from "./ThemedView";
import useThemeStore from "@/store/useThemeStore";
import colors from "@/constants/colors";
import providers, { Provider } from "@/constants/providers";
import useApiKeyStore from "@/store/useApiKeyStore";

interface ProviderSelectorProps {
  selectedProviderId: string;
  onSelect: (providerId: string) => void;
}

export default function ProviderSelector({ selectedProviderId, onSelect }: ProviderSelectorProps) {
  const [isOpen, setIsOpen] = useState(false);
  const { isDarkMode } = useThemeStore();
  const theme = isDarkMode ? colors.dark : colors.light;
  const { getApiKey } = useApiKeyStore();

  const selectedProvider = providers.find((p) => p.id === selectedProviderId) || providers[0];

  const toggleDropdown = () => {
    setIsOpen(!isOpen);
  };

  const handleSelect = (providerId: string) => {
    onSelect(providerId);
    setIsOpen(false);
  };

  const renderItem = ({ item }: { item: Provider }) => {
    const isSelected = item.id === selectedProviderId;
    const hasApiKey = !!getApiKey(item.id);

    return (
      <TouchableOpacity
        style={[styles.item, isSelected && { backgroundColor: isDarkMode ? "#2A2A2A" : "#F0F0F5" }]}
        onPress={() => handleSelect(item.id)}
      >
        <Image source={{ uri: item.logoUrl }} style={styles.logo} />
        <View style={styles.itemTextContainer}>
          <ThemedText style={{ fontWeight: isSelected ? "bold" : "normal" }}>{item.name}</ThemedText>
          {!hasApiKey && (
            <ThemedText variant="small" style={{ color: theme.error }}>
              No API key
            </ThemedText>
          )}
        </View>
      </TouchableOpacity>
    );
  };

  return (
    <View style={styles.container}>
      <TouchableOpacity onPress={toggleDropdown}>
        <ThemedView style={styles.button} darkColor={theme.card} lightColor={theme.card}>
          <Image source={{ uri: selectedProvider.logoUrl }} style={styles.logo} />
          <ThemedText style={styles.buttonText}>{selectedProvider.name}</ThemedText>
          <ChevronDown size={16} color={theme.text} />
        </ThemedView>
      </TouchableOpacity>

      {isOpen && (
        <ThemedView style={styles.dropdown} darkColor={theme.card} lightColor={theme.card}>
          <FlatList data={providers} renderItem={renderItem} keyExtractor={(item) => item.id} />
        </ThemedView>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    position: "relative",
    zIndex: 1,
  },
  button: {
    flexDirection: "row",
    alignItems: "center",
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: 8,
  },
  buttonText: {
    flex: 1,
    marginLeft: 8,
    fontWeight: "500",
  },
  dropdown: {
    position: "absolute",
    top: "100%",
    left: 0,
    right: 0,
    marginTop: 4,
    borderRadius: 8,
    elevation: 5,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    maxHeight: 200,
  },
  item: {
    flexDirection: "row",
    alignItems: "center",
    paddingHorizontal: 12,
    paddingVertical: 10,
  },
  itemTextContainer: {
    flex: 1,
    marginLeft: 8,
  },
  logo: {
    width: 24,
    height: 24,
    borderRadius: 12,
  },
});
