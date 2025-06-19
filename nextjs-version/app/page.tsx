"use client"

import { useState, useEffect } from "react"
import { Plus, Settings, MessageSquare } from "lucide-react"
import { Button } from "@/components/ui/button"
import { ChatInterface } from "@/components/chat-interface"
import { ChatHistory } from "@/components/chat-history"
import { ModelSelector } from "@/components/model-selector"
import { getChats, createChat, deleteChat, type Chat } from "@/lib/storage"
import Link from "next/link"

export default function HomePage() {
  const [chats, setChats] = useState<Chat[]>([])
  const [activeChat, setActiveChat] = useState<Chat | null>(null)
  const [showHistory, setShowHistory] = useState(false)
  const [showModelSelector, setShowModelSelector] = useState(false)

  useEffect(() => {
    const loadChats = () => {
      const savedChats = getChats()
      setChats(savedChats)
      if (savedChats.length > 0 && !activeChat) {
        setActiveChat(savedChats[0])
      }
    }
    loadChats()
  }, [])

  const handleNewChat = (provider: string, model: string) => {
    const newChat = createChat(provider, model)
    setChats((prev) => [newChat, ...prev])
    setActiveChat(newChat)
    setShowModelSelector(false)
  }

  const handleDeleteChat = (chatId: string) => {
    deleteChat(chatId)
    const updatedChats = getChats()
    setChats(updatedChats)
    if (activeChat?.id === chatId) {
      setActiveChat(updatedChats[0] || null)
    }
  }

  const handleSelectChat = (chat: Chat) => {
    setActiveChat(chat)
    setShowHistory(false)
  }

  if (!activeChat && chats.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center min-h-screen bg-gray-50 dark:bg-gray-900 p-4">
        <div className="text-center mb-8">
          <MessageSquare className="w-16 h-16 text-gray-400 mx-auto mb-4" />
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">Welcome to ChatFuse</h1>
          <p className="text-gray-600 dark:text-gray-400 max-w-md">
            Start chatting with AI models from various providers. Add your API keys in settings to get started.
          </p>
        </div>

        <div className="flex gap-4">
          <Button onClick={() => setShowModelSelector(true)} className="flex items-center gap-2">
            <Plus className="w-4 h-4" />
            New Chat
          </Button>

          <Link href="/settings">
            <Button variant="outline" className="flex items-center gap-2">
              <Settings className="w-4 h-4" />
              Settings
            </Button>
          </Link>
        </div>

        <ModelSelector open={showModelSelector} onClose={() => setShowModelSelector(false)} onSelect={handleNewChat} />
      </div>
    )
  }

  return (
    <div className="flex h-screen bg-white dark:bg-gray-900">
      {/* Chat History Sidebar */}
      <ChatHistory
        chats={chats}
        activeChat={activeChat}
        onSelectChat={handleSelectChat}
        onDeleteChat={handleDeleteChat}
        open={showHistory}
        onClose={() => setShowHistory(false)}
      />

      {/* Main Chat Area */}
      <div className="flex-1 flex flex-col">
        {/* Header */}
        <div className="flex items-center justify-between p-4 border-b border-gray-200 dark:border-gray-700">
          <div className="flex items-center gap-3">
            <Button variant="ghost" size="sm" onClick={() => setShowHistory(true)} className="md:hidden">
              <MessageSquare className="w-4 h-4" />
            </Button>
            <div>
              <h2 className="font-semibold text-gray-900 dark:text-white">{activeChat?.title || "New Chat"}</h2>
              <p className="text-sm text-gray-500 dark:text-gray-400">
                {activeChat?.provider} • {activeChat?.model}
              </p>
            </div>
          </div>

          <div className="flex items-center gap-2">
            <Button variant="ghost" size="sm" onClick={() => setShowModelSelector(true)}>
              <Plus className="w-4 h-4" />
            </Button>
            <Link href="/settings">
              <Button variant="ghost" size="sm">
                <Settings className="w-4 h-4" />
              </Button>
            </Link>
          </div>
        </div>

        {/* Chat Interface */}
        {activeChat && (
          <ChatInterface
            chat={activeChat}
            onUpdateChat={(updatedChat) => {
              setActiveChat(updatedChat)
              setChats((prev) => prev.map((c) => (c.id === updatedChat.id ? updatedChat : c)))
            }}
          />
        )}
      </div>

      {/* Model Selector Modal */}
      <ModelSelector open={showModelSelector} onClose={() => setShowModelSelector(false)} onSelect={handleNewChat} />

      {/* Floating New Chat Button (Mobile) */}
      <Button
        onClick={() => setShowModelSelector(true)}
        className="fixed bottom-6 right-6 rounded-full w-14 h-14 shadow-lg md:hidden"
        size="icon"
      >
        <Plus className="w-6 h-6" />
      </Button>
    </div>
  )
}
