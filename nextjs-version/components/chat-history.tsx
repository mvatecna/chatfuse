"use client"

import { MessageSquare, Trash2 } from "lucide-react"
import { Button } from "@/components/ui/button"
import { ScrollArea } from "@/components/ui/scroll-area"
import { Sheet, SheetContent, SheetHeader, SheetTitle } from "@/components/ui/sheet"
import type { Chat } from "@/lib/storage"
import { formatDistanceToNow } from "date-fns"

interface ChatHistoryProps {
  chats: Chat[]
  activeChat: Chat | null
  onSelectChat: (chat: Chat) => void
  onDeleteChat: (chatId: string) => void
  open: boolean
  onClose: () => void
}

export function ChatHistory({ chats, activeChat, onSelectChat, onDeleteChat, open, onClose }: ChatHistoryProps) {
  return (
    <>
      {/* Desktop Sidebar */}
      <div className="hidden md:flex w-80 border-r border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-800 flex-col">
        <div className="p-4 border-b border-gray-200 dark:border-gray-700">
          <h2 className="font-semibold text-gray-900 dark:text-white">Chat History</h2>
        </div>

        <ScrollArea className="flex-1">
          <div className="p-2 space-y-1">
            {chats.map((chat) => (
              <div
                key={chat.id}
                className={`group flex items-center gap-3 p-3 rounded-lg cursor-pointer transition-colors ${
                  activeChat?.id === chat.id
                    ? "bg-blue-100 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800"
                    : "hover:bg-gray-100 dark:hover:bg-gray-700"
                }`}
                onClick={() => onSelectChat(chat)}
              >
                <MessageSquare className="w-4 h-4 text-gray-500 flex-shrink-0" />
                <div className="flex-1 min-w-0">
                  <p className="font-medium text-sm text-gray-900 dark:text-white truncate">{chat.title}</p>
                  <p className="text-xs text-gray-500 dark:text-gray-400">
                    {chat.provider} • {formatDistanceToNow(new Date(chat.updatedAt), { addSuffix: true })}
                  </p>
                </div>
                <Button
                  variant="ghost"
                  size="sm"
                  className="opacity-0 group-hover:opacity-100 transition-opacity"
                  onClick={(e) => {
                    e.stopPropagation()
                    onDeleteChat(chat.id)
                  }}
                >
                  <Trash2 className="w-4 h-4" />
                </Button>
              </div>
            ))}
          </div>
        </ScrollArea>
      </div>

      {/* Mobile Sheet */}
      <Sheet open={open} onOpenChange={onClose}>
        <SheetContent side="left" className="w-80">
          <SheetHeader>
            <SheetTitle>Chat History</SheetTitle>
          </SheetHeader>

          <ScrollArea className="flex-1 mt-4">
            <div className="space-y-1">
              {chats.map((chat) => (
                <div
                  key={chat.id}
                  className={`group flex items-center gap-3 p-3 rounded-lg cursor-pointer transition-colors ${
                    activeChat?.id === chat.id
                      ? "bg-blue-100 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800"
                      : "hover:bg-gray-100 dark:hover:bg-gray-700"
                  }`}
                  onClick={() => {
                    onSelectChat(chat)
                    onClose()
                  }}
                >
                  <MessageSquare className="w-4 h-4 text-gray-500 flex-shrink-0" />
                  <div className="flex-1 min-w-0">
                    <p className="font-medium text-sm text-gray-900 dark:text-white truncate">{chat.title}</p>
                    <p className="text-xs text-gray-500 dark:text-gray-400">
                      {chat.provider} • {formatDistanceToNow(new Date(chat.updatedAt), { addSuffix: true })}
                    </p>
                  </div>
                  <Button
                    variant="ghost"
                    size="sm"
                    className="opacity-0 group-hover:opacity-100 transition-opacity"
                    onClick={(e) => {
                      e.stopPropagation()
                      onDeleteChat(chat.id)
                    }}
                  >
                    <Trash2 className="w-4 h-4" />
                  </Button>
                </div>
              ))}
            </div>
          </ScrollArea>
        </SheetContent>
      </Sheet>
    </>
  )
}
