import React from "react";
import { StyleSheet, View } from "react-native";
import { Message } from "@/types/chat";
import ThemedText from "./ThemedText";
import ThemedView from "./ThemedView";
import useThemeStore from "@/store/useThemeStore";
import colors from "@/constants/colors";
import { User, Bot } from "lucide-react-native";

interface ChatMessageProps {
  message: Message;
}

export default function ChatMessage({ message }: ChatMessageProps) {
  const { isDarkMode } = useThemeStore();
  const theme = isDarkMode ? colors.dark : colors.light;

  const isUser = message.role === "user";

  return (
    <View style={styles.container}>
      <View style={styles.avatarContainer}>
        {isUser ? (
          <View style={[styles.avatar, { backgroundColor: theme.primary }]}>
            <User size={16} color="#fff" />
          </View>
        ) : (
          <View style={[styles.avatar, { backgroundColor: theme.secondary }]}>
            <Bot size={16} color="#fff" />
          </View>
        )}
      </View>

      <View style={styles.messageContainer}>
        <ThemedView
          style={styles.messageBubble}
          darkColor={isUser ? theme.messageUser : theme.messageBot}
          lightColor={isUser ? theme.messageUser : theme.messageBot}
        >
          <ThemedText>{message.content}</ThemedText>
        </ThemedView>

        <ThemedText variant="small" style={styles.timestamp}>
          {new Date(message.timestamp).toLocaleTimeString([], {
            hour: "2-digit",
            minute: "2-digit",
          })}
        </ThemedText>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: "row",
    marginVertical: 8,
    paddingHorizontal: 16,
  },
  avatarContainer: {
    marginRight: 12,
    alignItems: "center",
    justifyContent: "flex-start",
  },
  avatar: {
    width: 32,
    height: 32,
    borderRadius: 16,
    alignItems: "center",
    justifyContent: "center",
  },
  messageContainer: {
    flex: 1,
  },
  messageBubble: {
    padding: 12,
    borderRadius: 16,
    maxWidth: "100%",
  },
  timestamp: {
    marginTop: 4,
    alignSelf: "flex-start",
  },
});
