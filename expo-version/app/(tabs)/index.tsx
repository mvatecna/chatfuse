import React from "react";
import { StyleSheet, FlatList, View, TouchableOpacity } from "react-native";
import { useRouter } from "expo-router";
import { PlusCircle } from "lucide-react-native";
import ThemedView from "@/components/ThemedView";
import ThemedText from "@/components/ThemedText";
import ChatListItem from "@/components/ChatListItem";
import useChatStore from "@/store/useChatStore";
import useThemeStore from "@/store/useThemeStore";
import colors from "@/constants/colors";

export default function ChatsScreen() {
  const router = useRouter();
  const { chats } = useChatStore();
  const { isDarkMode } = useThemeStore();
  const theme = isDarkMode ? colors.dark : colors.light;

  const handleNewChat = () => {
    router.push("/new-chat");
  };

  return (
    <ThemedView style={styles.container}>
      {chats.length > 0 ? (
        <FlatList
          data={chats}
          renderItem={({ item }) => <ChatListItem chat={item} />}
          keyExtractor={(item) => item.id}
          contentContainerStyle={styles.listContent}
        />
      ) : (
        <View style={styles.emptyContainer}>
          <ThemedText variant="title" style={styles.emptyTitle}>
            No chats yet
          </ThemedText>
          <ThemedText variant="subtitle" style={styles.emptySubtitle}>
            Start a new conversation with an AI model
          </ThemedText>
          <TouchableOpacity style={[styles.newChatButton, { backgroundColor: theme.primary }]} onPress={handleNewChat}>
            <PlusCircle size={20} color="#fff" />
            <ThemedText style={styles.newChatButtonText}>New Chat</ThemedText>
          </TouchableOpacity>
        </View>
      )}

      {chats.length > 0 && (
        <TouchableOpacity style={[styles.fab, { backgroundColor: theme.primary }]} onPress={handleNewChat}>
          <PlusCircle size={24} color="#fff" />
        </TouchableOpacity>
      )}
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  listContent: {
    paddingBottom: 80,
  },
  emptyContainer: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    padding: 20,
  },
  emptyTitle: {
    marginBottom: 8,
  },
  emptySubtitle: {
    textAlign: "center",
    marginBottom: 24,
  },
  newChatButton: {
    flexDirection: "row",
    alignItems: "center",
    paddingHorizontal: 20,
    paddingVertical: 12,
    borderRadius: 24,
  },
  newChatButtonText: {
    color: "#fff",
    fontWeight: "bold",
    marginLeft: 8,
  },
  fab: {
    position: "absolute",
    bottom: 24,
    right: 24,
    width: 56,
    height: 56,
    borderRadius: 28,
    justifyContent: "center",
    alignItems: "center",
    elevation: 5,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
  },
});
