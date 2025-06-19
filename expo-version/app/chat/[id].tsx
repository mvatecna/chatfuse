import React, { useRef, useEffect } from "react";
import { StyleSheet, FlatList, View } from "react-native";
import { useLocalSearchParams } from "expo-router";
import ThemedView from "@/components/ThemedView";
import ChatMessage from "@/components/ChatMessage";
import ChatInput from "@/components/ChatInput";
import useChatStore from "@/store/useChatStore";
import { Message } from "@/types/chat";

export default function ChatScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const { getChat, setActiveChat } = useChatStore();
  const chat = getChat(id);
  const flatListRef = useRef<FlatList<Message>>(null);

  useEffect(() => {
    if (id) {
      setActiveChat(id);
    }

    return () => {
      setActiveChat(null);
    };
  }, [id, setActiveChat]);

  const scrollToBottom = () => {
    if (flatListRef.current && chat?.messages.length) {
      flatListRef.current.scrollToEnd({ animated: true });
    }
  };

  if (!chat) {
    return (
      <ThemedView style={styles.container}>
        <View style={styles.centerContent}>
          <ThemedView style={styles.errorContainer}>
            <ThemedView.Text style={styles.errorText}>Chat not found</ThemedView.Text>
          </ThemedView>
        </View>
      </ThemedView>
    );
  }

  return (
    <ThemedView style={styles.container}>
      <FlatList
        ref={flatListRef}
        data={chat.messages}
        renderItem={({ item }) => <ChatMessage message={item} />}
        keyExtractor={(item) => item.id}
        contentContainerStyle={styles.messageList}
        onLayout={scrollToBottom}
      />

      <ChatInput chatId={id} onSend={scrollToBottom} />
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  messageList: {
    paddingTop: 16,
    paddingBottom: 16,
  },
  centerContent: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    padding: 20,
  },
  errorContainer: {
    padding: 16,
    borderRadius: 8,
    backgroundColor: "rgba(255, 0, 0, 0.1)",
  },
  errorText: {
    color: "red",
  },
});
