"use client"

import type React from "react"

import { useState, useRef, useEffect } from "react"
import { Send, Bot, User, WifiOff } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Textarea } from "@/components/ui/textarea"
import { ScrollArea } from "@/components/ui/scroll-area"
import { updateChat, getApiKey, type Chat, type Message } from "@/lib/storage"
import { streamText } from "ai"
import { getProviderModel } from "@/lib/ai-providers"
import ReactMarkdown from "react-markdown"
import { CapacitorService } from "@/lib/capacitor"
import { localAI } from "@/lib/local-ai"

interface ChatInterfaceProps {
  chat: Chat
  onUpdateChat: (chat: Chat) => void
}

export function ChatInterface({ chat, onUpdateChat }: ChatInterfaceProps) {
  const [input, setInput] = useState("")
  const [isLoading, setIsLoading] = useState(false)
  const [streamingMessage, setStreamingMessage] = useState("")
  const [isOnline, setIsOnline] = useState(true)
  const scrollAreaRef = useRef<HTMLDivElement>(null)
  const textareaRef = useRef<HTMLTextAreaElement>(null)

  useEffect(() => {
    if (scrollAreaRef.current) {
      scrollAreaRef.current.scrollTop = scrollAreaRef.current.scrollHeight
    }
  }, [chat.messages, streamingMessage])

  useEffect(() => {
    // Check online status
    const updateOnlineStatus = () => setIsOnline(navigator.onLine)
    window.addEventListener("online", updateOnlineStatus)
    window.addEventListener("offline", updateOnlineStatus)

    return () => {
      window.removeEventListener("online", updateOnlineStatus)
      window.removeEventListener("offline", updateOnlineStatus)
    }
  }, [])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!input.trim() || isLoading) return

    // Check if we can proceed with the request
    const isLocalModel = chat.provider === "local"
    if (!isLocalModel && !isOnline) {
      alert("Internet connection required for online models. Use local models for offline chat.")
      return
    }

    // Add haptic feedback for native apps
    await CapacitorService.hapticFeedback()

    const userMessage: Message = {
      id: Date.now().toString(),
      role: "user",
      content: input.trim(),
      timestamp: new Date(),
    }

    const updatedChat = {
      ...chat,
      messages: [...chat.messages, userMessage],
      updatedAt: new Date(),
    }

    onUpdateChat(updatedChat)
    updateChat(updatedChat)
    setInput("")
    setIsLoading(true)
    setStreamingMessage("")

    try {
      if (isLocalModel) {
        // Handle local model chat
        await handleLocalChat(updatedChat)
      } else {
        // Handle online model chat
        await handleOnlineChat(updatedChat)
      }
    } catch (error) {
      console.error("Error:", error)
      alert("Error sending message. Please try again.")
    } finally {
      setIsLoading(false)
    }
  }

  const handleLocalChat = async (updatedChat: Chat) => {
    try {
      // Load the model if not already loaded
      if (!localAI.isModelLoaded(chat.model)) {
        await localAI.loadModel(chat.model)
      }

      const messages = updatedChat.messages.map((msg) => ({
        role: msg.role as "user" | "assistant",
        content: msg.content,
      }))

      const stream = await localAI.chat(messages)
      let fullResponse = ""

      for await (const delta of stream) {
        fullResponse += delta
        setStreamingMessage(fullResponse)
      }

      const assistantMessage: Message = {
        id: Date.now().toString(),
        role: "assistant",
        content: fullResponse,
        timestamp: new Date(),
      }

      const finalChat = {
        ...updatedChat,
        messages: [...updatedChat.messages, assistantMessage],
        updatedAt: new Date(),
      }

      // Update title if it's the first exchange
      if (finalChat.messages.length === 2) {
        finalChat.title =
          updatedChat.messages[0].content.slice(0, 50) + (updatedChat.messages[0].content.length > 50 ? "..." : "")
      }

      onUpdateChat(finalChat)
      updateChat(finalChat)
      setStreamingMessage("")
    } catch (error) {
      console.error("Error with local model:", error)
      throw error
    }
  }

  const handleOnlineChat = async (updatedChat: Chat) => {
    const apiKey = getApiKey(chat.provider)
    if (!apiKey) {
      alert(`Please add your ${chat.provider} API key in settings`)
      return
    }

    try {
      const model = getProviderModel(chat.provider, chat.model, apiKey)

      const result = await streamText({
        model,
        messages: updatedChat.messages.map((msg) => ({
          role: msg.role,
          content: msg.content,
        })),
      })

      let fullResponse = ""

      for await (const delta of result.textStream) {
        fullResponse += delta
        setStreamingMessage(fullResponse)
      }

      const assistantMessage: Message = {
        id: Date.now().toString(),
        role: "assistant",
        content: fullResponse,
        timestamp: new Date(),
      }

      const finalChat = {
        ...updatedChat,
        messages: [...updatedChat.messages, assistantMessage],
        updatedAt: new Date(),
      }

      // Update title if it's the first exchange
      if (finalChat.messages.length === 2) {
        finalChat.title =
          updatedChat.messages[0].content.slice(0, 50) + (updatedChat.messages[0].content.length > 50 ? "..." : "")
      }

      onUpdateChat(finalChat)
      updateChat(finalChat)
      setStreamingMessage("")
    } catch (error) {
      console.error("Error with online model:", error)
      throw error
    }
  }

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault()
      handleSubmit(e)
    }
  }

  const isLocalModel = chat.provider === "local"
  const canSendMessage = isLocalModel || isOnline

  return (
    <div className="flex flex-col h-full">
      {/* Messages */}
      <ScrollArea className="flex-1 p-4" ref={scrollAreaRef}>
        <div className="space-y-4 max-w-3xl mx-auto">
          {chat.messages.map((message) => (
            <div key={message.id} className={`flex gap-3 ${message.role === "user" ? "justify-end" : "justify-start"}`}>
              {message.role === "assistant" && (
                <div
                  className={`w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 ${
                    isLocalModel ? "bg-green-500" : "bg-blue-500"
                  }`}
                >
                  <Bot className="w-4 h-4 text-white" />
                </div>
              )}

              <div
                className={`max-w-[80%] rounded-2xl px-4 py-2 ${
                  message.role === "user"
                    ? "bg-blue-500 text-white"
                    : "bg-gray-100 dark:bg-gray-800 text-gray-900 dark:text-white"
                }`}
              >
                {message.role === "assistant" ? (
                  <ReactMarkdown className="prose prose-sm dark:prose-invert max-w-none">
                    {message.content}
                  </ReactMarkdown>
                ) : (
                  <p className="whitespace-pre-wrap">{message.content}</p>
                )}
              </div>

              {message.role === "user" && (
                <div className="w-8 h-8 rounded-full bg-gray-500 flex items-center justify-center flex-shrink-0">
                  <User className="w-4 h-4 text-white" />
                </div>
              )}
            </div>
          ))}

          {/* Streaming Message */}
          {streamingMessage && (
            <div className="flex gap-3 justify-start">
              <div
                className={`w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 ${
                  isLocalModel ? "bg-green-500" : "bg-blue-500"
                }`}
              >
                <Bot className="w-4 h-4 text-white" />
              </div>
              <div className="max-w-[80%] rounded-2xl px-4 py-2 bg-gray-100 dark:bg-gray-800 text-gray-900 dark:text-white">
                <ReactMarkdown className="prose prose-sm dark:prose-invert max-w-none">
                  {streamingMessage}
                </ReactMarkdown>
                <div
                  className={`inline-block w-2 h-4 animate-pulse ml-1 ${isLocalModel ? "bg-green-500" : "bg-blue-500"}`}
                />
              </div>
            </div>
          )}

          {/* Loading Indicator */}
          {isLoading && !streamingMessage && (
            <div className="flex gap-3 justify-start">
              <div
                className={`w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 ${
                  isLocalModel ? "bg-green-500" : "bg-blue-500"
                }`}
              >
                <Bot className="w-4 h-4 text-white" />
              </div>
              <div className="bg-gray-100 dark:bg-gray-800 rounded-2xl px-4 py-2">
                <div className="flex gap-1">
                  <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" />
                  <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{ animationDelay: "0.1s" }} />
                  <div className="w-2 h-2 bg-gray-400 rounded-full animate-bounce" style={{ animationDelay: "0.2s" }} />
                </div>
              </div>
            </div>
          )}
        </div>
      </ScrollArea>

      {/* Connection Status */}
      {!canSendMessage && (
        <div className="px-4 py-2 bg-orange-50 dark:bg-orange-900/20 border-t border-orange-200 dark:border-orange-800">
          <div className="flex items-center gap-2 text-sm text-orange-700 dark:text-orange-300">
            <WifiOff className="w-4 h-4" />
            Offline - Switch to local models to continue chatting
          </div>
        </div>
      )}

      {/* Input Area */}
      <div className="border-t border-gray-200 dark:border-gray-700 p-4">
        <form onSubmit={handleSubmit} className="max-w-3xl mx-auto">
          <div className="flex gap-2 items-end">
            <div className="flex-1 relative">
              <Textarea
                ref={textareaRef}
                value={input}
                onChange={(e) => setInput(e.target.value)}
                onKeyDown={handleKeyDown}
                placeholder={canSendMessage ? "Type your message..." : "Go online or use local models to chat"}
                className="min-h-[44px] max-h-32 resize-none pr-12"
                disabled={isLoading || !canSendMessage}
              />
            </div>
            <Button
              type="submit"
              size="icon"
              disabled={!input.trim() || isLoading || !canSendMessage}
              className="h-11 w-11 rounded-full"
            >
              <Send className="w-4 h-4" />
            </Button>
          </div>
        </form>
      </div>
    </div>
  )
}
