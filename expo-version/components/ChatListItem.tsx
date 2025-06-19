import React from "react";
import { StyleSheet, TouchableOpacity, View } from "react-native";
import { useRouter } from "expo-router";
import { MessageSquare, Trash2 } from "lucide-react-native";
import ThemedText from "./ThemedText";
import ThemedView from "./ThemedView";
import useThemeStore from "@/store/useThemeStore";
import colors from "@/constants/colors";
import { Chat } from "@/types/chat";
import useChatStore from "@/store/useChatStore";
import providers from "@/constants/providers";

interface ChatListItemProps {
  chat: Chat;
}

export default function ChatListItem({ chat }: ChatListItemProps) {
  const router = useRouter();
  const { isDarkMode } = useThemeStore();
  const theme = isDarkMode ? colors.dark : colors.light;
  const { deleteChat, activeChat } = useChatStore();

  const provider = providers.find((p) => p.id === chat.providerId);
  const model = provider?.models.find((m) => m.id === chat.modelId);

  const isActive = activeChat === chat.id;

  const handlePress = () => {
    router.push(`/chat/${chat.id}`);
  };

  const handleDelete = () => {
    deleteChat(chat.id);
  };

  return (
    <TouchableOpacity onPress={handlePress}>
      <ThemedView style={[styles.container, isActive && { backgroundColor: isDarkMode ? "#2A2A2A" : "#F0F0F5" }]}>
        <View style={styles.iconContainer}>
          <MessageSquare size={20} color={theme.primary} />
        </View>

        <View style={styles.contentContainer}>
          <ThemedText numberOfLines={1} style={styles.title}>
            {chat.title}
          </ThemedText>

          <ThemedText variant="small" numberOfLines={1}>
            {model?.name || "Unknown model"} • {new Date(chat.updatedAt).toLocaleDateString()}
          </ThemedText>
        </View>

        <TouchableOpacity style={styles.deleteButton} onPress={handleDelete} hitSlop={{ top: 10, right: 10, bottom: 10, left: 10 }}>
          <Trash2 size={18} color={theme.error} />
        </TouchableOpacity>
      </ThemedView>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: "row",
    alignItems: "center",
    paddingVertical: 12,
    paddingHorizontal: 16,
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: "rgba(0,0,0,0.1)",
  },
  iconContainer: {
    marginRight: 12,
  },
  contentContainer: {
    flex: 1,
  },
  title: {
    fontWeight: "500",
    marginBottom: 2,
  },
  deleteButton: {
    padding: 4,
  },
});
