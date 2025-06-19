export interface Message {
  id: string
  role: "user" | "assistant"
  content: string
  timestamp: Date
}

export interface Chat {
  id: string
  title: string
  provider: string
  model: string
  messages: Message[]
  createdAt: Date
  updatedAt: Date
}

const STORAGE_KEYS = {
  CHATS: "chatfuse_chats",
  API_KEYS: "chatfuse_api_keys",
}

// Chat management
export function getChats(): Chat[] {
  if (typeof window === "undefined") return []

  try {
    const chats = localStorage.getItem(STORAGE_KEYS.CHATS)
    if (!chats) return []

    return JSON.parse(chats).map((chat: any) => ({
      ...chat,
      createdAt: new Date(chat.createdAt),
      updatedAt: new Date(chat.updatedAt),
      messages: chat.messages.map((msg: any) => ({
        ...msg,
        timestamp: new Date(msg.timestamp),
      })),
    }))
  } catch (error) {
    console.error("Error loading chats:", error)
    return []
  }
}

export function createChat(provider: string, model: string): Chat {
  const chat: Chat = {
    id: Date.now().toString(),
    title: "New Chat",
    provider,
    model,
    messages: [],
    createdAt: new Date(),
    updatedAt: new Date(),
  }

  const chats = getChats()
  chats.unshift(chat)
  saveChats(chats)

  return chat
}

export function updateChat(updatedChat: Chat): void {
  const chats = getChats()
  const index = chats.findIndex((chat) => chat.id === updatedChat.id)

  if (index !== -1) {
    chats[index] = updatedChat
    saveChats(chats)
  }
}

export function deleteChat(chatId: string): void {
  const chats = getChats().filter((chat) => chat.id !== chatId)
  saveChats(chats)
}

function saveChats(chats: Chat[]): void {
  if (typeof window === "undefined") return

  try {
    localStorage.setItem(STORAGE_KEYS.CHATS, JSON.stringify(chats))
  } catch (error) {
    console.error("Error saving chats:", error)
  }
}

// API Key management
export function getApiKey(provider: string): string | null {
  if (typeof window === "undefined") return null

  try {
    const keys = localStorage.getItem(STORAGE_KEYS.API_KEYS)
    if (!keys) return null

    const parsedKeys = JSON.parse(keys)
    return parsedKeys[provider] || null
  } catch (error) {
    console.error("Error loading API key:", error)
    return null
  }
}

export function setApiKey(provider: string, key: string): void {
  if (typeof window === "undefined") return

  try {
    const keys = localStorage.getItem(STORAGE_KEYS.API_KEYS)
    const parsedKeys = keys ? JSON.parse(keys) : {}

    parsedKeys[provider] = key
    localStorage.setItem(STORAGE_KEYS.API_KEYS, JSON.stringify(parsedKeys))
  } catch (error) {
    console.error("Error saving API key:", error)
  }
}

export function removeApiKey(provider: string): void {
  if (typeof window === "undefined") return

  try {
    const keys = localStorage.getItem(STORAGE_KEYS.API_KEYS)
    if (!keys) return

    const parsedKeys = JSON.parse(keys)
    delete parsedKeys[provider]
    localStorage.setItem(STORAGE_KEYS.API_KEYS, JSON.stringify(parsedKeys))
  } catch (error) {
    console.error("Error removing API key:", error)
  }
}
