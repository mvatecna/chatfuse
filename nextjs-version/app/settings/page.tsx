"use client"

import { useState, useEffect } from "react"
import { ArrowLeft, Key, Eye, EyeOff, Trash2 } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Switch } from "@/components/ui/switch"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { AI_PROVIDERS } from "@/lib/ai-providers"
import { getApiKey, setApiKey, removeApiKey } from "@/lib/storage"
import { LocalModelManager } from "@/components/local-model-manager"
import Link from "next/link"
import { CapacitorService } from "@/lib/capacitor"

export default function SettingsPage() {
  const [apiKeys, setApiKeys] = useState<Record<string, string>>({})
  const [showKeys, setShowKeys] = useState<Record<string, boolean>>({})
  const [darkMode, setDarkMode] = useState(false)

  useEffect(() => {
    // Load existing API keys (excluding local provider)
    const keys: Record<string, string> = {}
    AI_PROVIDERS.filter((p) => !p.isLocal).forEach((provider) => {
      const key = getApiKey(provider.id)
      if (key) keys[provider.id] = key
    })
    setApiKeys(keys)

    // Load dark mode preference
    const isDark = localStorage.getItem("darkMode") === "true"
    setDarkMode(isDark)
    if (isDark) {
      document.documentElement.classList.add("dark")
    }
  }, [])

  const handleSaveKey = (providerId: string, key: string) => {
    if (key.trim()) {
      setApiKey(providerId, key.trim())
      setApiKeys((prev) => ({ ...prev, [providerId]: key.trim() }))
    }
  }

  const handleRemoveKey = (providerId: string) => {
    removeApiKey(providerId)
    setApiKeys((prev) => {
      const newKeys = { ...prev }
      delete newKeys[providerId]
      return newKeys
    })
  }

  const toggleShowKey = (providerId: string) => {
    setShowKeys((prev) => ({ ...prev, [providerId]: !prev[providerId] }))
  }

  const handleDarkModeToggle = async (enabled: boolean) => {
    setDarkMode(enabled)
    localStorage.setItem("darkMode", enabled.toString())
    if (enabled) {
      document.documentElement.classList.add("dark")
    } else {
      document.documentElement.classList.remove("dark")
    }

    // Update native status bar
    await CapacitorService.setStatusBarStyle(enabled)
  }

  const onlineProviders = AI_PROVIDERS.filter((p) => !p.isLocal)

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <div className="max-w-2xl mx-auto p-4">
        {/* Header */}
        <div className="flex items-center gap-4 mb-6">
          <Link href="/">
            <Button variant="ghost" size="sm">
              <ArrowLeft className="w-4 h-4" />
            </Button>
          </Link>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">Settings</h1>
        </div>

        <Tabs defaultValue="general" className="space-y-6">
          <TabsList className="grid w-full grid-cols-3">
            <TabsTrigger value="general">General</TabsTrigger>
            <TabsTrigger value="api-keys">API Keys</TabsTrigger>
            <TabsTrigger value="local-models">Local Models</TabsTrigger>
          </TabsList>

          <TabsContent value="general" className="space-y-6">
            {/* Appearance */}
            <Card>
              <CardHeader>
                <CardTitle>Appearance</CardTitle>
                <CardDescription>Customize the look and feel of ChatFuse</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="flex items-center justify-between">
                  <div>
                    <Label htmlFor="dark-mode">Dark Mode</Label>
                    <p className="text-sm text-gray-500 dark:text-gray-400">Switch between light and dark themes</p>
                  </div>
                  <Switch id="dark-mode" checked={darkMode} onCheckedChange={handleDarkModeToggle} />
                </div>
              </CardContent>
            </Card>

            {/* About */}
            <Card>
              <CardHeader>
                <CardTitle>About ChatFuse</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-gray-600 dark:text-gray-400 mb-4">
                  ChatFuse is a minimalist mobile application that allows you to chat with various AI models from
                  different providers. Your API keys and chat history are stored securely on your device.
                </p>
                <div className="text-xs text-gray-500 dark:text-gray-500">Version 1.0.0</div>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="api-keys" className="space-y-6">
            {/* API Keys */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Key className="w-5 h-5" />
                  API Keys
                </CardTitle>
                <CardDescription>
                  Add your API keys for different AI providers. Keys are stored securely on your device.
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                {onlineProviders.map((provider) => (
                  <div key={provider.id} className="space-y-2">
                    <Label htmlFor={provider.id}>{provider.name}</Label>
                    <div className="flex gap-2">
                      <div className="relative flex-1">
                        <Input
                          id={provider.id}
                          type={showKeys[provider.id] ? "text" : "password"}
                          placeholder={`Enter your ${provider.name} API key`}
                          value={apiKeys[provider.id] || ""}
                          onChange={(e) =>
                            setApiKeys((prev) => ({
                              ...prev,
                              [provider.id]: e.target.value,
                            }))
                          }
                          onBlur={(e) => handleSaveKey(provider.id, e.target.value)}
                        />
                        <Button
                          type="button"
                          variant="ghost"
                          size="sm"
                          className="absolute right-2 top-1/2 -translate-y-1/2 h-6 w-6 p-0"
                          onClick={() => toggleShowKey(provider.id)}
                        >
                          {showKeys[provider.id] ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                        </Button>
                      </div>
                      {apiKeys[provider.id] && (
                        <Button variant="outline" size="sm" onClick={() => handleRemoveKey(provider.id)}>
                          <Trash2 className="w-4 h-4" />
                        </Button>
                      )}
                    </div>
                    <p className="text-xs text-gray-500 dark:text-gray-400">{provider.description}</p>
                  </div>
                ))}
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="local-models" className="space-y-6">
            <LocalModelManager />
          </TabsContent>
        </Tabs>
      </div>
    </div>
  )
}
