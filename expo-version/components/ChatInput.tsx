import React, { useState } from "react";
import { StyleSheet, TextInput, TouchableOpacity, View, Keyboard } from "react-native";
import { Send } from "lucide-react-native";
import useThemeStore from "@/store/useThemeStore";
import colors from "@/constants/colors";
import ThemedView from "./ThemedView";
import useChatStore from "@/store/useChatStore";
import useApiKeyStore from "@/store/useApiKeyStore";
import { Message } from "@/types/chat";

interface ChatInputProps {
  chatId: string;
  onSend?: () => void;
}

export default function ChatInput({ chatId, onSend }: ChatInputProps) {
  const [message, setMessage] = useState("");
  const { isDarkMode } = useThemeStore();
  const theme = isDarkMode ? colors.dark : colors.light;
  const { addMessage, getChat } = useChatStore();
  const { getApiKey } = useApiKeyStore();

  const handleSend = async () => {
    if (!message.trim()) return;

    const chat = getChat(chatId);
    if (!chat) return;

    const apiKey = getApiKey(chat.providerId);
    if (!apiKey) {
      // Handle missing API key
      const errorMessage: Message = {
        id: Date.now().toString(),
        role: "assistant",
        content: `Please add an API key for ${chat.providerId} in Settings to use this model.`,
        timestamp: Date.now(),
      };
      addMessage(chatId, errorMessage);
      setMessage("");
      Keyboard.dismiss();
      if (onSend) onSend();
      return;
    }

    // Add user message
    const userMessage: Message = {
      id: Date.now().toString(),
      role: "user",
      content: message.trim(),
      timestamp: Date.now(),
    };
    addMessage(chatId, userMessage);
    setMessage("");

    // Simulate AI response for now
    // In a real app, you would call the AI API here
    setTimeout(() => {
      const assistantMessage: Message = {
        id: (Date.now() + 1).toString(),
        role: "assistant",
        content: `This is a simulated response to: "${message.trim()}".\n\nIn a real app, this would call the ${
          chat.providerId
        } API with the ${chat.modelId} model.`,
        timestamp: Date.now() + 1,
      };
      addMessage(chatId, assistantMessage);
      if (onSend) onSend();
    }, 1000);

    Keyboard.dismiss();
    if (onSend) onSend();
  };

  return (
    <ThemedView style={styles.container} darkColor={theme.card} lightColor={theme.card}>
      <ThemedView style={styles.inputContainer} darkColor={theme.inputBackground} lightColor={theme.inputBackground}>
        <TextInput
          style={[styles.input, { color: theme.text }]}
          placeholder="Type a message..."
          placeholderTextColor={theme.subtext}
          value={message}
          onChangeText={setMessage}
          multiline
          maxLength={4000}
        />
      </ThemedView>

      <TouchableOpacity
        style={[styles.sendButton, { backgroundColor: message.trim() ? theme.primary : theme.border }]}
        onPress={handleSend}
        disabled={!message.trim()}
      >
        <Send size={20} color="#fff" />
      </TouchableOpacity>
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: "row",
    alignItems: "center",
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderTopWidth: 1,
    borderTopColor: "rgba(0,0,0,0.1)",
  },
  inputContainer: {
    flex: 1,
    borderRadius: 20,
    marginRight: 8,
  },
  input: {
    paddingHorizontal: 16,
    paddingVertical: 10,
    maxHeight: 120,
  },
  sendButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    alignItems: "center",
    justifyContent: "center",
  },
});
