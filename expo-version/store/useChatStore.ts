import { create } from "zustand";
import { persist, createJSONStorage } from "zustand/middleware";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { Chat, Message } from "@/types/chat";

interface ChatState {
  chats: Chat[];
  activeChat: string | null;
  createChat: (modelId: string, providerId: string) => string;
  addMessage: (chatId: string, message: Message) => void;
  updateChatTitle: (chatId: string, title: string) => void;
  deleteChat: (chatId: string) => void;
  setActiveChat: (chatId: string | null) => void;
  getChat: (chatId: string) => Chat | undefined;
}

const useChatStore = create<ChatState>()(
  persist(
    (set, get) => ({
      chats: [],
      activeChat: null,
      createChat: (modelId: string, providerId: string) => {
        const id = Date.now().toString();
        const newChat: Chat = {
          id,
          title: "New Chat",
          messages: [],
          modelId,
          providerId,
          createdAt: Date.now(),
          updatedAt: Date.now(),
        };

        set((state) => ({
          chats: [newChat, ...state.chats],
          activeChat: id,
        }));

        return id;
      },
      addMessage: (chatId: string, message: Message) => {
        set((state) => {
          const chatIndex = state.chats.findIndex((chat) => chat.id === chatId);
          if (chatIndex === -1) return state;

          const updatedChats = [...state.chats];
          const chat = { ...updatedChats[chatIndex] };

          // Add message to chat
          chat.messages = [...chat.messages, message];
          chat.updatedAt = Date.now();

          // Update chat title if it's the first user message
          if (chat.title === "New Chat" && message.role === "user") {
            const title = message.content.slice(0, 30) + (message.content.length > 30 ? "..." : "");
            chat.title = title;
          }

          updatedChats[chatIndex] = chat;

          return { chats: updatedChats };
        });
      },
      updateChatTitle: (chatId: string, title: string) => {
        set((state) => {
          const chatIndex = state.chats.findIndex((chat) => chat.id === chatId);
          if (chatIndex === -1) return state;

          const updatedChats = [...state.chats];
          updatedChats[chatIndex] = {
            ...updatedChats[chatIndex],
            title,
          };

          return { chats: updatedChats };
        });
      },
      deleteChat: (chatId: string) => {
        set((state) => {
          const updatedChats = state.chats.filter((chat) => chat.id !== chatId);
          const newActiveChat = state.activeChat === chatId ? (updatedChats.length > 0 ? updatedChats[0].id : null) : state.activeChat;

          return {
            chats: updatedChats,
            activeChat: newActiveChat,
          };
        });
      },
      setActiveChat: (chatId: string | null) => {
        set({ activeChat: chatId });
      },
      getChat: (chatId: string) => {
        return get().chats.find((chat) => chat.id === chatId);
      },
    }),
    {
      name: "chat-storage",
      storage: createJSONStorage(() => AsyncStorage),
    }
  )
);

export default useChatStore;
