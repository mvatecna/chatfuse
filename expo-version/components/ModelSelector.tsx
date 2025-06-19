import React, { useState } from "react";
import { StyleSheet, TouchableOpacity, View, FlatList } from "react-native";
import { ChevronDown } from "lucide-react-native";
import ThemedText from "./ThemedText";
import ThemedView from "./ThemedView";
import useThemeStore from "@/store/useThemeStore";
import colors from "@/constants/colors";
import providers, { AIModel } from "@/constants/providers";

interface ModelSelectorProps {
  providerId: string;
  selectedModelId: string;
  onSelect: (modelId: string) => void;
}

export default function ModelSelector({ providerId, selectedModelId, onSelect }: ModelSelectorProps) {
  const [isOpen, setIsOpen] = useState(false);
  const { isDarkMode } = useThemeStore();
  const theme = isDarkMode ? colors.dark : colors.light;

  const provider = providers.find((p) => p.id === providerId);
  const models = provider?.models || [];
  const selectedModel = models.find((m) => m.id === selectedModelId) || models[0];

  const toggleDropdown = () => {
    setIsOpen(!isOpen);
  };

  const handleSelect = (modelId: string) => {
    onSelect(modelId);
    setIsOpen(false);
  };

  const renderItem = ({ item }: { item: AIModel }) => {
    const isSelected = item.id === selectedModelId;

    return (
      <TouchableOpacity
        style={[styles.item, isSelected && { backgroundColor: isDarkMode ? "#2A2A2A" : "#F0F0F5" }]}
        onPress={() => handleSelect(item.id)}
      >
        <View>
          <ThemedText style={{ fontWeight: isSelected ? "bold" : "normal" }}>{item.name}</ThemedText>
          <ThemedText variant="small">{item.description}</ThemedText>
        </View>
      </TouchableOpacity>
    );
  };

  return (
    <View style={styles.container}>
      <TouchableOpacity onPress={toggleDropdown}>
        <ThemedView style={styles.button} darkColor={theme.card} lightColor={theme.card}>
          <ThemedText style={styles.buttonText}>{selectedModel?.name || "Select Model"}</ThemedText>
          <ChevronDown size={16} color={theme.text} />
        </ThemedView>
      </TouchableOpacity>

      {isOpen && (
        <ThemedView style={styles.dropdown} darkColor={theme.card} lightColor={theme.card}>
          <FlatList data={models} renderItem={renderItem} keyExtractor={(item) => item.id} />
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
    paddingHorizontal: 12,
    paddingVertical: 10,
  },
});
